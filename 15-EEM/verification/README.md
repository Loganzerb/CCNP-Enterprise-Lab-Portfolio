# EEM verification guide

These Cisco Modeling Labs tests connect an event detector to its actions and result. Selected syslog/debug excerpts, commands, temporary policies, and reported results form the October 9, 2026 lab record.

**Quick navigation:** [Verification guides](#verification-guides) · [Read the evidence](#read-the-evidence) · [Troubleshooting cases](../troubleshooting/README.md)

## Verification guides

| Guide | Blocks | Recorded result |
|---|---|---|
| [Syslog-triggered diagnostics](syslog-triggered-diagnostics.md) | 01–05 | Final GI1-DOWN-ALERT logs the failure and interface state; a separate temporary detector responds after its pattern is corrected |
| [Manual execution](manual-execution.md) | 06 | MANUAL-DIAG reportedly displays the interface summary and logs completion at 23:02:54.091 UTC |
| [Watchdog timer](watchdog-timer.md) | 07–08 | Three supplied trigger times are approximately 60 seconds apart; the test applet was later removed |
| [CLI detection and interception](cli-event-interception.md) | 09–12 | Removing the end anchor repaired the observed match; asynchronous and synchronous executions are reported |

## Read the evidence

Blocks retain selected lab-record lines, grouped by verification question. Labels distinguish CLI excerpts from commands/configuration and reported observations. [Full provenance](../scope.md#evidence-sources) explains the source boundaries.

Manual interface-summary output, policy registration, and event-history entries remain reported observations without their command output. Only GI1-DOWN-ALERT and MANUAL-DIAG were retained in the final saved configuration; watchdog, faulty-link, and CLI audit policies were temporary tests.

The 3 ms faulty-link interval is one timestamp pair, not a response-time guarantee. UTC appears only where identified in the lab record; other timestamp formatting is retained.

[EEM overview](../README.md) · [Configurations](../configs/README.md) · [Troubleshooting](../troubleshooting/README.md)
