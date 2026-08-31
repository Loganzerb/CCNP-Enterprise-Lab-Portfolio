# CCNP Enterprise Lab Portfolio

> **Hands-on Cisco enterprise routing and switching work, documented through configurations, captured device output, controlled fault injection, and recovery analysis.**

This repository is a technical evidence record of completed Cisco Modeling Labs (CML) projects. It is designed to show what was actually built, configured, verified, broken, diagnosed, and restored—not to serve as a collection of certification-note summaries.

Every completed section gives a reviewer a traceable path from design intent to implementation and observed behavior:

```text
topology → device configuration → healthy-state output → injected fault → diagnosis → restoration
```

## Portfolio snapshot

| Completed labs | Device configurations | Captured `.txt` evidence | Troubleshooting / controlled-test cases | Topology diagrams | Importable CML YAMLs |
|---:|---:|---:|---:|---:|---:|
| **5** | **26** | **83** | **27** | **5** | **2** |

These counts reflect the current repository contents. Future topics are not listed as completed, and an artifact is only claimed when it is present in the repository.

## Portfolio purpose

The goal is to demonstrate practical network-engineering work at a level that can be inspected rather than merely asserted. A hiring manager, engineer, or technical interviewer can open a lab and review:

- the topology and intended device roles;
- the actual per-device Cisco IOS or IOSvL2 configuration;
- captured `show` command material from the lab;
- the expected healthy control-plane and forwarding state;
- deliberately introduced failures and their observable symptoms;
- the commands and reasoning used to isolate the cause; and
- the corrective action and available recovery evidence.

This is a lab portfolio, not a claim that simulated work is production experience. Its purpose is to provide concrete evidence of hands-on configuration, verification, and troubleshooting in controlled enterprise-style environments.

## Engineering workflow

```text
BUILD  →  VERIFY  →  BREAK  →  DIAGNOSE  →  RESTORE
```

| Phase | Engineering activity | Evidence preserved in this repository |
|---|---|---|
| **Build** | Define roles, addressing, adjacencies, redundancy, and policy; configure each device in CML. | Topology diagrams, per-device `.cfg` files, and—where retained—CML YAML exports. |
| **Verify** | Establish a known-good baseline at interface, neighbor, protocol-database, routing, and forwarding layers. | Captured `.txt` evidence from commands such as `show ip eigrp topology`, `show ip ospf database`, `show ip bgp`, and `show spanning-tree`. |
| **Break** | Introduce one deliberate control-plane, policy, protection, or consistency fault at a time. | Scenario documentation and retained failure-state output. |
| **Diagnose** | Correlate symptoms across configuration, protocol state, logs, route installation, and interface behavior. | Command-by-command analysis, root-cause explanation, and supporting artifacts. |
| **Restore** | Remove the fault, return the design to its intended state, and verify the result. | Post-fix checks where captured, restored configuration snapshots, and explicit recovery notes. |

The case studies also identify evidence limits. If a complete console transcript was not retained, the scenario explains the observed state without manufacturing IOS output.

## Evidence index

| Lab | Configurations | Captured `.txt` evidence | Case studies | Diagram | CML import |
|---|---:|---:|---:|---|---|
| [**01 — EIGRP**](01-EIGRP/) | [5 `.cfg`](01-EIGRP/configs/) | [20 `.txt`](01-EIGRP/verification/) | [3 cases](01-EIGRP/troubleshooting/) | [View](01-EIGRP/topology.png) | — |
| [**02 — OSPF**](02-OSPF/) | [5 `.cfg`](02-OSPF/configs/) | [25 `.txt`](02-OSPF/verification/) | [3 cases](02-OSPF/troubleshooting/) | [View](02-OSPF/topology.png) | — |
| [**03 — BGP**](03-BGP/) | [6 `.cfg`](03-BGP/configs/) | [20 `.txt`](03-BGP/verification/) | [3 cases](03-BGP/troubleshooting/) | [View](03-BGP/topology.png) | — |
| [**04 — STP**](04-STP/) | [5 `.cfg`](04-STP/configs/) | [9 `.txt`](04-STP/verification/) | [11 cases](04-STP/troubleshooting/) | [View](04-STP/topology.png) | [YAML](04-STP/CCNP_MASTERCLASS_STP.yaml) |
| [**05 — MSTP**](05-MSTP/) | [5 `.cfg`](05-MSTP/configs/) | [9 `.txt`](05-MSTP/verification/) | [7 cases](05-MSTP/troubleshooting/) | [View](05-MSTP/topology.png) | [YAML](05-MSTP/CCNP_MASTERCLASS_MSTP.yaml) |

