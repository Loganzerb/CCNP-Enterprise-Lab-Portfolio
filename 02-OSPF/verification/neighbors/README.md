# OSPF Neighbor Verification

## Command Collected

```cisco
show ip ospf neighbor
```

This command validates neighbor discovery, peer router IDs, adjacency state, dead timers, neighbor addresses, local interfaces, and Designated Router/Backup Designated Router (DR/BDR) roles where elections apply.

## Healthy-State Observations

- Every expected relationship is in a `FULL` state; no neighbor is stuck in an intermediate adjacency state.
- On the `O1-CORE` to `O2-ABR` segment, `O2` is the DR and `O1` is the BDR.
- On the `O2-ABR` to `O4-EDGE` segment, `O4` is the DR and `O2` is the BDR.
- The `O2`–`O3`, `O3`–`O5`, and `O4`–`O5` relationships display `FULL/-`, matching their point-to-point operation.
- The observed topology is complete: `O1` has one neighbor, `O2` has three, and `O3`, `O4`, and `O5` each have two.

Together, the five captures establish the healthy adjacency baseline for the lab.
