# 12 — Multicast: Receiver-driven delivery and path diagnosis

Multicast lets a source send traffic to a group of interested receivers. This section follows how the network builds that delivery path, how routing decisions affect it, and how discovery faults can interrupt it even when ordinary routing works.

I built a Cisco Modeling Labs environment to separate receiver membership, RP discovery, source registration and forwarding behavior. The original six-node topology expands to seven nodes for BSR election and recovery testing. Each case connects the diagnosis to device evidence.

**In progress · Static RP, Auto-RP and BSR documented · Updated September 25, 2026**

## Start here

[Read the BSR lab](PIM-SM/bsr.md) for discovery resilience, election tests and group-specific RP selection. Its featured case, [OSPF reaches the BSR, but RP discovery stops](PIM-SM/troubleshooting/07-bsr-propagation.md), follows missing PIM settings through restored mappings and forwarding state.

The earlier [Auto-RP recovery case](PIM-SM/troubleshooting/04-autorp-listener-recovery.md) examines a different discovery mechanism, while [A ready receiver with no replies](PIM-SM/troubleshooting/03-source-rp-failure.md) isolates a source-side static-RP fault.

## Current work

| Topic | Status | Available material |
|---|---|---|
| [PIM-SM](PIM-SM/README.md) | Static RP, Auto-RP and BSR documented | Two topology diagrams, configuration guides, seven cases and 105 evidence blocks |
| Reverse Path Forwarding (RPF) | Path-change exercise documented within PIM-SM | [Move the source tree by changing a unicast route](PIM-SM/troubleshooting/01-rpf-path-change.md) |
| [Auto-RP](PIM-SM/auto-rp.md) | Completed lab phase | Candidate RP, Mapping Agent, listener recovery and native SPT state |
| [BSR](PIM-SM/bsr.md) | Completed lab phase | BSR election/recovery, RP-set propagation repair, forwarding state and RP hash selection |
| IGMPv2/v3, SSM, Bidir-PIM and MSDP | Planned dedicated subsections | Add as the corresponding labs are completed |

PIM-SM already uses IGMP receiver membership and RPF checks. Dedicated protocol comparisons and the final RPF review remain future work. BSR stays within PIM-SM; subsequent multicast topics will have their own subsections.

## Lab at a glance

![BSR topology with R5 added to the multicast diamond](PIM-SM/topology-bsr.png)

R5 provides another Candidate BSR without becoming a source-to-receiver transit router. R2 remains the RP, and the receiver-side router has different paths toward the RP and the source.

[Original topology](PIM-SM/topology.md) · [BSR wiring](PIM-SM/topology-bsr.md) · [Troubleshooting](PIM-SM/troubleshooting/README.md) · [Evidence guide](PIM-SM/verification/README.md) · [Progress](progress.md)

## Evidence scope

The portfolio separates captured output, operator observations and reconstructed commands. The supplied BSR export is an intermediate checkpoint, with completion steps documented. Forwarding state and measured receiver replies are identified separately; the BSR work does not reuse the earlier Auto-RP ping result as new evidence.

[Back to portfolio](../README.md)
