# CLI event detection and synchronous interception

The CLI exercise first repaired a detector that did not match `show clock`, then compared asynchronous execution with synchronous interception that permitted the original command.

**Quick navigation:** [Recorded results](#recorded-results) · [Asynchronous detector](#asynchronous-detector) · [Synchronous interception](#synchronous-interception) · [Evidence scope](#evidence-scope)

## Recorded results

| Stage | Result reported in the handoff |
|---|---|
| Asynchronous detector after pattern repair | Successful execution at **23:39:04.308 UTC** |
| Synchronous CLI-AUDIT | Successful execution at **23:47:42.086 UTC**; original command executed, a syslog appeared, and event history recorded success |

Both execution times belong to the October 9, 2026 lab. The temporary CLI audit applet was removed after testing.

## Asynchronous detector

### Block 09

**Supplied original detector configuration.**

```cisco
event cli pattern "^show clock$" sync no skip no
```

### Block 10

**Supplied debug excerpt during the matching failure.**

```text
check_eem_cli_policy_handler: command_string=show clock
check_eem_cli_policy_handler: num_matches = 0, response_code = 1
```

### Block 11

**Supplied corrected asynchronous detector configuration.**

```cisco
event cli pattern "^show clock" sync no skip no
```

Removing `$` repaired the observed matching failure. The corrected expression matches a prefix and can also match suffix text after `show clock`. The supplied debug establishes zero matches for the displayed command string; it does not establish the underlying reason the anchored expression failed.

## Synchronous interception

### Block 12

**Supplied temporary synchronous policy.**

```cisco
event manager applet CLI-AUDIT
 event cli pattern "^show clock" sync yes
 action 1.0 syslog msg "EEM CLI-AUDIT: Show clock executed"
 action 2.0 set _exit_status 1
```

`sync yes` makes the policy participate in processing the intercepted command. Setting `_exit_status` to `1` permits the original command; the handoff reports that it executed successfully. This exercise records the permitted-command path, without an intentional command-blocking test.

The configured `Show clock executed` message is a policy action before the original command is permitted to continue. Its wording alone does not establish completion; the command's success is a separate reported observation.

The handoff also reports a hidden-command compatibility warning for the earlier `set 2.0 _exit_status 1` form on IOS XE 17.3.2. The `action 2.0 set _exit_status 1` form was accepted without that warning; no warning transcript is supplied.

## Evidence scope

Configuration and two debug lines are supplied excerpts. The successful asynchronous and synchronous executions, their syslog appearance, and the successful event-history entry are reported observations without the corresponding output records. CLI-AUDIT was temporary and is not a final saved applet.

[Read the regex case](../troubleshooting/cli-regex-matching.md) · [Verification index](README.md) · [EEM overview](../README.md)
