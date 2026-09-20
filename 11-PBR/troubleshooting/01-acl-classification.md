# Case 01 — Changing a classifier reverses the selected traffic

## Summary

Changing the ACL used by PBR reversed which source took the alternate path. A deny entry excluded source A from the policy action; it did not drop that traffic. The following permit-any entry selected source B instead.

## Starting behavior

The baseline ACL permitted 10.1.1.0/24. Route-map permit sequence 10 referenced that ACL and set next hop 10.23.1.3. Source A traversed R3 while source B followed the normal route through R4. [Baseline policy and traces](../verification/01-baseline.md#block-08)

## Controlled change

I changed the classifier to deny source A and permit other sources. The captured ACL showed:

```cisco
10 deny 10.1.1.0 0.0.0.255
20 permit any
```

This readable configuration matches the [captured ACL](../verification/02-acl-classification.md#block-01). The ACL remained a route-map match condition, rather than an interface packet filter.

## Verification

| Source | Baseline | Changed classifier |
|---|---|---|
| A — 10.1.1.1 | R2 → R3 → R4 → R5 | R2 → R4 → R5 |
| B — 10.11.11.11 | R2 → R4 → R5 | R2 → R3 → R4 → R5 |

[Source-A trace — Block 02](../verification/02-acl-classification.md#block-02) · [Source-B trace — Block 03](../verification/02-acl-classification.md#block-03)

Source A did not match the sole route-map permit sequence and used normal routing. Source B matched permit any and received the next-hop action. Both traces reached a responding interface on R5; their final unanswered probes remain in the evidence.

## Restoration and lesson

I restored the ACL to permit only 10.1.1.0/24 before the next exercise. [Block 04](../verification/02-acl-classification.md#block-04) The later [final paired traces](../verification/04-route-map-sequencing.md#block-07) confirm the original source-specific behavior after all exercises.

**Takeaway:** identify how an ACL is being used before interpreting deny. In this policy, the ACL classified traffic; its permit-any entry broadened the group receiving the alternate-path action.

[Back to cases](README.md) · [Back to PBR](../README.md)
