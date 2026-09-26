# BIDIR configuration

| Guide | Scope |
|---|---|
| [Baseline settings](baseline.md) | Corrected interface roles, routing costs, PIM and BIDIR mapping |
| [Experiment changes](experiments.md) | Addressing repair, membership relocation and DF metric change |

The two guides contain selected command extracts reconstructed from the lab sequence and checked against the retained output. The six `.cfg` files below are captured device configuration blocks extracted from the readable September 25 CML checkpoint attachment. They preserve that checkpoint, including descriptive labels that lag behind the corrected wiring. The complete CML topology file is not included here. The baseline represents the corrected pre-transition design; the final captured experiment leaves R1's uplink cost at 50.

The source LAN uses an unmanaged switch. R1's actual cabling places its source LAN on Gi0/1 and its R3 uplink on Gi0/0; the first setup draft had those reversed.

## Captured checkpoint configurations

| Device | Captured file |
|---|---|
| Source host | [SRC-HOST.cfg](SRC-HOST.cfg) |
| First source-LAN router | [R1-DF-A.cfg](R1-DF-A.cfg) |
| Second source-LAN router | [R2-DF-B.cfg](R2-DF-B.cfg) |
| Branch router | [R3-BRANCH.cfg](R3-BRANCH.cfg) |
| RPA router | [R4-RPA.cfg](R4-RPA.cfg) |
| Receiver host | [RCV-HOST.cfg](RCV-HOST.cfg) |

R1's captured Gi0/0 description still says SHARED-SOURCE-LAN although its corrected address is `10.13.0.1/30`; Gi0/1 retains the converse transit description. The address, adjacency and wiring checks establish the actual roles. These labels are preserved as recorded, not silently corrected. The checkpoint has cost 10 on both R1 interfaces; Gi0/1 is passive in OSPF. The later DF experiment changes only Gi0/0 to cost 50.

[Topology and addressing](../topology.md) · [Evidence](../verification/README.md) · [Overview](../README.md)
