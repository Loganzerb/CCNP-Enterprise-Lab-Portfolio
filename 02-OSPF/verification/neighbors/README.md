# Neighbors — did the expected adjacencies form?

The five `show ip ospf neighbor` captures show all five expected links in `FULL` state, viewed from both ends.

| Capture | Neighbors in the retained baseline |
|---|---|
| [O1-CORE](O1-show-ip-ospf-neighbor.txt) | O2: `FULL/DR` |
| [O2-ABR](O2-show-ip-ospf-neighbor.txt) | O1: `FULL/BDR`; O4: `FULL/DR`; O3: `FULL/-` |
| [O3-BRANCH](O3-show-ip-ospf-neighbor.txt) | O2 and O5: `FULL/-` |
| [O4-EDGE](O4-show-ip-ospf-neighbor.txt) | O2: `FULL/BDR`; O5: `FULL/-` |
| [O5-TRANSIT](O5-show-ip-ospf-neighbor.txt) | O3 and O4: `FULL/-` |

The role after the slash belongs to the **neighbor**. O1 seeing O2 as `FULL/DR` means O2 is the designated router on that segment. The local interface view in the [interface captures](../interfaces/README.md) provides the complementary perspective.

`FULL/-` is normal on the point-to-point links in this design. Router IDs identify peers; the Address column gives the peer's address on the connecting link.

A full adjacency is one check, not a guarantee of every expected route. Compare [Case 01](../../troubleshooting/scenario-1-ospf-mtu-exstart-exchange.md), where synchronization stalls, with [Case 03](../../troubleshooting/scenario-3-abr-route-filtering-control-plane.md), where all captured O2 neighbors stay full while a summary disappears.

[Verification guide](../README.md)
