# STP Troubleshooting Casebook

## Triage method

The case studies use a consistent order so a blocked port is not “fixed” before its protection function is understood.

1. **Define scope:** one interface, one VLAN, all VLANs, or the whole bundle?
2. **Identify state:** physical down, STP discarding, inconsistent, suspended, or error-disabled?
3. **Locate the root:** verify root ID and root port for the affected VLAN.
4. **Inspect adjacency:** trunk parameters, native VLAN, allowed list, channel state, and BPDU expectation.
5. **Read logs:** correlate the first control-plane event with the state transition.
6. **Remove the fault:** restore the design contract, not merely the interface.
7. **Prove recovery:** confirm forwarding, consistency, root placement, and absence of a new loop.

The exact commands repeated across cases are:

```cisco
show spanning-tree vlan <vlan>
show spanning-tree vlan <vlan> detail
show spanning-tree inconsistentports
show interfaces trunk
show interfaces <interface> switchport
show etherchannel summary
show logging
```

## Case 1 — Rogue switch attempts to become VLAN 10 root

**Symptom**

The protected SW4-facing port stops forwarding VLAN 10 and appears as root-inconsistent, while the physical interface remains up.

**Injected fault**

`SW5-ROGUE` was connected to the designated root boundary and given a superior VLAN 10 bridge priority.

```cisco
! SW4, toward rogue
interface GigabitEthernet0/2
 spanning-tree guard root

! SW5-ROGUE
spanning-tree vlan 10 priority 0
```

**Evidence**

```cisco
show spanning-tree inconsistentports
show spanning-tree vlan 10
show logging | include ROOTGUARD|SPANTREE
```

Representative signature:

```text
%SPANTREE-2-ROOTGUARD_BLOCK: Root guard blocking port ... on VLAN0010
```

**Root cause**

The neighbor advertised a better bridge ID. Without Root Guard, the link could become SW4’s root port and move the campus root into an untrusted access domain.

**Remediation**

Remove the rogue priority or disconnect/reconfigure the unauthorized switch. Do not remove Root Guard to make the port green.

**Recovery behavior**

Root-inconsistent clears automatically after superior BPDUs cease. No error-disable bounce is required.

**Takeaway**

Root Guard defines where a root is allowed to exist. It accepts normal BPDUs but rejects superior ones.

## Case 2 — Switch connected to an edge port protected by BPDU Guard

**Symptom**

The host-facing port becomes error-disabled immediately after a switch is connected.

**Injected fault**

A BPDU source was attached to an interface configured as an RSTP edge port with BPDU Guard.

```cisco
interface GigabitEthernet0/3
 spanning-tree portfast edge
 spanning-tree bpduguard enable
```

**Evidence**

```cisco
show interfaces status err-disabled
show logging | include BPDU|ERR_DISABLE
show errdisable recovery
```

Representative signature:

```text
%SPANTREE-2-BLOCK_BPDUGUARD: Received BPDU on port ... with BPDU Guard enabled. Disabling port.
%PM-4-ERR_DISABLE: bpduguard error detected on ..., putting ... in err-disable state
```

**Root cause**

The operational edge assumption became false. A bridge on an edge port can create a loop before a user notices the wiring change.

**Remediation**

Remove the bridge or redesign the port as an intentional switch link. Then recover manually:

```cisco
interface GigabitEthernet0/3
 shutdown
 no shutdown
```

**Recovery behavior**

Unlike Root Guard, the interface stays error-disabled until manual or configured errdisable recovery occurs.

**Takeaway**

PortFast accelerates; BPDU Guard enforces. They solve different parts of the edge problem.

## Case 3 — Expected BPDUs disappear on an alternate path

**Symptom**

A physically up redundant port remains non-forwarding and is reported loop-inconsistent.

**Injected fault**

BPDU reception was suppressed on a port that was expected to continue hearing the designated bridge.

```cisco
interface GigabitEthernet0/2
 spanning-tree guard loop
```

**Evidence**

```cisco
show spanning-tree inconsistentports
show spanning-tree vlan 10 detail
show logging | include LOOPGUARD|SPANTREE
```

**Root cause**

Silence on a blocked/alternate path is ambiguous. Treating silence as an inferior neighbor and moving to forwarding could create a loop if only the BPDU direction failed.

**Remediation**

