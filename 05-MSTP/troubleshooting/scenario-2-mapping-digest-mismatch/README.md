# Case 02 — A VLAN moves into the wrong instance

Moving VLAN 20 changed how MST3 grouped its VLANs and made its region definition differ from the other switches.

## Change and evidence

| Mapping | Intended | During the fault |
|---|---|---|
| Instance 1 | 10,20 | 10 |
| Instance 2 | 30,40 | 20,30,40 |

The [combined mismatch file](../../verification/region-mismatch/mapping-and-name-mismatch.txt) records a changed digest, `0x181335FABF16F125760ABD9E58549D1A`, while name and revision remain `CCNP_MST` and `1`.

The mapping and boundary behavior in this part of the file are an observed-state summary. They should not be mistaken for a complete raw interface transcript.

## Diagnosis and correction

The digest directs attention to the mapping. The exact VLAN assignment identifies the mistake: VLAN 20 belongs with VLAN 10 in instance 1.

Restore instance 1 to VLANs 10/20 and instance 2 to VLANs 30/40. The [saved MST3 configuration](../../configs/MST3-ACCESS-B.cfg) contains those mappings.

In a replay, check the complete mapping, the original digest and normal internal port roles. The archive does not retain a separate post-repair capture for this test.

**Takeaway:** a fingerprint can reveal a mismatch; the readable configuration identifies what to correct.

[All cases](../README.md) · [Baseline region](../../verification/region/README.md)
