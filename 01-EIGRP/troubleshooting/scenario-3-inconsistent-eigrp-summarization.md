# Case 03 — Restore consistent summaries on redundant uplinks

Removing the branch summary from just one uplink caused the two distribution routers to learn a mixture of the summary and its component routes. On R2, a more-specific route pointed through R3 even though the covering summary pointed directly to the branch.

Reapplying the missing summary restored the documented summary-only routing view.

## Expected policy and fault

R4's four branch loopbacks cover `172.16.40.0/24` through `172.16.43.0/24`. Both distribution-facing interfaces normally advertise `172.16.40.0/22`.

I removed the summary on R4 Gi0/1 toward R3, leaving the summary on Gi0/0 toward R2. R3 could then learn the component prefixes directly. The R2–R3 link allowed the different advertisements to propagate between the distribution routers.

[Baseline summary and fault commands](../verification/incidents/scenario-3-inconsistent-eigrp-summarization.md#block-1)

## Diagnose the mixed routing view

| Observation point | Summary `172.16.40.0/22` | Component `172.16.40.0/24` |
|---|---|---|
| R2 | Directly through R4, `10.24.0.1`, metric 130816 | Through R3, `10.23.0.1`, metric 131072 |
| R3 | Through R2, `10.23.0.2` | Directly through R4, `10.34.0.2` |

[R3's route excerpts](../verification/incidents/scenario-3-inconsistent-eigrp-summarization.md#block-4) · [R2's exact-prefix lookups](../verification/incidents/scenario-3-inconsistent-eigrp-summarization.md#block-6)

For an address inside `172.16.40.0/24`, the more-specific installed route takes precedence over the covering `/22`. The lower EIGRP metric of the summary does not override that longest-prefix match.

This predicts that R2 would select the indirect path through R3 for matching destinations. No retained ping or traceroute establishes the actual traffic path or uninterrupted reachability during the fault.

## Repair and verification

I restored `ip summary-address eigrp 100 172.16.40.0 255.255.252.0` on R4 Gi0/1.

| Post-change excerpt | What it shows |
|---|---|
| R4 `show ip protocols` | The `/22` summary on both Gi0/0 and Gi0/1, with four components |
| R3 filtered route listing | A single branch-summary line through `10.34.0.2` |
| R2 filtered route listing | The `/22` through `10.24.0.1`; no component-route lines in the excerpt |

[Repair commands](../verification/incidents/scenario-3-inconsistent-eigrp-summarization.md#block-8) · [Recovery excerpts](../verification/incidents/scenario-3-inconsistent-eigrp-summarization.md#block-9)

**Capture inconsistency:** the R3 recovery line names Gi0/1, while the saved configuration and baseline evidence place `10.34.0.2` on R3 Gi0/2. The original line is preserved. It supports the reported return to a summary-only view, but does not independently confirm the physical egress interface; a fresh exact-prefix lookup would resolve that discrepancy.

## Engineering takeaway

Redundant links need consistent advertisement policy. Checking both prefix lengths and their next hops exposed a problem that a general reachability check could miss. Recovery was assessed at the summarizing router and at both receiving distribution routers.

[All original blocks](../verification/incidents/scenario-3-inconsistent-eigrp-summarization.md) · [Case index](README.md)
