# Scenario 5 — Superior Rapid-PVST+ VLAN

## Fault injected

MST5 was running Rapid PVST+. While the CIST root was inside the MST region, VLAN 10 on the Rapid-PVST+ side was made superior to the MST CIST information.

## Observation and diagnosis

MST4 `Gi0/2` was a designated `Bound(PVST)` boundary but changed to `Desg BKN* ... *PVST_Inc`. `show spanning-tree inconsistentports` reported MST0, MST1, and MST2 as `PVST Sim. Inconsistent`.

The physical link was still up; PVST Simulation logically blocked it because a VLAN 2-and-above root claim contradicted the CIST assumptions represented through VLAN 1.

## Fix and validation

Remove the superior VLAN 10 root condition. IOS clears the inconsistency automatically; verify zero inconsistent ports and `Desg FWD ... Bound(PVST)`.

Evidence: [superior-VLAN failure](../../verification/pvst-simulation/superior-vlan-failure.txt).
