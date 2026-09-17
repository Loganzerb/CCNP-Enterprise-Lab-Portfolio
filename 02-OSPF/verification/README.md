# OSPF verification guide

The evidence answers five connected questions: **Which interfaces participate? Which neighbors synchronize? What routing information is present? Which routes are installed? What process settings explain that behavior?**

All twenty-five original text files are preserved. Each group has a README linking every capture and explaining what to inspect.

| Evidence group | Files | Main question |
|---|---:|---|
| [Interfaces](interfaces/README.md) | 5 | Are area assignments, interface costs, and neighbor counts consistent with the design? |
| [Neighbors](neighbors/README.md) | 5 | Did the five expected router-to-router relationships reach `FULL`? |
| [Database](database/README.md) | 5 | Where were branch, default, and external advertisements originated? |
| [Routing](routing/README.md) | 5 | Were the expected summaries, defaults, external routes, and equal-cost next hops installed? |
| [Protocols](protocols/README.md) | 5 | Which process, areas, passive interfaces, and redistribution settings were reported? |
| [Incident excerpts](incidents/README.md) | 3 Markdown pages | What commands and selected output were retained from the three cases? |

## Follow one result across the files

For the external prefix `192.0.2.0/24`, O4's configuration identifies the static source and redistribution policy. Area 10's databases list O4 as the Type 7 originator. O2 and O1 list O2 as the Type 5 advertising router. O2's routing table shows `O N1`; O1's shows `O E1`.

For the branch summary, compare O2's four component routes and local Null0 summary with O1's Type 3 advertisement and installed `O IA` route. [Case 03](../troubleshooting/scenario-3-abr-route-filtering-control-plane.md) uses those observation points to isolate a filter.

## Read the scope correctly

The general files are baseline snapshots, not complete time-ordered logs for each incident. Use a case's own retained excerpts when assessing its failure and recovery.

Case 02 retains two recovery output excerpts, while its fault-state checks and remaining recovery checks are described in narrative. Command lists and the conceptual route-flow diagram are labeled as such.

A `FULL` neighbor confirms adjacency state; it does not prove that policy advertises every intended route. Installed equal-cost routes do not measure traffic distribution. The direct-link ping in Case 01 is the retained traffic test; the route/database cases do not demonstrate application delivery.

[Module overview](../README.md) · [Configuration guide](../configs/README.md) · [Case index](../troubleshooting/README.md)
