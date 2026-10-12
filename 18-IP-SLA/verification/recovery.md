# Recovery: return to the primary route

After the reported restoration of R2's target-facing link, Track 10 returned Up. The route and traceroute excerpts show R1 selecting ISP-A again. Final operation statistics retain the cumulative results from the interactive session.

**Quick navigation:** [Tracking recovery](#tracking-recovery) · [Primary route and path](#primary-route-and-path) · [Final measurements](#final-measurements) · [Interpretation](#interpret-final-measurements)

## Tracking recovery

### Block 01

**Supplied transcribed event excerpt.** Track 10 changes Down to Up at 22:44:02.062 on October 12. The restoration command is described in the lab record rather than supplied as console output.

```text
R1-BRANCH#
*Oct 12 22:44:02.062: %TRACK-6-STATE: 10 ip sla 10 reachability Down -> Up
```

## Primary route and path

### Block 02

**Supplied transcribed CLI excerpt.** The preferred default is restored through `10.12.12.2` at administrative distance 1.

```text
R1-BRANCH#sh ip route 0.0.0.0
Routing entry for 0.0.0.0/0, supernet
  Known via "static", distance 1, metric 0, candidate default path
  Routing Descriptor Blocks:
  * 10.12.12.2
      Route metric is 0, traffic share count is 1
```

### Block 03

**Supplied transcribed CLI excerpt.** The application traceroute now passes through R2 at `10.12.12.2` and R4's ISP-A address `10.24.24.2`. Its second-hop timeout marker is retained.

```text
R1-BRANCH#traceroute 10.40.40.41 source 10.100.1.1
Tracing the route to 10.40.40.41
VRF info: (vrf in name/id, vrf out name/id)
  1 10.12.12.2 2 msec 2 msec 1 msec
  2 10.24.24.2 3 msec *  2 msec
```

## Final measurements

### Block 04

**Supplied transcribed CLI excerpt.** The latest operation started at 22:50:40 UTC on October 12 and returned OK, RTT 5 ms. The counters report 73 successes and 58 failures across the interactive session.

```text
R1-BRANCH#show ip sla statistics 10
IPSLAs Latest Operation Statistics

IPSLA operation id: 10
        Latest RTT: 5 milliseconds
Latest operation start time: 22:50:40 UTC Mon Oct 12 2026
Latest operation return code: OK
Number of successes: 73
Number of failures: 58
Operation time to live: Forever
```

### Block 05

**Supplied transcribed CLI excerpt.** Track 10 is Up, with three recorded changes, and lists a static-routing consumer.

```text
R1-BRANCH#show track 10
Track 10
  IP SLA 10 reachability
  Reachability is Up
    3 changes, last change 00:06:44
  Latest operation return code: OK
  Latest RTT (millisecs) 5
  Tracked by:
    Static IP Routing 0
```

## Interpret final measurements

The restored route and application traceroute support the recorded return to ISP-A. No recovery ping transcript was supplied. The latest successful SLA probe concerns `10.40.40.40`, distinct from the application traceroute target `10.40.40.41`.

The success/failure totals are cumulative probe counters. They are not a benchmark of application packet loss, a count of one ping run, or a measured failover duration. Likewise, the interval between the Down and Up event timestamps is not the time taken to switch to the backup. The displayed `Static IP Routing 0` identifies a static-routing consumer; it does not establish zero tracked routes.

[Failover evidence](failover.md) · [Baseline](baseline.md) · [Verification index](README.md) · [Overview](../README.md) · [Lessons learned](../lessons-learned.md) · [Evidence scope](../scope.md)
