# STP Path Engineering and Legacy Convergence

## Objective

Control the forwarding topology predictably with root placement, interface cost, and port priority, while recognizing legacy convergence features that may still appear in existing networks or exams.

## Engineering hierarchy

The cleanest design establishes the root bridge first. Interface tuning is then used for a documented exception—not to compensate for accidental root placement.

```cisco
! Primary and secondary root placement
spanning-tree vlan 10,20 priority 24576
spanning-tree vlan 30,40 priority 28672

! Make this uplink less preferred for VLANs 10 and 20
interface port-channel12
 spanning-tree vlan 10,20 cost 40000

! Resolve equal upstream information by sender Port ID
interface gigabitEthernet1/0/2
 spanning-tree vlan 10,20 port-priority 64
```

Cost is evaluated before port priority. A port-priority change has no effect unless the earlier comparison fields tie. Port priority is encoded in the Port ID and normally changes in increments supported by the platform.

## Short and long path-cost methods

```cisco
spanning-tree pathcost method long
show spanning-tree pathcost method
```

Representative values:

| Link speed | Short method | Long method |
|---:|---:|---:|
| 100 Mb/s | 19 | 200,000 |
| 1 Gb/s | 4 | 20,000 |
| 10 Gb/s | 2 | 2,000 |
| 100 Gb/s | 1 | 200 |

The long method differentiates modern link speeds better. All switches in the Layer 2 domain should use a consistent method; otherwise operators can misread path decisions and custom values may not express the same intent.

```cisco
ASW1# show spanning-tree vlan 10
Interface        Role Sts Cost      Prio.Nbr Type
Po11             Root FWD 20000     128.65   P2p
Po12             Altn BLK 40000     128.66   P2p
```

## Port-priority tie-break lab

Two parallel non-bundled links advertise identical root, cost, and sender bridge information. The upstream sender Port ID decides which BPDU is superior. If the same sender port is observed through a shared-media condition, the local receiving Port ID is the final tie-break.

```cisco
! Upstream switch influences the neighbor's selection
interface gigabitEthernet1/0/1
 spanning-tree vlan 10 port-priority 64
```

Verification must be performed on both ends so the configured field is not confused with the local port priority displayed by the receiving switch.

## UplinkFast and BackboneFast recognition

These are legacy Cisco enhancements for 802.1D environments:

- **UplinkFast** accelerates failover from a failed Root Port to a blocked redundant uplink on an access switch. It also modifies bridge priority and port costs, so it should not be enabled casually.
- **BackboneFast** accelerates recovery from an indirect link failure by using Root Link Query messages rather than waiting the full Max Age.

```cisco
! Legacy recognition only; not required by RSTP
spanning-tree uplinkfast
spanning-tree backbonefast
show spanning-tree backbonefast
```

Rapid PVST+ incorporates rapid alternate-port and inferior-information handling, making these 802.1D optimizations unnecessary in a modern rapid-mode design.

## Validation procedure

```cisco
show spanning-tree root
show spanning-tree vlan 10
show spanning-tree interface port-channel12 cost
show running-config interface port-channel12
```

1. Confirm the intended root and secondary root.
2. Calculate the expected cumulative cost from each candidate path.
3. Check the sender bridge and port tie-breakers if cost ties.
4. Shut only the lab link under test and record convergence.
5. Restore it and confirm the preferred steady-state topology returns.

## Skills demonstrated

- Built deterministic per-VLAN forwarding paths from election and cost inputs.
- Used long path costs appropriate to high-speed campus links.
- Distinguished local and sender Port ID effects in equal-cost designs.
- Recognized UplinkFast and BackboneFast without importing obsolete behavior into RSTP.

