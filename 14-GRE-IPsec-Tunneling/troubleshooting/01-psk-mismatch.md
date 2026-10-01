# Case 01 — Existing SAs conceal a peer-authentication mismatch

## Symptom and controlled change

R3's configured PSK was deliberately changed to a different value. The existing IKE/IPsec SAs initially kept the VPN usable. Clearing their state forced a new authentication attempt and exposed the mismatch.

## Investigation

1. Check IKE before interpreting GRE or OSPF symptoms. R1 showed MM_NO_STATE/MM_KEY_EXCH attempts, with no completed QM_IDLE entry.
2. Inspect ESP separately. Both routers had outbound SPI zero and zero protected-packet counters. R1 recorded four send errors; R3 recorded seven.
3. Correlate the routing impact. Both OSPF neighbor commands returned no entries.
4. Compare the known configuration change and peer keys. The malformed-message warning supported the failure timeline but did not uniquely diagnose a PSK error.

[Failure evidence: Blocks 05–08](../verification/04-psk.md#block-05--r1-has-main-mode-attempts-without-usable-esp)

## Root cause and remediation

The peers had different authentication keys. R3's matching shared key was restored. The [configuration-change guide](../configs/faults.md#case-01--psk-mismatch) uses sanitized placeholders and labels the reconstructed commands.

## Post-fix validation

R1 returned to QM_IDLE/ACTIVE. Outbound SPI 0x207CA9F7 appeared, protected counters became 2 outbound / 3 inbound, and errors were zero. OSPF returned to FULL on Tunnel0. These recovery captures are partial ESP views; the [final validation](../verification/03-final-validation.md) supplies the complete healthy SA and traffic checks.

[Recovery evidence: Blocks 09–11](../verification/04-psk.md#block-09--ike-returns-to-qm_idle-after-key-correction)

## Lesson learned

Test whether a changed configuration can negotiate fresh SAs. Continuing traffic through an existing SA can hide a mismatch that will surface during renewal. Repairing authentication restored the dependency OSPF needed; no OSPF restart was recorded.

[Troubleshooting index](README.md) · [Verification](../verification/README.md) · [GRE/IPsec overview](../README.md)
