# VRRP: Master Election, Tracking, and Recovery

The [campus topology](../topology.png) was reused for this phase: VLAN 20 used VRRP in place of its earlier HSRP group.

## Design objective

Demonstrate redundant gateway operation on VLAN 20 and compare recovery behavior with the preceding HSRP exercises.

## Expected state

DIST-B, priority 120, should be preferred over DIST-A, priority 100. Loss of DIST-B’s gateway interface or tracked upstream link should allow DIST-A to become Master.

## Observed behavior

DIST-A initially became Master. After DIST-B joined and the configured priorities were established, the stable state became DIST-B Master and DIST-A Backup.

An upstream recovery also exposed DIST-B becoming Master before its OSPF adjacency reached FULL. A subsequent preemption-delay test reversed that ordering.

## Questions investigated

The initial election should reflect VRRP’s enabled preemption. Upstream tracking should reduce DIST-B’s effective priority below DIST-A’s. Delaying recovery preemption should give OSPF additional convergence time.

## Verification workflow

Compare both peers’ `show vrrp` output, then test gateway-interface failure, upstream tracking, and recovery separately. Correlate VRRP transitions with track and OSPF timestamps, and verify the client’s routed path.

## Captured results

### Configuration and steady state

Observed settings:

| Setting | DIST-A | DIST-B |
|---|---|---|
| Group / interface | 20 / Vlan20 | 20 / Vlan20 |
| Virtual IP | 10.20.20.1 | 10.20.20.1 |
| Priority | 100 | 120 |
| Stable role | Backup | Master |
| Advertisement interval | 1.000 sec | 1.000 sec |
| Displayed Master Down interval | 3.609 sec | 3.531 sec |

The entered configuration used legacy `vrrp 20 ip` syntax. These were IPv4 VRRPv2 lab exercises; VRRPv3 discussion is not presented as hands-on evidence.

DIST-B excerpt:

```text
Virtual IP address is 10.20.20.1
Virtual MAC address is 0000.5e00.0114
Advertisement interval is 1.000 sec
Preemption enabled
Priority is 120
Master Router is 10.20.20.3 (local), priority is 120
```

Source: [VRRP configuration, election and stable Master/Backup roles](vrrp/FHRP-DIST-A-and-DIST-B-vrrp-election-and-baseline.txt).

### Gateway-interface failure

DIST-A became Master:

```text
Master Router is 10.20.20.2 (local), priority is 100
```

PC-B’s subsequent verification showed:

```text
5 packets transmitted, 5 packets received, 0% packet loss
```

Traceroute’s first routed hop was `10.20.20.2`. This verifies the converged failure state, not uninterrupted service during the transition.

Source: [DIST-A Master state and converged client forwarding](vrrp/FHRP-DIST-A-and-PC-B-gateway-interface-failover.txt).

### Upstream tracking

DIST-B after shutting Gi0/0:

```text
State is Backup
Priority is 99  (cfgd 120)
  Track object 2 state Down decrement 21
Master Router is 10.20.20.2, priority is 100
```

The arithmetic was `120 − 21 = 99`, below DIST-A’s 100. PC-B again completed 5/5 probes after convergence.

Source: [VRRP priority decrement and converged client forwarding](vrrp/FHRP-DIST-B-and-PC-B-tracked-uplink-failover.txt).

### Recovery ordering

Without the added delay, DIST-B’s logs showed:

```text
*Sep  6 20:53:10.393: %VRRP-6-STATECHANGE: Vl20 Grp 20 state Backup -> Master
*Sep  6 20:53:13.089: %OSPF-5-ADJCHG: Process 10, Nbr 10.255.255.1 on GigabitEthernet0/0 from LOADING to FULL, Loading Done
```

VRRP became Master approximately **2.696 seconds before** OSPF reached FULL.

After configuring a 10-second preemption delay, the recovery logs showed:

```text
*Sep  6 21:07:28.807: %OSPF-5-ADJCHG: Process 10, Nbr 10.255.255.1 on GigabitEthernet0/0 from LOADING to FULL, Loading Done
*Sep  6 21:07:32.255: %VRRP-6-STATECHANGE: Vl20 Grp 20 state Backup -> Master
```

OSPF reached FULL approximately **3.448 seconds before** VRRP became Master.

Sources: [VRRP Master transition precedes OSPF FULL](vrrp/FHRP-DIST-B-uplink-recovery-without-preemption-delay.txt), [Master state with a 10-second preemption delay](vrrp/FHRP-DIST-B-show-vrrp-preemption-delay.txt), [Delayed VRRP recovery ordering and combined client ping capture](vrrp/FHRP-DIST-B-and-PC-B-delayed-recovery-logs-and-ping.txt).

## Engineering analysis

Interface tracking reported link recovery before routing convergence completed. Immediate recovery preemption could therefore restore gateway ownership too early.

## Recovery approach

Track DIST-B’s upstream interface with decrement 21 and add a 10-second preemption delay.

## Recovery verification

The delayed recovery established the intended control-plane ordering. The combined failure/recovery ping capture still reported:

```text
78 packets transmitted, 70 packets received, 10% packet loss
round-trip min/avg/max = 3.122/19192.313/52938.820 ms
```

The unusually large RTT values and combined capture prevent a clean recovery-only outage measurement. The result is not described as lossless.

Source: [Delayed VRRP recovery ordering and combined client ping capture](vrrp/FHRP-DIST-B-and-PC-B-delayed-recovery-logs-and-ping.txt).

## Engineering takeaway

VRRP Master/Backup state, effective priority, and routing readiness are separate checks. A preemption delay improved the observed recovery sequence, but a fixed delay does not directly verify route availability.

[Evidence index](README.md) · [FHRP overview](../README.md)
