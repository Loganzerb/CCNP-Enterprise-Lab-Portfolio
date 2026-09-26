# IGMPv2 and IGMPv3 — receiver membership and source selection

Multicast delivery depends on knowing which networks have interested receivers. This lab follows a receiver as its membership expires, returns, and becomes specific to one source. The work connects host reports to the router's forwarding decisions, making it possible to explain why a receiver branch appears or disappears.

**Recorded outcomes:** the IGMPv2 receiver branch was removed when membership expired and restored after new reports. IGMPv3 then produced source-specific state for `10.1.1.10 → 232.1.1.1`, alongside the existing any-source group.

## Choose a phase

| Phase | What it demonstrates | Evidence |
|---|---|---|
| [01 — IGMPv2](igmpv2.md) | Membership, querier behavior, timer expiry and rejoin | [Blocks 01–03](verification/01-v2-membership.md) |
| [02 — IGMPv3 and SSM](igmpv3-ssm.md) | Version migration, INCLUDE/EXCLUDE and source-specific routing | [Blocks 04–07](verification/02-v3-ssm.md) |

For a quick case review, start with [the receiver branch disappears without a captured Leave](troubleshooting/01-membership-expiry.md). For technical review, compare [the two membership modes with the resulting route](verification/02-v3-ssm.md#block-07--correlate-the-membership-view-with-the-multicast-route).

## Navigate the files

| Guide | Contents |
|---|---|
| [Topology](topology.md) | Receiver LAN, source direction and the existing PIM-SM underlay |
| [Configuration](configs/README.md) | Selected commands and the purpose of each change |
| [Verification](verification/README.md) | Seven numbered blocks with full captured text |
| [Troubleshooting](troubleshooting/README.md) | Membership expiry and command/output interpretation |

## Evidence scope

This section includes the SSM control-plane exercise completed with IGMPv3. The captures establish membership and `(S,G)` state; they do not include a completed SSM traffic test or a second-source rejection test. Report suppression and the Leave/group-specific-query sequence are explained as protocol behavior, not presented as captured experiments.

[PIM-SM](../PIM-SM/README.md) · [BIDIR-PIM](../BIDIR-PIM/README.md) · [Back to Multicast](../README.md)
