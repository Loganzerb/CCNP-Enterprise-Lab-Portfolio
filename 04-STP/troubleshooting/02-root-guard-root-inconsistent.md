# Case 02 — Prevent an unexpected root takeover

## Why this matters

The design assigns preferred roots to distribution switches. A new switch advertising more-preferred root information can change that design unless the attachment policy prevents it.

## Documented exercise

The original notes describe SW5 advertising a superior bridge ID toward a guarded port. The port entered `root-inconsistent`, keeping the unwanted root direction out of forwarding for the affected spanning-tree instance.

## Evidence available

The [saved root priorities](../configs/README.md) establish the intended SW1/SW4 roles. This case retains the exercise account but no failure table or recovery capture. The final configuration files do not preserve the temporary Root Guard interface setting or identify the exact test port.

## How to investigate

The following explains the diagnostic approach; it is not a retained chronological console session.

| Question | What to inspect |
|---|---|
| Did the preferred root direction change? | Compare the claimed root information with the intended design. |
| Is protection blocking the instance? | Inspect inconsistent-port output and the relevant VLAN state. |
| Which attachment supplied the information? | Check the affected interface, its guard policy, the peer, and logs. |

Reference commands:

```text
show spanning-tree inconsistentports
show spanning-tree vlan 10
show logging
```

For a replay, use the affected VLAN and interface. These are suggested checks.

## Recovery and verification

The original notes describe clearing the condition by stopping the superior BPDU source, either by restoring the test switch's priority or removing the test connection. Verify that the intended root and normal port roles return after the condition clears.

The mechanism is documented, but exact priority changes, port identity, and before/after output are absent. A successful recovery is not independently demonstrated by the retained files.

## Engineering takeaway

A protected topology change and a physically failed link require different responses. Restore the intended root relationship rather than treating every blocked state as a cabling problem.

[Case index](README.md) · [Verification guide](../verification/README.md) · [Module overview](../README.md)
