# Lab 20A troubleshooting

## Restore the return path for router-originated probes

**Reported symptom.** The initial loopback pings failed. The lab record attributes the failure to missing return routing on the ISP routers.

**Diagnostic reasoning.** An outward route to an ISP loopback lets an Echo Request reach the destination. An Echo Reply then needs a route to the request's source. Checking the route on R1 and the source-side prefix on the ISP distinguishes those two directions. For ISP-A, the configured source `10.20.12.1` requires coverage on R4. For a backup-path test sourced from `10.20.13.1`, check coverage on R5.

**Correction.** The saved configuration shows a route on R4 to `10.20.12.0/30` via `198.51.100.1` and a route on R5 to `10.20.13.0/30` via `203.0.113.1`. R4 also has a saved route to `10.20.13.0/30` through R2. The [return-route table](../configs/README.md#provide-isp-return-routes) preserves all three entries.

**Captured verification.** The before-and-after ISP lookups show the missing return routes and the installed corrections. The R1 retests used each previously uncovered source address and received 5/5 replies on both paths. This procedure checked the specific paths needed by the probes. [Route and ping excerpts](../verification/return-path.md)

## Detect loss beyond a reachable next hop

**Reported failure exercise.** Shutting R2 Gi0/1 removed the primary provider handoff while the R1–R2 link remained in service. This isolates a failure beyond R1's primary next hop. An unconditional low-distance default through R2 would stay installed while that next hop remained resolvable, leaving R3's floating default unused.

**Correction in the design.** R1 tracks the IP SLA Echo operation and uses that result to control the AD 1 static default. Its /32 route to `4.4.4.4` preserves the intended first hop for subsequent probes. The AD 10 route supplies the backup while the primary route is withdrawn.

**Captured verification.** R2's syslog and route lookup show the lost eBGP adjacency and ISP-A loopback route in the outage. The R1 excerpts show IP SLA Timeout and Track 10 Down, then the next hop toward ISP-B and the Gi0/2 CEF egress. R1 later returned to its primary default with a successful SLA result and Track 10 Up. The lab record reports restoration of the R2 eBGP session and loopback route separately. [Tracked default excerpts](../verification/tracked-default.md)

## If replay differs from the reported sequence

| Symptom | Checks |
|---|---|
| Probe fails at baseline | Confirm R1's host route and source, R2's route to the probe target, and R4's return route. Check the R2–R4 eBGP session before troubleshooting Track 10. |
| Probe remains reachable after the test shutdown | Confirm the fault was on R2 Gi0/1. Inspect the core's probe route and the edge BGP and IP tables for a usable alternate path through the inter-provider link. Check the reply path to `10.20.12.1`. |
| Probe times out but R1 keeps the primary default | Check Track 10's state and confirm the active AD 1 route is bound to that track object. Check for another installed default. |
| R1 installs the backup but packets fail | Check the packet's actual longest-prefix match, R3's onward route, and the remote return route for that source. The default CEF entry describes R1's egress only. |

[Overview](../README.md) · [Failover operation](../operation.md) · [Replay commands](../verification/README.md#replay-and-capture)
