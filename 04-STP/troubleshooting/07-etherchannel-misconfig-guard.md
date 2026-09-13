# Case 07 — The Peers Disagree About the Logical Bundle

## Why this matters

A static bundle assumes its member links connect to a compatible logical relationship at the far end. Incorrect wiring or grouping can create an unsafe topology.

## Documented exercise

The original notes describe a static-bundle mismatch between the local grouping and remote relationship. EtherChannel misconfiguration guard detected inconsistent control traffic and err-disabled the affected links.

## Evidence available

The [SW3 summary](../verification/convergence/SW3-show-spanning-tree-summary.txt) explicitly reports EtherChannel misconfig guard enabled. That establishes feature status, not activation. The exact failure logs, partner mapping, affected interfaces, and post-repair output are not retained.

## How to investigate

The following explains the diagnostic approach; it is not a retained chronological console session.

| Question | What to inspect |
|---|---|
| Which feature disabled the interfaces? | Read err-disable status and logs for the actual reason. |
| Do the physical links have the intended partners? | Compare wiring and member assignments at both ends. |
| Do both switches agree on the logical bundle? | Inspect channel configuration and operational membership together. |

Reference commands:

```text
show interfaces status err-disabled
show etherchannel summary
show logging
```

Use the actual affected VLAN and interface when replaying the exercise. The command list is guidance, not newly captured output.

## Recovery and verification

The documented method is to correct wiring or channel configuration before recovering the interfaces, then verify membership against the intended partner.

This case has configuration/status context and an exercise account, not a complete captured incident. The enabled guard field does not demonstrate that it fired during the shown summary.

## Engineering takeaway

A protective interface shutdown can indicate an unsafe topology relationship. Correct the relationship before restoring the affected links.

[Case index](README.md) · [Verification guide](../verification/README.md) · [Module overview](../README.md)
