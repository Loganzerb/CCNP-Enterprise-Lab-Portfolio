# Troubleshooting casebook

Each case follows the operational sequence used in the lab: establish a baseline, inject one failure, identify the control-plane symptom, isolate the cause, remove the fault, and verify recovery.

| Case | Scenario | Primary proof command |
|---:|---|---|
| 01 | BPDU Guard err-disable from rogue switch | `show interfaces status err-disabled` |
| 02 | Root Guard root-inconsistent | `show spanning-tree inconsistentports` |
| 03 | Loop Guard loop-inconsistent | `show spanning-tree inconsistentports` |
| 04 | Native VLAN / PVID mismatch | `show spanning-tree detail` |
| 05 | Trunk/access Port Type Inconsistent | `show spanning-tree inconsistentports` |
| 06 | EtherChannel VLAN-mask suspension | `show etherchannel summary` |
| 07 | EtherChannel misconfiguration guard | `show interfaces status err-disabled` |
| 08 | Bridge Assurance inconsistency | `show spanning-tree detail` |
| 09 | Classic STP convergence and timers | `show spanning-tree vlan <id>` |
| 10 | Path-cost and port-priority engineering | `show spanning-tree interface <if> detail` |
| 11 | LACP passive/passive and member failure | `show etherchannel summary` |

Supporting `.txt` evidence is linked where a complete or representative exact capture survived. Cases without a retained transcript document only the observed state and diagnosis.
