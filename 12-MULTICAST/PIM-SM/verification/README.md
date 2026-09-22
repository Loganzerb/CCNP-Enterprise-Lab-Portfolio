# PIM-SM verification guide

These four pages retain **39 numbered blocks**. Each block gives a short interpretation before the original CLI output, so a reader can inspect the evidence without having to infer why the command was run.

| Page | Blocks | What to look for |
|---|---:|---|
| [01 — Baseline](01-baseline.md) | 15 | Different source/RP routes, membership, receiver replies and source-tree forwarding |
| [02 — RPF path change](02-rpf-path-change.md) | 7 | Static-route selection, changed tree and rollback across R4, R3 and R2 |
| [03 — Receiver-side RP failure](03-receiver-rp-failure.md) | 6 | Local membership survives while the upstream tree is missing |
| [04 — Source-side RP failure](04-source-rp-failure.md) | 11 | Healthy receiver tree, missing registration mechanism, timeouts and restored state |

## Read the checks together

| Check | Question it answers |
|---|---|
| `show ip igmp groups` | Has the local router learned receiver interest? |
| `show ip pim neighbor` | Are adjacent routers participating in PIM? |
| `show ip pim rp mapping` | Which RP does this router know for the group? |
| `show ip pim tunnel` | Does this IOSv router show its PIM registration mechanism? |
| `show ip rpf <address>` | Which reverse path does the router select toward that source or RP? |
| `show ip mroute <group>` | What incoming and outgoing interfaces are installed for the group and source? |
| Source-to-group ping | Did the receiver reply to the submitted probes? |

For shared-tree state, the reverse-path lookup is toward the RP; for source-tree state, it is toward the source. A matching interface alone does not tell you which tree is in use. [Cisco PIM and RPF behavior](https://www.cisco.com/c/en/us/td/docs/switches/lan/c9000/multicast/multicast-configuration-guide/pim.html)

## Decode the entries

- `(*,G)` identifies group state rooted at the RP; `(S,G)` identifies a particular source and group.
- **Incoming interface (IIF)** is the selected receiving direction. **Outgoing interface list (OIL)** lists downstream branches.
- The retained CLI legend defines flags such as `T` (SPT-bit set), `P` (pruned), `J` (Join SPT) and `F` (Register flag).
- `Null` needs context: R2's shared-tree IIF is Null because R2 is the RP; R4's Null IIF with RP `0.0.0.0` during the fault has a different meaning.

## Evidence handling

Output is taken from the submitted lab captures. Cleanup normalizes line endings, decodes escaped spaces and removes Markdown escapes from CLI characters. It does not alter addresses, flags, counters, timeout markers or interleaved logs. Blocks are separate snapshots, not simultaneous measurements.

The baseline multicast ping includes an initial timeout marker and duplicate replies to one request. Their cause was not established by a packet capture. The source-side repair has a reported reply and captured recovered state, but no complete post-repair ping transcript. The receiver-side repair establishes tree recovery only.

Configuration commands are reconstructed in the [exercise guide](../configs/exercise-commands.md). They are distinct from these captured results. The presence of `224.0.1.40` in IGMP output is not proof that the planned Auto-RP lab has been completed.

[Back to cases](../troubleshooting/README.md) · [Back to PIM-SM](../README.md)

