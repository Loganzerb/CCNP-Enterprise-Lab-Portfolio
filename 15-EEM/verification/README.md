# EEM verification guide

These Cisco Modeling Labs tests connect an event detector to its actions and observed result. The October 9, 2026 handoff supplies selected syslog and debug excerpts, commands, temporary policy definitions, and reported execution results.

**Quick navigation:** [Verification guides](#verification-guides) · [Read the evidence](#read-the-evidence) · [Troubleshooting cases](../troubleshooting/README.md)

## Verification guides

| Guide | Blocks | Recorded result |
|---|---|---|
| [Syslog-triggered diagnostics](syslog-triggered-diagnostics.md) | 01–05 | Final GI1-DOWN-ALERT logs the failure and interface state; a separate temporary detector responds after its pattern is corrected |
| [Manual execution](manual-execution.md) | 06 | MANUAL-DIAG reportedly displays the interface summary and logs completion at 23:02:54.091 UTC |
| [Watchdog timer](watchdog-timer.md) | 07–08 | Three supplied trigger times are approximately 60 seconds apart; the test applet was later removed |
| [CLI detection and interception](cli-event-interception.md) | 09–12 | Removing the end anchor repaired the observed match; asynchronous and synchronous executions are reported |

## Read the evidence

The blocks preserve the handoff's supplied lines. They are grouped by verification question rather than presented as one uninterrupted console transcript. Configuration and command blocks identify what was configured or invoked; they are not output records.

Manual interface-summary output, policy-registration output, and event-history entries were described without their command output being supplied. Those observations remain prose. Only GI1-DOWN-ALERT and MANUAL-DIAG were retained in the final saved configuration; watchdog, faulty-link, and CLI audit policies were temporary tests.

The 3 ms faulty-link interval describes one pair of syslog timestamps. It provides no response-time guarantee. UTC is retained where the handoff explicitly labels it; other excerpts keep their supplied timestamp formatting.

[EEM overview](../README.md) · [Configurations](../configs/README.md) · [Troubleshooting](../troubleshooting/README.md)
