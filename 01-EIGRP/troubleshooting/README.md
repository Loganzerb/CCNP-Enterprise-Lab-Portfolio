# EIGRP troubleshooting

The first two cases compare backup eligibility for the same branch summary, `172.16.40.0/22`. The third follows a route-policy inconsistency across the two distribution routers.

| Case | Decisive evidence | Original blocks |
|---|---|---|
| [01 — Qualified backup takes over](scenario-1-feasible-successor-promotion.md) | R3's reported distance is below R1's feasible distance; the replacement route is then installed | [31 blocks](../verification/incidents/scenario-1-feasible-successor-promotion.md) |
| [02 — Alternate fails the feasibility condition](scenario-2-no-feasible-successor-dual-recalculation.md) | The values are equal before failure; R3 becomes successor afterward | [35 blocks](../verification/incidents/scenario-2-no-feasible-successor-dual-recalculation.md) |
| [03 — Different summaries on redundant uplinks](scenario-3-inconsistent-eigrp-summarization.md) | Exact `/22` and `/24` lookups expose different sources; reapplying the summary restores the intended advertisements | [11 blocks](../verification/incidents/scenario-3-inconsistent-eigrp-summarization.md) |

## Compare the failover experiments

| At R1 before failure | Case 01 | Case 02 |
|---|---:|---:|
| Destination feasible distance (FD) | 131072 | 131072 |
| R3's reported distance (RD) | 130816 | 131072 |
| Strict test: RD < FD | Pass | Fail |
| R3 qualifies as the backup | Yes | No |
| Installed metric through R3 after failure | 156416 | 156672 |

A failed feasibility test does not prove that a path contains a loop. It means that this test does not qualify it for use as a precomputed loop-free alternative.

Neither experiment measures convergence time or packet loss. Case 02 retains no direct Active-state or Query/Reply event. The original 77 blocks include command lists and explanatory calculations as well as selected device output; they are not 77 independent captures.

[Module overview](../README.md) · [Topology](../topology.md) · [Verification guide](../verification/README.md)
