# Region mismatches: one matching field can hide a difference

Three controlled changes on MST3 tested the components of region identity independently. They explain why matching digests do not guarantee that two switches belong to the same region.

| Change on MST3 | Name | Revision | Mapping digest | Available signature |
|---|---|---:|---|---|
| Revision mismatch | CCNP_MST | 2 | Unchanged | Boundary roles and local instance roots |
| VLAN 20 moved to instance 2 | CCNP_MST | 1 | Changed | Explicit mapping summary and reported boundaries |
| Name mismatch | WRONG_REGION | 1 | Unchanged | Boundary roles in the captured MST0 output |

[Revision capture](revision-mismatch.txt) · [Combined mapping/name capture](mapping-and-name-mismatch.txt).

The baseline digest is `0xCA136A235706B316C8DB8F921067A68F`; moving VLAN 20 changes it to `0x181335FABF16F125760ABD9E58549D1A`.

The combined file includes both console excerpts and a concise observed-state summary. In particular, its mapping-case boundary statement is prose, not a full interface table. The name-case boundary roles are shown directly.

The [saved MST3 file](../../configs/MST3-ACCESS-B.cfg) returns to the intended region definition. That establishes saved configuration, not a time-ordered post-repair port-state capture for each exercise.

[Case 01 — Revision](../../troubleshooting/scenario-1-revision-mismatch/README.md) · [Case 02 — Mapping](../../troubleshooting/scenario-2-mapping-digest-mismatch/README.md) · [Case 03 — Name](../../troubleshooting/scenario-3-region-name-mismatch/README.md) · [Evidence index](../README.md)
