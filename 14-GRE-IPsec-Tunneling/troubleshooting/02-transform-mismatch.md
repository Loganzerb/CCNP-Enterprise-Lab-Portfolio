# Case 02 — IKE remains healthy while ESP cannot negotiate

## Symptom and controlled change

R3's ESP encryption changed to AES-128 while R1 retained AES-256. The already-negotiated SA initially continued operating. Clearing IPsec SAs while retaining IKE exposed the proposal disagreement.

## Investigation

1. Separate Phase 1 from Phase 2. IKE stayed QM_IDLE/ACTIVE with connection ID 1010.
2. Inspect the current ESP state. R1's outbound SPI and counters were zero; send errors were four.
3. Correlate routing loss. OSPF moved from FULL to DOWN when the dead timer expired.
4. Compare the configured ESP transforms. The controlled AES-128/AES-256 difference prevented a compatible new ESP SA.

[Failure evidence: Blocks 12–14](../verification/05-transform.md#block-12--ospf-loses-its-neighbor-when-protected-traffic-stops)

## Root cause and remediation

The data-protection proposals disagreed, while the authenticated IKE SA remained valid. Restoring R3's AES-256 transform reference corrected the Phase 2 dependency.

## Post-fix validation

The first post-repair sample still showed SPI zero and 13 send errors. Later, outbound SPI 0x448ABAA8 appeared, counters reached 85 encrypted / 85 decrypted, and errors were zero. The recovery log recorded LOADING to FULL, confirmed by the neighbor table.

[Intermediate and recovered states: Blocks 15–19](../verification/05-transform.md#block-15--ike-is-still-present-immediately-after-repair)

## Lesson learned

QM_IDLE can coexist with a failed ESP data plane. Preserve intermediate checks and wait for current SA, routing, and traffic evidence to agree. The surviving IKE SA supported new ESP negotiation after repair; OSPF recovered naturally.

[Troubleshooting index](README.md) · [Verification](../verification/README.md) · [GRE/IPsec overview](../README.md)
