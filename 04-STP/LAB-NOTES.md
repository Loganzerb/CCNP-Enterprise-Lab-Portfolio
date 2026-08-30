# STP Masterclass Lab Notes

## 1. Baseline and protocol modes

I began with the redundant four-switch topology and confirmed that STP removed Layer 2 loops while preserving standby paths. I compared classic PVST+ and Rapid PVST+ rather than treating “STP” as one behavior.

```cisco
spanning-tree mode pvst
spanning-tree mode rapid-pvst

show spanning-tree summary
show spanning-tree vlan 10
show spanning-tree vlan 10 detail
```

The classic instance exposed Listening/Learning timer dependence. Rapid PVST+ used RSTP roles and point-to-point proposal/agreement synchronization. During protocol migration, a port retained `Peer is STP` even after the global mode was Rapid PVST+. This distinguished global mode from per-port compatibility state. Re-detection restored native rapid behavior:

```cisco
clear spanning-tree detected-protocols
```

## 2. Root election and tie-breakers

I first observed default root selection by the lowest Bridge ID, then replaced accidental MAC-based selection with an explicit design.

```cisco
! SW1-DIST-A
spanning-tree vlan 10,20 priority 24576
spanning-tree vlan 30,40 priority 28672

! SW4-DIST-B
spanning-tree vlan 10,20 priority 28672
spanning-tree vlan 30,40 priority 24576
```

The experiments validated the election sequence:

1. Lowest root Bridge ID.
2. Lowest root-path cost.
3. Lowest sender Bridge ID.
4. Lowest sender port ID.
5. Lowest local port ID when the remaining information is tied.

The extended system ID was visible in VLAN-specific priorities. For example, configured priority 24576 appeared as `24586` in VLAN 10.

## 3. Convergence, timers, and topology changes

The detailed output exposed the default values:

```text
Hello 2 seconds
Max Age 20 seconds
Forward Delay 15 seconds
```

I tested direct failures and loss of superior information. Classic STP could require approximately 30 seconds for Listening plus Learning, or approach 50 seconds where stored information first had to age out. RSTP promoted alternate paths rapidly by exchanging proposal/agreement information and synchronizing non-edge designated ports.

I also proved that an edge-port flap was not counted as an RSTP topology change. Before and after shutting/no-shutting `SW3-ACCESS-B Gi0/3`, the counter remained at four while the “last change” timer continued increasing.

```cisco
show spanning-tree vlan 10 detail | include topology
```

## 4. PortFast and BPDU Guard

Host-facing ports were configured as edge ports and protected against accidental switch attachment.

```cisco
interface GigabitEthernet0/3
 switchport mode access
 switchport access vlan 10
 spanning-tree portfast edge
 spanning-tree bpduguard enable
```

Normal host operation showed `P2p Edge`, zero received BPDUs, and BPDU Guard enabled. Connecting a BPDU-speaking switch caused the physical interface to enter err-disabled state. Recovery required removing the unsafe attachment, then bouncing the interface (or using an intentional errdisable recovery policy).

## 5. Root Guard

I protected the downstream-facing path from an unauthorized root:

```cisco
interface GigabitEthernet0/1
 spanning-tree guard root
```

After the downstream/rogue switch advertised a superior VLAN 10 Bridge ID, the protected VLAN instance entered `root-inconsistent`. The interface remained physically up; this was not BPDU Guard. Removing the superior-root condition allowed automatic recovery.

## 6. Loop Guard, BPDU Filter, and UDLD

Loop Guard was tested on a non-edge path expected to keep receiving BPDUs.

```cisco
interface GigabitEthernet0/2
 spanning-tree guard loop
```

When expected BPDUs disappeared while the link remained up, STP prevented unsafe forwarding with `loop-inconsistent`. Valid BPDU reception restored the instance automatically.

BPDU Filter was evaluated as a different control: it suppresses STP visibility instead of reacting to a fault. Interface-level filtering was shown to be especially hazardous on switch-to-switch links because forwarding can continue without the BPDUs required to detect a loop. Global PortFast filtering was distinguished from the persistent interface command.

UDLD was recognized as physical/link-direction protection, not an STP role guard. Normal mode detects and reports a one-way condition; aggressive mode can verify the failure and err-disable the link. IOSvL2 limitations made this primarily a recognition and diagnostic exercise rather than a faithful optical one-way failure emulation.

## 7. PVID/native VLAN and port-type inconsistency

The redundant `SW2 Gi0/2` to `SW3 Gi0/2` trunk was used to inject a native-VLAN mismatch. I established the healthy baseline with `show interfaces trunk`, changed one side only, and then correlated the syslog with:

```cisco
show spanning-tree inconsistentports
show spanning-tree vlan 10
show interfaces trunk
```

IOS protected the topology with a PVID inconsistency. Restoring the same native VLAN on both ends removed the inconsistency automatically.

I separately examined Port Type Inconsistency, which occurs when the BPDU view of the segment conflicts—for example, an RSTP point-to-point/network expectation meeting incompatible edge/shared behavior. The key lesson was to fix the link classification/configuration on both ends rather than forcing the blocked port forward.

## 8. Path-cost and port-priority engineering

I changed costs per VLAN to steer traffic without moving the root bridge:

```cisco
interface GigabitEthernet0/0
 spanning-tree vlan 10 cost 50000
```

Root-port selection followed the lowest total path cost. When costs tied, upstream sender information decided the result; port priority affected selection only after superior criteria tied.

```cisco
interface GigabitEthernet0/1
 spanning-tree vlan 10 port-priority 64
```

I compared path-cost methods directly:

```cisco
spanning-tree pathcost method short
spanning-tree pathcost method long
show spanning-tree summary
```

Gigabit links appeared with cost `4` under short costs and `20000` under long costs. The saved topology uses long costs on all switches.

## 9. EtherChannel and STP

Parallel links were bundled so STP evaluated one logical Port-channel instead of blocking individual member links:

```cisco
interface range GigabitEthernet0/0-1
 channel-group 1 mode active

interface Port-channel1
 switchport mode trunk
 switchport trunk allowed vlan 10,20,30,40
```

I verified member state with `show etherchannel summary` and STP role/cost on the Port-channel. A member-level inconsistency demonstrated why channel parameters must match. EtherChannel misconfiguration guard was recognized from `show spanning-tree summary` and from the protection response to incompatible bundling.

## 10. Bridge Assurance and legacy features

Bridge Assurance was tested using the network edge type on switch-to-switch links:

```cisco
interface GigabitEthernet0/1
 spanning-tree portfast network
```

Network ports expect continuous RSTP/MST BPDUs in both directions. A missing/incompatible peer caused protective blocking rather than unsafe forwarding. This was deliberately kept separate from PortFast edge, which is for end hosts.

Finally, I verified that UplinkFast and BackboneFast were disabled in Rapid PVST+ summaries. They remain useful recognition topics for legacy 802.1D/PVST+ troubleshooting, but RSTP already incorporates rapid alternate-path and inferior-BPDU handling mechanisms. They were not added to the final Rapid PVST+ design.

## Final saved state

- Rapid PVST+ on all five switches.
- Long path-cost method.
- VLANs 10/20 rooted at `SW1-DIST-A`.
- VLANs 30/40 rooted at `SW4-DIST-B`.
- VLAN 10 host ports configured as PortFast edge with BPDU Guard.
- Network port type retained on selected inter-switch interfaces used for Bridge Assurance testing.
- All trunks restricted to VLANs 10, 20, 30, and 40.
