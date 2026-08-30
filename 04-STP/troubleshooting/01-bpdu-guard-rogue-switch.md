# Case 01 — BPDU Guard err-disable from SW5-ROGUE

## Failure injection

A protected PortFast edge interface was connected to SW5-ROGUE, allowing the edge port to receive a spanning-tree BPDU.

## Observed behavior

BPDU Guard treated the BPDU as a violation and placed the interface in the `err-disabled` state. This was a physical-interface protection result, not an STP inconsistency state.

## Diagnosis

```text
show interfaces status err-disabled
show errdisable recovery
show logging
show running-config interface <edge-interface>
```

The saved SW2 and SW3 configurations preserve the intended edge policy:

```cisco
spanning-tree portfast edge
spanning-tree bpduguard enable
```

## Recovery

Remove the switching/BPDU-producing device, correct the cabling or policy, then recover the interface administratively (`shutdown` / `no shutdown`) or through an intentionally configured err-disable recovery policy.

## Lesson

BPDU Guard reacts to any received BPDU on a protected edge port. Unlike Root Guard, it does not wait for a superior BPDU and does not use `root-inconsistent`.
