# OSPF topology and addressing

![OSPF five-router baseline topology](topology.png)

The diagram shows the five-router OSPF design verified by the neighbor captures. **O2 connects Area 0 and Area 10.** Area 10 is configured as a totally NSSA: O2 uses `nssa no-summary`, while O3, O4, and O5 use `nssa`.

## Device roles

| Router | Router ID / Loopback0 | Area participation | Role |
|---|---|---|---|
| O1-CORE | `10.100.1.1/32` | Area 0 | Backbone observation point |
| O2-ABR | `10.100.2.2/32` | Areas 0 and 10; Loopback0 in Area 0 | Area border, branch summarization, NSSA translation |
| O3-BRANCH | `10.100.3.3/32` | Area 10 | Four branch loopbacks |
| O4-EDGE | `10.100.4.4/32` | Area 10 | ASBR redistributing two static test prefixes |
| O5-TRANSIT | `10.100.5.5/32` | Area 10 | Second internal path between O3 and O4 |

The area border router (ABR) exchanges routing information between areas. The autonomous system boundary router (ASBR) introduces routes from another source; here, O4 introduces selected static routes.

## Verified router-to-router links

| Link and network | First endpoint | Second endpoint | Area / network type |
|---|---|---|---|
| O1–O2: `10.100.12.0/30` | O1 Gi0/0: `10.100.12.1` | O2 Gi0/0: `10.100.12.2` | Area 0 / broadcast |
| O2–O3: `10.100.23.0/30` | O2 Gi0/1: `10.100.23.1` | O3 Gi0/0: `10.100.23.2` | Area 10 / point-to-point |
| O2–O4: `10.100.24.0/30` | O2 Gi0/2: `10.100.24.1` | O4 Gi0/0: `10.100.24.2` | Area 10 / broadcast |
| O3–O5: `10.100.35.0/30` | O3 Gi0/1: `10.100.35.1` | O5 Gi0/0: `10.100.35.2` | Area 10 / point-to-point |
| O4–O5: `10.100.45.0/30` | O4 Gi0/1: `10.100.45.2` | O5 Gi0/1: `10.100.45.1` | Area 10 / point-to-point |

All five links have captured full adjacencies. The broadcast segments elect designated and backup routers; the point-to-point segments do not. On O1–O2, O2 is DR and O1 is BDR. On O2–O4, O4 is DR and O2 is BDR in the retained baseline.

[Neighbor evidence](verification/neighbors/README.md) · [Interface evidence](verification/interfaces/README.md)

## Branch and external advertisements

O3's Loopbacks 1–4 use `172.20.32.1/24` through `172.20.35.1/24`. O2 advertises their combined `172.20.32.0/22` summary into Area 0. O1's installed metric is 21 in the baseline.

O4 redistributes `192.0.2.0/24` and `198.51.100.0/24`, both backed by Null0. Area 10 carries these as Type 7 LSAs; O2 advertises translated Type 5 LSAs into Area 0. O2 installs `O N1` routes and O1 installs `O E1` routes.

O2 also originates the captured Area 10 default as a Type 3 LSA. This is separate from the two external test prefixes and does not establish Internet access.

## Connections outside the five-router view

| Retained setting | Evidence boundary |
|---|---|
| O1 Gi0/1: `10.200.1.2/30`, Area 0, description toward R1-CORE | Interface output shows point-to-point state with `0/0` neighbors; no peer configuration is included in this module |
| O4 Gi0/2: `10.200.2.2/30`, Area 10, description toward R3-DIST-B | Interface output shows point-to-point state with `0/0` neighbors; the subnet appears in routing evidence |
| O4 Gi0/3: `10.250.2.1/29`, description toward B2-ISP-B | Retained in the extract but not active in the module's OSPF interface output |

These settings explain addresses and other-protocol context in the raw files. They are omitted from the diagram so a configured interface is not presented as a verified extra adjacency.

## Redundant paths

O2 has two installed next hops toward O5's loopback: through O3 and O4, both metric 21. O3 has two next hops toward O4 and the redistributed prefixes. O5 has two next hops for the default route.

Those entries establish equal-cost route installation. They do not measure per-flow distribution, throughput, or failover time.

[Configuration guide](configs/README.md) · [Routing evidence](verification/routing/README.md) · [Module overview](README.md)
