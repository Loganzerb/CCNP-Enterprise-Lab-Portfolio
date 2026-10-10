# Manual EEM execution

MANUAL-DIAG gives an administrator a repeatable interface check without waiting for an automatic event. Its `event none` detector requires an explicit invocation.

**Quick navigation:** [Recorded result](#recorded-result) · [Supplied command](#supplied-command) · [Interpret the actions](#interpret-the-actions) · [Evidence scope](#evidence-scope)

## Recorded result

The handoff reports that MANUAL-DIAG displayed the `show ip interface brief` results through `action puts` and generated a completion syslog at **23:02:54.091 UTC** on October 9, 2026.

## Supplied command

### Block 06

**Supplied invocation command.**

```cisco
event manager run MANUAL-DIAG
```

## Interpret the actions

The supplied policy enters privileged CLI, runs the interface-summary command, displays `$_cli_result`, and logs `EEM MANUAL-DIAG: Diagnostic completed`. The displayed command result and completion message serve different purposes: one exposes interface state; the other marks the end of the procedure.

MANUAL-DIAG is one of the two applets retained in the final saved configuration. The [configuration guide](../configs/README.md) covers the saved policies.

## Evidence scope

The invocation is supplied, but the interface-summary output and completion syslog line are not. Their successful appearance and completion time are reported handoff observations; no reconstructed output is presented here.

[Verification index](README.md) · [EEM overview](../README.md)
