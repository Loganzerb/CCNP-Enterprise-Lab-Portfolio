# Database — where did the routing information originate?

The link-state database (LSDB) records OSPF advertisements. These `show ip ospf database` captures show the inventory by area and LSA type; they are not complete detailed output for every advertisement.

| Capture | What to inspect |
|---|---|
| [O1-CORE](O1-show-ip-ospf-database.txt) | Area 0 summaries from O2, including the branch summary, plus two Type 5 external advertisements |
| [O2-ABR](O2-show-ip-ospf-database.txt) | Both area databases; Area 10 Type 7 entries from O4; translated Type 5 entries advertised by O2 |
| [O3-BRANCH](O3-show-ip-ospf-database.txt) | Area 10 router/network LSAs, a default summary from O2, and two Type 7 entries |
| [O4-EDGE](O4-show-ip-ospf-database.txt) | The two Type 7 entries list O4's router ID as their originator |
| [O5-TRANSIT](O5-show-ip-ospf-database.txt) | The same Area 10 advertisement set at another observation point |

## Useful fields and LSA types

| Output section or field | Interpretation in this lab |
|---|---|
| Router Link States — Type 1 | Routers describing topology within each area |
| Net Link States — Type 2 | Broadcast segments represented by their designated router |
| Summary Net Link States — Type 3 | Inter-area prefixes, including O2's branch summary toward Area 0 and default toward Area 10 |
| Type-7 AS External Link States | NSSA external prefixes `192.0.2.0` and `198.51.100.0`, originated by O4 |
| Type-5 AS External Link States | Corresponding external advertisements outside Area 10, with O2 as advertising router |
| Link ID and ADV Router | The advertisement's identifier and its originator; these are different fields |
| Age / Seq# / Checksum | State of an individual advertisement; snapshots taken at different times can have different ages |

No Type 4 section is present in these saved database inventories. The module does not claim a captured example of every possible LSA type.

The inventory alone does not expose every mask, metric, or forwarding address. [Case 03](../../troubleshooting/scenario-3-abr-route-filtering-control-plane.md) retains detailed summary output identifying the `/22` mask and metric. [Case 02](../../troubleshooting/scenario-2-nssa-capability-and-lsa-translation.md) distinguishes reported stale-LSA observations from its captured recovery excerpts.

Follow an advertisement into the [routing table](../routing/README.md) before claiming route installation.

[Verification guide](../README.md)
