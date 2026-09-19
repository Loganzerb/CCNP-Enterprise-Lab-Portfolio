# Incident excerpts and commands

These pages preserve all **48 original fenced blocks** from the three cases, unchanged and in their original order. Blocks include selected CLI output, documented configuration changes, command lists, and one conceptual flow diagram.

| Case | Blocks | Evidence scope |
|---|---:|---|
| [01 — MTU mismatch](scenario-1-ospf-mtu-exstart-exchange.md) | 17 | Failure excerpts, successful fault-state ping, MTU/debug checks, and recovery output on both routers |
| [02 — NSSA mismatch](scenario-2-nssa-capability-and-lsa-translation.md) | 11 | Conceptual flow, commands, and two device-output excerpts from recovery; no retained fault-state CLI excerpts |
| [03 — Area filter](scenario-3-abr-route-filtering-control-plane.md) | 20 | Policy configuration, missing route/LSA, neighbor and component-route excerpts, and recovery output |

The [case studies](../../troubleshooting/README.md) interpret these excerpts and distinguish captured output from narrative observations.

The general verification snapshots in neighboring directories were captured separately. They establish the documented baseline, not a time-ordered failure/recovery record.

[Verification guide](../README.md)
