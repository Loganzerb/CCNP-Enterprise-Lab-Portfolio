# PIM-SM — Discover the RP, trace the path, isolate the fault

Protocol Independent Multicast Sparse Mode (PIM-SM) builds delivery paths for receivers that request a multicast group. A Rendezvous Point (RP) gives sources and receivers a common meeting point; the network can then use a source-specific path.

I used a diamond-shaped topology to make those paths visibly different. The work progresses from a static RP through Auto-RP to BSR, with controlled routing changes, discovery faults and recovery tests. BSR adds a seventh node to test election resilience.

**3 discovery phases · 7 case studies · 105 evidence blocks**

**Status:** Static RP, Auto-RP and BSR documented. Dedicated IGMPv2/v3, SSM, Bidir-PIM and MSDP work remains separate from this PIM-SM subsection.

## Follow the three phases

| Phase | What it covers | Start here |
|---|---|---|
| Static RP | Receiver membership, source registration, different tree paths and three controlled exercises | [Baseline evidence](verification/01-baseline.md) and [original configuration guide](configs/README.md) |
| Auto-RP | Migration to dynamic discovery, removal of static fallback, listener troubleshooting and final forwarding | [Auto-RP overview and lessons](auto-rp.md) |
| BSR | Two BSR candidates, takeover/recovery, PIM propagation repair and RP hashing | [BSR overview and lessons](bsr.md) |

## Results at a glance

| Exercise | Recorded result | What it demonstrates |
|---|---|---|
| Receiver joins, then source sends | Receiver replies; R4's shared and source entries use different interfaces | Membership, tree state and delivery are separate checks |
| Change R4's route toward the source | Source tree moves from R3 to R2 and returns after rollback | Unicast routing affects multicast path selection |
| Remove R4's static RP mapping | Membership remains; restoring the mapping rebuilds the upstream tree | Local interest alone does not establish delivery |
| Remove R1's static RP mapping | Twenty probes time out; restoration brings back registration and source state | A receiver tree can coexist with a source-side fault |
| Replace static RP with Auto-RP | Dynamic-only mappings and 19 replies from 20 probes | Discovery works without static fallback |
| Restore Auto-RP control transport | R3 receives announcements again; R4 relearns the RP; native source-tree state returns | Role configuration and control-message transport must both work |
| Isolate the preferred BSR | R3 takes over; R3 accepts R5 after recovery | Verify election state beyond the candidate's local view |
| Repair missing PIM on R3 | R1–R4 learn RP 2.2.2.2 via bootstrap; source-tree state follows | Ordinary routing can work while multicast discovery fails |
| Test equal-priority Candidate RPs | R2's larger hash selects it for 239.1.1.1 | The RP address is not the first equal-priority tie-break |

## Start with a case

- [OSPF reaches the BSR, but RP discovery stops](troubleshooting/07-bsr-propagation.md) — correlate named interfaces, BSR knowledge and recovered mappings.
- [Isolate the preferred BSR, then restore it](troubleshooting/06-bsr-failover.md) — distinguish local candidate state from the connected domain's election.
- [Auto-RP roles exist, but discovery cannot recover](troubleshooting/04-autorp-listener-recovery.md) — distinguish initial outage conditions from a domain-wide listener problem during recovery.
- [A ready receiver with no replies](troubleshooting/03-source-rp-failure.md) — interpret source identity and receiver readiness during a static-RP fault.
- [Receiver membership without an upstream tree](troubleshooting/02-receiver-rp-failure.md) — compare the missing RP setting at the other edge.
- [A unicast route moves the multicast tree](troubleshooting/01-rpf-path-change.md) — follow the changed path across three routers.

## Lab design

![BSR phase: the original diamond plus R5 connected to R3](topology-bsr.png)

Static RP and Auto-RP use the original six-node topology. BSR adds R5 as a leaf off R3; the original diamond links, RP address and endpoint addresses stay the same.

| Device | Responsibility |
|---|---|
| MCAST-SOURCE | Sends multicast probes from 10.1.1.10 |
| R1-FHR | First-hop router beside the source |
| R2-RP | RP at Loopback0 2.2.2.2; Candidate RP in each dynamic-discovery phase |
| R3-TRANSIT | Source-tree transit; Auto-RP Mapping Agent, then Candidate BSR in the BSR phase |
| R4-LHR | Last-hop router beside the receiver |
| MCAST-RECEIVER | Joins the group and replies from 10.4.4.10 |
| R5-BSR2 | Added for BSR; elected in the final connected state at 5.5.5.5 |

OSPF area 0 supplies unicast reachability. R4 reaches the RP through R2 and the source through R3. Group `239.1.1.1` is the baseline across all three phases. Temporary groups `239.2.2.2` and `239.3.3.3` belong to the original static-RP fault exercises.

[Original addressing and wiring](topology.md) · [BSR addressing and wiring](topology-bsr.md) · [Auto-RP discovery roles](auto-rp.md#same-topology-separate-discovery-roles)

## Explore the files

| Location | What you will find |
|---|---|
| [Troubleshooting](troubleshooting/README.md) | Seven cases linked to exact evidence blocks |
| [Verification](verification/README.md) | Twelve evidence pages with phase-specific interpretations |
| [Configurations](configs/README.md) | Static templates, dynamic-discovery changes and an intermediate BSR CML export |
| [Auto-RP](auto-rp.md) | Migration, control-plane behavior, final forwarding and lessons learned |
| [BSR](bsr.md) | Elections, propagation repair, group-specific RP selection and lessons |
| [Progress](../progress.md) | Completed work, evidence limits and remaining multicast topics |

## Evidence scope

The original static-RP captures are from September 20–21, 2026. Auto-RP adds September 22–23 captures and selected excerpts from the completed handoff. The supplied outputs are distinct from reconstructed configuration commands and protocol interpretation.

The static receiver-side repair establishes tree recovery; the static source-side repair has a reported reply without a complete recovery ping. Auto-RP's **19/20** result is the migration test. Its later repair is supported by recovered counters, mapping and forwarding-state excerpts, without another complete post-fix ping transcript.

BSR adds September 24–25 captures. Its election failover test predates Candidate RP setup and does not establish traffic continuity. Later BSR recovery is supported by RP mappings and forwarding state, without a complete multicast ping transcript.

The saved BSR export is an intermediate checkpoint; [completion steps](configs/bsr.md#complete-the-saved-checkpoint) identify the missing R3 PIM settings and later Candidate RP addition.

The device templates reconstruct the original static baseline. The Auto-RP guide describes the subsequent changes; no final Auto-RP running-config set is presented as an export or claimed to have been rerun during documentation.

[Back to Multicast](../README.md) · [Back to portfolio](../../README.md)
