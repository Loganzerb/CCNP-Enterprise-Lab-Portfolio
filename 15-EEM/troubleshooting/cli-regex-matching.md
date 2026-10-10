# Case 02 — A CLI detector records zero matches

The registered asynchronous detector reportedly missed `show clock`. The supplied debug showed the command string and zero matches. Removing the end-of-line anchor repaired the observed behavior, while the underlying reason for the original failure remained unproven.

**Quick navigation:** [Investigate the symptom](#investigate-the-symptom) · [Repair and result](#repair-and-result) · [Synchronous follow-up](#synchronous-follow-up) · [Evidence scope](#evidence-scope)

## Investigate the symptom

The original detector used `^show clock$` with `sync no skip no`. Debug displayed `command_string=show clock` followed by `num_matches = 0, response_code = 1`.

[Original detector — Block 09](../verification/cli-event-interception.md#block-09) · [Failure debug — Block 10](../verification/cli-event-interception.md#block-10)

These lines establish the observed matching failure. They do not explain why that expression failed to match.

## Repair and result

The expression changed to `^show clock`, retaining `sync no skip no`. The handoff reports successful asynchronous execution at **23:39:04.308 UTC** on October 9, 2026. [Corrected detector — Block 11](../verification/cli-event-interception.md#block-11)

The change removes the end anchor while preserving the beginning anchor. The resulting prefix match can also match suffix text after `show clock`. The result supports that correction in this exercise; it does not establish a general platform rule or a hidden-character cause.

## Synchronous follow-up

CLI-AUDIT was then tested with `sync yes` and `action 2.0 set _exit_status 1`, which permits the original command. The handoff reports successful execution at **23:47:42.086 UTC**, the command's execution, an EEM syslog, and a successful event-history entry. [Temporary policy — Block 12](../verification/cli-event-interception.md#block-12)

The policy's `Show clock executed` syslog action precedes the original command's continuation. The command's success is reported separately; the configured message alone does not prove it completed.

An earlier `set 2.0 _exit_status 1` form reportedly produced a compatibility warning; the action form was accepted without it. The warning and event-history output were not supplied. An intentional command-blocking test is not recorded.

## Evidence scope

The detector configurations and two failure-debug lines are supplied. Successful execution times and the synchronous results are reported observations, without their complete output transcripts. The temporary CLI audit policy was removed afterward.

**Takeaway:** verify the match and resulting command behavior independently, and keep an observed repair separate from an unproven failure mechanism.

[Case index](README.md) · [Verification index](../verification/README.md) · [EEM overview](../README.md)
