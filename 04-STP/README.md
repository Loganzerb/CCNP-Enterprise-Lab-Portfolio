# 04 — STP: Safe redundancy and predictable paths

Backup links let a switched network survive failures, but they also create opportunities for loops. This lab examines how Spanning Tree Protocol (STP) selects forwarding paths and responds to unsafe or inconsistent conditions.

I built a five-switch Cisco Modeling Labs environment, assigned preferred roots for different VLAN groups, and documented protection and link-bundle exercises.

**Five switches · Two lab endpoints · Eleven documented exercises · Nine retained captures**

**Start here:** [One member fails, then the whole bundle stops forming](troubleshooting/11-lacp-negotiation-and-member-failure.md). The captured sequence distinguishes a degraded bundle that still forwards from a negotiation failure that removes the logical link.

## Lab design

![STP topology with redundant distribution and access switches, two endpoints, and a controlled test switch](topology.png)

SW1 is the preferred root for VLANs 10/20; SW4 is preferred for VLANs 30/40. SW2 and SW3 connect the endpoints and provide redundant paths. SW5 is a controlled test switch connected to SW4.

The saved design uses Rapid PVST+ and long path costs. The topology shows physical wiring; forwarding roles vary by VLAN and experiment.

[Topology, device roles, and terminology](topology.md)

## Results at a glance

| Question | Retained result |
|---|---|
| Which path does an access switch select? | SW3 uses Gi0/0 as its VLAN 10 root port and keeps Gi0/2 Alternate/Blocked |
| What changes when parallel links are bundled? | SW5 sees logical Po1 as its Root/Forwarding interface |
| Does losing one member remove the logical path? | Gi0/1 is down while Po1 remains in use and forwarding |
| What happens when negotiation fails? | Both members are suspended and Po1 is down |

[Root-selection evidence](verification/root-election/README.md) · [Bundle and failure sequence](verification/etherchannel/README.md)

## What this work demonstrates

- **Intentional path selection:** connect root priorities and port roles to the design.
- **Fault isolation:** distinguish normal blocking, protective inconsistency, and bundle failure.
- **Configuration review:** compare saved protection settings with the evidence for a particular exercise.
- **Verification:** separate an operational state from a measured service result.

## Explore the files

| Guide | Contents |
|---|---|
| [Configurations](configs/README.md) | Five switch files, root priorities, protection settings, and import notes |
| [Verification](verification/README.md) | All nine captures, with interpretation guides for each topic |
| [Troubleshooting](troubleshooting/README.md) | Eleven exercises covering protection, consistency, path selection, and bundles |
| [CML export](CCNP_MASTERCLASS_STP.yaml) | Saved topology and embedded device configurations |

For a first technical review, follow the LACP sequence through its baseline, member failure, and negotiation failure. The protection cases explain their documented exercises and identify which event captures are unavailable.

## Evidence scope

The LACP experiment is an earlier stage than the saved configuration: SW4 and SW5's final files contain separate trunks rather than Po1. Its short-cost values should not be combined with later long-cost examples. [Configuration stage notes](configs/README.md#experiment-stages) explain these differences.

The retained record establishes port roles, settings, and selected failures. Several protection exercises have narrative or configuration support without complete failure/recovery transcripts. No standalone endpoint ping capture or measured convergence comparison is included.

[Back to portfolio](../README.md)
