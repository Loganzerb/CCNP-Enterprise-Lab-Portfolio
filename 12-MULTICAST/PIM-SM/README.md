# PIM-SM — Three ways to establish the Rendezvous Point

Protocol Independent Multicast Sparse Mode (PIM-SM) builds paths for receivers that request a multicast group. The Rendezvous Point (RP) provides their initial meeting point with sources; a source-specific path can then carry the traffic.

This lab develops that behavior through **Static RP → Auto-RP → BSR**. Each phase documents a distinct method of supplying RP information, with its own results and troubleshooting evidence.

**3 completed phases · 7 case studies · 105 evidence blocks**

## Choose a phase

| Phase | What I investigated | Recorded result |
|---|---|---|
| [01 — Static RP](static-rp.md) | Tree formation, route changes and RP faults at the source and receiver edges | Receiver replies, changed forwarding paths and targeted recovery checks |
| [02 — Auto-RP](auto-rp.md) | Migration from static configuration and a later listener-related discovery failure | 19/20 replies in the migration test; recovered counters, mapping and forwarding state after repair |
| [03 — BSR](bsr.md) | Candidate elections, failover/recovery, PIM propagation and RP hashing | BSR takeover and recovery, restored RP mappings and group-specific selection explained by hash output |

Open a phase overview for its topology, configuration guide, evidence pages and cases. The evidence limits remain attached to the relevant phase; the Auto-RP traffic result is not a BSR measurement.

## What changes between phases

| Phase | How RP information is supplied | Roles in this lab | Topology |
|---|---|---|---|
| Static RP | RP address configured on each multicast router | R2 is RP 2.2.2.2 | [Original six nodes](topology.md) |
| Auto-RP | Candidate announcements reach a Mapping Agent, which distributes the mapping | R2 is Candidate RP; R3 is Mapping Agent | [Same wiring; Auto-RP roles](auto-rp.md#same-topology-separate-discovery-roles) |
| BSR | The elected BSR distributes the RP-set; routers select the RP for the group | R2 is Candidate RP; R3/R5 are Candidate BSRs; R5 wins in the final connected state | [Seven nodes, with R5 added](topology-bsr.md) |

Across the three phases, source **10.1.1.10** sends to **239.1.1.1**, receiver **10.4.4.10** joins the group, and R2's RP address remains **2.2.2.2**. OSPF supplies reachability. R4 has distinct directions toward the RP through R2 and toward the source through R3.

## Browse by evidence type

| Guide | Contents |
|---|---|
| [Configurations by phase](configs/README.md) | Static templates, Auto-RP changes and the intermediate BSR checkpoint |
| [Verification by phase](verification/README.md) | Twelve pages of numbered evidence blocks and interpretation |
| [Troubleshooting by phase](troubleshooting/README.md) | Seven cases linking symptoms, diagnosis, repair and validation |

[IGMPv2/v3 and SSM](../IGMPv2-v3/README.md) and [BIDIR-PIM](../BIDIR-PIM/README.md) have their own sections alongside PIM-SM. [Multicast progress](../progress.md) records what is complete and what remains.

[Back to Multicast](../README.md) · [Back to portfolio](../../README.md)