Restore BPDU flow and correct the one-way/control-plane fault. Do not force the port forward.

**Recovery behavior**

Loop-inconsistent clears automatically when valid BPDUs return.

**Takeaway**

Loop Guard protects the topology from “BPDU silence means safe” logic.

## Case 4 — Native VLAN/PVID mismatch

**Symptom**

One or more VLAN instances block on a trunk even though the link is physically up. IOS reports PVID inconsistency.

**Injected fault**

One trunk endpoint was changed to native VLAN 20 while the peer retained its original native VLAN.

```cisco
interface GigabitEthernet0/1
 switchport trunk native vlan 20
```

**Evidence**

```cisco
show interfaces trunk
show interfaces GigabitEthernet0/1 switchport
show spanning-tree inconsistentports
show logging | include PVID|SPANTREE
```

Representative signatures:

```text
%SPANTREE-2-RECV_PVID_ERR: Received BPDU with inconsistent peer vlan id ...
%SPANTREE-2-BLOCK_PVID_LOCAL: Blocking ... on VLAN... Inconsistent local vlan.
```

**Root cause**

Untagged frames and STP BPDUs are being associated with different VLAN identities at opposite ends of the same link.

**Remediation**

Configure the same native VLAN at both ends and verify the allowed VLAN lists.

**Recovery behavior**

The inconsistency clears automatically after consistent BPDUs are exchanged.

**Takeaway**

A trunk can be electrically and administratively up while STP correctly refuses unsafe per-VLAN forwarding.

## Case 5 — RSTP port-type inconsistency

**Symptom**

A point-to-point inter-switch link is blocked as inconsistent after one side is configured with incompatible edge/network semantics.

**Injected fault**

The two ends were deliberately given asymmetric port-type expectations. The final supported network-port form used for Bridge Assurance was:

```cisco
interface GigabitEthernet0/1
 spanning-tree portfast network
```

**Evidence**

```cisco
show spanning-tree inconsistentports
show spanning-tree vlan 10 detail
show running-config interface GigabitEthernet0/1
```

**Root cause**

RSTP’s operational type no longer matches the physical role of the link. Edge is for hosts; network/point-to-point is for compatible bridges.

**Remediation**

Remove edge semantics from switch links and make both endpoints consistent. Reserve `portfast network` for supported network-port/Bridge Assurance designs.

**Recovery behavior**

The STP inconsistency clears after compatible BPDUs and port types return.

**Takeaway**

Port type is a control-plane contract, not a cosmetic label.

## Case 6 — LACP passive/passive produces no Port-channel

**Symptom**

The intended `Port-channel1` is absent or down, and physical links do not appear bundled. STP cannot show the expected logical path.

**Injected fault**

Both endpoints were set to passive:

```cisco
interface range GigabitEthernet0/2-3
 channel-group 1 mode passive
```

**Evidence**

```cisco
show etherchannel summary
show lacp neighbor
show interfaces port-channel 1
show spanning-tree vlan 10
```

**Root cause**

LACP passive mode waits for a peer to initiate. Two passive endpoints never begin negotiation.

**Remediation**

Set at least one side to active; using active/active makes intent explicit.

```cisco
channel-group 1 mode active
```

**Recovery behavior**

After LACP bundles compatible members, STP recalculates using the Port-channel as one logical port.

**Takeaway**

Diagnose bundle formation before diagnosing STP on the bundle.

## Case 7 — EtherChannel member suspended by VLAN-mask mismatch

**Symptom**

One physical member is suspended or excluded; the port-channel has less bandwidth than expected or fails to form.

**Injected fault**

Channel members were given different allowed VLAN lists.

```cisco
interface GigabitEthernet0/2
 switchport trunk allowed vlan 10,20
interface GigabitEthernet0/3
 switchport trunk allowed vlan 10,20,30,40
```

**Evidence**

```cisco
show etherchannel summary
show interfaces trunk
show running-config interface GigabitEthernet0/2
show running-config interface GigabitEthernet0/3
```

**Root cause**

EtherChannel requires compatible Layer 2 parameters across all members. A different VLAN mask would make one logical link behave differently per physical member.

**Remediation**

Normalize member configuration. Apply trunk policy at the Port-channel where supported:

```cisco
interface Port-channel1
 switchport trunk allowed vlan 10,20,30,40
```

**Recovery behavior**

