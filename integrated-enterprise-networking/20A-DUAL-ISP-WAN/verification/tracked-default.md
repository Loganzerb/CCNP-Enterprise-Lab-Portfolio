# Lab 20A tracked default, outage, and recovery

**Captured CLI excerpts from the original CML lab session.** The outputs show selected routing and forwarding states from the historical exercise.

## Normal tracked default

R1 had two configured static defaults. Track 10 reported Up with return code OK, and R1 installed the AD 1 default via 10.20.12.2.

```text
R1-CORE#show running-config | include ^ip route 0.0.0.0
ip route 0.0.0.0 0.0.0.0 10.20.12.2 track 10
ip route 0.0.0.0 0.0.0.0 10.20.13.2 10

R1-CORE#show ip route 0.0.0.0
Routing entry for 0.0.0.0/0, supernet
  Known via "static", distance 1, metric 0, candidate default path
  Routing Descriptor Blocks:
  * 10.20.12.2
      Route metric is 0, traffic share count is 1

R1-CORE#show track 10
Track 10
  IP SLA 10 reachability
  Reachability is Up
    1 change, last change 00:02:58
  Latest operation return code: OK
  Latest RTT (millisecs) 9
  Tracked by:
    Static IP Routing 0
```

## Upstream failure

**Reported action.** R2-EDGE-A Gi0/1 was shut down while Gi0/0 toward R1 remained in service. The selected R2 capture shows the eBGP adjacency down with an interface-flap reason and the missing route to 4.4.4.4.

```text
R2-EDGE-A#show ip route 4.4.4.4
% Network not in table

*Nov 22 22:07:09.119: %BGP-5-NBR_RESET: Neighbor 198.51.100.2 reset (Interface flap)
*Nov 22 22:07:09.123: %BGP-5-ADJCHANGE: neighbor 198.51.100.2 Down Interface flap
```

R1's SLA probe timed out and Track 10 went Down. R1 withdrew its tracked primary default and installed its AD 10 default via 10.20.13.2, toward ISP-B. The CEF lookup selected Gi0/2 for the supplied source and destination pair.

```text
R1-CORE#show ip sla statistics 10
IPSLAs Latest Operation Statistics

IPSLA operation id: 10
        Latest RTT: NoConnection/Busy/Timeout
Latest operation start time: 22:07:39 UTC Sun Nov 22 2026
Latest operation return code: Timeout
Number of successes: 103
Number of failures: 7
Operation time to live: Forever

R1-CORE#show track 10
Track 10
  IP SLA 10 reachability
  Reachability is Down
    2 changes, last change 00:00:30
  Latest operation return code: Timeout
  Tracked by:
    Static IP Routing 0

R1-CORE#show ip route 0.0.0.0
Routing entry for 0.0.0.0/0, supernet
  Known via "static", distance 10, metric 0, candidate default path
  Routing Descriptor Blocks:
  * 10.20.13.2
      Route metric is 0, traffic share count is 1

R1-CORE#show ip cef exact-route 10.20.13.1 8.8.8.8
10.20.13.1 -> 8.8.8.8 =>IP adj out of GigabitEthernet0/2, addr 10.20.13.2
```

## Primary recovery

**Reported action and observation.** R2 Gi0/1 was restored. The lab completion record reports recovery of the R2 eBGP session and ISP-A loopback route.

The captured R1 output confirms an OK SLA result and Track 10 Up, with the AD 1 default again using 10.20.12.2. The CEF lookup selected Gi0/1 for the supplied source and destination pair.

```text
R1-CORE#show ip sla statistics 10
IPSLAs Latest Operation Statistics

IPSLA operation id: 10
        Latest RTT: 2 milliseconds
Latest operation start time: 22:10:59 UTC Sun Nov 22 2026
Latest operation return code: OK
Number of successes: 126
Number of failures: 24
Operation time to live: Forever

R1-CORE#show track 10
Track 10
  IP SLA 10 reachability
  Reachability is Up
    3 changes, last change 00:01:53
  Latest operation return code: OK
  Latest RTT (millisecs) 2
  Tracked by:
    Static IP Routing 0

R1-CORE#show ip route 0.0.0.0
Routing entry for 0.0.0.0/0, supernet
  Known via "static", distance 1, metric 0, candidate default path
  Routing Descriptor Blocks:
  * 10.20.12.2
      Route metric is 0, traffic share count is 1

R1-CORE#show ip cef exact-route 10.20.12.1 8.8.8.8
10.20.12.1 -> 8.8.8.8 =>IP adj out of GigabitEthernet0/1, addr 10.20.12.2
```

## What the lookups establish

The outage lookup used source 10.20.13.1 and the recovery lookup used source 10.20.12.1. Both used 8.8.8.8 as a forwarding lookup destination. They show R1's selected adjacencies in each state. End-to-end delivery via the backup default and Internet connectivity remain unverified. The timestamps identify individual snapshots. The exercise record does not measure the convergence interval. [Evidence scope](../scope.md)

[Verification index](README.md) · [Return-path captures](return-path.md) · [Routing operation](../operation.md)