`—` means the current folder does not contain a `.yaml` or `.yml` export. The EIGRP, OSPF, and BGP sections document CML-built work through topology diagrams, configurations, verification output, and troubleshooting records, but they are not directly importable from the current repository snapshot. The STP and MSTP sections include CML lab YAML files with embedded node-configuration snapshots; local image mapping and VLAN-database state should be verified after import.

## Completed lab sections

### 01 — [EIGRP: DUAL, redundancy, and route control](01-EIGRP/)

This five-router EIGRP AS 100 environment models core, distribution, branch, and remote roles across **R1-CORE**, **R2-DIST-A**, **R3-DIST-B**, **R4-BRANCH**, and **R5-REMOTE**. The saved configurations preserve classic EIGRP on R1–R4 and named-mode IPv4 EIGRP on R5, demonstrating both configuration models inside the same autonomous system.

Configuration and evidence include:

- neighbor formation, router IDs, passive-interface policy, and MD5 key-chain authentication;
- Diffusing Update Algorithm (DUAL) operation, successors, feasible successors, Feasible Distance, Reported Distance, and the Feasibility Condition;
- redundant path selection and convergence after a successor failure;
- manual `/22` summarization for branch and remote LAN ranges;
- EIGRP stub `connected summary` behavior on R5;
- default-only route filtering toward the remote router;
- explicit 2-second hello and 6-second hold timers on **R4-BRANCH**'s uplink to **R2-DIST-A**; and
- route-map-controlled static-default injection plus route-map and tag-controlled EIGRP/OSPF redistribution preserved in the device configurations.

The verification tree contains five-device captures for neighbors, topology tables, EIGRP routes, and protocol state. The three completed cases cover [feasible-successor promotion](01-EIGRP/troubleshooting/scenario-1-feasible-successor-promotion.md), [recalculation when no feasible successor exists](01-EIGRP/troubleshooting/scenario-2-no-feasible-successor-dual-recalculation.md), and [inconsistent manual summarization across redundant uplinks](01-EIGRP/troubleshooting/scenario-3-inconsistent-eigrp-summarization.md).

> **Evidence note:** In the no-feasible-successor case, convergence completed too quickly to retain direct Active/Query/Reply output. The case documents the metric and topology change without presenting a captured Stuck-in-Active event.

**Review:** [Lab README](01-EIGRP/README.md) · [Topology](01-EIGRP/topology.png) · [Configurations](01-EIGRP/configs/) · [Verification](01-EIGRP/verification/) · [Troubleshooting](01-EIGRP/troubleshooting/)

### 02 — [OSPF: multi-area design, LSDB analysis, and policy](02-OSPF/)

This five-router OSPFv2 process 1 lab uses **Area 0** and **Area 10** to expose backbone, Area Border Router (ABR), branch, edge/Autonomous System Boundary Router (ASBR), and transit behavior. Area 10 operates as a totally Not-So-Stubby Area (NSSA), creating a practical environment for examining adjacency formation, Link-State Advertisement (LSA) scope, external-route translation, summarization, and route policy.

Implemented and verified:

- broadcast and point-to-point OSPF network types, including DR/BDR and full point-to-point adjacencies;
- router IDs, passive-interface defaults, reference bandwidth, path limits, and MD5 message-digest authentication;
- Type 1, Type 2, Type 3, Type 5, and Type 7 LSAs in captured Link-State Database output;
- Type 7-to-Type 5 translation by **O2-ABR** between Area 10 and Area 0;
- summarization of `172.20.32.0/24` through `172.20.35.0/24` as `172.20.32.0/22`;
- ABR prefix filtering and the distinction between healthy adjacencies and missing inter-area reachability;
- route-map-controlled static redistribution by **O4-EDGE** as external type 1 routes;
- totally NSSA default-route behavior; and
- Equal-Cost Multipath (ECMP) where equal-cost routes are present.

