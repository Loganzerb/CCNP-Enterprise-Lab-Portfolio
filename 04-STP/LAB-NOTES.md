# STP Masterclass Lab Notes

## How to read this journal

The entries follow the actual progression of the CML lab. **Observed** blocks reproduce values or state captured in the session. **Expected signature** blocks are representative Cisco IOS indications used to recognize a condition; they are not claimed as exact console captures when the conversation did not preserve the literal line. This distinction matters because some IOSvL2 behaviors and debug facilities were incomplete.

## 1. Build and PVST+ baseline

The initial fabric used four IOSvL2 switches and two hosts. Five inter-switch links intentionally created multiple Layer 2 cycles. VLANs 10, 20, 30, and 40 were created and allowed on explicit 802.1Q trunks.

```cisco
vlan 10
 name USERS_A
vlan 20
 name USERS_B
vlan 30
 name SERVICES_A
vlan 40
 name SERVICES_B

interface range GigabitEthernet0/0-2
 switchport trunk encapsulation dot1q
 switchport mode trunk
 switchport trunk allowed vlan 10,20,30,40
 switchport nonegotiate
```

The first pass used PVST+ to reinforce that Cisco maintains a separate 802.1D-derived election for each VLAN. The baseline questions were operational:

- Which bridge is root for each VLAN?
- What is the root path cost on each non-root switch?
- Which side of each segment is designated?
- Which redundant port is blocking, and what superior information caused it to lose?

```cisco
show spanning-tree root
show spanning-tree vlan 10
show spanning-tree vlan 20
show interfaces trunk
```

The classic state sequence was used as the comparison point:

```text
Blocking → Listening (forward-delay) → Learning (forward-delay) → Forwarding
```

With default values, the visible listening plus learning interval is roughly 30 seconds. Max Age can extend failure recovery when a bridge must age out stale information.

## 2. Migration to Rapid PVST+

Each switch was migrated with:

```cisco
spanning-tree mode rapid-pvst
```

Verification required more than seeing the command in running configuration. IOS needed to report RSTP and expose rapid roles/types:

```text
Spanning tree enabled protocol rstp
...
Gi0/0  Root/Desg/Altn  FWD/BLK  ...  P2p
Gi0/3  Desg            FWD      ...  P2p Edge
```

RSTP collapses classic blocking, listening, and disabled into **discarding**, retains learning and forwarding, and adds explicit alternate and backup roles. The operational difference is that a point-to-point designated port can use proposal/agreement instead of waiting through both forward-delay periods.

## 3. Root election and extended system ID

The lab deliberately moved the VLAN 10 root to `SW4-DIST-B`:

```cisco
SW4-DIST-B(config)# spanning-tree vlan 10 priority 4096
```

Because VLAN 10 is carried in the extended system ID, the displayed value became `4096 + 10 = 4106`.

**Observed on SW4:**

```text
VLAN0010
Spanning tree enabled protocol rstp
Root ID    Priority    4106
Address     5254.000d.a2e1
This bridge is the root
Hello Time   2 sec  Max Age 20 sec  Forward Delay 15 sec

Bridge ID  Priority    4106   (priority 4096 sys-id-ext 10)
Address     5254.000d.a2e1

Gi0/0  Desg FWD 4  128.1  P2p
Gi0/1  Desg FWD 4  128.2  P2p
```

**Observed on SW2 after the election:**

```text
Root ID    Priority    4106
Address     5254.000d.a2e1
Cost        4
Port        2 (GigabitEthernet0/1)

Gi0/0  Desg FWD 4  128.1  P2p
Gi0/1  Root FWD 4  128.2  P2p
Gi0/2  Desg FWD 4  128.3  P2p
Gi0/3  Desg FWD 4  128.4  P2p Edge
```

This before/after proves the complete chain: a superior bridge ID was introduced; SW4 declared itself root; SW2 selected its direct Gi0/1 path; and the host port remained forwarding as an edge port.

## 4. Proposal/agreement and synchronization

The test kept SW2 visible while SW4 introduced the superior BPDU. The lab image accepted:

```cisco
debug spanning-tree synchronization
```

but did not print the internal handshake to the console. Rather than fabricate a packet exchange, the result was inferred from protocol state and transition counters.

Conceptually, the event was:

```text
SW4 sends proposal with superior root information
→ SW2 selects Gi0/1 as its new root port
→ SW2 synchronizes non-edge designated ports
→ SW2 returns agreement
→ rapid forwarding is permitted on the point-to-point link
```

The edge interface was excluded from the synchronization requirement because an edge port is assumed not to lead to another bridge.

**Observed transition counters on SW2:**

