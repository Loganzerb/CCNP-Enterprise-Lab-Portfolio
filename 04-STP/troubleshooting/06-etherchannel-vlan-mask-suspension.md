# Case 06 — EtherChannel VLAN-mask suspension

## Failure injection

An EtherChannel member was given a trunk allowed-VLAN mask that did not match the other member/logical Port-Channel.

## Observed behavior

IOS suspended the inconsistent member rather than allowing two links with different Layer 2 forwarding properties to operate inside one logical bundle.

## Diagnosis

```text
show etherchannel summary
show interfaces trunk
show interfaces <member> switchport
show interfaces port-channel 1
show running-config interface <member>
show logging
```

## Recovery

Make the allowed VLAN list, native VLAN, trunk mode, and other bundle-relevant attributes consistent. Apply operational trunk policy to the Port-Channel where appropriate, then verify the member returns to `(P)`.

## Lesson

LACP adjacency alone does not guarantee a member can bundle. EtherChannel also enforces Layer 2 attribute consistency.
