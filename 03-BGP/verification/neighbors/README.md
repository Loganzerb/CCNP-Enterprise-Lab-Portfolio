# Neighbor sessions — did the routers establish peering?

Each file contains `show ip bgp summary` for one router. A number in `State/PfxRcd` means the session is established; the number is a received-prefix count, not a health score.

| Router | Captured peers and prefix counts |
|---|---|
| [O1-CORE](O1-show-ip-bgp-summary.txt) | O2 `10.100.2.2`: 3; B1 `10.250.1.2`: 5 |
| [O2-ABR](O2-show-ip-bgp-summary.txt) | O1 `10.100.1.1`: 4; O4 `10.100.4.4`: 6 |
| [O4-EDGE](O4-show-ip-bgp-summary.txt) | O2 `10.100.2.2`: 5; B2 `10.250.2.2`: 6; B1 `10.250.2.3`: 5 |
| [B1-ISP-A](B1-show-ip-bgp-summary.txt) | O1 `10.250.1.1`: 3; O4 `10.250.2.1`: 5; X1 direct `10.250.3.2`: 4; X1 loopback `10.255.3.3`: 4 |
| [B2-ISP-B](B2-show-ip-bgp-summary.txt) | O4 `10.250.2.1`: 3; X1 `10.250.4.2`: 6 |
| [X1-OUTSIDE](X1-show-ip-bgp-summary.txt) | B1 direct `10.250.3.1`: 3; B2 `10.250.4.1`: 2; B1 loopback `10.255.1.1`: 3 |

These snapshots show established global IPv4 sessions. They were not captured simultaneously, and their counts are not the expected values for every later experiment.

For a failed-session comparison, [Case 01](../../troubleshooting/scenario-1-wrong-remote-as.md) pairs `Idle` with an explicit wrong-AS notification. For an established session hiding a path problem, see [Case 02](../../troubleshooting/scenario-2-ibgp-next-hop-reachability.md).

[Verification guide](../README.md) · [Topology](../../topology.md)
