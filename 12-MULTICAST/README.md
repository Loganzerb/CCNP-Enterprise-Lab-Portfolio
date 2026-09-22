# 12 — Multicast: Receiver-driven delivery and path diagnosis

Multicast lets a source send traffic to a group of interested receivers. This section follows how the network builds that delivery path, how routing decisions affect it, and how a missing setting can stop delivery even when receiver membership looks healthy.

I built a six-node Cisco Modeling Labs environment and used controlled changes to separate receiver membership, source registration and forwarding-path behavior. Each case links the diagnosis to the actual device output.

**In progress · PIM-SM static-RP checkpoint · Updated September 22, 2026**

## Start here

[Read the PIM-SM lab](PIM-SM/README.md) for the design and results, or go straight to [A ready receiver with no replies](PIM-SM/troubleshooting/03-source-rp-failure.md). That case records twenty unanswered probes after the source-side router loses its Rendezvous Point (RP) mapping, followed by the repair and available recovery evidence.

## Current work

| Topic | Status | Available material |
|---|---|---|
| [PIM-SM](PIM-SM/README.md) | Static-RP exercises documented; dynamic RP work next | Topology, six reconstructed configurations, three cases and 39 evidence blocks |
| Reverse Path Forwarding (RPF) | Path-change exercise documented within PIM-SM | [Move the source tree by changing a unicast route](PIM-SM/troubleshooting/01-rpf-path-change.md) |
| Auto-RP and BSR | Theory covered; lab evidence pending | Next expansion of PIM-SM |
| IGMPv2/v3, SSM, Bidir-PIM and MSDP | Planned dedicated subsections | Add as the corresponding labs are completed |

The PIM-SM lab already uses IGMP receiver membership. It does not yet establish a comparison of IGMP versions or Source-Specific Multicast behavior.

## Lab at a glance

![Multicast diamond topology with source and receiver endpoints, R2 as the RP and R3 as the baseline source-tree transit router](PIM-SM/topology.png)

The design gives the receiver-side router different paths toward the RP and the source. That makes tree selection visible in the output rather than relying on a diagram alone.

[Addressing and wiring](PIM-SM/topology.md) · [Troubleshooting cases](PIM-SM/troubleshooting/README.md) · [Evidence guide](PIM-SM/verification/README.md) · [Progress and next captures](progress.md)

## Evidence scope

This is a checkpoint of an ongoing lab, not a completed multicast curriculum. The published blocks retain actual CLI output; reconstructed configuration files and reported observations are labeled separately. Dynamic RP discovery and the remaining multicast topics will be added when their own evidence is available.

[Back to portfolio](../README.md)