```text
Port 1 (GigabitEthernet0/0) ... designated forwarding
Number of transitions to forwarding state: 1

Port 2 (GigabitEthernet0/1) ... root forwarding
Number of transitions to forwarding state: 2

Port 3 (GigabitEthernet0/2) ... designated forwarding
Number of transitions to forwarding state: 2

Port 4 (GigabitEthernet0/3) ... designated forwarding
Number of transitions to forwarding state: 6
```

The counters do not by themselves decode every handshake flag, but they corroborate repeated role/state changes. That was the strongest evidence exposed by this IOSvL2 build.

## 5. Classic STP versus RSTP convergence and timers

The timer values still appear under Rapid PVST+:

```text
Hello Time 2 sec  Max Age 20 sec  Forward Delay 15 sec
```

Their presence does not mean every RSTP transition waits 30 seconds. RSTP uses current role information, point-to-point link type, edge status, and proposal/agreement. Classic STP depends much more heavily on forward-delay and max-age behavior.

The practical comparison recorded in the lab was:

| Event | Classic PVST+/802.1D behavior | Rapid PVST+/802.1w behavior |
|---|---|---|
| New designated point-to-point path | Listening + learning timers | Proposal/agreement when safe |
| Edge/host link | PortFast required for immediate forwarding | Operational edge transitions immediately |
| Alternate path takeover | Timer-driven recalculation | Alternate role is already known and can replace root path rapidly |
| BPDU generation | Root originates; downstream relays | Every RSTP bridge sends BPDUs |

## 6. Root-controlled timers

Timer changes belong at the root because the root’s BPDU parameters govern the tree. A representative experiment is:

```cisco
spanning-tree vlan 10 hello-time 1
spanning-tree vlan 10 max-age 12
spanning-tree vlan 10 forward-time 10
```

Verification is performed on both the root and a downstream bridge. If a non-root is locally configured and then receives root information, the operational values follow the root. The engineering takeaway is to treat STP timers as a coordinated topology policy, not a per-access-switch tuning knob. Timer reduction was not used as a substitute for RSTP.

## 7. Root-port and designated-port tie-breakers

The lab worked through the full comparison sequence. For received BPDUs, the superior vector is selected in this order:

1. lowest root bridge ID;
2. lowest root path cost;
3. lowest sender bridge ID;
4. lowest sender port ID;
5. lowest local port ID when all received information is otherwise identical.

### Path-cost engineering

```cisco
interface GigabitEthernet0/0
 spanning-tree vlan 10 cost 20000
```

After raising one candidate’s cost, `show spanning-tree vlan 10` was used to prove the root port moved to the lower-total-cost path. Removal returned the election to the original vector:

```cisco
interface GigabitEthernet0/0
 no spanning-tree vlan 10 cost
```

### Sender bridge ID tie-break

With equal total cost through two neighbors, the neighbor advertising the lower bridge ID wins. This is not the local switch comparing its own interface number yet; it is comparing the sender identity in the two received BPDUs.

### Sender port ID and port priority

Parallel links from the same neighbor produce the same root ID, cost, and sender bridge ID. The lower sender port ID wins. Port priority changes sender port ID in increments supported by IOS:

```cisco
interface GigabitEthernet0/1
 spanning-tree vlan 10 port-priority 64
```

The change must be applied on the **sending** switch interface when the goal is to alter the sender-port-ID tie-break. Applying port priority on the receiver affects local port ID only at the final tie-break.

## 8. Bridge-priority and final split-root design

After temporary priority experiments, the topology was returned to a production-like policy:

```cisco
! SW1-DIST-A
spanning-tree vlan 10,20 priority 24576
spanning-tree vlan 30,40 priority 28672

! SW4-DIST-B
spanning-tree vlan 10,20 priority 28672
spanning-tree vlan 30,40 priority 24576
```

The policy is auditable in the YAML and avoids `root primary` hiding the actual numerical intent.

## 9. Short versus long path cost

The lab saved all switches with:

```cisco
spanning-tree pathcost method long
```

The observed GigabitEthernet cost was `4`. In other platforms and modes, the same speed may display a different numeric cost. The important rule is that all switches in an engineered domain should use a consistent method; otherwise apparently “equal” paths may not be equal. Verification:

```cisco
show spanning-tree pathcost method
show spanning-tree vlan 10
```

## 10. Edge-port behavior and BPDU Guard

The final host-port configuration is preserved in the export:

```cisco
interface GigabitEthernet0/3
 switchport access vlan 10
 switchport mode access
 spanning-tree portfast edge
 spanning-tree bpduguard enable
```

