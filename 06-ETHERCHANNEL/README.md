# 06 — EtherChannel: Bundle resilience and fault isolation

A bundle can be operational while traffic still fails. This four-switch Cisco Modeling Labs project compares static EtherChannel, LACP, and PAgP, then investigates member failure, inconsistent trunk settings, and an unexpected forwarding result.

The work connects three checks: whether links bundle, whether a VLAN forwards, and whether the endpoint receives traffic.

**Four switches · Three bundle types · Two detailed cases · 42 evidence captures**

**Start here:** [A VLAN mismatch suspends one member](troubleshooting/case-01-vlan-mask-mismatch.md). Changing one member's allowed VLAN list suspended that interface while the other member kept the logical bundle up. Restoring the list returned both members to service.

## Lab design

![EtherChannel topology with static, LACP, and PAgP bundles](topology.png)

Two distribution and two access switches form redundant paths. Po10 is static, Po20 uses LACP, and Po30 uses PAgP. A separate trunk joins the access switches.

PC-A at `10.10.10.10/24` tests SW4's VLAN 10 interface at `10.10.10.20/24`. The PC-B position shown in the diagram is not deployed in the final export. Infrastructure trunks use native VLAN 99 and allow VLANs `1,10,20,30,99`.

[Topology, interfaces, and intended design](topology.md)

## Results at a glance

| Experiment | Retained result |
|---|---|
| [Member VLAN mismatch](troubleshooting/case-01-vlan-mask-mismatch.md) | One member suspended; restoring its allowed list recovered two bundled members |
| [Max-bundle forwarding anomaly](troubleshooting/case-02-max-bundle-forwarding-anomaly.md) | A one-active/one-standby bundle coincided with 0/5 replies; recovery showed two bundled members and 5/5 replies |
| [Single-member failure](verification/guided-labs.md) | Po20 remained forwarding; the failure run retained 60/60 replies |
| [Direct-trunk failure](verification/guided-labs.md) | Traffic was interrupted; MAC learning identified the alternate path through all three bundles |
| [Final baseline](verification/README.md) | Intended members were bundled and PC-A received 10/10 replies from SW4 |

The max-bundle case retains an unresolved observation: the internal cause is not established. Its evidence supports recovery after the experiment without identifying a particular software defect.

## What this work demonstrates

- **Fault isolation:** distinguish a member incompatibility from loss of the whole bundle.
- **Forwarding analysis:** inspect spanning tree and endpoint results alongside aggregation state.
- **Resilience verification:** separate single-member degradation from path reconvergence.
- **Technical judgment:** document conflicting indicators and the limits of a diagnosis.

## Explore the files

| Guide | Contents |
|---|---|
| [Configurations](configs/README.md) | Four exported switch configurations, roles, and replay guidance |
| [Verification](verification/README.md) | 14 final-state captures and their interpretation |
| [Guided exercises](verification/guided-labs.md) | Failover, member resilience, and capability checks |
| [Troubleshooting](troubleshooting/README.md) | Two cases and 28 fault, recovery, and capability captures |
| [CML export](CML-LAB.yaml) | Final saved topology and configuration material |

## Evidence scope

The saved configuration uses classic PVST. SW2's healthy Po30 is Alternate/Blocked for all carried VLANs, illustrating why a bundled link need not forward a particular test.

Captures span separate experiment stages. The final ping verifies its ten probes; the selected hashing algorithm does not measure throughput or member utilization. The [coverage table](verification/README.md#coverage-and-boundaries) identifies which additional exercises have captured output and which remain narrative observations.

Use the [configuration guide](configs/README.md#reuse-the-lab) before importing the final saved lab or replaying a fault.

[Back to portfolio](../README.md)
