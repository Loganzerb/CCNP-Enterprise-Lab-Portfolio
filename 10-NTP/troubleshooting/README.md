# NTP troubleshooting cases

Each case connects a service symptom to the checks, correction and recorded result. The linked blocks retain the supporting device output.

| Case | Diagnostic question | Outcome |
|---|---|---|
| [01 — Source failover and recovery](01-source-failover.md) | Does a reachable time source qualify for selection? | Backup hierarchy confirmed; primary acceptance lagged behind link recovery |
| [02 — Missing loopback return route](02-loopback-return-route.md) | Can the server reply to the source address NTP actually uses? | Sourced ping recovered to 5/5 and NTP reach rebuilt to 17 |
| [03 — UDP/123 blocked by an ACL](03-acl-udp123.md) | Does successful ping establish that time updates can pass? | Corrected ACL recorded 37 permit matches and NTP reach recovered to 1 |

**Suggested first read:** Case 03. It shows why a successful general connectivity check must be followed by a service-specific check.

These are controlled lab exercises. Link shutdown/restoration and the preference change in Case 01 include recorded confirmations; Cases 02 and 03 include direct route, ping, association and ACL output.

[Verification guide](../verification/README.md) · [Configuration guide](../configs/README.md) · [Back to NTP](../README.md)
