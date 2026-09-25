# PIM-SM troubleshooting cases

These controlled exercises compare a changed route with missing RP information at opposite ends of the multicast path. Cases 01–03 belong to the static-RP phase. Case 04 follows the later Auto-RP discovery outage and listener recovery. Cases 05–07 extend the work into BSR. Start with Case 07 for the latest propagation investigation, Case 04 for Auto-RP recovery, or Case 03 for the original source-side traffic failure.

| Case | Trigger | Recorded outcome |
|---|---|---|
| [01 — A unicast route moves the multicast tree](01-rpf-path-change.md) | Route the source LAN through R2 from R4 | The source tree moves to R2; rollback restores R3 |
| [02 — Receiver membership without an upstream tree](02-receiver-rp-failure.md) | Remove R4's static RP mapping | Membership remains local; restoring the mapping rebuilds the receiver branch |
| [03 — A ready receiver with no replies](03-source-rp-failure.md) | Remove R1's static RP mapping | Twenty probes time out; repair restores the PIM tunnel and source-tree state, with a reply reported |
| [04 — Auto-RP roles exist, but discovery cannot recover](04-autorp-listener-recovery.md) | Mapping Agent withdrawal followed by listener omissions during recovery | Announcements and dynamic RP learning return after domain-wide repair |
| [05 — R5 does not enter the BSR election](05-bsr-candidate-omission.md) | Candidate command omitted on R5 | R5 wins at priority 20 after candidacy is configured |
| [06 — Isolate the preferred BSR, then restore it](06-bsr-failover.md) | Shut R5's only transit link, then restore it | R3 takes over in the connected domain and later accepts R5 again |
| [07 — OSPF reaches the BSR, but RP discovery stops](07-bsr-propagation.md) | Missing PIM on R3 Gi0/0 and Gi0/1 | R1–R4 recover matching bootstrap mappings; forwarding state follows |

Each case separates the observed symptom, diagnostic evidence, targeted change and recovery limits. Case 01 is a path-change experiment, not a demonstrated packet-drop incident.

[Evidence guide](../verification/README.md) · [Exercise commands](../configs/exercise-commands.md) · [Back to PIM-SM](../README.md)

