# Case 01 — An Unexpected Switch on an Endpoint Port

## Why this matters

An endpoint-facing port is intended for a client, not for extending the switching topology. This exercise examines the protection response when that assumption is broken.

## Documented exercise

The original notes describe connecting SW5-ROGUE to a protected PortFast edge interface. The port received a BPDU—a switch control message—and entered `err-disabled` state.

## Evidence available

The [SW2](../configs/SW2-ACCESS-A.cfg) and [SW3](../configs/SW3-ACCESS-B.cfg) configurations preserve PortFast edge and BPDU Guard on Gi0/3. They establish the intended client-port policy. The notes do not identify which protected interface was used for the fault, and no exact activation log or recovery transcript is retained.

## How to investigate

The following explains the diagnostic approach; it is not a retained chronological console session.

| Question | What to inspect |
|---|---|
| What disabled the port? | Inspect interface err-disable status and logs for the reported reason; a down port alone does not establish BPDU Guard. |
| Was this supposed to be a client port? | Compare the actual attachment with its access-port, PortFast, and BPDU Guard settings. |
| What introduced the BPDU? | Check the attached device and cabling before changing the protection policy. |

Reference commands:

```text
show interfaces status err-disabled
show errdisable recovery
show logging
```

Use the actual affected VLAN and interface when replaying the exercise. The command list is guidance, not newly captured output.

## Recovery and verification

The documented method is to remove the unintended switch connection or correct the design, then recover the affected interface administratively or through an intentionally configured recovery policy. Restoring the port before removing the triggering condition may leave the problem unresolved.

A replay should retain the original trigger, the named interface's recovery, and client forwarding checks. The existing files support the policy and documented exercise, not a measured service outage or captured successful repair.

## Engineering takeaway

Identify the reason for a protective shutdown before resetting the interface. Here the intended question is whether a client-facing port received switch control traffic.

[Case index](README.md) · [Verification guide](../verification/README.md) · [Module overview](../README.md)
