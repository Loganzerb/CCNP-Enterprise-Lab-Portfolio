# Boundary and Master roles: the path to an external root

In this earlier experiment, the overall spanning-tree root was outside the main region. MST4 became the main region's connection toward that root.

[Open the original external-CIST-root capture](external-cist-root.txt).

| Field on MST4 | Recorded result | Interpretation |
|---|---|---|
| MST0 Root | External address `5254.0012.fa9f`, priority 16384 | The overall root is outside this switch's region |
| Regional Root | `this switch` | MST4 is the main region's selected bridge toward that root |
| Gi0/2 in MST0 | `Root FWD ... Bound(RSTP)` | The external root path |
| Gi0/2 in MSTI 1 and 2 | `Mstr FWD ... Bound(RSTP)` | That external connection represented in each instance |

MST4 can be the Regional Root while MST1 remains the internal instance 1 root. These roles answer different questions.

This capture belongs to MST5's separate-MST-region stage. The [saved MST5 configuration](../../configs/MST5-BOUNDARY.cfg) instead runs Rapid PVST+. The original notes also describe a link shutdown and restoration, but that transition is not present in this file.

[Case 04](../../troubleshooting/scenario-4-external-cist-root-boundary/README.md) · [Evidence index](../README.md)
