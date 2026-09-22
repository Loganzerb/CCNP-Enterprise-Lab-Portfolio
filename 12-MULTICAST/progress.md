# Multicast progress

**Snapshot: September 22, 2026.** This page tracks what is ready to review and what still needs lab evidence.

| Work | Current position |
|---|---|
| Six-node topology and OSPF underlay | Built; source and RP paths verified |
| Static-RP PIM-SM | Receiver membership, shared-tree state, source state and receiver replies captured |
| RPF path change | Changed and restored the source tree with a temporary unicast route |
| Receiver-side RP fault | Captured missing mapping, local membership and tree recovery |
| Source-side RP fault | Captured twenty timeouts and recovered device state; a post-repair reply was reported |
| Cleanup | Removed the two temporary receiver joins; retained 239.1.1.1 |
| Auto-RP | Next lab checkpoint; R2 is planned as candidate RP and R3 as mapping agent |
| BSR | Planned after Auto-RP |
| IGMPv2/v3, SSM, Bidir-PIM, MSDP | Planned dedicated labs |

## Next evidence to retain

For Auto-RP and BSR, save the configuration changes, learned RP mappings and their origin, receiver membership, source-specific forwarding state and a complete source-to-group ping transcript. Record the baseline before each change and retain the rollback checks.

For a stronger close to the static-RP work, capture a fresh post-repair ping to 239.3.3.3 during a repeat of the source-side fault, and a source-to-receiver test for 239.2.2.2 after the receiver-side repair. These would add direct traffic verification to the recovery state already retained.

Keep dynamic-RP evidence in a separate phase under PIM-SM so the static-RP baseline and its cases remain reproducible. Add other topic directories when they contain a lab, configuration guide and evidence.

[Back to Multicast](README.md)

