# PIM-SM troubleshooting cases

These controlled exercises compare a changed route with missing RP information at opposite ends of the multicast path. Start with Case 03 for the clearest traffic failure, then compare Case 02 to see why the same missing setting produces a different local symptom.

| Case | Trigger | Recorded outcome |
|---|---|---|
| [01 — A unicast route moves the multicast tree](01-rpf-path-change.md) | Route the source LAN through R2 from R4 | The source tree moves to R2; rollback restores R3 |
| [02 — Receiver membership without an upstream tree](02-receiver-rp-failure.md) | Remove R4's static RP mapping | Membership remains local; restoring the mapping rebuilds the receiver branch |
| [03 — A ready receiver with no replies](03-source-rp-failure.md) | Remove R1's static RP mapping | Twenty probes time out; repair restores the PIM tunnel and source-tree state, with a reply reported |

Each case separates the observed symptom, diagnostic evidence, targeted change and recovery limits. Case 01 is a path-change experiment, not a demonstrated packet-drop incident.

[Evidence guide](../verification/README.md) · [Exercise commands](../configs/exercise-commands.md) · [Back to PIM-SM](../README.md)

