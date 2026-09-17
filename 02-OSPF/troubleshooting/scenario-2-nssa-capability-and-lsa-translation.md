# Case 02 — Restore consistent NSSA area settings

Removing O4's NSSA declaration made its area type inconsistent with its neighbors. The lab record describes lost adjacencies and external routes, followed by recovery when the setting was restored.

The retained recovery excerpts confirm that O4 again advertised the two test prefixes as Type 7 LSAs and O2 installed them as NSSA external routes. The broader failure and recovery sequence is documented in the original narrative, with less captured output than Cases 01 and 03.

## Expected behavior and fault

Area 10 is a Not-So-Stubby Area (NSSA), which allows O4 to introduce selected external routes:

- `192.0.2.0/24`
- `198.51.100.0/24`

O4 advertises them inside Area 10 as Type 7 link-state advertisements (LSAs). O2, the area border router, translates eligible Type 7 advertisements into Type 5 advertisements for Area 0. O1 then installs the external routes.

The controlled change removed `area 10 nssa` on O4 only. O2 and O5 retained NSSA configuration.

[Original fault commands](../verification/incidents/scenario-2-nssa-capability-and-lsa-translation.md#block-2) · [General database evidence for the healthy design](../verification/database/README.md)

## Diagnosis recorded during the lab

| Observation described in the original case | Diagnostic significance |
|---|---|
| O4's adjacencies to O2 and O5 reset and remained down | The problem affected neighbor formation |
| O2 still reported an NSSA; O4 no longer did | Identified the one-sided area-type change |
| O4 held self-originated Type 5 advertisements instead of Type 7 advertisements | Its external-route behavior no longer matched the NSSA design |
| O2 retained aging Type 7 entries but lacked translated Type 5 entries and the external routes | Database presence alone did not establish a usable route |
| O1 lacked the external advertisements and routes | The effect extended into the backbone |

These failure-state observations were recorded in prose; matching CLI transcripts were not retained in this case. The healthy-state database files are separate captures and do not substitute for a fault-state record.

## Repair and captured recovery

The documented repair restored `area 10 nssa` under O4's OSPF process without clearing the process.

| Retained recovery excerpt | What it establishes |
|---|---|
| O4: both external prefixes, advertising router `10.100.4.4`, metric type 1, metric 20 | Type 7 origination resumed, as identified by the source case |
| O2: both prefixes as `O N1 [110/31]` through `10.100.24.2` | O2 installed both NSSA external routes through O4 |

[Repair commands](../verification/incidents/scenario-2-nssa-capability-and-lsa-translation.md#block-4) · [The two recovery excerpts](../verification/incidents/scenario-2-nssa-capability-and-lsa-translation.md#block-5)

The original narrative also reports `FULL` adjacencies, resumed Type 7-to-Type 5 translation, and `O E1` routes on O1. Dedicated incident excerpts for those checks were not retained. No endpoint delivery or convergence timing was measured in the supplied evidence.

## Engineering takeaway

Consistent area settings are a prerequisite for route exchange. During diagnosis, compare neighbor state, area capabilities, advertisements, and installed routes; an old database entry alone cannot establish that the external-route chain is functioning.

[All original blocks](../verification/incidents/scenario-2-nssa-capability-and-lsa-translation.md) · [Case index](README.md)
