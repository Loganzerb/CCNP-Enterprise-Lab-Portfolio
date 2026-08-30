# Region mismatch evidence

Three independent region-identity faults were tested on MST3-ACCESS-B:

1. **Revision 2:** name and digest still matched, but the switch became a one-switch region and links showed `Bound(RSTP)`.
2. **Mapping mismatch:** VLAN 20 moved from MSTI 1 to MSTI 2; digest changed to `0x181335FABF16F125760ABD9E58549D1A` and the region split.
3. **Name `WRONG_REGION`:** revision and digest were unchanged, but the region still split.

This proves that region membership requires all three elements: name, revision, and VLAN-to-instance mapping.
