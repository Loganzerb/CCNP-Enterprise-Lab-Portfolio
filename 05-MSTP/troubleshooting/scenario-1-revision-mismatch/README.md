# Case 01 — Matching mappings, different regions

MST3 retained the expected name and VLAN mapping but used a different revision number. Its neighbors were therefore treated as external to its region.

## Change and symptom

The documented change was revision **1 → 2** on MST3-ACCESS-B. The [retained capture](../../verification/region-mismatch/revision-mismatch.txt) shows:

- Name `CCNP_MST`, revision `2`, and the original mapping digest.
- All three links toward the main region marked `Bound(RSTP)`.
- MST3 as Regional Root and as the local root for instances 1 and 2.
- Gi0/2 as Root in MST0 and Master in instances 1 and 2.

## Diagnosis

The matching digest confirmed the mapping fingerprint, not the complete region identity. Revision was the distinguishing field. Comparing the [baseline definition](../../verification/region/main-region-configuration-and-digest.txt) with the failure capture isolates that difference.

## Correction and evidence status

The documented correction restores revision 1 on MST3. Its [saved configuration](../../configs/MST3-ACCESS-B.cfg) contains that restored value.

For a replay, verify the revision and then confirm that the internal neighbor links no longer appear as boundaries. The original notes describe that recovery, but no post-repair interface transcript is retained here.

**Takeaway:** verify every region-identity field before treating a matching digest as proof of membership.

[All cases](../README.md) · [Mismatch comparison](../../verification/region-mismatch/README.md)
