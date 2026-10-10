# Temporary EEM exercises

These applets were configured and tested during the completed lab, then removed. Their configuration comes from the handoff; none is present in the final CML export. Snippets show the supplied commands rather than a reconstructed full running configuration.

## Recurring watchdog

```cisco
event manager applet TIMER-HEARTBEAT
 event timer watchdog time 60
 action 1.0 syslog msg "EEM TIMER: Periodic 60-second heartbeat"
```

The watchdog repeats without manual invocation. The three retained timestamps show approximately 60-second recurrence. [Timer verification](../verification/watchdog-timer.md)

## Syslog fault-test detector

Original detector:

```cisco
event syslog pattern "%LINK-3-UPDOWN.*GigabitEthernet1.*down"
```

Repaired detector:

```cisco
event syslog pattern "%LINK-5-CHANGED.*GigabitEthernet1.*administratively down"
```

The handoff supplies these detector lines and the resulting `LINK-FAULT-TEST` alert. It does not supply the entire temporary applet configuration. This test policy is separate from the retained GI1-DOWN-ALERT line-protocol policy. [Syslog troubleshooting case](../troubleshooting/incorrect-syslog-pattern.md)

## Asynchronous CLI detector

Original detector:

```cisco
event cli pattern "^show clock$" sync no skip no
```

Revised detector:

```cisco
event cli pattern "^show clock" sync no skip no
```

This mode publishes the event without waiting for policy completion and allows the original command to run. Removing the end anchor repaired matching in the lab and broadened the expression to accept suffixes. The complete asynchronous applet was not supplied. [CLI detector case](../troubleshooting/cli-regex-matching.md)

## Synchronous CLI audit

```cisco
event manager applet CLI-AUDIT
 event cli pattern "^show clock" sync yes
 action 1.0 syslog msg "EEM CLI-AUDIT: Show clock executed"
 action 2.0 set _exit_status 1
```

Synchronous processing waits for the policy. `_exit_status 1` permits the original command to proceed. The syslog message's wording is retained exactly, but that action occurs before command permission; the message alone is not proof that `show clock` completed. The handoff separately reports command execution and successful event history.

The supported `action 2.0 set _exit_status 1` form was accepted without the compatibility warning reported for the earlier `set 2.0 _exit_status 1` form on IOS XE 17.3.2. [CLI verification](../verification/cli-event-interception.md)

[Retained configurations](README.md) · [Troubleshooting](../troubleshooting/README.md) · [Overview](../README.md)
