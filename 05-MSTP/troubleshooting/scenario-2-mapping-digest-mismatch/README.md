# Scenario 2 — Mapping and digest mismatch

## Fault injected

On MST3-ACCESS-B, VLAN 20 was removed from MSTI 1 and placed into MSTI 2. Its effective mapping became MSTI 1 → VLAN 10 and MSTI 2 → VLANs 20,30,40.

## Observation and diagnosis

The digest changed from `0xCA136A...` to `0x181335...`, and interfaces facing the main region showed `Bound(RSTP)`. Unlike a path-cost or bridge-priority change, a mapping change changes region identity.

Use `show spanning-tree mst configuration` to locate the exact mapping difference after the digest warns that one exists.

## Fix and validation

Restore MSTI 1 → VLANs 10,20 and MSTI 2 → VLANs 30,40. Verify the original digest and disappearance of boundary roles.

Evidence: [mapping and name mismatch captures](../../verification/region-mismatch/mapping-and-name-mismatch.txt).
