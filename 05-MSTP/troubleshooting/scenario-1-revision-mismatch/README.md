# Scenario 1 — Revision mismatch

## Fault injected

MST3-ACCESS-B kept region name `CCNP_MST` and the original VLAN mapping, but its revision was changed from 1 to 2.

## Observation and diagnosis

The digest remained `0xCA136A235706B316C8DB8F921067A68F`, proving that the digest alone does not encode the revision. MST3 behaved as a one-switch region: links toward MST1, MST2, and MST4 displayed `Bound(RSTP)`, MST3 identified itself as Regional Root, and its best external link was Root for MST0 and Master for MSTIs.

Compare name, revision, mapping, and digest on both ends; matching mappings do not override a revision mismatch.

## Fix and validation

Restore revision 1 on MST3. After reconvergence, boundary labels clear and normal internal roles return without a reboot.

Evidence: [captured revision mismatch](../../verification/region-mismatch/revision-mismatch.txt).
