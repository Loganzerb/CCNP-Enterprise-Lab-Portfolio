# Scenario 3 — Region-name mismatch

## Fault injected

MST3-ACCESS-B was renamed from `CCNP_MST` to `WRONG_REGION`, while revision 1 and the correct mappings remained in place.

## Observation and diagnosis

The digest stayed `0xCA136A...`, yet MST3 again formed a separate region and showed `Bound(RSTP)`. This isolates the name as a region-membership requirement independent of the mapping digest.

## Fix and validation

Restore the exact case-sensitive region name `CCNP_MST`, then confirm name, revision, digest, and internal port roles.

Evidence: [mapping and name mismatch captures](../../verification/region-mismatch/mapping-and-name-mismatch.txt).