The 25 captured outputs form a five-layer baseline: [interfaces](02-OSPF/verification/interfaces/), [neighbors](02-OSPF/verification/neighbors/), [database](02-OSPF/verification/database/), [routing](02-OSPF/verification/routing/), and [protocols](02-OSPF/verification/protocols/). Completed break/fix cases cover an [MTU mismatch holding an adjacency in EXSTART](02-OSPF/troubleshooting/scenario-1-ospf-mtu-exstart-exchange.md), an [NSSA capability and Type 7-to-Type 5 translation failure](02-OSPF/troubleshooting/scenario-2-nssa-capability-and-lsa-translation.md), and [ABR filtering that removes a Type 3/O IA route while neighbors remain FULL](02-OSPF/troubleshooting/scenario-3-abr-route-filtering-control-plane.md).

**Review:** [Lab README](02-OSPF/README.md) · [Topology](02-OSPF/topology.png) · [Configurations](02-OSPF/configs/) · [Verification](02-OSPF/verification/) · [Troubleshooting](02-OSPF/troubleshooting/)

### 03 — [BGP: multi-AS routing, policy, and path resilience](03-BGP/)

This six-router, four-AS environment combines enterprise route reflection with redundant provider connectivity. Enterprise AS 65000 contains **O1-CORE**, **O2-ABR**, and **O4-EDGE**; O2 is the route reflector for O1 and O4. Provider routers **B1-ISP-A** and **B2-ISP-B** operate in AS 65100 and AS 65200, while **X1-OUTSIDE** operates in AS 65300.

Configuration and evidence include:

- loopback-sourced iBGP with route reflection and `next-hop-self`;
- conventional eBGP and loopback-based eBGP multihop across redundant external paths;
- IPv4 unicast routing plus configured IPv6 and CUSTOMER-A IPv4 VRF address families on the B1–X1 relationship;
- exact Null0-backed BGP network origination;
- `summary-only` aggregation of `192.0.2.0/24` from more-specific prefixes;
- route-map-controlled static redistribution of `10.50.50.0/24`;
- X1 tagging `198.51.100.0/24` with community `65300:100` toward B1's direct session, where B1 sets Local Preference 50, while X1 marks the loopback multihop advertisement with `no-export`; and
- control-plane verification followed by route and recursive next-hop forwarding checks.

The healthy-state evidence includes six neighbor summaries, six IPv4 BGP tables, five policy captures, and three forwarding captures. The completed cases diagnose and restore a [wrong remote AS / Bad Peer AS failure](03-BGP/troubleshooting/scenario-1-wrong-remote-as.md), [unreachable iBGP next-hop after removing `next-hop-self`](03-BGP/troubleshooting/scenario-2-ibgp-next-hop-reachability.md), and [unintended outbound filtering caused by a route-map implicit deny](03-BGP/troubleshooting/scenario-3-route-map-implicit-deny.md). The latter two cases also show alternate paths preserving reachability while an individual path is repaired.

> **Evidence note:** IPv6 and VRF BGP are present in the saved configurations, while the dedicated raw verification set is IPv4-focused. The configurations also retain some unattached study-policy objects; the lab README distinguishes those objects from policy active in the captured baseline.

**Review:** [Lab README](03-BGP/README.md) · [Topology](03-BGP/topology.png) · [Configurations](03-BGP/configs/) · [Verification](03-BGP/verification/) · [Troubleshooting](03-BGP/troubleshooting/)

### 04 — [STP: campus Layer 2 resiliency and protection](04-STP/)

This Rapid PVST+ masterclass uses an importable seven-node CML topology: five IOSvL2 switches, two VLAN 10 endpoints, and nine links. Four switches form a redundant campus design, while **SW5-ROGUE** provides a dedicated fault-injection point. Trunks carry VLANs 10, 20, 30, and 40.

Implemented and analyzed:

