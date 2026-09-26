# PIM-SM troubleshooting — Cases by phase

Each case follows the symptom, evidence, diagnosis, targeted change and available recovery checks. Choose the discovery method first, then the incident.

[Static RP](#static-rp) · [Auto-RP](#auto-rp) · [BSR](#bsr)

## Static RP

Three controlled exercises isolate routing and RP dependencies. The path-change case demonstrates a changed route, not a packet-drop incident. [Phase overview](../static-rp.md).

| Case | Trigger | Recorded outcome |
|---|---|---|
| [01 — A unicast route moves the multicast tree](01-rpf-path-change.md) | Route the source LAN through R2 from R4 | The source tree moves to R2; rollback restores R3 |
| [02 — Receiver membership without an upstream tree](02-receiver-rp-failure.md) | Remove R4's static RP mapping | Membership remains local; restoring the mapping rebuilds the receiver branch |
| [03 — A ready receiver with no replies](03-source-rp-failure.md) | Remove R1's static RP mapping | Twenty probes time out; repair restores the PIM tunnel and source-tree state, with a reply reported |

## Auto-RP

The discovery investigation separates the initial Mapping Agent withdrawal from the listener fault encountered during recovery. [Phase overview](../auto-rp.md).

| Case | Trigger | Recorded outcome |
|---|---|---|
| [04 — Auto-RP roles exist, but discovery cannot recover](04-autorp-listener-recovery.md) | Mapping Agent withdrawal followed by listener omissions during recovery | Announcements and dynamic RP learning return after domain-wide repair |

## BSR

Two election exercises and a propagation fault. Start with Case 07 for the interface-level diagnosis; Case 06 measures election behavior rather than traffic continuity. [Phase overview](../bsr.md).

| Case | Trigger | Recorded outcome |
|---|---|---|
| [05 — R5 does not enter the BSR election](05-bsr-candidate-omission.md) | Candidate command omitted on R5 | R5 wins at priority 20 after candidacy is configured |
| [06 — Isolate the preferred BSR, then restore it](06-bsr-failover.md) | Shut R5's only transit link, then restore it | R3 takes over in the connected domain and later accepts R5 again |
| [07 — OSPF reaches the BSR, but RP discovery stops](07-bsr-propagation.md) | Missing PIM on R3 Gi0/0 and Gi0/1 | R1–R4 recover matching bootstrap mappings; forwarding state follows |

[Evidence by phase](../verification/README.md) · [Configurations by phase](../configs/README.md) · [All PIM-SM phases](../README.md)
