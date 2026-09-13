# Case 06 — A Bundle Member Has Different VLAN Settings

## Why this matters

Links grouped into one logical bundle need compatible forwarding settings. A mismatched member can be withheld from the bundle rather than forwarding with a different VLAN policy.

## Documented exercise

The original notes describe changing a member's allowed VLAN mask so it disagreed with the other member or logical port-channel. IOS suspended the inconsistent member.

## Evidence available

The [LACP baseline](../verification/etherchannel/SW5-healthy-lacp-summary.txt) shows two healthy members in a separate capture. This case has no dedicated VLAN-mask failure or recovery output. The suspended members in [Case 11](11-lacp-negotiation-and-member-failure.md) belong to a different negotiation exercise and are not evidence of this VLAN-mask fault.

## How to investigate

The following explains the diagnostic approach; it is not a retained chronological console session.

| Question | What to inspect |
|---|---|
| Which member is missing from the bundle? | Inspect each member flag, rather than only the port-channel status. |
| What incompatibility does IOS report? | Use logs to distinguish VLAN inconsistency from negotiation or physical failure. |
| Which settings differ? | Compare the affected member, its peer member, and logical port-channel for allowed VLANs, native VLAN, and mode. |

Reference commands:

```text
show etherchannel summary
show interfaces trunk
show interfaces switchport
show logging
```

Use the actual affected VLAN and interface when replaying the exercise. The command list is guidance, not newly captured output.

## Recovery and verification

The documented method is to restore compatible trunk settings according to the intended bundle design, then check that the member returns to (P).

The notes do not retain the exact removed VLAN, faulted member, repair command sequence, or client result. Those cannot be borrowed from the separate EtherChannel module as if they occurred in this STP experiment.

## Engineering takeaway

The same suspended flag can arise for different reasons. The member configuration and error message are needed to identify the cause.

[Case index](README.md) · [Verification guide](../verification/README.md) · [Module overview](../README.md)
