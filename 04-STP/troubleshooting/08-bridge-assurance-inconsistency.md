# Case 08 — Bridge Assurance inconsistency

## Baseline

SW3 Gi0/1 and SW4 Gi0/1 were made point-to-point STP network ports on both ends. The final CML configuration preserves `spanning-tree portfast network` on this link.

## Failure injection

Continuous BPDU participation was broken on one side while the infrastructure link remained operational.

## Observed behavior

The protected peer placed the link/instances into Bridge Assurance inconsistency (`*BA_Inc`) instead of allowing a silent STP participant to forward.

## Diagnosis

```text
show spanning-tree interface gigabitEthernet 0/1 detail
show spanning-tree inconsistentports
show spanning-tree summary
show logging
```

See the exact [pre-network-port interface detail](../verification/bridge-assurance/SW3-Gi0-1-detail-before-network-port.txt), which shows the point-to-point link and per-VLAN BPDU counters before the network-port relationship was enabled.

## Recovery

Restore network-port configuration and bidirectional BPDU exchange on both ends. Verify the `*BA_Inc` marker clears and normal per-VLAN roles return.

## Lesson

“Bridge Assurance is enabled” in the global summary does not prove an arbitrary trunk is protected. Both ends must operate as compatible STP network ports.
