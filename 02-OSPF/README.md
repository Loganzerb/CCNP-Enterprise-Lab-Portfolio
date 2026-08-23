# OSPF Lab Portfolio

## Overview

This section documents a completed five-router, CCNP-level Open Shortest Path First (OSPF) lab built to examine how a multi-area link-state routing domain operates, converges, and responds to faults and policy changes. **O1-CORE**, **O2-ABR**, **O3-BRANCH**, **O4-EDGE**, and **O5-TRANSIT** model core, area-border, branch, edge, and transit responsibilities.

The lab extends beyond neighbor formation to cover network types, Designated Router (DR) and Backup Designated Router (BDR) behavior, the Link-State Database (LSDB), inter-area exchange, stub-area variants, external routing, route control, and Equal-Cost Multipath (ECMP). Sanitized configurations, healthy-state evidence, and three completed troubleshooting case studies are organized in dedicated directories.

> **Scope note:** Interface addressing, device-to-interface mappings, and command-line output are documented in the supporting artifacts captured from the lab. This overview avoids unsupported assumptions.

## Lab Objectives

- Build and validate a five-router OSPFv2 domain using process 1.
- Establish a multi-area hierarchy containing **Area 0** and **Area 10**.
- Confirm neighbor formation and progression to the expected adjacency states.
- Examine DR/BDR elections on eligible multiaccess segments.
- Relate OSPF network types to discovery, elections, timers, and next-hop behavior.
- Interpret Link-State Advertisement (LSA) types by originator, scope, router role, and routing-table result.
- Analyze internal-router, backbone-router, Area Border Router (ABR), and Autonomous System Boundary Router (ASBR) responsibilities.
- Validate Not-So-Stubby Area (NSSA) and totally NSSA behavior, including Type 7 origination and Type 7-to-Type 5 translation.
- Apply and verify summarization and route filtering at OSPF area boundaries.
- Validate ECMP when the topology provides equal-cost routes.
- Examine redistribution as a controlled routing-domain boundary.
- Introduce realistic control-plane faults, identify root causes, restore service, and document before-and-after evidence.

## Topology Summary

![OSPF Lab Topology](topology.png)

| Router | Functional role |
|---|---|
| **O1-CORE** | Core and backbone routing within the OSPF domain |
| **O2-ABR** | ABR connecting the backbone and non-backbone area |
| **O3-BRANCH** | Branch-side participant in the multi-area design |
| **O4-EDGE** | Edge function used for route-policy and external-routing behavior |
| **O5-TRANSIT** | Transit-side routing function associated with the lab boundary |

**Area 0** provides the OSPF backbone. **Area 10** provides the non-backbone area used to study inter-area routing and NSSA/totally NSSA behavior. The design creates clear observation points for ABR processing, LSA scope, external-route translation, summarization, filtering, and path selection.

## Technologies and Concepts Practiced

### OSPF Adjacencies and Interface Behavior

- Router IDs, hello exchange, neighbor discovery, and progression to `FULL`
- Adjacency prerequisites, including compatible area and interface parameters
- OSPF interface network types and their effect on topology representation
- DR and BDR elections on eligible multiaccess networks

### Multi-Area OSPF

- Area 0 backbone and Area 10 non-backbone design
- Internal-router, backbone-router, and ABR responsibilities
- Inter-area reachability through the ABR
- Area boundaries as control points for summarization and filtering
- NSSA and totally NSSA behavior, including the default route supplied by the ABR and the handling of external information

### Link-State Advertisements

| LSA type | Function examined |
|---|---|
| **Type 1** | Router topology within an area |
| **Type 2** | Multiaccess network representation by the DR, where applicable |
| **Type 3** | Inter-area summary information originated by an ABR |
| **Type 4** | Reachability to an ASBR across area boundaries |
| **Type 5** | External prefixes advertised through the standard OSPF domain |
| **Type 7** | External prefixes originated inside an NSSA |

The lab connects each relevant LSA to its originator, flooding scope, associated router role, and routing-table outcome rather than treating the LSDB as an isolated table.

### NSSA, Summarization, and Route Control

- Type 5 restrictions within an NSSA
- Type 7 external origination and Type 7-to-Type 5 translation at the ABR
- Inter-area summarization of `172.20.32.0/24` through `172.20.35.0/24` as `172.20.32.0/22`
- ABR prefix filtering and its effect on Type 3 advertisements without disrupting healthy adjacencies
- ASBR and ABR responsibilities at redistribution and area boundaries

### Path Selection and Redistribution Boundaries

- OSPF cost comparison and best-path selection
- ECMP installation when multiple paths have equal OSPF cost
- Redistribution as an explicit policy boundary, verified through both the LSDB and routing table
- External route behavior across the Type 7-to-Type 5 translation boundary

## Skills Demonstrated

