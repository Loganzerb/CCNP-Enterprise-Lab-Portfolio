# Case 01 — An active HSRP gateway loses its upstream path

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

Source: [Active gateway without upstream route and failed client probes](../verification/hsrp-tracking/FHRP-DIST-A-and-PC-A-untracked-upstream-black-hole.txt).

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

Source: [Tracking lowers effective HSRP priority to 99](../verification/hsrp-tracking/FHRP-DIST-A-show-track-and-standby-uplink-down.txt).

Recovery testing then exposed premature preemption. A 10-second minimum preemption delay was added to DIST-A.

## Verification

With DIST-A’s uplink still down, PC-A completed:

```text
10 packets transmitted, 10 packets received, 0% packet loss
```

Its first routed hop changed to `10.10.10.3`, confirming DIST-B carried the traffic.

Source: [Client forwarding through DIST-B with DIST-A uplink down](../verification/hsrp-tracking/PC-A-ping-and-traceroute-tracking-failover.txt).

Recovery ordering, summarized from DIST-A’s logs:

| Event | Without added delay | With 10-second delay |
|---|---|---|
| Track Up | 22:32:41.237 | 23:06:43.518 |
| OSPF FULL | 22:32:47.222 | 23:06:50.690 |
| HSRP Active | 22:32:42.404 | 23:06:55.125 |

Without the delay, HSRP became Active **4.818 seconds before** OSPF FULL. With the delay, it became Active **4.435 seconds after** OSPF FULL.

The respective recovery ping captures reported **60/76** and **51/57** successful probes. Both contained loss; the delayed run is not described as seamless.

Sources: [HSRP recovery precedes OSPF FULL; client loss retained](../verification/hsrp-tracking/FHRP-DIST-A-and-PC-A-recovery-without-preemption-delay.txt), [OSPF FULL precedes delayed HSRP recovery; client loss retained](../verification/hsrp-tracking/FHRP-DIST-A-and-PC-A-recovery-with-preemption-delay.txt).

A separate tracked-failure run also recorded **33/69** successful probes. Tracking achieved the intended final role change, but these captures do not justify a fast-convergence guarantee.

Source: [Tracked failure with client packet loss retained](../verification/hsrp-tracking/FHRP-DIST-A-and-PC-A-tracked-uplink-failure.txt).

Final steady-state verification returned PC-A to DIST-A with 5/5 successful probes.

Source: [Final steady-state forwarding through DIST-A](../verification/hsrp-tracking/PC-A-ping-and-traceroute-preferred-path-restored.txt).

## Engineering takeaway

A functioning first hop can still be an unusable gateway. Tracking should reflect the failure being protected against, and recovery must consider routing readiness as well as interface state.

[Evidence index](../verification/README.md) · [Case studies](README.md)
