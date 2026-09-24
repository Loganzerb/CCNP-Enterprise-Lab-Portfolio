# Multicast progress

**Snapshot: September 23, 2026.** Auto-RP is the latest completed phase. BSR is the next lab.

| Work | Current position |
|---|---|
| Six-node topology and OSPF underlay | Built; different source and RP paths verified |
| Static-RP PIM-SM | Membership, tree state, receiver replies and three controlled cases documented |
| RPF path change | Source tree moved with a temporary unicast route and restored |
| Static RP faults | Receiver-side tree recovery and source-side failure/recovery documented |
| Auto-RP migration | Listener, Candidate RP and Mapping Agent configured; dynamic mapping verified before static removal across R1–R4 |
| Auto-RP-only traffic | Captured 19 replies from 20 probes |
| Auto-RP troubleshooting | Mapping Agent withdrawal distinguished from missing-listener recovery fault |
| Auto-RP recovery | Listener restored across the domain; R3 counters, R4 dynamic mapping and final source-tree state verified |
| BSR | Next section when the lab resumes; not completed |
| IGMPv2/v3, SSM, Bidir-PIM, MSDP | Planned dedicated labs |

## Evidence retained

The PIM-SM section now contains **69 numbered blocks**: 39 from the original static-RP checkpoint and 30 for Auto-RP. The Auto-RP material combines original CLI captures with selected excerpts supplied in the completed handoff.

The Auto-RP migration has a complete 20-probe transcript. Later recovery has counters, mapping and forwarding-state excerpts, without a separate complete post-fix ping transcript. Registration state is captured; receipt of a Register-Stop packet is inferred from the state transition rather than directly captured.

## Next checkpoint

Begin BSR from a saved, verified Auto-RP baseline. Retain the starting configuration and RP mapping, each intentional phase change, the new mapping origin, traffic results and rollback checks. Keep BSR evidence distinct from this completed Auto-RP phase.

A full final running-config set, CML export and complete post-fix traffic transcript would make the Auto-RP checkpoint easier to reproduce independently. These are additional artifacts, not reasons to mark the completed lab phase as unfinished.

[Read Auto-RP](PIM-SM/auto-rp.md) · [Back to Multicast](README.md)
