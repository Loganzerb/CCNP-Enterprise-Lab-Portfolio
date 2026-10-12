# IP SLA lessons learned

**Quick navigation:** [Engineering distinctions](#engineering-distinctions) · [Probe path](#keep-the-probe-on-the-intended-path) · [Result limits](#interpret-the-results-at-their-captured-scope)

## Engineering distinctions

| Engineering distinction | What the lab established |
|---|---|
| Local link state versus upstream reachability | During the reported R2–R4 outage, R1 Gi1 remained up/up while IP SLA tracking transitioned Down |
| Probe target versus application target | `10.40.40.40` tested the primary path; the separate `10.40.40.41` target followed the active default route |
| Tracked primary versus floating backup | Track 10 Down accompanied the default via ISP-B with administrative distance 200; recovery restored ISP-A with distance 1 |
| Threshold versus timeout | The initial 5000 ms threshold exceeded the 2000 ms timeout and scheduling was rejected; the final threshold was 1000 ms |
| Assumed interface order versus actual wiring | Reported CDP diagnosis placed R2 on R4 Gi0/1 and R3 on R4 Gi0/0 |
| Backup ping versus traceroute responses | The backup application-target ping received 5/5 replies; its traceroute still retained a timeout marker |
| Recovery path versus a new ping result | Recovery output restored the primary route and showed traceroute through R2; no recovery application-target ping was supplied |
| Session counters versus a performance benchmark | The final 73 successes and 58 failures cover the interactive session, without establishing a loss rate or failover duration |
| Historical results versus a portable export | The original session produced the supplied results; the sanitized YAML has not been freshly imported and boot-tested |

## Keep the probe on the intended path

The `/32` route to `10.40.40.40` uses primary next hop `10.12.12.2`. While that next hop remains resolvable, the probe stays on ISP-A even when the application target uses ISP-B. This keeps successful backup forwarding from being interpreted as primary-path recovery.

The tested outage was on **R2 Gi0/1 toward R4**, with R1's primary Gi1 still up/up. That is the boundary of this experiment, rather than a test of every possible local-link or next-hop failure. [Outage test boundary](verification/failover.md#test-boundary) · [Experiment boundaries](scope.md#experiment-boundaries)

## Interpret the results at their captured scope

The [backup forwarding captures](verification/failover.md#backup-forwarding) retain both the **5/5** ping and the traceroute's `*` timeout marker. Those are different checks: the marker records a traceroute probe without a response, while the separate ping result establishes those five successful replies.

Recovery is supported by the tracking transition, restored primary default, and traceroute through R2. The final IP SLA `OK` result concerns the probe target; it does not add an uncaptured recovery ping to the application target. The [final measurements](verification/recovery.md#interpret-final-measurements) preserve the cumulative **73 successes / 58 failures** without deriving a convergence time or traffic-loss benchmark.

The completed practical scope was **ICMP Echo, object tracking, static-route failover, and failback**. UDP Jitter, TCP Connect, an SLA responder, tracking delays, and reaction alerts remained theory-only. The [two troubleshooting cases](troubleshooting/README.md) distinguish the captured scheduling rejection from the reported interface diagnosis and later schedule acceptance.

[Troubleshooting](troubleshooting/README.md) · [Threshold case](troubleshooting/threshold-timeout.md) · [Interface case](troubleshooting/interface-mapping.md) · [Verification](verification/README.md) · [Configurations](configs/README.md) · [Topology](topology.md) · [Operation](operation.md) · [Evidence scope](scope.md) · [Overview](README.md)
