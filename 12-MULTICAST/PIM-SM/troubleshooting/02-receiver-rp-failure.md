# Case 02 — Receiver membership without an upstream tree

The receiver successfully joined a group, but its local router could not build the branch toward the RP. Restoring that router's RP mapping repaired the tree. The case separates a working local membership mechanism from an established multicast delivery path.

## Fault and symptom

The static RP mapping was removed from **R4-LHR**, then MCAST-RECEIVER joined the fresh group `239.2.2.2`. Using a new group made the test easier to distinguish from the existing baseline.

R4 learned the membership from `10.4.4.10`. Its multicast entry nevertheless showed **RP 0.0.0.0 and incoming interface Null**, while R2-RP had no entry for the group.

## Diagnosis and repair

| Check | Observation | Evidence |
|---|---|---|
| RP mapping on R4 | Empty table | [Block 01](../verification/03-receiver-rp-failure.md#block-01) |
| Local receiver interest | 239.2.2.2 present on Gi0/0 | [Block 02](../verification/03-receiver-rp-failure.md#block-02) |
| R4 tree state | Local outgoing branch exists, but RP and upstream direction are missing | [Block 03](../verification/03-receiver-rp-failure.md#block-03) |
| RP tree state | Group not found | [Block 04](../verification/03-receiver-rp-failure.md#block-04) |

The targeted repair on R4 was:

```cisco
ip pim rp-address 2.2.2.2
```

R4 then identified RP `2.2.2.2` and Gi0/1 as its incoming direction. R2 gained `(*,239.2.2.2)` with Gi0/1 toward R4 in its outgoing list. [Recovery on R4](../verification/03-receiver-rp-failure.md#block-05) · [Recovery on R2](../verification/03-receiver-rp-failure.md#block-06)

## What the result establishes

The repair restored the receiver's upstream tree. It did not require changing the endpoint's membership setting. No source-to-group ping was captured for `239.2.2.2`, so this case claims tree recovery rather than verified end-to-end delivery.

The two Null incoming-interface results illustrate why context matters: on R4 with an unknown RP, Null exposed the missing upstream direction; on R2, which is the RP, Null was part of the healthy shared-tree state.

[Reproduce the changes](../configs/exercise-commands.md#case-02--remove-the-receiver-side-rp-mapping) · [Back to cases](README.md)

