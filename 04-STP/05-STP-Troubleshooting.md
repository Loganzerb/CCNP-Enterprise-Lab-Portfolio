# STP Troubleshooting Cases

## Method

Each case follows the same operational sequence: identify scope, read the reported reason, validate both ends, correct the cause, and verify stable reconvergence. Clearing an inconsistent or err-disabled state without correcting the mismatch is not considered a fix.

## Case 1: PVID and native-VLAN mismatch

**Symptom**

```text
%SPANTREE-2-RECV_PVID_ERR: Received BPDU with inconsistent peer vlan id
%SPANTREE-2-BLOCK_PVID_LOCAL: Blocking Gi1/0/1 on VLAN0999
```

**Diagnosis**

```cisco
show interfaces trunk
show spanning-tree inconsistentports
show running-config interface gigabitEthernet1/0/1
```

One end used native VLAN 999 while the other used native VLAN 1. PVST+ BPDUs carry VLAN-identifying information, allowing Cisco switches to detect that an untagged BPDU was classified into a different local VLAN.

**Correction and proof**

```cisco
interface gigabitEthernet1/0/1
 switchport trunk native vlan 999

show interfaces trunk
show spanning-tree inconsistentports
```

Expected result: matching native VLANs and no inconsistent ports. Allowed-VLAN symmetry was checked at the same time.

## Case 2: Port Type Inconsistency

**Symptom**

```text
%SPANTREE-2-BLOCK_PORT_TYPE: Blocking Gi1/0/2 on VLAN0010.
Inconsistent port type.
```

**Root cause**

The peers disagree about the operational link type or edge/network intent—for example, one side is configured as a shared link while the other operates point-to-point, or Bridge Assurance/network-port settings are asymmetric.

```cisco
show spanning-tree interface gigabitEthernet1/0/2 detail
show interfaces gigabitEthernet1/0/2 status
show running-config interface gigabitEthernet1/0/2
```

The fix is to make both ends reflect the physical design. Forcing `spanning-tree link-type point-to-point` is appropriate only on a full-duplex point-to-point link.

## Case 3: Loop Guard inconsistency

**Symptom**

```text
Po20 Altn BLK -> Loop_Inc BLK
```

The port stopped receiving BPDUs but remained physically up. The blocked result is protective and correct.

```cisco
show spanning-tree inconsistentports
show interfaces counters errors
show udld neighbors
show logging | include LOOPGUARD|UDLD
```

The investigation checked remote STP operation, one-way forwarding, optics, and member-link health. BPDU return restored forwarding automatically after the fault was removed.

## Case 4: BPDU Guard err-disable

```cisco
show interfaces status err-disabled
show errdisable recovery
show logging | include BPDU|ERR_DISABLE
```

An unmanaged switch connected to an edge port caused the expected fail-closed action. The device was removed before interface recovery. Disabling BPDU Guard would have hidden the policy violation.

## Case 5: EtherChannel mismatch

One side showed `Po11(SU)` with two `(P)` members; the peer showed standalone links. STP consequently saw different logical topologies.

```cisco
show etherchannel summary
show lacp neighbor
show interfaces switchport
show spanning-tree interface port-channel11
```

LACP mode and member trunk settings were aligned. Verification required `(P)` on every intended member at both ends and a single Port-channel in the STP table.

## Case 6: Unexpected root change

```cisco
show spanning-tree root
show spanning-tree vlan 10 detail
show logging | include ROOT|SPANTREE
```

A downstream lab switch advertised a lower Bridge ID. Root Guard correctly moved the protected designated port to root-inconsistent. The bridge priority was corrected and the intended primary/secondary root policy revalidated.

## Case 7: BPDU Filter removes loop detection

Two edge ports were cabled through a small switch while interface-level BPDU Filter was active. No usable BPDUs crossed the ports, so STP could not detect the loop. The filter was removed, BPDU Guard restored, and the cabling corrected.

This case demonstrates why interface-level BPDU Filter is not equivalent to BPDU Guard and should not be used as generic edge-port hardening.

## Troubleshooting command set

```cisco
show spanning-tree summary
show spanning-tree root
show spanning-tree vlan 10 detail
show spanning-tree inconsistentports
show interfaces trunk
show interfaces status err-disabled
show etherchannel summary
show udld neighbors
show logging | include SPANTREE|UDLD|EC-|ERR_DISABLE
```

## Skills demonstrated

- Separated normal alternate blocking from protocol inconsistency and err-disable conditions.
- Correlated syslog reason codes with trunk, STP, UDLD, and EtherChannel evidence.
- Validated peer symmetry before changing timers or clearing state.
- Proved recovery against intended root placement, port roles, and forwarding scope.

