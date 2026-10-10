# EEM troubleshooting cases

Both exercises began with a registered detector that did not respond as expected. The repairs follow the actual message or debug result instead of treating registration as proof that an event will match.

**Quick navigation:** [Case index](#case-index) · [Diagnostic approach](#diagnostic-approach) · [Verification](../verification/README.md)

## Case index

| Case | Diagnostic question | Recorded result |
|---|---|---|
| [Incorrect syslog pattern](incorrect-syslog-pattern.md) | Does the detector match the emitted message identifier and state text? | Corrected LINK-FAULT-TEST appears 3 ms after the supplied LINK-5-CHANGED entry |
| [CLI regex matching](cli-regex-matching.md) | Does the CLI detector record a match for the command being tested? | Removing `$` repaired the observed match; successful asynchronous and synchronous runs are reported |

## Diagnostic approach

Compare detector intent with the actual event text, inspect the match result, make a targeted correction, and verify the policy action. The syslog case supplies a repair-result excerpt. The CLI case supplies failure debugging and reports the successful executions without their full output.

These were temporary Cisco Modeling Labs troubleshooting policies. The final saved GI1-DOWN-ALERT applet uses a different LINEPROTO detector from the repaired LINK-FAULT-TEST case. The CLI pattern's underlying failure mechanism remains unproven.

[EEM overview](../README.md) · [Verification index](../verification/README.md) · [Configurations](../configs/README.md)
