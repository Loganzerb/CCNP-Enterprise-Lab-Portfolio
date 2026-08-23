# OSPF Interface Verification

## Command Collected

```cisco
show ip ospf interface brief
```

This command provides a compact interface-level view of the OSPF process ID, area assignment, interface address and mask, cost, network state, and full-neighbor count.

## Healthy-State Observations

- All displayed interfaces run OSPF process `1` with the intended area assignments.
- `O1-CORE` is in Area 0; `O2-ABR` has interfaces in both Area 0 and Area 10; `O3-BRANCH`, `O4-EDGE`, and `O5-TRANSIT` are in Area 10.
- The `O1`–`O2` segment shows `O1` as BDR and `O2` as DR. The `O2`–`O4` segment shows `O2` as BDR and `O4` as DR.
- The `O2`–`O3`, `O3`–`O5`, and `O4`–`O5` links use point-to-point state and each reports one full neighbor.
- `O3-BRANCH` advertises loopbacks `172.20.32.1/24` through `172.20.35.1/24` in Area 10.
- OSPF costs are consistent in the captures: transit links use cost `10`, while loopbacks use cost `1`.

The output aligns interface participation with the neighbor evidence and confirms the intended ABR boundary.
