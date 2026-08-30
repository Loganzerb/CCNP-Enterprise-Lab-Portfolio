# EtherChannel, Channel Protection, and Bridge Assurance

## Objective

Validate the boundary between physical link aggregation and spanning tree, then protect network-facing links from partial channel formation and silent BPDU loss.

## EtherChannel and STP

When a bundle forms correctly, STP evaluates the Port-channel as one logical interface. It does not block individual forwarding members to break a loop.

```cisco
interface range gigabitEthernet1/0/1-2
 switchport mode trunk
 channel-group 11 mode active

interface port-channel11
 description DSW1 uplink
 switchport mode trunk
 switchport trunk native vlan 999
 switchport trunk allowed vlan 10,20,30,40,999
```

```cisco
show etherchannel summary
show interfaces port-channel11 trunk
show spanning-tree interface port-channel11
```

```text
Group  Port-channel  Protocol  Ports
11     Po11(SU)      LACP      Gi1/0/1(P) Gi1/0/2(P)

VLAN0010  Desg FWD 20000 128.65 P2p
```

`S` and `U` show a Layer 2 Port-channel in use; `(P)` shows bundled members. Suspended, standalone, or individual states must be corrected before interpreting the STP topology.

## Channel consistency and misconfiguration guard

All members need compatible Layer 2 attributes: access/trunk mode, native VLAN, allowed VLAN list, speed/duplex where applicable, and negotiation protocol. Configuration belongs on the Port-channel once formed.

```cisco
spanning-tree etherchannel guard misconfig
show spanning-tree summary
show interfaces status err-disabled
show logging | include EC-|SPANTREE
```

Channel-misconfig guard protects against a topology in which one side treats parallel links as a bundle while the other side treats them as separate STP ports. A detected inconsistency can err-disable affected interfaces rather than risk a loop.

```text
%SPANTREE-2-CHNL_MISCFG: Detected loop due to etherchannel misconfiguration
%PM-4-ERR_DISABLE: channel-misconfig error detected
```

The repair sequence is to align both ends, verify a single logical bundle, and only then recover the interfaces according to the site's err-disable policy.

## Bridge Assurance

Bridge Assurance extends RSTP/MST behavior on supported Cisco platforms. On a network port, both sides continuously exchange BPDUs—even when one side is alternate or discarding. Loss of BPDUs places the affected port in a bridge-assurance inconsistent state instead of allowing it to forward.

```cisco
spanning-tree bridge assurance

interface port-channel11
 spanning-tree portfast network
```

Both ends must support and be configured consistently. `portfast network` identifies a switch-to-switch network port; it does **not** give host-facing edge behavior.

```cisco
show spanning-tree summary
show spanning-tree inconsistentports
show spanning-tree interface port-channel11 detail
```

```text
Name                 Interface       Inconsistency
VLAN0010             Port-channel11  Bridge Assurance Inconsistent
```

### Bridge Assurance versus Loop Guard

| Attribute | Bridge Assurance | Loop Guard |
|---|---|---|
| Expected deployment | Supported point-to-point network ports, both ends | Selected redundant non-designated paths |
| BPDU expectation | Bidirectional on every network port | Continued receipt where BPDUs are expected |
| Typical scope | Link/port protection across instances | Per-instance inconsistency behavior |
| Requirement | Compatible configuration on both peers | Local safeguard |

## Skills demonstrated

- Verified aggregation before drawing conclusions from spanning-tree state.
- Diagnosed channel attribute mismatch and asymmetric bundling risks.
- Explained channel-misconfig guard as a topology-safety mechanism.
- Applied Bridge Assurance only to compatible point-to-point network links.

