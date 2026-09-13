# 06 — EtherChannel: Bundles, Resilience, and Fault Isolation

This Cisco Modeling Labs project connects four switches using static EtherChannel, LACP, and PAgP, then examines what happens when a member fails, trunk settings disagree, or a bundle looks operational while traffic fails.

The work demonstrates three separate checks: **can the links bundle, can the VLAN forward, and can the endpoint receive traffic?** Configurations establish intent; protocol and spanning-tree output explain state; endpoint tests show the recorded service result.

## Start here

| Case | Problem and result | What it demonstrates |
|---|---|---|
| [01 — Member VLAN-mask mismatch](troubleshooting/case-01-vlan-mask-mismatch.md) | Removing VLAN 99 from one member suspended that member. Restoring the list returned both members to `(P)`. | Isolating a configuration inconsistency while the logical bundle remains up |
| [02 — Forwarding anomaly after max-bundle](troubleshooting/case-02-max-bundle-forwarding-anomaly.md) | A one-active/one-standby bundle appeared operational, but the retained endpoint test failed 0/5. The recovery capture shows 5/5. | Comparing bundle state with actual forwarding and keeping an unresolved platform diagnosis within the evidence |
| [Guided resilience exercises](verification/guided-labs.md) | Direct-trunk failure interrupted traffic; a separate single-member failure test retained 60/60 replies. | Distinguishing path reconvergence from member degradation |

The cases expand existing controlled experiments. They are not newly performed blind incidents.

## Topology and intended design

![EtherChannel lab topology](topology.png)

SW1–SW4 below abbreviate the `EC-SW1-DIST-A`, `EC-SW2-DIST-B`, `EC-SW3-ACCESS-A`, and `EC-SW4-ACCESS-B` device names.

| Connection | Member interfaces | Final configuration |
|---|---|---|
| Static Po10: SW1 ↔ SW2 | Gi0/0 and Gi0/1 on both switches | `on` ↔ `on` |
| LACP Po20: SW1 ↔ SW3 | SW1 Gi0/2–3; SW3 Gi0/0–1 | SW1 `active`; SW3 `passive` |
| PAgP Po30: SW2 ↔ SW4 | SW2 Gi0/2–3; SW4 Gi0/0–1 | SW2 `desirable`; SW4 `auto` |
| Direct trunk: SW3 ↔ SW4 | Gi0/2 on both switches | Independent 802.1Q trunk |
| PC-A ↔ SW3 | PC-A eth0; SW3 Gi0/3 | Access VLAN 10 |

Infrastructure trunks use native VLAN 99 and allow VLANs `1,10,20,30,99`. The saved switch configurations use **classic PVST**, rather than Rapid PVST+.

PC-A is `10.10.10.10/24`. Tests target SW4's VLAN 10 switch interface at `10.10.10.20/24`. PC-B appears in the supplied diagram as an unused endpoint position; it is absent from the [final CML export](CML-LAB.yaml). The diagram provides design context, not additional experimental proof.

## Final verification highlights

| Check | Retained result | Interpretation |
|---|---|---|
| Bundle membership | Po10, Po20, and Po30 are `SU`; intended members are `P` | The logical bundles are Layer 2/in use and their members are bundled |
| Trunk policy | Native VLAN 99; allowed/active VLANs `1,10,20,30,99` | The captured trunk settings match the design |
| SW2 Po30 spanning tree | Alternate/Blocked for all five carried VLANs | A healthy bundle can be intentionally blocked by spanning tree |
| Endpoint reachability | PC-A receives 10/10 replies from SW4 | This final test establishes reachability during its ten probes |
| Load-balancing setting | SW3 reports `src-dst-ip` | The capture identifies the selected algorithm; it does not measure member utilization or throughput |

The [verification guide](verification/README.md) links every final-state capture and explains the fields to inspect. A successful final ping does not demonstrate that every redundant path carried that test.

## Configuration and evidence navigation

| Guide | Contents |
|---|---|
| [Configuration guide](configs/README.md) | Four exported switch configurations, device roles, important settings, and replay notes |
| [Final verification index](verification/README.md) | Fifteen captures covering bundles, trunks, peers, spanning tree, VLANs, load-balancing settings, and endpoint replies |
| [Guided lab narrative](verification/guided-labs.md) | Direct-trunk failover, member failure/recovery, and capability experiments |
| [Troubleshooting index](troubleshooting/README.md) | Two detailed cases and all 27 supporting fault, recovery, and capability captures |
| [CML lab export](CML-LAB.yaml) | Final node/link map and embedded configuration material |
| [Topology image](topology.png) | Visual overview of the supplied design |

## Coverage and boundaries

| Area | What this package supports |
|---|---|
| Static, LACP, and PAgP formation | Saved configurations and final bundle summaries; LACP and PAgP peer captures |
| Direct-trunk failover | Interrupted ping run and MAC learning through Po20 → Po10 → Po30; return to the direct trunk |
| Single LACP member failure | One down member, continued Po20 forwarding, 60/60 failure-run replies, and 75/75 recovery-run replies |
| Member VLAN consistency | Captured configuration change, explicit incompatibility log, suspension, and recovered membership |
| `max-bundle 1` | Captured enable transition, failed endpoint probes, and recovery evidence; internal defect mechanism remains unproven |
| Hashing | CLI lists MAC/IP choices and the final capture selects `src-dst-ip`. The earlier lab summary reported traffic-counter experiments, but those counter captures are absent |
| LACP system priority | Captured removal of priority 1, restored system ID priority 32768, and subsequent link/bundle transitions |
| LACP port priority | Earlier summary reports a selection experiment; no dedicated priority-change capture is retained |
| Negotiation variants and static asymmetry | Earlier summary reports active/active, passive/passive, auto/auto, and asymmetric-static tests; separate raw test records are not included |
| LACP fast rate and Layer 4 hashing | Captured CLI help does not offer these choices in the shown contexts on this image |
| `min-links` and `test etherchannel load-balance` | Unsupported-command reports are retained in the earlier summary only; raw rejection captures are absent |
| Fast switchover and standalone forwarding | Fast switchover was skipped; standalone-disable configuration was inspected, but a standalone forwarding-failure test was not performed |
| Layer 3 EtherChannel | Temporary routed Po40 configuration and removal are captured; no addressed, physically bundled Layer 3 forwarding test |

## Reuse the lab

Import [CML-LAB.yaml](CML-LAB.yaml) into a separate lab and check its image mappings: the export uses `iosvl2-2020` switches and a `desktop-3-13-2-xfce` endpoint. Verify VLANs, interface mappings, PC-A addressing, and SW4's VLAN 10 interface before testing. The saved switch blocks do not contain explicit VLAN-creation stanzas; confirm the VLAN database after import.

Start with the [final-state checks](verification/README.md), then reproduce a documented experiment. The export is the final saved lab, not a pre-fault snapshot for either case.

## Evidence policy

The source is the supplied September 11 portfolio ZIP. Its 42 evidence captures, four configuration text files, topology image, and CML export are preserved unchanged. The configuration files were supplied as de-indented extracts from the export; they are not fresh device captures.

Narrative excerpts normalize chat escaping and whitespace for readability. Original files retain prompts, partial commands, formatting artifacts, and counters. Tables explain those observations without creating missing terminal output. The investigations below organize the available evidence; they do not claim a complete chronological console recording.

Configuration, reported lab history, observed output, and suggested replay commands are identified separately. No new CML execution, performance benchmark, or save confirmation is implied by this documentation.
