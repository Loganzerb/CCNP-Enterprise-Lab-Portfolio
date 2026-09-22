# Case 01 — A unicast route moves the multicast tree

Changing one route on the receiver-side router moved the multicast source tree from R3 to R2. Removing that route restored the original branch. This shows why multicast diagnosis must include the underlying routing decision.

## Starting point and change

For source `10.1.1.10` and group `239.1.1.1`, R4's source lookup used Gi0/2 through R3. Its RP lookup used Gi0/1 through R2. A temporary static route on R4 made the source LAN prefer R2:

```cisco
ip route 10.1.1.0 255.255.255.0 10.24.0.1
```

## Follow the evidence

| Stage | Observation | Evidence |
|---|---|---|
| Baseline | R4's source entry uses Gi0/2; its group entry uses Gi0/1 | [Baseline Block 12](../verification/01-baseline.md#block-12) |
| Changed lookup | Source RPF switches to Gi0/1 through 10.24.0.1 using static routing | [Block 01](../verification/02-rpf-path-change.md#block-01) |
| Changed tree | R4's source entry also uses Gi0/1; R2 forwards it toward R4 | [Block 02](../verification/02-rpf-path-change.md#block-02), [Block 03](../verification/02-rpf-path-change.md#block-03) |
| Old branch removed | R3 reports the group not found | [Block 04](../verification/02-rpf-path-change.md#block-04) |
| Rollback | R4 and R3 return to the original source path; R2's source branch is pruned | [Block 05](../verification/02-rpf-path-change.md#block-05), [Block 06](../verification/02-rpf-path-change.md#block-06), [Block 07](../verification/02-rpf-path-change.md#block-07) |

## Interpretation

The multicast tree followed the changed source RPF decision. During the altered state, both `(*,G)` and `(S,G)` used R4's Gi0/1, but the source entry retained `JT` flags. A source-specific tree can pass through the router that is also the RP; this capture does not show a return to shared-tree-only forwarding.

## Restoration and scope

The temporary route was removed with `no ip route 10.1.1.0 255.255.255.0 10.24.0.1`. R4's source RPF returned to OSPF through R3, R3 regained the source entry and R2's source outgoing list returned to Null.

The evidence verifies tree migration and rollback. No traffic-loss measurement, RPF-drop counter or convergence timing was retained for this exercise.

[Reproduce the changes](../configs/exercise-commands.md#case-01--change-the-source-rpf-path) · [Back to cases](README.md)

