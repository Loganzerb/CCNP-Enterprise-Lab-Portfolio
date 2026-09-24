# NTP verification guide

The evidence is grouped by the question each test answers. Read a short interpretation above each numbered block, then inspect the retained CLI directly.

| Evidence page | Blocks | What it establishes |
|---|---:|---|
| [01 — Hierarchy and synchronization](01-hierarchy.md) | 8 | Source/core/client strata, selection before synchronization, and switch wiring |
| [02 — Failover and source acceptance](02-failover.md) | 9 | Backup operation, rejected sources, preference-test outcome and later recovery |
| [03 — Loopback source and return routing](03-loopback-route.md) | 7 | Missing route, sourced ping failure, installed route and renewed NTP exchange |
| [04 — Ping succeeds while NTP is blocked](04-acl-udp123.md) | 10 | Applied ACL, matching counters, failed association, repair and cleanup |

## Read the outputs in layers

| Question | Useful evidence | Reading it in this lab |
|---|---|---|
| Can replies reach the client source? | Source-specific ping and return route | 0/5 became 5/5 after the /32 route was installed |
| Are NTP exchanges occurring? | Association reach and ACL counters | Reach recovered to 17 after routing repair and to 1 after ACL repair |
| Is the source accepted? | Association markers and detail | A responding source could still be x, insane or invalid |
| Is the local clock synchronized? | show ntp status | Initial and backup hierarchy captures explicitly report synchronized |

**Reach** is an eight-bit history displayed in octal, not a percentage or a total packet count. **377** represents eight successful recent polls. **1** and **17** show partial rebuilt history; a positive value alone does not prove synchronization. Confirm local state with `show ntp status`.

The association's **st** field describes the remote source. Local stratum appears in `show ntp status`. In these captures, `*` marks the system peer, `+` a candidate, `x` a falseticker and `~` a configured association. Detailed `insane, invalid` output means the source's time is not accepted.

The [R3 baseline pair](01-hierarchy.md#block-03) is particularly useful: the association had a selected marker while local status still said unsynchronized and FREQ. A [later status](01-hierarchy.md#block-05) explicitly recorded synchronized and CTRL.

## Capture conventions and limits

These selected outputs were recorded during the September 18–19, 2026 lab sessions. They are organized by test, with repeated waiting polls omitted. Wiring blocks are grouped with the baseline rather than placed in their original conversation order.

Formatting cleanup decodes escaped spaces and Markdown escapes, normalizes line endings and restores the CLI asterisk legend where it became a list marker. Device values, offsets, counters, spelling and truncated command lines remain as recorded. Complete readable commands in the configuration guide are labeled separately.

Link shutdown/restoration and applying `prefer` were confirmed in the exercise notes. Their effects are captured here; a contemporaneous interface-state or running-config dump for those actions is not available. The original YAML represents an earlier stage than the source-interface exercises.

Local clock agreement does not establish UTC accuracy. Failover duration was not measured. The two communication repairs end before a final synchronized R3 status; symmetric peering, authentication and external time sources were outside the tests.

[Back to cases](../troubleshooting/README.md) · [Back to NTP](../README.md)
