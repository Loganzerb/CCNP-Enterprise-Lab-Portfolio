# Controlled changes — isolate one crypto dependency at a time

The following commands are **reconstructions of the recorded lab changes**, not captured configuration sessions. The supplied failure and recovery output remains separate in [verification](../verification/README.md). Run each fault from its healthy baseline; restore it before the next case.

## Case 01 — PSK mismatch

On R3, replace the matching key with a deliberately different placeholder:

```ios
no crypto isakmp key REPLACE_WITH_SHARED_LAB_KEY address 192.0.2.1
crypto isakmp key REPLACE_WITH_DIFFERENT_LAB_KEY address 192.0.2.1
```

Existing SAs initially masked this change. The exercise cleared IKE/IPsec state to force fresh authentication. Reconstructed EXEC commands for this isolated lab are `clear crypto sa` and `clear crypto isakmp`. Restore the shared key for recovery.

## Case 02 — Transform mismatch

Reconstruct an AES-128 alternative on R3 and reference it from the map:

```ios
crypto ipsec transform-set GRE-IPSEC-BAD esp-aes esp-sha256-hmac
 mode transport
!
crypto map GRE-IPSEC-MAP 10 ipsec-isakmp
 set transform-set GRE-IPSEC-BAD
```

The lab cleared IPsec SAs while retaining IKE. Restoring `set transform-set GRE-IPSEC` allows AES-256 ESP to negotiate again. The alternative object's name is a documentation reconstruction; the recorded fault was the AES-128/AES-256 disagreement.

## Case 03 — Selector mismatch

On R3:

```ios
ip access-list extended GRE-IPSEC-ACL
 no permit gre host 198.51.100.2 host 192.0.2.1
 permit gre host 198.51.100.2 host 192.0.2.5
```

Restore the reciprocal identity:

```ios
ip access-list extended GRE-IPSEC-ACL
 no permit gre host 198.51.100.2 host 192.0.2.5
 permit gre host 198.51.100.2 host 192.0.2.1
```

The supplied compilation retains the two selector lines, not the complete ACL-edit session. Post-repair checks compare current SPI, counters, OSPF, and traffic rather than restarting the routing process.

[Troubleshooting cases](../troubleshooting/README.md) · [Configuration guide](README.md) · [Overview](../README.md)
