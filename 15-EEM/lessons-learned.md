# EEM engineering lessons

| Lesson | What the lab showed |
|---|---|
| Validate behavior after registration | A registered syslog or CLI policy can still find no matching event |
| Use the message actually emitted | Administrative shutdown produced `%LINK-5-CHANGED`; a `%LINK-3-UPDOWN` detector did not match it |
| Separate the trigger from the diagnostic result | The alert established that the applet fired; the later `EEM DIAG` established collection of the interface state |
| Keep manual execution explicit | `event none` and `event manager run` supplied an on-demand diagnostic path |
| Test recurring behavior | Three watchdog timestamps showed repeated execution, not just a configured timer |
| Understand synchronous command permission | The tested synchronous policy used `_exit_status 1` to permit the original CLI command |
| Treat a regex repair as a measured change | Removing `$` worked here and broadened the match; the original failure's underlying cause was not captured |
| Preserve the final deployment boundary | Two applets remain in the export; timer and CLI experiments are retained as completed test documentation |

The practical skill was constructing applets, testing their triggers and actions, and tracing silent failures with the actual device messages. The lab supports diagnostic automation and data collection; it does not establish production readiness or automated service recovery.

[Process diagrams](operation.md) · [Troubleshooting cases](troubleshooting/README.md) · [Evidence scope](scope.md) · [Overview](README.md)