The suspended member rejoins after consistency checks pass; aggregate bandwidth and possibly STP path cost update.

**Takeaway**

Member suspension is loop prevention, not merely an LACP inconvenience.

## Case 8 — EtherChannel/STP misconfiguration guard

**Symptom**

Ports enter an EtherChannel-related STP inconsistency instead of forwarding as separate links.

**Injected fault**

One endpoint treated parallel links as a single channel while the peer treated them independently or used mismatched channel parameters.

**Evidence**

```cisco
show spanning-tree inconsistentports
show etherchannel summary
show running-config interface Port-channel1
show logging | include EC|SPANTREE
```

**Root cause**

The same logical segment is represented differently at each end, producing incompatible BPDU observations and a high loop risk.

**Remediation**

Make channel protocol/mode, member set, trunk mode, native VLAN, allowed VLAN mask, and physical settings identical. Do not disable the misconfiguration guard.

**Recovery behavior**

After consistent bundling, STP sees one Port-channel and recalculates normally.

**Takeaway**

The logical STP topology is only trustworthy when the link-aggregation topology agrees at both ends.

## Case 9 — Root port takes the “wrong” equal-cost path

**Symptom**

Traffic uses a redundant uplink different from the operator’s expectation even though link speed and total root cost appear equal.

**Injected condition**

Two candidate paths were engineered to the same root path cost.

**Evidence**

```cisco
show spanning-tree vlan 10
show spanning-tree vlan 10 detail
```

Compare, in order: root ID, received cost, sender bridge ID, sender port ID, then local port ID.

**Root cause**

STP is deterministic, but the operator stopped at “lowest cost.” The lower sender bridge ID wins an equal-cost neighbor comparison. For parallel links from the same bridge, the lower sender port ID wins.

**Remediation**

Engineer the intended criterion explicitly:

```cisco
interface GigabitEthernet0/0
 spanning-tree vlan 10 cost 20000

interface GigabitEthernet0/1
 spanning-tree vlan 10 port-priority 64
```

Apply port priority on the sender if sender-port-ID is the tie-break being targeted.

**Recovery behavior**

RSTP recalculates and can move the alternate/root roles rapidly when the new vector is superior.

**Takeaway**

“Wrong” usually means the complete BPDU vector was not compared.

## Case 10 — Unexpected root after bridge-priority change

**Symptom**

The displayed priority is not the exact number configured, and the VLAN root moves immediately.

**Injected fault/change**

SW4 VLAN 10 priority was set to 4096.

**Observed evidence**

```text
Root ID Priority 4106
Address 5254.000d.a2e1
This bridge is the root
```

SW2 then reported:

```text
Cost 4
Port 2 (GigabitEthernet0/1)
Gi0/1 Root FWD
```

**Root cause**

The extended system ID adds VLAN 10 to configured priority 4096. The resulting 4106 is lower than the previous root’s bridge ID.

**Remediation**

Restore the intended primary/secondary policy:

```cisco
! SW1
spanning-tree vlan 10,20 priority 24576
! SW4
spanning-tree vlan 10,20 priority 28672
```

**Recovery behavior**

Rapid PVST+ elects the superior root and updates port roles. Edge ports stay outside synchronization.

**Takeaway**

Always interpret bridge priority with the VLAN extended system ID.

## Case 11 — Short/long cost-method mismatch

**Symptom**

Interface costs are numerically different from a reference design, or a path assumed to be equal is not equal.

**Injected condition**

The lab compared short and long path-cost methods; the saved topology standardized on long.

```cisco
spanning-tree pathcost method long
```

**Evidence**

```cisco
show spanning-tree pathcost method
show spanning-tree vlan 10
```

The lab’s GigabitEthernet paths displayed cost 4.

**Root cause**

Different cost scales map bandwidth to different values. Mixing assumptions can undermine intentional equality or preference.

**Remediation**

Standardize the method across the Layer 2 domain and revalidate every manually configured cost.

**Recovery behavior**

STP recalculates based on the new vectors; RSTP role changes follow normal rapid behavior.

**Takeaway**

Cost numbers are meaningful only with their cost method and topology context.

## Case 12 — Bridge Assurance / BPDU loss on a network port

**Symptom**

A physically up network port is held non-forwarding after it stops receiving expected BPDUs.

**Injected fault**

The SW3–SW4 link was configured as a network port on both ends, then BPDU continuity was disrupted.

