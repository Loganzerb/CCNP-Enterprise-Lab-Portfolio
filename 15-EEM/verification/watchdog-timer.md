# Recurring watchdog execution

TIMER-HEARTBEAT tested recurring EEM execution without a manual trigger. It was a temporary exercise applet and was removed afterward.

**Quick navigation:** [Recorded result](#recorded-result) · [Temporary policy](#temporary-policy) · [Trigger times](#trigger-times) · [Evidence scope](#evidence-scope)

## Recorded result

Three recorded trigger times support recurring execution at approximately 60-second intervals. The differences between adjacent timestamps are **60.001 seconds** each.

## Temporary policy

### Block 07

**Recorded configuration — temporary watchdog.**

```cisco
event manager applet TIMER-HEARTBEAT
 event timer watchdog time 60
 action 1.0 syslog msg "EEM TIMER: Periodic 60-second heartbeat"
```

## Trigger times

### Block 08

**Recorded timestamps — October 9, 2026.**

```text
23:07:24.899
23:08:24.900
23:09:24.901
```

The configured detector requests a 60-second watchdog interval. These three times show the recurring behavior observed in this exercise; they do not establish exact scheduling under other conditions.

## Evidence scope

The lab record contains configuration and three timestamps; complete heartbeat syslog lines are unavailable. Execution without manual invocation is reported. TIMER-HEARTBEAT was removed from the final saved policy set.

[Verification index](README.md) · [EEM overview](../README.md)
