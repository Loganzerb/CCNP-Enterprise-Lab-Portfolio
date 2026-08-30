# Case 05 — Trunk/access Port Type Inconsistent

## Failure injection

One side of a switch-to-switch link was configured as an 802.1Q trunk while the opposite side behaved as an access port.

## Observed behavior

STP reported a Port Type Inconsistent condition. The devices disagreed about whether the segment represented a shared access VLAN or a tagged multi-VLAN infrastructure link.

## Diagnosis

```text
show spanning-tree inconsistentports
show interfaces trunk
show interfaces switchport
show running-config interface <interface>
show logging
```

## Recovery

Make both ends intentional trunks with matching encapsulation/native/allowed VLAN settings, or make both ends intentional access ports in the same VLAN.

## Lesson

Interface mode is part of the Layer 2 contract. A cable can be up while the spanning-tree interpretation of the segment is unsafe.
