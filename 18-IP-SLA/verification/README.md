# IP SLA verification guide

The October 12, 2026 CML excerpts connect a successful ICMP Echo probe, object tracking, route selection, and an application test through the backup provider. During the upstream outage, R1's primary interface remained up/up. Recovery restored the primary default and the recorded traceroute path.

**Quick navigation:** [Verification guides](#verification-guides) · [Evidence block index](#evidence-block-index) · [Read the evidence](#read-the-evidence)

## Verification guides

| Guide | Local blocks | Recorded result |
|---|---|---|
| [Baseline](baseline.md) | 01–03 | IP SLA OK, RTT 3 ms, Track 10 Up, primary default through `10.12.12.2` at distance 1 |
| [Remote failure and backup forwarding](failover.md) | 01–05 | Track 10 Down; R1 Gi1 still up/up; backup default at distance 200; application ping 5/5 through ISP-B |
| [Recovery and final measurements](recovery.md) | 01–05 | Track 10 Up; primary default and ISP-A traceroute restored; latest SLA result OK |
| [Scheduling rejection](../troubleshooting/threshold-timeout.md) | 01 | Scheduling rejected while threshold 5000 ms exceeded timeout 2000 ms |

## Evidence block index

Block numbers are local to each page. All fourteen supplied output fences are retained across these verification pages and the scheduling case.

| Page / block | Supplied excerpt |
|---|---|
| [Baseline 01](baseline.md#block-01) | Successful probe statistics: 4 successes, 0 failures |
| [Baseline 02](baseline.md#block-02) | Track 10 Up |
| [Baseline 03](baseline.md#block-03) | Primary default at distance 1 |
| [Failover 01](failover.md#block-01) | Up-to-Down tracking event |
| [Failover 02](failover.md#block-02) | Backup default at distance 200 |
| [Failover 03](failover.md#block-03) | R1 interface states during the outage |
| [Failover 04](failover.md#block-04) | Loopback-sourced application ping: 5/5 |
| [Failover 05](failover.md#block-05) | Application traceroute through ISP-B |
| [Recovery 01](recovery.md#block-01) | Down-to-Up tracking event |
| [Recovery 02](recovery.md#block-02) | Restored primary default |
| [Recovery 03](recovery.md#block-03) | Application traceroute through ISP-A |
| [Recovery 04](recovery.md#block-04) | Final cumulative probe statistics |
| [Recovery 05](recovery.md#block-05) | Final tracking state and routing consumer |
| [Threshold 01](../troubleshooting/threshold-timeout.md#block-01) | Scheduling command and rejection |

## Read the evidence

These are supplied, directly transcribed excerpts from the original interactive lab, not new output from the sanitized export. The remote-link shutdown/restoration and CDP wiring diagnosis are reported in the lab record; no raw CDP output was supplied. [Evidence scope](../scope.md) identifies the source boundaries.

The final 73 successes and 58 failures are cumulative session counters, not a loss benchmark or failover duration. The backup stage retains a successful ping; recovery retains route and traceroute evidence without a recovery ping. Both traceroutes preserve their timeout markers.

[Overview](../README.md) · [Configurations](../configs/README.md) · [Topology](../topology.md) · [Packet flow](../operation.md) · [Troubleshooting](../troubleshooting/README.md) · [Lessons learned](../lessons-learned.md) · [Evidence scope](../scope.md)