- Designing and validating a hierarchical OSPF deployment
- Reading neighbor, interface, protocol, database, and routing state as a connected evidence set
- Distinguishing adjacency failures from LSDB, policy, and forwarding failures
- Explaining ABR and ASBR behavior across area and redistribution boundaries
- Evaluating NSSA translation rather than checking only end-to-end reachability
- Applying summarization and filtering at deliberate control points
- Confirming ECMP from metric and installed-next-hop evidence
- Troubleshooting through baseline capture, fault isolation, correction, and post-change validation
- Producing sanitized, reproducible documentation suitable for a technical portfolio

## Verification Strategy

Verification is layered so that a successful ping is not mistaken for complete protocol health:

1. **Interfaces** — [`verification/interfaces/`](verification/interfaces/) confirms operational state and intended OSPF participation.
2. **Neighbors** — [`verification/neighbors/`](verification/neighbors/) validates peer router IDs, adjacency state, and DR/BDR relationships where applicable.
3. **Database** — [`verification/database/`](verification/database/) records LSA origin, type, scope, and translation behavior.
4. **Routing** — [`verification/routing/`](verification/routing/) confirms intra-area, inter-area, external, and equal-cost route installation as appropriate.
5. **Protocols** — [`verification/protocols/`](verification/protocols/) captures process-level area, timer, reference-bandwidth, and policy context.

Together, these healthy-state artifacts provide the baseline used by the troubleshooting case studies.

## Completed Troubleshooting Case Studies

1. [`scenario-1-ospf-mtu-exstart-exchange.md`](troubleshooting/scenario-1-ospf-mtu-exstart-exchange.md) — traces an interface Maximum Transmission Unit (MTU) mismatch that permits neighbor discovery but prevents database synchronization, leaving the adjacency in `EXSTART` or `EXCHANGE` until the inconsistency is corrected.

2. [`scenario-2-nssa-capability-and-lsa-translation.md`](troubleshooting/scenario-2-nssa-capability-and-lsa-translation.md) — follows an NSSA capability mismatch from adjacency loss and failed Type 7 origination through the absence of translated Type 5 LSAs and external routes, then verifies restoration of the Type 7 → Type 5 → `O E1` path.

3. [`scenario-3-abr-route-filtering-control-plane.md`](troubleshooting/scenario-3-abr-route-filtering-control-plane.md) — demonstrates that all OSPF adjacencies can remain `FULL` while ABR policy suppresses the `172.20.32.0/22` Type 3 LSA toward Area 0; removing only the filter application restores both the LSA and the `O IA` route.

Each case study records the intended behavior, healthy baseline, injected fault, symptoms, diagnostic evidence, root cause, corrective action, post-restoration verification, and operational takeaway.

## Repository Structure

```text
02-OSPF/
├── README.md
├── topology.png
├── configs/
│   ├── README.md
│   ├── O1-CORE.cfg
│   ├── O2-ABR.cfg
│   ├── O3-BRANCH.cfg
│   ├── O4-EDGE.cfg
│   └── O5-TRANSIT.cfg
├── verification/
│   ├── README.md
│   ├── neighbors/
│   ├── interfaces/
│   ├── database/
│   ├── routing/
│   └── protocols/
└── troubleshooting/
    ├── README.md
    ├── scenario-1-ospf-mtu-exstart-exchange.md
    ├── scenario-2-nssa-capability-and-lsa-translation.md
    └── scenario-3-abr-route-filtering-control-plane.md
```

This structure separates device configuration, healthy-state evidence, and fault analysis while keeping the main README easy to scan.

## Lab Environment

- **Platform:** Cisco Modeling Labs (CML)
- **Routing protocol:** OSPFv2 for IPv4
- **OSPF process:** 1
- **Routers:** O1-CORE, O2-ABR, O3-BRANCH, O4-EDGE, and O5-TRANSIT
- **Area design:** Area 0 and Area 10
- **Evidence:** Sanitized configurations and captured Cisco IOS verification output

Device software versions and resource assignments may vary by CML image. The portfolio emphasizes observable protocol behavior rather than image-specific assumptions.

## Key Takeaways

- A neighbor entry alone does not prove a usable adjacency; final state and database synchronization matter.
- The LSDB can reveal whether information was originated, received, translated, or suppressed before the routing table exposes the downstream symptom.
- ABRs are control boundaries for LSA transformation, summarization, and filtering—not merely routers that connect areas.
- NSSA troubleshooting requires following external information across Type 7 and Type 5 LSAs.
- Healthy `FULL` adjacencies do not guarantee correct inter-area reachability when route policy is involved.
- ECMP must be validated through OSPF cost and installed next hops rather than inferred from redundant links.
- Redistribution is safest when treated as an explicit, testable policy boundary.
- A known-good baseline makes fault isolation faster and the resulting documentation more credible.

## Optional Extensions

- Record convergence timing for selected link and neighbor failures.
- Extend cost-manipulation tests with additional documented ECMP transitions.
- Add a compact command index mapping verification goals to commonly used Cisco IOS commands.

---

This lab is part of the **CCNP Enterprise Lab Portfolio** and demonstrates practical OSPF design, verification, and troubleshooting through reproducible evidence rather than configuration alone.
