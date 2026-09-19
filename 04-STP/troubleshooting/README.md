# STP troubleshooting

These eleven exercises explain how the lab responds to changed topology, inconsistent settings, and missing control information. They retain the original filenames so existing portfolio links continue to work.

**Start with [Case 11](11-lacp-negotiation-and-member-failure.md)** for the most complete direct-output sequence. For a short introduction to protection policy, use [Case 01](01-bpdu-guard-rogue-switch.md).

## Case index

| Case | Diagnostic question | Evidence available |
|---|---|---|
| [01 — BPDU Guard](01-bpdu-guard-rogue-switch.md) | What happens when an expected client port receives switch messages? | Saved edge policy and exercise account; failure/recovery transcript absent |
| [02 — Root Guard](02-root-guard-root-inconsistent.md) | How is an unwanted root direction rejected? | Intended root design and exercise account; temporary guard setting and event captures absent |
| [03 — Loop Guard](03-loop-guard-bpdu-suppression.md) | What if a link stays up but expected control messages disappear? | Exercise account; temporary policy and event captures absent |
| [04 — Native VLAN mismatch](04-native-vlan-pvid-mismatch.md) | What if a trunk's two ends disagree about the native VLAN? | Design context and exercise account; mismatch/recovery captures absent |
| [05 — Trunk/access mismatch](05-trunk-access-port-type-inconsistent.md) | What if one side expects multiple VLANs and the other expects one? | Saved-mode context and exercise account; event captures absent |
| [06 — Member VLAN-mask mismatch](06-etherchannel-vlan-mask-suspension.md) | Why might one link be refused membership in a bundle? | Separate healthy bundle context and exercise account; this fault's captures absent |
| [07 — Misconfiguration guard](07-etherchannel-misconfig-guard.md) | What if the peers disagree about the logical bundle? | Enabled feature status and exercise account; activation/recovery captures absent |
| [08 — Bridge Assurance](08-bridge-assurance-inconsistency.md) | What if an infrastructure peer stops participating in control-message exchange? | Pre-change interface detail and saved network-port settings; failure/recovery captures absent |
| [09 — Recovery and timers](09-classic-stp-convergence-timers.md) | Do timer settings tell us how long service was interrupted? | Mode, timer, and state snapshots; no measured convergence comparison |
| [10 — Path engineering](10-path-cost-port-priority-engineering.md) | How do root priority, path cost, and port priority affect selection? | Saved priorities and selected-port/cost captures; dedicated override comparison absent |
| [11 — LACP member and negotiation failures](11-lacp-negotiation-and-member-failure.md) | How is one member down different from the entire bundle down? | Direct baseline, bundle, member-failure, and suspension captures; final negotiation-repair capture absent |

## Understand the different protective outcomes

| State | Meaning in these exercises |
|---|---|
| Alternate/Blocked | A normal redundant path held out of forwarding to prevent a loop |
| Root-inconsistent | Protection rejects an unwanted superior-root condition |
| Loop-inconsistent | Protection responds to missing expected BPDU reception |
| BA_Inc | The documented Bridge Assurance inconsistency |
| Err-disabled | The interface has been disabled by a protection mechanism; inspect the reason |
| EtherChannel member suspended | The member is not participating in its bundle; configuration or negotiation checks are needed |

The label narrows the investigation but does not replace the configuration, peer, and log checks.

## Reading method

Each case explains the operational concern, the documented exercise, the retained evidence, and the recovery approach. **Reference commands are suggested checks for a replay.**

Cases supported only by lab notes are identified as documented exercises. The [verification index](../verification/README.md) links every original capture so a technical reviewer can examine the underlying record.

[Module overview](../README.md) · [Configuration guide](../configs/README.md)
