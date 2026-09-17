# Case 02 — Recover with no qualified backup

R1 knew an alternate path through R3, but that path did not satisfy EIGRP's feasibility condition. After the R2 path was shut down, the saved output showed R3 as the new successor with a higher metric.

The case demonstrates the difference between knowing an alternate and having a qualified backup. It does not retain the transient Active/Query/Reply sequence.

## Establish the pre-failure condition

The experiment used `172.16.40.0/22`, initially reached through two equal-cost successors. I increased delay on R3 Gi0/2 toward the branch, changing the path information available to R1.

| R1's prepared topology | Total metric | Reported distance |
|---|---:|---:|
| R2, selected path | 131072 | 130816 |
| R3, known alternate | 156672 | 131072 |

R1's FD was 131072. The alternate failed the strict comparison: **131072 < 131072 is false**. The `all-links` view retained that alternate, while the IP routing table contained only R2's route.

[Preparation commands](../verification/incidents/scenario-2-no-feasible-successor-dual-recalculation.md#block-7) · [Detailed topology, all-links view, and installed route](../verification/incidents/scenario-2-no-feasible-successor-dual-recalculation.md#block-10)

The cleanup record also identifies a temporary R1 Gi0/1 delay left from earlier testing. The captured pre-failure metrics establish this experiment's eligibility condition; they should not be presented as an isolated measurement of the R3 delay change alone.

## Fail the preferred path

I shut down R1 Gi0/0 toward R2. Query/Reply debugging was attempted, and an Active-route query was run. No useful Query/Reply messages were retained; the Active query returned only the table heading.

The subsequent prefix and routing-table excerpts showed:

| Check | Recorded result |
|---|---|
| Route state | Passive, one successor |
| New successor | R3 at `10.13.0.2`, R1 Gi0/1 |
| Topology FD | 156672 |
| Path metric / RD | `156672/131072` |
| Installed IP route | Internal EIGRP, metric 156672 |

[Failure and attempted observation](../verification/incidents/scenario-2-no-feasible-successor-dual-recalculation.md#block-18) · [Post-failure topology and route](../verification/incidents/scenario-2-no-feasible-successor-dual-recalculation.md#block-23)

The transition from an ineligible alternate to an installed successor is captured. The intervening DUAL processing is protocol interpretation, not a saved packet or state-transition trace. No convergence duration can be calculated from these excerpts, and there is no captured Stuck-in-Active event.

## Restore and verify

The documented cleanup re-enabled R1 Gi0/0 and removed temporary delay settings from R3 Gi0/2 and R1 Gi0/1. The saved checks show R1 Gi0/1 back at 10 microseconds and the branch summary back to two successors, each `131072/130816`.

[Cleanup commands and restored topology](../verification/incidents/scenario-2-no-feasible-successor-dual-recalculation.md#block-28)

## Engineering takeaway

An alternate path in the topology table is not automatically ready for backup use. Check its reported distance against the destination's FD, then verify the actual installed route after failure. This case establishes route recovery; it does not measure packet delivery or transient convergence behavior.

[All original blocks](../verification/incidents/scenario-2-no-feasible-successor-dual-recalculation.md) · [Compare Case 01](scenario-1-feasible-successor-promotion.md) · [Case index](README.md)
