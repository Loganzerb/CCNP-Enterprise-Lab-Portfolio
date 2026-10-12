# Remote failure: backup forwarding with the primary link still up

The lab record describes shutting R2-ISP-A GigabitEthernet0/1 toward R4, leaving R1's primary ISP-facing link active. The supplied excerpts then show Track 10 Down, the floating backup default installed, and successful traffic to the separate application target.

**Quick navigation:** [Tracking and route change](#tracking-and-route-change) · [Local interface state](#local-interface-state) · [Backup forwarding](#backup-forwarding) · [Test boundary](#test-boundary)

## Tracking and route change

### Block 01

**Supplied transcribed event excerpt.** Track 10 changes from Up to Down at 22:34:22.031 on October 12. The remote shutdown command and its exact time were not supplied as CLI output.

```text
R1-BRANCH#
*Oct 12 22:34:22.031: %TRACK-6-STATE: 10 ip sla 10 reachability Up -> Down
```

### Block 02

**Supplied transcribed CLI excerpt.** The default now uses ISP-B next hop `10.13.13.2` at administrative distance 200.

```text
R1-BRANCH#show ip route 0.0.0.0
Routing entry for 0.0.0.0/0, supernet
  Known via "static", distance 200, metric 0, candidate default path
  Routing Descriptor Blocks:
  * 10.13.13.2
      Route metric is 0, traffic share count is 1
```

## Local interface state

### Block 03

**Supplied transcribed CLI excerpt — during the outage.** R1 GigabitEthernet1 remains up/up. The branch's local physical link state alone did not describe availability of the remote primary path.

```text
R1-BRANCH#sh ip interface brief
Interface              IP-Address      OK? Method Status                Protocol
GigabitEthernet1       10.12.12.1      YES manual up                    up
GigabitEthernet2       10.13.13.1      YES manual up                    up
GigabitEthernet3       unassigned      YES unset  administratively down down
GigabitEthernet4       unassigned      YES unset  administratively down down
Loopback0              10.100.1.1      YES manual up                    up
```

## Backup forwarding

### Block 04

**Supplied transcribed CLI excerpt.** Five loopback-sourced probes to application target `10.40.40.41` receive replies, with recorded minimum/average/maximum RTT of 2/2/3 ms.

```text
R1-BRANCH#ping 10.40.40.41 source 10.100.1.1
Sending 5, 100-byte ICMP Echos to 10.40.40.41, timeout is 2 seconds:
Packet sent with a source address of 10.100.1.1
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 2/2/3 ms
```

### Block 05

**Supplied transcribed CLI excerpt.** The path uses R3 at `10.13.13.2`, then R4's ISP-B address `10.34.34.2`. The second-hop timeout marker is retained.

```text
R1-BRANCH#traceroute 10.40.40.41 source 10.100.1.1
Tracing the route to 10.40.40.41
VRF info: (vrf in name/id, vrf out name/id)
  1 10.13.13.2 2 msec 1 msec 1 msec
  2 10.34.34.2 22 msec *  2 msec
```

The route, sourced ping, and traceroute establish backup forwarding for this test. The timeout marker does not erase the five successful ping replies; neither short test measures uninterrupted service throughout the transition.

## Test boundary

The `/32` probe route remains pinned through `10.12.12.2`, so backup application success does not make the probe report primary recovery in this tested outage. R1 Gi1 stayed up/up and the primary next hop remained resolvable. This is a remote R2-to-R4 link failure, not a test of every possible local-link or next-hop failure.

The record does not include a continuous traffic trace or the failure-injection timestamp needed to measure failover duration. [Recovery evidence](recovery.md) records the later return to ISP-A.

[Baseline](baseline.md) · [Recovery](recovery.md) · [Verification index](README.md) · [Overview](../README.md) · [Packet flow](../operation.md) · [Evidence scope](../scope.md)
