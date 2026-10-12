# Syslog-triggered EEM diagnostics

The final GI1-DOWN-ALERT applet detects GigabitEthernet1 line-protocol failure, runs an interface check, and logs its result. A separate temporary LINK-FAULT-TEST exercise shows why a registered detector still needs a pattern that matches the device's actual message.

**Quick navigation:** [Final saved policy](#final-saved-policy) · [Temporary pattern test](#temporary-pattern-test) · [Evidence scope](#evidence-scope)

## Final saved policy

GI1-DOWN-ALERT watches `%LINEPROTO-5-UPDOWN` messages containing GigabitEthernet1 and `down`. It enters privileged CLI, runs `show ip interface brief | include GigabitEthernet1`, and places `$_cli_result` in its diagnostic syslog.

### Block 01

**Selected CLI excerpt — October 9, 2026.** The failure, custom alert, and diagnostic result appear in sequence.

```text
22:34:47.104 %LINEPROTO-5-UPDOWN:
Interface GigabitEthernet1, changed state to down

22:34:47.106 %HA_EM-6-LOG:
GI1-DOWN-ALERT: EEM ALERT:
GigabitEthernet1 line protocol DOWN

22:34:47.428 %HA_EM-6-LOG:
GI1-DOWN-ALERT: EEM DIAG:
GigabitEthernet1 10.66.12.1
YES manual administratively down down
```

The diagnostic message retains the interface address and its administrative/protocol state. It supports the recorded action chain from line-protocol event to CLI-result logging.

## Temporary pattern test

LINK-FAULT-TEST was a separate troubleshooting applet and was subsequently removed. It used a LINK message detector, whereas final GI1-DOWN-ALERT uses LINEPROTO.

### Block 02

**Recorded configuration — incorrect detector.**

```cisco
event syslog pattern "%LINK-3-UPDOWN.*GigabitEthernet1.*down"
```

### Block 03

**Selected CLI excerpt — administrative-shutdown message.**

```text
%LINK-5-CHANGED:
Interface GigabitEthernet1,
changed state to administratively down
```

The emitted identifier was LINK-5-CHANGED, not the LINK-3-UPDOWN identifier in the detector.

### Block 04

**Recorded configuration — corrected detector.**

```cisco
event syslog pattern "%LINK-5-CHANGED.*GigabitEthernet1.*administratively down"
```

### Block 05

**Selected CLI excerpt — repair result.**

```text
23:21:17.157 %LINK-5-CHANGED:
Interface GigabitEthernet1, changed state to administratively down

23:21:17.160 %HA_EM-6-LOG:
LINK-FAULT-TEST: EEM FAULT-TEST: Gi1 failure detected
```

The two recorded syslog timestamps are 3 ms apart. This interval describes that event pair and provides no performance guarantee.

## Evidence scope

Registration and the initial failure are reported observations without output excerpts. The selected excerpts show the repaired LINK detector, distinct from the final LINEPROTO policy. [Evidence sources](../scope.md#evidence-sources) document the provenance.

[Read the pattern-mismatch case](../troubleshooting/incorrect-syslog-pattern.md) · [Verification index](README.md) · [EEM overview](../README.md)
