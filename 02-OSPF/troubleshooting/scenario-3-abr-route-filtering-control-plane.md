# Case 03 — Recover a missing branch route with healthy neighbors

O1 lost the branch summary even though all three of O2's OSPF neighbors remained `FULL`. The branch routes still existed inside Area 10. Comparing both sides of the area boundary traced the missing advertisement to an outbound filter on O2.

Removing only the filter attachment restored the summary LSA and O1's inter-area route.

## Expected behavior and fault

O3 originates four branch prefixes, `172.20.32.0/24` through `172.20.35.0/24`. O2 summarizes them as `172.20.32.0/22` toward Area 0, where O1 normally installs the summary as `O IA`.

The controlled fault applied `AREA10-TO-AREA0` outbound from Area 10. Its first entry denied the `/22` and its more-specific prefixes; the next permitted other prefixes. O2's area-range configuration remained present.

[Summary configuration and fault commands](../verification/incidents/scenario-3-abr-route-filtering-control-plane.md#block-1) · [Combined OSPF configuration](../verification/incidents/scenario-3-abr-route-filtering-control-plane.md#block-5)

## How I isolated the cause

| Observation | What it narrowed down |
|---|---|
| O1's prefix lookup returned `% Network not in table` | The expected route was absent |
| O1's summary-LSA query returned no entry for the prefix | The inter-area advertisement was missing too |
| O2's three neighbors remained `FULL` | The captured failure did not involve a lost adjacency |
| O2 and O4 retained all four branch `/24` routes | The component routes still existed inside Area 10 |
| O2's attached prefix list explicitly denied the summary | The policy matched the missing advertisement |

[O1's missing route and LSA](../verification/incidents/scenario-3-abr-route-filtering-control-plane.md#block-6) · [Neighbors and component routes](../verification/incidents/scenario-3-abr-route-filtering-control-plane.md#block-8) · [Prefix-list output](../verification/incidents/scenario-3-abr-route-filtering-control-plane.md#block-11)

The evidence locates the fault at O2's advertisement boundary. Retained routes inside Area 10 establish routing state, not a successful endpoint traffic test.

## Repair and verification

I removed `area 10 filter-list prefix AREA10-TO-AREA0 out` from O2's OSPF process. The prefix-list definition was initially left in place, so the repair changed the policy attachment alone.

| Captured post-change result | Interpretation |
|---|---|
| O2's `172.20.32.0/22` summary to Null0, plus all four component routes | The local summary and its contributing routes were present |
| O1's `172.20.32.0/22` route, inter-area, metric 21, via `10.100.12.2` | The expected route was installed again |
| O1's Type 3 LSA, advertising router `10.100.2.2`, mask `/22`, metric 11 | The summary advertisement returned |

[Repair commands](../verification/incidents/scenario-3-abr-route-filtering-control-plane.md#block-13) · [Recovery excerpts](../verification/incidents/scenario-3-abr-route-filtering-control-plane.md#block-14)

The original narrative reports that all O2 neighbors also remained `FULL` after repair; a separate post-repair neighbor excerpt was not retained.

It also reports that O2's local Null0 summary disappeared during filtering. The retained fault-state route excerpts show the component routes, rather than a complete table proving that absence. The summary's return is captured; its reported disappearance is kept as a lab observation, not a general rule.

## Engineering takeaway

Healthy neighbors do not guarantee that the intended routes cross an area boundary. Checking the source routes, summary advertisement, and installed route isolated the filter and made the recovery verifiable without changing the rest of the design.

[All original excerpts and commands](../verification/incidents/scenario-3-abr-route-filtering-control-plane.md) · [Case index](README.md)
