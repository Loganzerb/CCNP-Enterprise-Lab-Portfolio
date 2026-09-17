# Case 01 — Verify a qualified backup taking over

R1 initially had two equal-cost paths to the branch summary. Increasing the local cost of the R3 path made R2 preferred while leaving R3 eligible as a loop-free backup. When the R2-facing interface was shut down, R1 installed the R3 path.

## Prepare and qualify the backup

The destination was `172.16.40.0/22`. Initially, R1's topology entry showed two successors, each with total metric 131072 and reported distance 130816.

I applied `delay 100` on R1 Gi0/1, toward R3. The interface excerpt shows a delay of 1000 microseconds. The change increased R1's cost through R3 without changing the distance R3 advertised.

| Candidate at R1 | Total metric | Reported distance | Role after the change |
|---|---:|---:|---|
| R2, `10.12.0.2` | 131072 | 130816 | Selected successor |
| R3, `10.13.0.2` | 156416 | 130816 | Qualified alternate |

R3 satisfied the feasibility condition: **130816 < 131072**. Its higher total metric kept it out of the routing table, but its reported distance qualified it as a feasible successor.

[Initial topology](../verification/incidents/scenario-1-feasible-successor-promotion.md#block-3) · [Delay change and output](../verification/incidents/scenario-1-feasible-successor-promotion.md#block-6) · [Prepared topology](../verification/incidents/scenario-1-feasible-successor-promotion.md#block-11)

## Fail the preferred path and check the result

I shut down R1 Gi0/0 toward R2.

| Post-failure check | Captured result |
|---|---|
| Destination topology entry | Passive, one successor through R3 |
| R3 path metric / RD | `156416/130816` |
| IP routing table | Route through `10.13.0.2` on Gi0/1, metric 156416 |
| Active-route query | Heading only; no Active prefixes at the time of the check |

[Failure commands](../verification/incidents/scenario-1-feasible-successor-promotion.md#block-18) · [Topology and installed route](../verification/incidents/scenario-1-feasible-successor-promotion.md#block-20) · [Active-route check](../verification/incidents/scenario-1-feasible-successor-promotion.md#block-24)

The topology header retains FD 131072 while the selected path's metric is 156416. FD is a stored feasibility bound and need not equal the current path metric. The separate fields are preserved as captured.

The before/after results support feasible-successor promotion. The later empty Active query is a snapshot; it is not a continuous trace proving that no transient state or packet exchange occurred anywhere.

## Restore the baseline

I re-enabled R1 Gi0/0 and removed the temporary Gi0/1 delay. The saved excerpts show both R1 neighbors present, Gi0/0 up/up, and two equal-cost successors again at metric 131072.

[Restoration commands and checks](../verification/incidents/scenario-1-feasible-successor-promotion.md#block-25)

## Engineering takeaway

Backup eligibility and route installation answer different questions. The metric comparison established that R3 qualified before the failure; the routing table established that it became the replacement afterward. No retained traffic test measures packet loss or uninterrupted service.

[All original blocks](../verification/incidents/scenario-1-feasible-successor-promotion.md) · [Compare Case 02](scenario-2-no-feasible-successor-dual-recalculation.md) · [Case index](README.md)
