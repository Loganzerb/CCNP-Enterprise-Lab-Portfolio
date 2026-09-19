# Case 05 — One side expects a trunk, the other an access port

## Why this matters

An access link serves one VLAN; a trunk carries multiple VLANs. A switch-to-switch connection needs a consistent intended role at both ends.

## Documented exercise

The original notes describe configuring one end as a trunk while the other behaved as an access port. STP reported a Port Type Inconsistent condition.

## Evidence available

The exercise account is retained, but its exact peer/interface pair, mismatched operating modes, failure table, and recovery transcript are absent. The [configuration guide](../configs/README.md) explains the saved trunk and endpoint roles.

## How to investigate

The following explains the diagnostic approach; it is not a retained chronological console session.

| Question | What to inspect |
|---|---|
| What mode is each interface actually using? | Compare switchport operational mode on both ends, alongside the configured mode. |
| Does the intended connection carry one VLAN or several? | Use the topology and design to choose the correct role. |
| Which STP state reflects the disagreement? | Correlate inconsistent-port output and logs with those interfaces. |

Reference commands:

```text
show interfaces trunk
show interfaces switchport
show spanning-tree inconsistentports
show logging
```

For a replay, use the affected VLAN and interface. These are suggested checks.

## Recovery and verification

The documented method is to restore a consistent intended role: matching infrastructure trunks or an intentional same-VLAN access connection. For this lab's infrastructure, use the saved trunk design as the reference.

The saved access-VLAN line alone does not prove access-port operation: SW4 Gi0/2 and SW5 Gi0/0 retain such a line alongside explicit trunk mode. A replay needs operational before/after checks on the actual affected interfaces.

## Engineering takeaway

Read the operating mode and the complete interface configuration. An isolated line can suggest a different role from the one the interface is actually configured to use.

[Case index](README.md) · [Verification guide](../verification/README.md) · [Module overview](../README.md)
