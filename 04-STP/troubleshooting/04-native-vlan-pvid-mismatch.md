# Case 04 — Native VLAN / PVID mismatch

## Failure injection

The 802.1Q native VLAN was changed on only one end of a trunk, producing inconsistent Port VLAN ID (PVID) information in BPDUs.

## Observed behavior

The trunk remained physically up, but STP detected the native-VLAN/PVID inconsistency and blocked the affected control-plane relationship rather than accepting ambiguous untagged traffic.

## Diagnosis

```text
show interfaces trunk
show spanning-tree detail
show spanning-tree inconsistentports
show running-config interface <interface>
show logging
```

Compare both ends for `switchport trunk native vlan` and confirm the same allowed VLAN set.

## Recovery

Restore the same native VLAN on both ends, then verify the inconsistency clears and expected VLANs return to forwarding.

## Lesson

An operational trunk is not necessarily a consistent trunk. Control-plane checks can correctly block a link that still shows physical and line protocol up.
