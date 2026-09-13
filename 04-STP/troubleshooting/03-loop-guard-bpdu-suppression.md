# Case 03 — A Link Is Up but Expected Control Messages Stop

## Why this matters

A physical link can stay up while the control messages used to maintain a safe topology disappear. The switch needs to avoid making an unsafe forwarding decision based on that missing information.

## Documented exercise

The original exercise suppressed BPDU reception on a non-designated port that was expected to keep receiving those messages. Loop Guard placed the affected instance in `loop-inconsistent`.

## Evidence available

This case preserves the original exercise account. No dedicated failure, BPDU-loss timeline, or recovery capture is included. The [final configurations](../configs/README.md) do not retain the temporary Loop Guard interface policy. The [SW3 summary](../verification/convergence/SW3-show-spanning-tree-summary.txt) reports the global Loopguard default as disabled.

## How to investigate

The following explains the diagnostic approach; it is not a retained chronological console session.

| Question | What to inspect |
|---|---|
| Is the physical link actually down? | Compare interface status with the reported STP condition. |
| Which instance lost expected information? | Identify the inconsistent VLAN/port and its prior role. |
| Why are BPDUs missing? | Inspect peer state and the deliberate suppression condition; do not infer a specific physical defect from the condition name alone. |

Reference commands:

```text
show spanning-tree inconsistentports
show spanning-tree detail
show logging
```

Use the actual affected VLAN and interface when replaying the exercise. The command list is guidance, not newly captured output.

## Recovery and verification

The documented recovery method is to restore BPDU delivery and remove the test's suppression condition. Then verify that the affected instance returns to its intended role.

No exact suppression command, elapsed detection time, or recovery transcript is retained. Those details would require fresh capture during a replay.

## Engineering takeaway

Physical connectivity and control-message health are separate checks. A protective inconsistent state explains why a link can be up without being allowed to forward.

[Case index](README.md) · [Verification guide](../verification/README.md) · [Module overview](../README.md)
