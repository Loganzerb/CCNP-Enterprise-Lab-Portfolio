# Neighbors — who was exchanging routes?

Each file contains `show ip eigrp neighbors` for one device. Together they record all six expected EIGRP links.

| Capture | Peer addresses and local interfaces |
|---|---|
| [R1-CORE](R1-show-ip-eigrp-neighbors.txt) | R2 `10.12.0.2` on Gi0/0; R3 `10.13.0.2` on Gi0/1 |
| [R2-DIST-A](R2-show-ip-eigrp-neighbors.txt) | R1 `10.12.0.1` on Gi0/0; R3 `10.23.0.1` on Gi0/1; R4 `10.24.0.1` on Gi0/2 |
| [R3-DIST-B](R3-show-ip-eigrp-neighbors.txt) | R1 `10.13.0.1` on Gi0/0; R2 `10.23.0.2` on Gi0/1; R4 `10.34.0.2` on Gi0/2 |
| [R4-BRANCH](R4-show-ip-eigrp-neighbors.txt) | R2 `10.24.0.2` on Gi0/0; R3 `10.34.0.1` on Gi0/1; R5 `10.45.0.2` on Gi0/2 |
| [R5-REMOTE](R5-show-ip-eigrp-neighbors.txt) | R4 `10.45.0.1` on Gi0/0; header identifies named instance `CCNP-LAB` |

All headers identify AS 100. Queue counts are zero at capture time. Uptime and hold counters describe that moment; one snapshot does not demonstrate long-term stability or the absence of earlier resets.

R2's shorter hold countdown for R4 is consistent with the 6-second hold time configured on R4's facing interface. Different remaining timer values are not themselves evidence of a fault.

Neighbor presence establishes a routing relationship. For the destinations learned through it, continue to the [topology](../topology/README.md) and [routing](../routing/README.md) guides.

[Verification guide](../README.md) · [Interface addressing](../../topology.md)