```cisco
interface GigabitEthernet0/1
 spanning-tree portfast network
```

**Evidence**

```cisco
show spanning-tree inconsistentports
show spanning-tree vlan 10 detail
show logging | include ASSURANCE|SPANTREE
```

Representative signature:

```text
%SPANTREE-2-BRIDGE_ASSURANCE_BLOCK: Blocking port ... due to bridge assurance
```

**Root cause**

A point-to-point network adjacency lost bidirectional BPDU assurance. Forwarding could create a loop if the data plane remains partially available.

**Remediation**

Restore bidirectional BPDU exchange and confirm compatible Bridge Assurance/network-port configuration on both ends.

**Recovery behavior**

The inconsistency clears when expected BPDUs return. Exact behavior depends on platform support; IOSvL2 limitations were noted during this experiment.

**Takeaway**

Bridge Assurance protects the network-port contract in both directions; it is not an access-edge feature.

## Case 13 — BPDU Filter hides the control plane

**Symptom**

A link carries user traffic but stops participating normally in STP; adjacent switches may age out BPDU information and select unsafe roles.

**Injected fault**

Interface-level BPDU Filter was enabled:

```cisco
interface GigabitEthernet0/3
 spanning-tree bpdufilter enable
```

**Evidence**

```cisco
show spanning-tree interface GigabitEthernet0/3 detail
show running-config interface GigabitEthernet0/3
show logging
```

**Root cause**

Filtering suppressed the very control packets STP needs to detect a bridge and prevent a loop.

**Remediation**

Remove interface BPDU Filter. Use BPDU Guard on genuine host edges and allow STP to operate on bridge links.

**Recovery behavior**

Normal elections resume when BPDUs are exchanged; any guard inconsistency downstream clears according to that feature’s rules.

**Takeaway**

BPDU Filter makes a topology quieter, not safer.

## Case 14 — Legacy convergence feature used in the wrong mode

**Symptom**

An operator expects UplinkFast or BackboneFast to explain Rapid PVST+ convergence.

**Injected condition**

Legacy commands and behaviors were reviewed against the final RSTP topology.

**Evidence**

```cisco
show spanning-tree summary
show spanning-tree vlan 10
show running-config | include uplinkfast|backbonefast
```

**Root cause**

UplinkFast and BackboneFast are Cisco enhancements for classic 802.1D/PVST+. RSTP already defines alternate roles, proposal/agreement, and rapid transition behavior.

**Remediation**

Use Rapid PVST+ consistently and troubleshoot its roles/types. Retain knowledge of UplinkFast and BackboneFast for legacy networks and exam recognition.

**Recovery behavior**

No fault recovery is needed; the correction is conceptual and architectural.

**Takeaway**

Do not explain an RSTP event with an inactive legacy mechanism.

## Recovery matrix

| Condition | Typical state | Clears automatically after fault removal? | Primary proof |
|---|---|---:|---|
| Root Guard | root-inconsistent | Yes | `show spanning-tree inconsistentports` |
| Loop Guard | loop-inconsistent | Yes | inconsistent ports + STP detail |
| PVID mismatch | PVID inconsistent | Yes | trunks + logs + inconsistent ports |
| Port-type inconsistency | type inconsistent | Yes | STP detail + interface config |
| Bridge Assurance | BA-inconsistent | Yes, platform dependent | STP detail + logs |
| BPDU Guard | error-disabled | No, unless recovery configured | interface status + errdisable reason |
| UDLD aggressive | error-disabled | Normally requires recovery | `show udld` + errdisable status |
| LACP passive/passive | no bundle | Forms when an active initiator exists | EtherChannel summary + LACP neighbor |
| VLAN-mask mismatch | suspended member | Rejoins after parity | EtherChannel summary + trunks |
| EtherChannel misconfig guard | EC/STP inconsistent | After channel consistency | inconsistent ports + channel summary |

## Closing validation

After any remediation, the case is not closed until all of these are true:

```cisco
show spanning-tree root
show spanning-tree inconsistentports
show spanning-tree vlan 10
show spanning-tree vlan 30
show etherchannel summary
show interfaces trunk
```

The intended roots must be restored, inconsistent ports must be empty, the correct alternate path must remain available, every channel member must be bundled, and the trunk VLAN/native-VLAN contract must match at both ends.

