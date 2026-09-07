# 01 — HSRP Upstream Black Hole

## Problem

VLAN 10 lost upstream connectivity when DIST-A’s Gi0/0 failed, even though DIST-A remained the HSRP Active gateway.

## Expected behavior

The redundant design should move gateway service to DIST-B when DIST-A loses its usable upstream path.

## Observed symptoms

PC-A lost all ten test probes. DIST-A retained HSRP priority 120 and Active state, but its OSPF adjacency and destination route disappeared.

## Hypotheses

- The client could not reach its local gateway.
- DIST-A remained reachable but lacked an upstream route.
- HSRP did not track the failed uplink.

## Troubleshooting methodology

Compare HSRP state with interface status, OSPF neighbors, and the destination route. Use client ping and traceroute to locate the forwarding failure. Add tracking while the uplink remains down, then verify the alternate path.

## Evidence

Failure-state excerpts:

```text
Vl10        10   120 P Active  local           10.10.10.3      10.10.10.1
```

```text
FHRP-DIST-A#show ip ospf neighbor
FHRP-DIST-A#show ip route 10.255.255.1
% Subnet not in table
```

```text
10 packets transmitted, 0 packets received, 100% packet loss
```

Traceroute:

```text
1  10.10.10.2 (10.10.10.2)  2.401 ms  2.547 ms  2.658 ms
2  10.10.10.2 (10.10.10.2)  2.392 ms !H  2.658 ms !H  *
```

The interface capture showed Gi0/0 administratively down while Vlan10 remained up/up.

Source: [e72f8156](../../evidence/e72f8156.txt).

## Root cause

HSRP still exchanged messages over the functioning client VLAN. Upstream Gi0/0 health was not connected to the group’s priority, so loss of the route did not cause gateway withdrawal.

## Resolution

Track Gi0/0 and apply decrement 21 to DIST-A’s configured priority 120:

`120 − 21 = 99`, below DIST-B’s 100.

The resulting capture showed:

```text
State is Standby
Active router is 10.10.10.3, priority 100 (expires in 9.504 sec)
Priority 99 (configured 120)
  Track object 1 state Down decrement 21
```

Source: [4254dc30](../../evidence/4254dc30.txt).

Recovery testing then exposed premature preemption. A 10-second minimum preemption delay was added to DIST-A.

## Verification

With DIST-A’s uplink still down, PC-A completed:

```text
10 packets transmitted, 10 packets received, 0% packet loss
```

Its first routed hop changed to `10.10.10.3`, confirming DIST-B carried the traffic.

Source: [350b16d6](../../evidence/350b16d6.txt).

Recovery ordering, summarized from DIST-A’s logs:

| Event | Without added delay | With 10-second delay |
|---|---|---|
| Track Up | 22:32:41.237 | 23:06:43.518 |
| OSPF FULL | 22:32:47.222 | 23:06:50.690 |
| HSRP Active | 22:32:42.404 | 23:06:55.125 |

Without the delay, HSRP became Active **4.818 seconds before** OSPF FULL. With the delay, it became Active **4.435 seconds after** OSPF FULL.

The respective recovery ping captures reported **60/76** and **51/57** successful probes. Both contained loss; the delayed run is not described as seamless.

Sources: [c152afa9](../../evidence/c152afa9.txt), [dd7781cf](../../evidence/dd7781cf.txt).

A separate tracked-failure run also recorded **33/69** successful probes. Tracking achieved the intended final role change, but these captures do not justify a fast-convergence guarantee.

Source: [08a1b850](../../evidence/08a1b850.txt).

Final steady-state verification returned PC-A to DIST-A with 5/5 successful probes.

Source: [3aa38457](../../evidence/3aa38457.txt).

## Lessons / ENCOR concept

A functioning first hop can still be an unusable gateway. Tracking should reflect the failure being protected against, and recovery must consider routing readiness as well as interface state.

[Evidence index](../../evidence/README.md) · [Case studies](../README.md)
