# PIM-SM verification guide

These seven pages retain **69 numbered blocks**: 39 for static RP and 30 for Auto-RP. Each block identifies its purpose before the evidence. Auto-RP combines original CLI captures with clearly labeled selected handoff excerpts.

| Page | Blocks | What to look for |
|---|---:|---|
| [01 — Baseline](01-baseline.md) | 15 | Different source/RP routes, membership, receiver replies and source-tree forwarding |
| [02 — RPF path change](02-rpf-path-change.md) | 7 | Static-route selection, changed tree and rollback across R4, R3 and R2 |
| [03 — Receiver-side RP failure](03-receiver-rp-failure.md) | 6 | Local membership survives while the upstream tree is missing |
| [04 — Source-side RP failure](04-source-rp-failure.md) | 11 | Healthy receiver tree, missing registration mechanism, timeouts and restored state |
| [05 — Auto-RP migration](05-autorp-migration.md) | 11 | Candidate/Mapping-Agent setup, coexistence, static removal and 19/20 replies |
| [06 — Auto-RP failure and recovery](06-autorp-recovery.md) | 11 | Initial outage, stalled recovery, listener diagnosis and recovered discovery |
| [07 — Auto-RP forwarding](07-autorp-forwarding.md) | 8 | Shared tree, SPT, neighbors, unicast-table distinction, RP prune and FHR registration state |

## Read the checks together

| Check | Question it answers |
|---|---|
| `show ip igmp groups` | Has the local router learned receiver interest? |
| `show ip pim neighbor` | Are adjacent routers participating in PIM? |
| `show ip pim rp mapping` | Which RP does this router know for the group? |
| `show ip pim tunnel` | Does this IOSv router show its PIM registration mechanism? |
| `show ip rpf <address>` | Which reverse path does the router select toward that source or RP? |
| `show ip mroute <group>` | What incoming and outgoing interfaces are installed for the group and source? |
| `show ip pim autorp` | Which discovery messages have been sent or received, and is listener forwarding enabled? |
| Source-to-group ping | Did the receiver reply to the submitted probes? |

For shared-tree state, the reverse-path lookup is toward the RP; for source-tree state, it is toward the source. A matching interface alone does not tell you which tree is in use. [Cisco PIM and RPF behavior](https://www.cisco.com/c/en/us/td/docs/switches/lan/c9000/multicast/multicast-configuration-guide/pim.html)

## Decode the entries

- `(*,G)` identifies group state rooted at the RP; `(S,G)` identifies a particular source and group.
- **Incoming interface (IIF)** is the selected receiving direction. **Outgoing interface list (OIL)** lists downstream branches.
- The retained CLI legend defines flags such as `T` (SPT-bit set), `P` (pruned), `J` (Join SPT) and `F` (Register flag).
- `Null` needs context: R2's shared-tree IIF is Null because R2 is the RP; R4's Null IIF with RP `0.0.0.0` during the fault has a different meaning.

## Evidence handling

Pages 01–05 and Blocks 01–09 of Page 06 retain retrieved lab CLI. Blocks 10–11 of Page 06 and Page 07 retain selected excerpts or field summaries from the completed Auto-RP handoff; missing prompts, timers and fields have not been invented. Cleanup normalizes line endings, decodes escaped spaces and removes Markdown escapes from CLI characters. It does not alter addresses, flags, counters, timeout markers or interleaved logs. Blocks are separate snapshots, not simultaneous measurements.

In the static-RP phase, the baseline multicast ping includes an initial timeout marker and duplicate replies to one request. Their cause was not established by a packet capture. The source-side repair has a reported reply and captured recovered state, but no complete post-repair ping transcript. The receiver-side repair establishes tree recovery only.

Configuration commands are reconstructed in the [exercise guide](../configs/exercise-commands.md). They are distinct from these captured results. Membership in `224.0.1.40` alone does not prove dynamic discovery. Auto-RP is established here by role counters and `elected via Auto-RP` mappings after static removal. The captured 19/20 ping belongs to migration; later recovery includes forwarding-state excerpts without a separate complete traffic transcript. Register-Stop is a protocol interpretation consistent with the captured transition, not a retained packet capture.

[Auto-RP overview](../auto-rp.md) · [Auto-RP configuration](../configs/auto-rp.md) · [Back to cases](../troubleshooting/README.md) · [Back to PIM-SM](../README.md)
