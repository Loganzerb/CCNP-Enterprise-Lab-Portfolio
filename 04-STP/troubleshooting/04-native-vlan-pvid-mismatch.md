# Case 04 — The Two Ends of a Trunk Disagree

## Why this matters

A trunk carries several VLANs. Both ends need a consistent interpretation of the native VLAN so that untagged traffic and control information are handled as intended.

## Documented exercise

The original exercise changed the native VLAN on only one side of a trunk. Its notes report a native-VLAN/PVID inconsistency and protective blocking while the physical link remained up.

## Evidence available

The [saved configurations](../configs/README.md) provide the trunk design, and the [SW5 pre-bundle capture](../verification/etherchannel/SW5-before-etherchannel.txt) shows native VLAN 1 on its two trunks at that stage. That capture is not the mismatch event. The exact affected link, changed VLAN IDs, failure log, and recovery output are not retained.

## How to investigate

The following explains the diagnostic approach; it is not a retained chronological console session.

| Question | What to inspect |
|---|---|
| Do both ends use the same native VLAN? | Compare operational trunk output and the corresponding interface settings on both peers. |
| Which VLAN or port is inconsistent? | Use STP detail, inconsistent-port output, and logs to locate the condition. |
| Does the allowed VLAN list also match the design? | Inspect this separately; an allowed-list difference is not automatically a native-VLAN mismatch. |

Reference commands:

```text
show interfaces trunk
show spanning-tree inconsistentports
show logging
```

Use the actual affected VLAN and interface when replaying the exercise. The command list is guidance, not newly captured output.

## Recovery and verification

The documented method is to restore the intended native VLAN consistently on both ends, then confirm that the inconsistency clears and the expected VLANs can forward.

The notes describe the correction, but no dedicated post-fix output or client test is retained. Do not use an unrelated healthy trunk capture as proof of this repair.

## Engineering takeaway

An up cable and an operational trunk are only part of the health check. The configuration agreement between peers determines how the VLANs are handled.

[Case index](README.md) · [Verification guide](../verification/README.md) · [Module overview](../README.md)