An edge port bypasses normal synchronization and reaches forwarding immediately. It does not stop sending BPDUs, and edge status is lost if a BPDU is received. BPDU Guard adds the enforcement action: an unexpected BPDU error-disables the interface.

**Expected signature:**

```text
%SPANTREE-2-BLOCK_BPDUGUARD: Received BPDU on port ... with BPDU Guard enabled. Disabling port.
%PM-4-ERR_DISABLE: bpduguard error detected on ..., putting ... in err-disable state
```

Diagnosis and controlled recovery:

```cisco
show interfaces status err-disabled
show errdisable recovery
show logging | include BPDU|ERR_DISABLE
shutdown
no shutdown
```

Recovery was paired with removing the switch/BPDU source; bouncing an unsafe port without fixing its attachment only repeats the failure.

## 11. Root Guard

Root Guard was placed toward `SW5-ROGUE` on a port that should remain designated and should never lead to a superior root:

```cisco
interface GigabitEthernet0/2
 spanning-tree guard root
```

The rogue was then assigned a lower VLAN 10 priority. The protected port should enter `root-inconsistent`, not error-disable.

**Expected signature:**

```text
%SPANTREE-2-ROOTGUARD_BLOCK: Root guard blocking port ... on VLAN0010
```

```cisco
show spanning-tree inconsistentports
show spanning-tree vlan 10
```

When the superior BPDUs stop, Root Guard recovers automatically. This test emphasized that Root Guard permits ordinary BPDUs; it rejects only superior information that would move the root boundary.

## 12. Loop Guard

Loop Guard belongs on a non-designated path where BPDUs are expected. Silence on such a path must not be interpreted as permission to forward.

```cisco
interface GigabitEthernet0/2
 spanning-tree guard loop
```

When expected BPDUs were suppressed, the recognition target was `loop-inconsistent`:

```cisco
show spanning-tree inconsistentports
show spanning-tree vlan 10 detail
```

Unlike UDLD, Loop Guard reasons from missing STP information and keeps the port from transitioning out of a blocking/discarding role. It automatically clears when valid BPDUs return.

## 13. UDLD recognition

UDLD was studied beside Loop Guard, not conflated with it. UDLD detects a unidirectional Layer 2 link using its own neighbor protocol; aggressive mode can error-disable the link. Loop Guard protects STP when BPDUs disappear on a non-designated path. The relevant recognition commands are:

```cisco
udld enable
interface GigabitEthernet0/1
 udld port aggressive
show udld neighbors
show interfaces status err-disabled
```

IOSvL2/CML does not faithfully emulate every physical one-way failure, so this portion was treated as feature recognition and diagnostic method rather than falsely claiming a physical-layer capture.

## 14. BPDU Filter

BPDU Filter was tested as a dangerous boundary tool. Interface-level filtering can stop both sending and receiving BPDUs, effectively removing STP’s protection while the link can still carry data:

```cisco
interface GigabitEthernet0/3
 spanning-tree bpdufilter enable
```

Global PortFast BPDU Filter has different behavior: it starts filtering on eligible PortFast ports but can lose PortFast/filtering behavior when BPDUs arrive. The journal’s operational takeaway is simple: BPDU Filter is not a substitute for BPDU Guard and should not be used to “fix” unexpected BPDUs.

## 15. PVID/native VLAN mismatch

One end of a trunk was temporarily given a different native VLAN:

```cisco
interface GigabitEthernet0/1
 switchport trunk native vlan 20
```

The peer remained at the previous native VLAN. Cisco BPDUs carry VLAN/PVID information that can expose the mismatch. The recognition target was a per-VLAN `PVID_Inc`/inconsistent state and log messages similar to:

```text
%SPANTREE-2-RECV_PVID_ERR: Received BPDU with inconsistent peer vlan id ...
%SPANTREE-2-BLOCK_PVID_LOCAL: Blocking ... on VLAN... Inconsistent local vlan.
```

Evidence:

```cisco
show interfaces trunk
show interfaces GigabitEthernet0/1 switchport
show spanning-tree inconsistentports
show logging | include PVID|SPANTREE
```

Matching native VLANs restored consistency automatically.

## 16. Port Type Inconsistency

RSTP link-type/edge expectations were deliberately made asymmetric. A switch-to-switch link should not be forced to behave like an edge. Cisco can protect the topology with a port-type inconsistency when BPDU semantics conflict.

```cisco
show spanning-tree inconsistentports
show spanning-tree vlan 10 detail
show running-config interface GigabitEthernet0/1
```

