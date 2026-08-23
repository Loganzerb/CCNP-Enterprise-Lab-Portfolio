# OSPF Verification

This directory preserves the healthy-state evidence for the five-router OSPF (Open Shortest Path First) lab. The collection is organized in layers so that verification moves from adjacency formation through interface participation and link-state convergence to the resulting routes and protocol-wide policy.

## Verification Methodology

| Layer | Command | What it validates |
|---|---|---|
| [Neighbors](neighbors/) | `show ip ospf neighbor` | Expected peers reach a full adjacency, including DR/BDR and point-to-point relationships. |
| [Interfaces](interfaces/) | `show ip ospf interface brief` | Process, area, address, cost, network state, and neighbor count are correct on each OSPF-enabled interface. |
| [Database](database/) | `show ip ospf database` | The Link-State Database (LSDB) contains the expected Link-State Advertisements (LSAs), summaries, NSSA externals, and translated externals. |
| [Routing](routing/) | `show ip route ospf` | OSPF installs the intended intra-area, inter-area, external, summarized, default, and Equal-Cost Multi-Path (ECMP) routes. |
| [Protocols](protocols/) | `show ip protocols` | Process-wide router IDs, area membership, passive interfaces, path limits, redistribution, and routing sources match the design. |

## Healthy-State Design Proven by the Evidence

- `O1-CORE` operates in Area 0 and reaches Area 10 through `O2-ABR`.
- `O2-ABR` joins Area 0 and Area 10, acting as the Area Border Router (ABR) between the backbone and the Not-So-Stubby Area (NSSA).
- `O3-BRANCH`, `O4-EDGE`, and `O5-TRANSIT` participate in Area 10.
- `O4-EDGE` acts as an Autonomous System Boundary Router (ASBR) and redistributes the static prefixes `192.0.2.0/24` and `198.51.100.0/24`.
- Area 10 carries those external prefixes as Type 7 LSAs; `O2-ABR` translates them to Type 5 LSAs for Area 0.
- `O2-ABR` advertises the summarized branch prefix `172.20.32.0/22` toward Area 0 and originates the Area 10 default route.
- The routing evidence confirms ECMP where equal-cost paths exist, including the path to `O5-TRANSIT` from `O2-ABR`.

The raw command-output files in each subdirectory remain the source of truth; these READMEs provide a concise interpretation of that evidence.
