# Case 05 — An external VLAN claim blocks a designated boundary

The CIST root was inside the MST region, but the Rapid PVST+ side advertised a superior root for VLAN 10. The inconsistency caused protection to block the boundary.

## Follow the evidence

The [failure capture](../../verification/pvst-simulation/superior-vlan-failure.txt) shows MST4 Gi0/2 as:

```text
Desg BKN* ... Bound(PVST) *PVST_Inc
```

The inconsistent-port output lists MST0, MST1 and MST2 against **that same interface**. The original excerpt identifies the CIST root as remaining inside MST while the external VLAN became superior.

## Diagnosis and correction

This is a PVST Simulation consistency failure at a designated boundary. The required correction is to remove the conflicting external VLAN 10 root preference and restore a consistent root design.

The original notes report that the inconsistency cleared after correction. The retained text file contains only the failed state; it does not include the correction command, a clear log or a subsequent forwarding table.

For a replay, confirm zero inconsistent entries and the expected Gi0/2 role after correcting the external root information. Add a traffic check if claiming service recovery.

**Takeaway:** classify which side owns the CIST root before interpreting a boundary inconsistency. The [next case](../scenario-6-pvst-sim-inferior-vlan/README.md) demonstrates the opposite direction and includes captured clearing evidence.

[All cases](../README.md) · [PVST evidence comparison](../../verification/pvst-simulation/README.md)