The remediation is to make both sides’ roles honest: network/point-to-point for switch links, edge only for host-facing links. The exported YAML retains `spanning-tree portfast network` on the SW3–SW4 link from the Bridge Assurance exercise.

## 17. EtherChannel and STP behavior

Parallel links were bundled so STP would see one logical `Port-channel`, not several independent physical ports:

```cisco
interface range GigabitEthernet0/2-3
 switchport trunk encapsulation dot1q
 switchport mode trunk
 channel-group 1 mode active

interface Port-channel1
 switchport mode trunk
 switchport trunk allowed vlan 10,20,30,40
```

Verification was layered:

```cisco
show etherchannel summary
show lacp neighbor
show spanning-tree vlan 10
```

Only after the members showed bundled should STP output be interpreted at `Po1`. The aggregate’s path cost reflects the logical bandwidth; a member failure can change aggregate bandwidth/cost without necessarily making the port-channel go down.

## 18. LACP passive/passive

Both sides were set to passive to demonstrate a negotiation deadlock:

```cisco
channel-group 1 mode passive
```

Passive listens but does not initiate. With passive/passive, the channel does not form, so there is no logical port for STP to treat as the intended bundle. `show etherchannel summary` and `show lacp neighbor` are therefore checked before blaming STP.

Remediation changes at least one side to active:

```cisco
channel-group 1 mode active
```

## 19. VLAN mask suspension

Allowed-VLAN or trunk-parameter differences across channel members were introduced to show that member compatibility is a prerequisite for bundling:

```cisco
interface GigabitEthernet0/2
 switchport trunk allowed vlan 10,20
interface GigabitEthernet0/3
 switchport trunk allowed vlan 10,20,30,40
```

The member may be suspended rather than silently forwarding with a different VLAN mask. Evidence is gathered from both EtherChannel and trunk views:

```cisco
show etherchannel summary
show interfaces trunk
show running-config interface GigabitEthernet0/2
show running-config interface GigabitEthernet0/3
```

The remediation is exact member parity, preferably by applying Layer 2 policy to the port-channel interface and allowing IOS to propagate it.

## 20. Bridge Assurance

The SW3–SW4 inter-switch link in the export is marked as a network edge on both ends:

```cisco
interface GigabitEthernet0/1
 spanning-tree portfast network
```

On supported platforms, Bridge Assurance expects BPDUs in both directions on point-to-point network ports. If they stop, the port is held in a BA-inconsistent state. This is broader than Loop Guard because it applies to network ports including designated ports. It requires compatible operation at both ends.

IOSvL2 support and command behavior can vary; the saved configuration proves the intended setup, while exact BA syslog is treated as a recognition signature rather than a preserved capture:

```text
%SPANTREE-2-BRIDGE_ASSURANCE_BLOCK: Blocking port ... due to bridge assurance
```

## 21. EtherChannel misconfiguration guard

The lab distinguished channel negotiation failure from Cisco’s STP EtherChannel misconfiguration protection. If one side treats links as a bundle and the other sends inconsistent BPDUs per physical link, STP may place ports into an EtherChannel inconsistency state to prevent a loop.

```cisco
show spanning-tree inconsistentports
show etherchannel summary
show logging | include EC|SPANTREE
```

The fix is not to disable the guard. It is to make channel protocol, channel-group, trunk mode, native VLAN, allowed VLAN set, speed/duplex, and member configuration consistent on both ends.

## 22. UplinkFast and BackboneFast recognition

These are legacy PVST+/802.1D Cisco enhancements:

- **UplinkFast** accelerates a blocked uplink’s transition after a direct failure and historically adjusts bridge priority/path costs.
- **BackboneFast** uses Root Link Query behavior to react to indirect failures and inferior BPDUs without waiting the full Max Age.

Rapid PVST+ incorporates faster alternate-path and synchronization behavior, so these commands are not the mechanism used by the final lab. They were studied so legacy outputs and design questions can be recognized without applying obsolete tuning to RSTP.

## 23. Final verification and saved state

The final audit used:

```cisco
show spanning-tree summary
show spanning-tree root
show spanning-tree vlan 10
show spanning-tree vlan 30
show spanning-tree inconsistentports
show interfaces trunk
show running-config | section spanning-tree
```

Saved state highlights:

- Rapid PVST+ on every switch;
- long path-cost method on every switch;
- SW1 preferred for VLANs 10/20 and SW4 preferred for VLANs 30/40;
- explicit VLAN 10/20/30/40 trunks with DTP disabled;
- PortFast edge plus BPDU Guard on PC-facing ports;
- a dedicated rogue-switch connection retained for repeatable fault injection;
- Bridge Assurance/network-port configuration retained on the SW3–SW4 path.

