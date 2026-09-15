# PVST Simulation: a protection state at the boundary

When the MST region meets Rapid PVST+, inconsistent root information can cause the boundary to block. These two captures show different starting conditions and different amounts of recovery evidence.

| Test | Starting condition | Captured blocked role | Recovery evidence |
|---|---|---|---|
| [Superior VLAN 10](superior-vlan-failure.txt) | CIST root inside MST; external VLAN 10 claims a better root | Gi0/2 `Desg BKN*`, `Bound(PVST)`, `PVST_Inc` | Failure capture only |
| [Inferior VLAN 10](inferior-vlan-failure-and-recovery.txt) | CIST root reached through the external domain; VLAN 10 supplies worse information | Gi0/2 `Root BKN*`, `Bound(PVST)`, `PVST_Inc` | FAIL and OK logs; inconsistent-entry count returns to 0 |

**Read the count correctly:** the failure output lists MST0, MST1 and MST2 against the same physical interface, Gi0/2. The displayed total of three is not evidence of three failed physical links.

Cisco documents these as boundary consistency checks involving the VLAN 1/CIST information and other PVST VLANs. [Cisco PVST Simulation reference](https://www.cisco.com/c/en/us/support/docs/lan-switching/multiple-instance-stp-mistp-8021s/116464-configure-pvst-00.html).

The original notes describe correcting both conditions. Only the inferior-VLAN file contains a clear message and a zero-inconsistency check. Neither file retains endpoint tests, and the cleared condition in Case 06 should not be presented as measured application recovery.

[Case 05](../../troubleshooting/scenario-5-pvst-sim-superior-vlan/README.md) · [Featured Case 06](../../troubleshooting/scenario-6-pvst-sim-inferior-vlan/README.md) · [Evidence index](../README.md)