- deterministic per-VLAN root placement and load sharing: **SW1-DIST-A** for VLANs 10/20 and **SW4-DIST-B** for VLANs 30/40;
- Rapid PVST+ convergence and the long path-cost method;
- root-port, designated-port, alternate-port, path-cost, and port-priority decision making;
- PortFast edge and BPDU Guard at endpoint-facing ports;
- Root Guard, Loop Guard, inconsistent-port states, and err-disable diagnosis;
- native-VLAN/PVID and trunk/access consistency failures;
- LACP EtherChannel formation, STP operation over a port channel, member degradation, passive/passive failure, and the documented recovery method; and
- Bridge Assurance network-port behavior.

The strongest retained EtherChannel sequence shows two standalone links, healthy LACP formation as `Po1(SU)`, STP moving to the logical port channel, single-member degradation, and passive/passive suspension. The case study documents the recovery method; a separate post-recovery transcript after the passive/passive fault was not retained. Eleven documented cases cover BPDU Guard, Root Guard, Loop Guard, native-VLAN mismatch, port-type inconsistency, EtherChannel consistency and misconfiguration protection, Bridge Assurance, classic-STP timer observations, path engineering, and LACP member/negotiation failures.

> **Evidence note:** All eleven cases document the observed symptom, diagnosis, and recovery method, but retained failure-state output is strongest for LACP. Several protection and consistency cases retain case analysis plus configuration or baseline evidence rather than full failure transcripts, and exact classic-STP stopwatch timing was not retained.

**Review:** [Lab README](04-STP/README.md) · [Topology](04-STP/topology.png) · [CML YAML](04-STP/CCNP_MASTERCLASS_STP.yaml) · [Configurations](04-STP/configs/) · [Verification](04-STP/verification/) · [Troubleshooting](04-STP/troubleshooting/)

### 05 — [MSTP: regions, instances, boundaries, and interoperability](05-MSTP/)

This importable five-switch CML lab creates a four-switch `CCNP_MST` region and a fifth boundary/interoperability node. The main region uses revision 1, maps VLANs 10/20 to MST instance 1 and VLANs 30/40 to MST instance 2, assigns **MST1-DIST-A** as the MSTI 1 root, and assigns **MST4-DIST-B** as the MSTI 2 root.

Implemented and verified:

- MST0/IST operation and the treatment of VLANs not mapped to another instance;
- independent MSTI root elections and per-instance path diversity;
- region identity through name, revision, VLAN-to-instance mapping, and configuration digest;
- Common and Internal Spanning Tree (CIST), CIST Regional Root, boundary-port, Root Port, and Master Port behavior;
- separate-region behavior with an external CIST root;
- Max Hops and remaining-hop observations;
- operational long path costs on 1-Gb links; and
- MST-to-Rapid-PVST+ simulation, with captured logical blocking in both superior- and inferior-VLAN consistency directions and captured FAIL/OK syslog plus zero-inconsistent recovery for the inferior-VLAN case.

Nine captured-output/excerpt files document the main region, instance paths, engineered roots, boundary/master roles, region mismatch signatures, PVST Simulation behavior, and operational details. Seven cases isolate revision, mapping/digest, and name mismatches; external CIST-root behavior; superior and inferior PVST Simulation failures; and a transient Dispute state during reconvergence.

> **Saved-state note:** The main four switches are restored to the intended MST region. In the final CML YAML, MST5 is saved in Rapid PVST+ mode as the interoperability boundary; its temporary separate-region MST experiments remain documented in the evidence and case studies. The superior-VLAN recovery is documented, but its post-recovery CLI was not retained.

**Review:** [Lab README](05-MSTP/README.md) · [Topology](05-MSTP/topology.png) · [CML YAML](05-MSTP/CCNP_MASTERCLASS_MSTP.yaml) · [Configurations](05-MSTP/configs/) · [Verification](05-MSTP/verification/) · [Troubleshooting](05-MSTP/troubleshooting/)

## Repository structure

The following high-signal tree reflects the current repository. Supporting README and placeholder files inside subdirectories are omitted here only to keep the map readable.

