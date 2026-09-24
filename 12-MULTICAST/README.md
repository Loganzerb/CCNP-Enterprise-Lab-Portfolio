# 12 — Multicast: Receiver-driven delivery and path diagnosis

Multicast lets a source send traffic to a group of interested receivers. This section follows how the network builds that delivery path, how routing decisions affect it, and how discovery or configuration faults can interrupt delivery even when receiver membership looks healthy.

I built a six-node Cisco Modeling Labs environment and used controlled changes to separate receiver membership, RP discovery, source registration and forwarding behavior. Each case links the diagnosis to the available device evidence.

**In progress · Static-RP and Auto-RP phases documented · Updated September 23, 2026**

## Start here

[Read the Auto-RP lab](PIM-SM/auto-rp.md) for the migration from static configuration to dynamic discovery, or go straight to [Auto-RP roles exist, but discovery cannot recover](PIM-SM/troubleshooting/04-autorp-listener-recovery.md). The case follows a stalled Mapping Agent through domain-wide listener repair and recovered forwarding state.

For the original static-RP work, [A ready receiver with no replies](PIM-SM/troubleshooting/03-source-rp-failure.md) compares receiver-side readiness with a source-side RP fault.

## Current work

| Topic | Status | Available material |
|---|---|---|
| [PIM-SM](PIM-SM/README.md) | Static-RP and Auto-RP phases documented | Topology, baseline configurations, migration guide, four cases and 69 evidence blocks |
| Reverse Path Forwarding (RPF) | Path-change exercise documented within PIM-SM | [Move the source tree by changing a unicast route](PIM-SM/troubleshooting/01-rpf-path-change.md) |
| [Auto-RP](PIM-SM/auto-rp.md) | Complete through final troubleshooting and forwarding validation | Candidate RP, Mapping Agent, listener recovery and native SPT state |
| BSR | Next lab; not completed | No completed BSR configuration or verification is claimed |
| IGMPv2/v3, SSM, Bidir-PIM and MSDP | Planned dedicated subsections | Add as the corresponding labs are completed |

The PIM-SM lab already uses IGMP receiver membership. It does not yet establish a comparison of IGMP versions or Source-Specific Multicast behavior.

## Lab at a glance

![Original static-RP multicast topology; Auto-RP uses the same physical wiring](PIM-SM/topology.png)

The diagram preserves the original static-RP design. Auto-RP uses the same wiring and RP address, adding the Candidate RP role on R2 and Mapping Agent role on R3. The receiver-side router still has different paths toward the RP and the source.

[Addressing and wiring](PIM-SM/topology.md) · [Troubleshooting cases](PIM-SM/troubleshooting/README.md) · [Evidence guide](PIM-SM/verification/README.md) · [Progress](progress.md)

## Evidence scope

This remains an ongoing multicast portfolio. Static-RP and Auto-RP are documented; BSR and later topics are pending. Captured CLI, selected handoff excerpts, reconstructed commands and protocol interpretation are identified in their respective guides.

[Back to portfolio](../README.md)
