# 05 — MSTP: Predictable Paths and Boundary Protection

Redundant switch links keep a network flexible, but they also need loop prevention. Multiple Spanning Tree Protocol (MSTP) lets groups of VLANs share a spanning-tree instance, with different groups using different preferred paths.

I built a five-switch Cisco Modeling Labs environment to verify those paths, test what makes switches belong to the same MST region, and investigate protection at a boundary with Rapid PVST+. The work connects configuration choices to observed switch behavior.

**5 switches · 2 configured VLAN-group instances · 7 documented cases · 9 retained evidence files**

## Results at a glance

| Engineering question | Observed result |
|---|---|
| Can VLAN groups use different preferred paths? | MST2-ACCESS-A selects Gi0/0 toward MST1 for VLANs 10/20 and Gi0/1 toward MST4 for VLANs 30/40 |
| Is a matching configuration digest enough to establish region membership? | Changing the revision or region name leaves the mapping digest unchanged but produces boundary roles |
| How does the region reach an external spanning-tree root? | MST4 uses the same boundary link as Root for MST0 and Master for the two VLAN-group instances |
| What happens when the external VLAN information is inconsistent? | MST4 blocks the boundary; Case 06 records the failure, the subsequent clear message and zero remaining inconsistent entries |

## Start here

[Case 06 — A boundary blocked by inconsistent root information](troubleshooting/scenario-6-pvst-sim-inferior-vlan/README.md) is the strongest failure-and-recovery record. It explains why protection blocked the link and what the captured recovery actually establishes.

For a quick design review, see [different paths over the same wiring](verification/instances/README.md). For deeper troubleshooting, compare the [three region-identity mismatches](verification/region-mismatch/README.md).

## Lab topology

![Five-switch MSTP topology: four switches in CCNP_MST and MST5 outside the region, connected by six trunks](topology.png)

| Device | Responsibility |
|---|---|
| MST1-DIST-A | Preferred root for instance 1: VLANs 10 and 20 |
| MST2-ACCESS-A / MST3-ACCESS-B | Access-side switches with redundant internal paths |
| MST4-DIST-B | Preferred root for instance 2: VLANs 30 and 40; attachment to MST5 |
| MST5-BOUNDARY | External test switch: a separate MST region in earlier exercises, Rapid PVST+ in the saved configuration |

The main region is **CCNP_MST, revision 1**. Instance 0, the Internal Spanning Tree (IST), contains VLANs not assigned to instances 1 or 2. [The topology guide](topology.md) provides exact ports, trunk VLAN lists and the distinction between saved and experimental states.

## What this work demonstrates

- **Intentional path selection:** configure roots and verify their effect at an access switch.
- **Fault isolation:** compare region identity, operating mode and port roles instead of relying on one matching field.
- **Interoperability troubleshooting:** distinguish normal boundary operation from a consistency failure.
- **Evidence-based reporting:** identify captured recovery separately from a correction described in the lab notes.

## Explore the files

| Location | What the reader gets |
|---|---|
| [Configurations](configs/README.md) | Five saved device files explained by role, important settings and experiment stage |
| [Verification](verification/README.md) | An index of every retained capture with a short interpretation |
| [Troubleshooting](troubleshooting/README.md) | Seven cases with symptoms, reasoning and the available recovery evidence |
| [CML export](CCNP_MASTERCLASS_MSTP.yaml) | Original saved five-switch lab; read the configuration guide before import |
| [Technical references](references.md) | Cisco explanations supporting the protocol interpretation |

## Evidence scope

The original nine text files, five device configurations and CML export are preserved unchanged. Some text files combine console excerpts with explicitly identified observations. This revision improves their context and redraws the topology from the saved wiring.

Case 06 proves that the reported inconsistency cleared; it does not include a post-repair forwarding table or endpoint traffic test. Other cases retain different amounts of failure and recovery evidence. No new lab results, throughput measurements or convergence timings are claimed.
