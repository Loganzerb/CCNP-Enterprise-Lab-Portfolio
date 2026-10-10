# Recurring watchdog execution

TIMER-HEARTBEAT tested recurring EEM execution without a manual trigger. It was a temporary exercise applet and was removed afterward.

**Quick navigation:** [Recorded result](#recorded-result) · [Temporary policy](#temporary-policy) · [Trigger times](#trigger-times) · [Evidence scope](#evidence-scope)

## Recorded result

Three supplied trigger times support recurring execution at approximately 60-second intervals. The differences between adjacent timestamps are **60.001 seconds** each.

## Temporary policy

### Block 07

**Supplied temporary configuration.**

```cisco
event manager applet TIMER-HEARTBEAT
 event timer watchdog time 60
 action 1.0 syslog msg "EEM TIMER: Periodic 60-second heartbeat"
```

## Trigger times

### Block 08

**Supplied observed timestamps — October 9, 2026.**

```text
23:07:24.899
23:08:24.900
23:09:24.901
```

The configured detector requests a 60-second watchdog interval. These three times show the recurring behavior observed in this exercise; they do not establish exact scheduling under other conditions.

## Evidence scope

The handoff supplies the configuration and three timestamps, without full heartbeat syslog lines or an uninterrupted console transcript. Its account states that execution occurred without manual intervention and that the applet was removed afterward. TIMER-HEARTBEAT is absent from the final saved EEM policy set.

[Verification index](README.md) · [EEM overview](../README.md)
