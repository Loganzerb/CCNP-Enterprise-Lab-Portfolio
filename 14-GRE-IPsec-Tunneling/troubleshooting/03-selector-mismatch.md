# Case 03 — Historical counters obscure a wrong traffic selector

## Symptom and controlled change

R3's GRE selector was changed from remote address 192.0.2.1 to 192.0.2.5. Its actual IKE peer remained 192.0.2.1. IKE stayed established, but private traffic failed 0/5 and OSPF lost its neighbor.

## Investigation

1. Compare the selected identity with the peer. R3's crypto output showed remote identity 192.0.2.5 alongside current_peer 192.0.2.1.
2. Check usable ESP state. R3 had outbound SPI zero and zero counters, even with zero send errors.
3. Inspect the opposite endpoint. R1 retained 102 encrypted and 102 decrypted packets but had current outbound SPI zero, 24 send errors, and no OSPF neighbor.
4. Test actual service. The sourced ping from 10.30.30.1 to 10.10.10.1 returned 0/5.

[Failure evidence: Blocks 20–26](../verification/06-selector.md#block-23--the-protected-identity-disagrees-with-the-actual-peer)

## Root cause and remediation

R3 selected GRE to the wrong destination, so the two peers no longer had reciprocal identities for the actual tunnel. Restoring `permit gre host 198.51.100.2 host 192.0.2.1` corrected the selector without changing the IKE peer.

## Post-fix validation

R3's selected remote address returned to 192.0.2.1. Outbound SPI 0xCD2CA569 appeared, counters became 7 outbound / 9 inbound, errors were zero, and OSPF returned to FULL. That SPI matches R1's final inbound ESP SA.

[Recovery evidence: Blocks 27–29](../verification/06-selector.md#block-28--the-correct-identity-restores-esp) · [Final 20/20 test and counter growth](../verification/03-final-validation.md)

## Lesson learned

The peer address and protected traffic identity are different objects. Compare both. Nonzero cumulative counters describe earlier activity; current SPIs, active SAs, fresh traffic, and counter changes establish present forwarding.

[Troubleshooting index](README.md) · [Verification](../verification/README.md) · [GRE/IPsec overview](../README.md)
