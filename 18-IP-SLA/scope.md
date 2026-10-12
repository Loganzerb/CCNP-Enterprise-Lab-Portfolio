# IP SLA scope and evidence provenance

This October 12, 2026 CML exercise covers **ENCOR v1.2 4.4 — Configure and verify IP SLA** through ICMP Echo monitoring, object tracking, a tracked primary default, and a floating backup default. It records an upstream failure while the branch's primary interface remains up/up, followed by backup forwarding and return to the primary path.

**Quick navigation:** [Sources](#sources) · [Experiment boundaries](#experiment-boundaries) · [Measurement limits](#measurement-limits) · [Public export and portability](#public-export-and-portability)

## Sources

The supplied package, `CCNP_IP_SLA_ENCOR_4_4`, contains the lab README, implementation handoff, sanitized CML reconstruction, and `evidence/VERIFIED_LAB_OUTPUTS.md`.

| Material | Source and interpretation |
|---|---|
| Numbered output blocks | Supplied, directly transcribed excerpts from the original interactive CML session; preserved verbatim in [verification](verification/README.md) and the [scheduling case](troubleshooting/threshold-timeout.md) |
| IP SLA settings, routes, node definitions, and physical links | Supplied sanitized reconstruction of the verified configuration, derived from the engineer's original export; public artifacts are indexed in [configurations](configs/README.md) |
| Remote-link shutdown and restoration | Described test actions in the lab README; command/output transcripts were not supplied |
| Interface-mapping diagnosis | Reported use of CDP after a direct-connect ping failed; no raw CDP or initial ping output was supplied |
| Topology and process diagrams | Explanations of the supplied design and record, not screenshots or packet captures |

The original-session outputs are not results from a fresh run of the sanitized file. Missing console lines, timestamps, screenshots, or PCAPs have not been created.

## Experiment boundaries

Operation 10 probes `10.40.40.40` from `10.100.1.1`. Its host route uses the primary ISP next hop; separate application target `10.40.40.41` follows the active default. R4's floating return routes are part of the supplied functional design.

The tested outage disabled the R2-to-R4 link while R1 Gi1 remained up/up. The probe pin was valid while its primary next hop remained resolvable. This result does not establish behavior for every local-interface or next-hop failure.

UDP Jitter, TCP Connect, IP SLA responders, object-tracking delays, and reaction alerts were theory-only topics. They were not configured or tested in this exercise.

## Measurement limits

The backup stage retains 5/5 application ping replies and its traceroute. Recovery retains Track Up, the primary default, and a traceroute through ISP-A; no recovery ping was supplied. Traceroute timeout markers remain in the original excerpts.

The final 73 successes and 58 failures are cumulative session counters, not an application loss benchmark. No timed failure-injection record or continuous traffic capture supports a failover-duration or uninterrupted-service claim. Latest probe RTT values describe their operation snapshots, not general path performance.

The scheduling rejection is observed on the lab's CSR1000v IOS XE 17.3.2 image. Later scheduling acceptance is reported alongside accumulated statistics. The wiring diagnosis is also reported; neither has been expanded into missing console output.

## Public export and portability

The source package describes its YAML as a sanitized reconstruction, with generated PKI, licensing/identifier material, and boilerplate removed. It preserves four nodes, four physical links, and the corrected R4 interface mapping. No Cisco images or proprietary binaries are included.

Structural parsing and configuration checks are separate from runtime reproduction. The sanitized YAML has not been freshly imported, booted, or rerun in CML during portfolio preparation. Historical probe counters are not embedded in its startup configuration and would restart in a new session.

[Overview](README.md) · [Configurations](configs/README.md) · [Verification](verification/README.md) · [Troubleshooting](troubleshooting/README.md) · [Lessons learned](lessons-learned.md) · [Topology](topology.md) · [Packet flow](operation.md)
