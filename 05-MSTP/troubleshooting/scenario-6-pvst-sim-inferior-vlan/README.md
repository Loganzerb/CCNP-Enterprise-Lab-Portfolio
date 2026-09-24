# Case 06 — Inconsistent root information blocks the boundary

The MST region relied on an external spanning-tree root, but VLAN 10 supplied conflicting information. MST4 blocked its boundary root port. After the documented correction, the switch logged that the inconsistency had cleared and reported zero inconsistent entries.

## Establish the symptom

MST5 was running Rapid PVST+, and the external domain supplied the CIST root through VLAN 1. The retained failure log identifies **Gi0/2** and **VLAN 10**, describing an inconsistent inferior BPDU.

A BPDU is the control message switches use to select spanning-tree paths. Here, *inferior* means less preferred in the root comparison.

[Read the original failure-and-recovery excerpt](../../verification/pvst-simulation/inferior-vlan-failure-and-recovery.txt).

## Connect the observations

| Observation | Why it matters |
|---|---|
| `PVSTSIM_FAIL` names the root port and VLAN 10 | Identifies the protection mechanism and the conflicting VLAN |
| Gi0/2 is `Root BKN* ... Bound(PVST) *PVST_Inc` | The selected external root path is blocked by the inconsistency |
| MST0, MST1 and MST2 appear against Gi0/2 | One physical boundary is affected across the three listed instances |

This directs the investigation toward root-information consistency across the MST/Rapid-PVST+ boundary. The output does not justify treating the problem as three separate failed links.

Cisco's PVST Simulation explanation describes the consistency requirement between VLAN 1/CIST and the other external VLANs.

## Correction and captured recovery

The original lab notes describe restoring consistent VLAN 10 root information. The exact repair command was not retained.

The subsequent evidence is explicit:

| Check | Result |
|---|---|
| IOS log | `PVSTSIM_OK`: inconsistency cleared on Gi0/2 |
| Inconsistent-port check | **0** remaining entries |

That establishes recovery from the reported protection condition. It does **not** include a post-repair `Root FWD` table, endpoint ping or application test. The interval between log messages includes the troubleshooting work and is not a convergence-time measurement.

## What to add on a replay

After correcting the root information, capture the expected port roles and an appropriate traffic test. Keep that additional service proof separate from the existing inconsistency-clear evidence.

**Takeaway:** identify why protection blocked the path, correct the conflicting information, and verify both the cleared condition and the service outcome you intend to claim.

[All cases](../README.md) · [Topology stages](../../topology.md)