```text
CCNP-Enterprise-Lab-Portfolio/
├── README.md
├── 01-EIGRP/
│   ├── README.md
│   ├── topology.png
│   ├── configs/                         # 5 sanitized router configurations
│   ├── verification/
│   │   ├── neighbors/                   # 5 show ip eigrp neighbors captures
│   │   ├── protocols/                   # 5 show ip protocols captures
│   │   ├── routing/                     # 5 show ip route eigrp captures
│   │   └── topology/                    # 5 show ip eigrp topology captures
│   └── troubleshooting/                 # 3 case-study Markdown files
├── 02-OSPF/
│   ├── README.md
│   ├── topology.png
│   ├── configs/                         # 5 sanitized router configurations
│   ├── verification/
│   │   ├── database/                    # 5 show ip ospf database captures
│   │   ├── interfaces/                  # 5 interface-brief captures
│   │   ├── neighbors/                   # 5 show ip ospf neighbor captures
│   │   ├── protocols/                   # 5 show ip protocols captures
│   │   └── routing/                     # 5 show ip route ospf captures
│   └── troubleshooting/                 # 3 case-study Markdown files
├── 03-BGP/
│   ├── README.md
│   ├── topology.png
│   ├── configs/                         # 6 sanitized router configurations
│   ├── verification/
│   │   ├── bgp-table/                   # 6 full IPv4 BGP table captures
│   │   ├── forwarding/                  # 3 forwarding captures
│   │   ├── neighbors/                   # 6 BGP summary captures
│   │   └── policy/                      # 5 targeted policy captures
│   └── troubleshooting/                 # 3 case-study Markdown files
├── 04-STP/
│   ├── README.md
│   ├── topology.png
│   ├── CCNP_MASTERCLASS_STP.yaml        # 7 nodes, 9 links, embedded configs
│   ├── configs/                         # 5 IOSvL2 switch configurations
│   ├── verification/
│   │   ├── bridge-assurance/
│   │   ├── convergence/
│   │   ├── etherchannel/
│   │   ├── path-engineering/
│   │   ├── protection/
│   │   └── root-election/
│   └── troubleshooting/                 # 11 case-study Markdown files
└── 05-MSTP/
    ├── README.md
    ├── topology.png
    ├── CCNP_MASTERCLASS_MSTP.yaml       # 5 nodes, 6 links, embedded configs
    ├── configs/                         # 5 IOSvL2 switch configurations
    ├── verification/
    │   ├── boundary-master/
    │   ├── instances/
    │   ├── operational/
    │   ├── pvst-simulation/
    │   ├── region/
    │   ├── region-mismatch/
    │   └── root-engineering/
    └── troubleshooting/                 # 7 scenario directories
```

## Skills and technologies demonstrated

| Area | Evidence-backed technologies and practices |
|---|---|
| **EIGRP** | Classic and named mode, DUAL, successors and feasible successors, metric/path analysis, authentication, timers, summarization, stub routing, filtering, passive interfaces, and controlled redistribution. |
| **OSPFv2** | Multi-area design, totally NSSA, ABR/ASBR roles, broadcast and point-to-point networks, DR/BDR, LSDB analysis, Type 7-to-Type 5 translation, summarization, filtering, external type 1 routes, default routing, and ECMP. |
| **BGP** | iBGP route reflection, redundant eBGP, eBGP multihop, IPv4, configured IPv6 and VRF address families, next-hop handling, aggregation, static redistribution, communities, Local Preference, `no-export`, prefix lists, and route maps. |
| **Campus Layer 2** | VLANs, 802.1Q trunks, Rapid PVST+, deterministic root placement, long path costs, PortFast edge, BPDU Guard, and Root Guard, Loop Guard, inconsistent-port, and Bridge Assurance case analysis; retained raw failure evidence varies by feature. |
| **EtherChannel** | LACP negotiation, port-channel formation, STP interaction, member degradation, passive/passive failure, and VLAN-mask and misconfiguration-protection case analysis. |
| **MSTP** | MST regions, IST/MST0, VLAN-to-instance mapping, configuration digests, per-instance roots, CIST Regional Root and Master Port behavior, boundary operation, Max Hops, Dispute state, and MST/PVST Simulation. |
| **Troubleshooting** | Healthy baselining, controlled fault injection, layered diagnosis, log and state correlation, control-plane versus forwarding-plane isolation, correction, restoration procedures, and validation where captured. |
| **Lab engineering and documentation** | Cisco Modeling Labs, IOSv/IOSvL2 configuration, importable YAML preservation, topology diagrams, sanitized configuration publishing, raw command capture, and reproducible case-study writing. |

