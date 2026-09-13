# 04 — Spanning Tree: Safe Redundancy in a Switched Network

A network needs backup links to survive failures. Those extra links also create a risk: without loop prevention, traffic can circulate through the switches and disrupt service. This lab explores how Spanning Tree Protocol (STP) keeps redundant links safe, chooses predictable paths, and responds to inconsistent or unsafe conditions.

I built a five-switch Cisco Modeling Labs environment, assigned preferred switching roots for different VLAN groups, examined the resulting port roles, and documented controlled protection and link-bundle experiments.

**Five switches · Two lab endpoints · Eleven documented exercises · Nine retained CLI captures**

## Start here

| If you want to understand… | Read this | Main result |
|---|---|---|
| How the network chooses a safe path | [Root selection explained](verification/root-election/README.md) | SW3 uses Gi0/0 as its VLAN 10 root port and keeps Gi0/2 as an alternate blocked path |
| What happens when a bundled link loses a member | [Case 11 — LACP formation and failures](troubleshooting/11-lacp-negotiation-and-member-failure.md) | One member down leaves the logical link forwarding; a separate negotiation failure leaves the whole bundle down |
| How an unexpected switch is handled | [Case 01 — BPDU Guard](troubleshooting/01-bpdu-guard-rogue-switch.md) | Explains the documented edge-port protection exercise, supported by the saved policy; its failure transcript was not retained |

The first two reading paths include direct device output. Several other exercises retain explanations and configuration context rather than complete failure-and-recovery transcripts.

## The lab at a glance

![STP lab: two distribution switches, two access switches, two endpoints, and a dedicated test switch](topology.png)

| Device | Role in everyday language |
|---|---|
| SW1-DIST-A | Distribution switch preferred as the spanning-tree root for VLANs 10 and 20 |
| SW4-DIST-B | Distribution switch preferred as root for VLANs 30 and 40 |
| SW2-ACCESS-A | Connects PC1 and provides redundant paths toward the distribution switches |
| SW3-ACCESS-B | Connects PC2 and provides a second access-side observation point |
| SW5-ROGUE | Deliberately controlled test switch used to introduce conditions the network should detect |
| PC1 and PC2 | VLAN 10 endpoints included in the topology; no standalone endpoint ping capture is retained in this section |

The infrastructure trunks carry VLANs 10, 20, 30, and 40. The diagram shows physical wiring; forwarding and blocked states change with the VLAN and experiment.

### A few terms that make the files easier to read

| Term | Meaning in this lab |
|---|---|
| VLAN | A logical network carried through the switches |
| Trunk | A switch link that carries multiple VLANs |
| Root bridge | The reference switch used to calculate a VLAN's spanning tree; it is not necessarily the path for every packet |
| Root port | A switch's selected path toward that root |
| Alternate / blocked | A redundant path kept out of normal forwarding to prevent a loop |
| BPDU | A control message switches exchange to maintain spanning-tree information |
| EtherChannel / port-channel | Several physical links represented as one logical link |
| Inconsistent / err-disabled | Protective states; the cases explain whether an STP instance or an interface is affected |

## Design choices and observed results

| Design choice | Why it matters | Available evidence |
|---|---|---|
| Split preferred roots between SW1 and SW4 | Makes path selection intentional for different VLAN groups | [Saved root priorities](configs/README.md) and [SW3's per-VLAN interface detail](verification/bridge-assurance/README.md) |
| Retain alternate links | Provides redundant topology while avoiding active switching loops | [SW3 VLAN 10 roles](verification/root-election/README.md) show a Root/FWD port and an Alternate/Blocked port |
| Configure edge protection | Helps contain an unexpected switch connection at a client-facing port | [SW2/SW3 configuration guide](configs/README.md) identifies PortFast edge and BPDU Guard |
| Examine STP over a bundle | Separates a physical-member problem from loss of the logical path | [LACP evidence sequence](verification/etherchannel/README.md) |
| Compare state with evidence | Avoids treating a feature setting or an up interface as sufficient proof | [Verification guide](verification/README.md) explains each capture and its limits |

The saved priorities make SW1 primary at 24576 for VLANs 10/20, with SW4 secondary at 28672. For VLANs 30/40, those preferences are reversed. The [configuration guide](configs/README.md) connects those settings to the device roles.

## Explore the files

| Location | What the reader gets |
|---|---|
| [Configurations](configs/README.md) | Five device files explained by role, important settings, and relationship to the captured output |
| [Verification](verification/README.md) | An index of all nine original captures, with plain-English explanations of what to inspect |
| [Troubleshooting](troubleshooting/README.md) | Eleven linked exercises covering protection, consistency, path selection, and bundle behavior |
| [CML export](CCNP_MASTERCLASS_STP.yaml) | The saved topology and embedded configurations for lab reuse |
| [Topology image](topology.png) | An overview of the physical design |

For an interview, follow one question through its expected behavior, observed output, explanation, and available recovery evidence. The technical commands remain available for deeper inspection without requiring every reader to interpret a console dump first.

## Understand the different lab stages

The saved configuration files use **Rapid PVST+ and the long path-cost method**. SW4 and SW5 are saved with separate trunk interfaces; their final files do not contain Po1 or channel-group commands.

The LACP captures preserve an earlier temporary bundle experiment. They show local costs of 3 and 4, while the later long-cost examples show 20000. These values belong to different retained stages and should not be combined into one final-state snapshot.

The SW3 Gi0/1 detail was captured **before** the Bridge Assurance network-port change. It explains root roles and BPDU activity at that point; the later configurations preserve the network-port setting. Neither replaces a missing Bridge Assurance failure capture.

## Reuse and evidence scope

Import [CCNP_MASTERCLASS_STP.yaml](CCNP_MASTERCLASS_STP.yaml) into a separate CML lab. Its image references are `iosvl2-2020` and `desktop-3-13-2-xfce`. Check image mappings, VLAN creation, and the intended baseline before recreating an exercise. The switch configuration blocks do not include explicit VLAN-creation stanzas. The export is a saved lab, not a ready-made fault state for every case.

All original device captures, five configurations, and the CML export are preserved unchanged from the supplied portfolio ZIP. The topology image redraws the same physical wiring in the EtherChannel/FHRP visual style; it is not additional experimental evidence. Explanations distinguish **captured output**, **saved configuration**, and **documented observations**. Reference checks describe what to verify in a replay, not newly collected results.

The retained evidence demonstrates port roles, settings, and selected failures. It does not establish measured endpoint availability, exact convergence times, or complete recovery for every exercise. Missing output is identified in the relevant case rather than filled with hypothetical results.
