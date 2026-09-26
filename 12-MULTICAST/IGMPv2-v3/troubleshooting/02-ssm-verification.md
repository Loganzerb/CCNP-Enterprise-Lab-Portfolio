# Case 02 — verify SSM when one command and one display fall short

**Result:** R4's configuration and multicast route establish source-specific state. The retained IGMP detail view remains incomplete; its missing source row is not filled in or treated as proof of a forwarding fault.

## Symptoms

`show ip pim ssm` returned an invalid-input marker. Later, `show ip igmp groups detail` showed INCLUDE mode and an SSM flag for `232.1.1.1`, but printed no source rows.

## Investigation

1. The running configuration returned `ip pim ssm default`.
2. IGMP detail distinguished the ASM group's EXCLUDE/empty-list membership from the SSM group's INCLUDE membership.
3. `show ip mroute 232.1.1.1` identified source `10.1.1.10`, flags `sTI`, incoming Gi0/2 and outgoing Gi0/0.

[Blocks 05–07 — command rejection through route verification](../verification/02-v3-ssm.md)

## Resolution and limits

The investigation changed the verification method. No additional configuration repair was justified by these displays. The unsupported command and the missing row are distinct observations; the missing row's cause was not established.

The `(S,G)` result corroborates the source-specific request. It does not establish packet delivery, performance or rejection of another source; those would need separate traffic evidence.

## Lesson

Separate CLI availability, configuration intent, membership state and forwarding outcomes. When one display is incomplete, corroborate it with an independent table before changing the network.

[Configuration](../configs/README.md) · [All investigations](README.md) · [Overview](../README.md)