## How to review or reproduce the labs

### Review the evidence without running CML

1. Open the lab's top-level `README.md` to understand its design and scope.
2. Use `topology.png` to identify device roles and relationships.
3. Inspect `configs/` to confirm that the described features were actually configured.
4. Read `verification/` and open the raw `.txt` files to compare narrative claims with IOS state.
5. Follow one case in `troubleshooting/` from healthy baseline through fault, diagnosis, corrective action, and recovery.

This path is intentionally useful to technical reviewers who do not have access to a CML environment.

### Import the STP or MSTP topology into CML

1. Download or clone the repository.
2. In the CML dashboard, use the lab import function and select one of the following files:
   - [`04-STP/CCNP_MASTERCLASS_STP.yaml`](04-STP/CCNP_MASTERCLASS_STP.yaml)
   - [`05-MSTP/CCNP_MASTERCLASS_MSTP.yaml`](05-MSTP/CCNP_MASTERCLASS_MSTP.yaml)
3. Confirm that the required node and image definitions are available locally. Both labs use `node_definition: iosvl2` with `image_definition: iosvl2-2020`; the STP topology also uses `node_definition: desktop` with `image_definition: desktop-3-13-2-xfce` for PC1 and PC2. Image mappings may need adjustment on another CML system.
4. Verify that VLANs 10, 20, 30, and 40 exist on the participating IOSvL2 switches. The saved configurations preserve trunk/access policy and MST mappings, but the YAML files do not include explicit VLAN-creation stanzas; create any missing VLANs before comparing operational state.
5. Start the nodes, allow the control plane to converge, and establish a baseline with the commands listed in the lab README and verification folders.
6. Reproduce a troubleshooting case one change at a time. Record the failure state, identify the cause from evidence, restore the intended setting, and compare the result with the retained artifacts.

The YAML files contain the saved node configurations. The standalone files under `configs/` make those configurations easy to review and compare outside CML.

### Reconstruct the routing labs

The current EIGRP, OSPF, and BGP folders do **not** contain CML YAML exports. Use their topology diagrams, device configurations, verification captures, and case studies as reconstruction references. The routing configurations are sanitized portfolio extracts rather than complete restore files; redacted authentication values and environment-specific details must be supplied and validated before replaying them in another lab.

## Evidence and scope policy

- **Repository contents are authoritative.** Only the five present lab sections are described as completed.
- **Configuration provenance is stated.** EIGRP, OSPF, and BGP publish sanitized extracts. STP and MSTP publish per-switch configurations extracted from their authoritative CML YAMLs.
- **Captured output is not synthesized.** The `.txt` files preserve exact or raw-style console material where retained; contextual notes distinguish full transcripts, excerpts, and concise observed-state summaries.
- **Saved state is not confused with every transient test state.** Restored configurations can differ from temporary fault injection documented in a case study.
- **Evidence gaps remain visible.** A scenario without a complete retained transcript is documented as such instead of being supplemented with invented output.
- **Configured and verified are not treated as synonyms.** For example, the BGP configurations include IPv6 and VRF address families, while the dedicated raw verification collection focuses on IPv4.
- **These are controlled labs.** The artifacts demonstrate hands-on CML engineering and troubleshooting, not production change history or vendor-certified completion status.

## Suggested technical-review path

For a focused review, choose one lab and follow this sequence:

```text
lab README
    ↓
topology diagram
    ↓
one device configuration
    ↓
one healthy-state .txt capture
    ↓
one troubleshooting case
    ↓
available post-restoration evidence
```

That path lets a reviewer evaluate design intent, command-line implementation, interpretation of protocol state, fault-isolation reasoning, and recovery discipline as one connected body of work.

---

This portfolio emphasizes a simple standard: **show the configuration, preserve the output, explain the failure, and prove the restoration wherever the evidence was retained.**
