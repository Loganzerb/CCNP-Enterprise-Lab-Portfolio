# Case 03 — The correct mapping under the wrong region name

A region-name change separated MST3 from its intended neighbors even though the revision and mapping digest still matched.

## Symptom and diagnosis

The [captured name-mismatch output](../../verification/region-mismatch/mapping-and-name-mismatch.txt) shows `WRONG_REGION`, revision 1 and the baseline digest. MST0 then shows MST3 as Regional Root, with boundary classifications on Gi0/0, Gi0/1 and Gi0/2.

The name is the distinguishing field. This test complements Case 01: neither matching revision nor matching digest can override a different region name.

## Correction and evidence status

Restore the exact intended name, `CCNP_MST`, on MST3. The [saved device file](../../configs/MST3-ACCESS-B.cfg) contains that name, revision 1 and the original mappings.

The lab notes describe restoration. A post-repair port-state transcript is not retained, so a replay should verify both the definition and disappearance of the unintended boundary labels.

**Takeaway:** compare the complete region definition on both ends of the link; do not infer membership from matching VLAN lists alone.

[All cases](../README.md) · [Three-way mismatch comparison](../../verification/region-mismatch/README.md)
