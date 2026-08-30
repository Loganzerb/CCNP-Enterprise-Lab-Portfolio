# Scenario 6 — Inferior Rapid-PVST+ VLAN

## Fault injected

The Rapid-PVST+ domain contained the external CIST root through VLAN 1, but VLAN 10 advertised inferior root information.

## Observation and diagnosis

IOS logged `%SPANTREE-2-PVSTSIM_FAIL: Blocking root port Gi0/2: Inconsistent inferior PVST BPDU received on VLAN 10...`. The MST0 root port changed to `Root BKN* ... *PVST_Inc`, and all three instances appeared in `show spanning-tree inconsistentports`.

This is the opposite consistency direction from Scenario 5: the external PVST domain is the CIST path, so VLANs 2-and-above must not be inferior to the VLAN 1/CIST root information.

## Fix and validation

Restore consistent VLAN 10 root information. IOS logged `%SPANTREE-2-PVSTSIM_OK`, and the inconsistent-port count returned to zero.

Evidence: [inferior-VLAN failure and recovery](../../verification/pvst-simulation/inferior-vlan-failure-and-recovery.txt).
