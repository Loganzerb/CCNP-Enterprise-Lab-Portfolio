# OSPF Protocol Verification

## Command Collected

```cisco
show ip protocols
```

This command validates process-wide OSPF settings: process number, router ID, area participation, enabled networks and interfaces, passive interfaces, maximum paths, redistribution, routing information sources, and administrative distance.

## Healthy-State Observations

- Every router runs OSPF process `1` with a stable loopback-based router ID: `10.100.1.1` through `10.100.5.5`.
- `O1-CORE` participates only in Area 0.
- IOS identifies `O2-ABR` as an area border router; it participates in one normal area and one Not-So-Stubby Area (NSSA), Area 10.
- `O3-BRANCH`, `O4-EDGE`, and `O5-TRANSIT` each participate only in the Area 10 NSSA.
- IOS identifies `O4-EDGE` as an Autonomous System Boundary Router (ASBR) and shows static-route redistribution with metric `20`, including subnets.
- `O3-BRANCH` has `maximum path 2`, matching the lab's intended Equal-Cost Multi-Path (ECMP) behavior; the other routers show a maximum of four paths.
- Loopbacks and other non-neighbor-facing interfaces appear in the passive-interface lists, while the routing-source lists identify the expected OSPF peers.
- The OSPF administrative distance is the default `110` on all five routers.

Other routing protocols appear in some raw captures because these routers belong to a larger masterclass topology; this section intentionally interprets only the OSPF evidence.
