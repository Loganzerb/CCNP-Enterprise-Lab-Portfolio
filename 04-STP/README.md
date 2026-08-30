# 04 — Spanning Tree Engineering: PVST+, Rapid PVST+, Protection, and Failure Analysis

This project is the Layer 2 control-plane section of my CCNP Enterprise lab portfolio. It records a multi-session Cisco Modeling Labs investigation into how Cisco spanning tree selects paths, reacts to change, protects the topology, and exposes faults. The work began with a four-switch redundant campus and two access hosts, then added `SW5-ROGUE` as a controlled fault source.

This is not a generic STP command reference. The configuration, bridge IDs, port roles, transition counters, and failure interpretations below come from the lab conversation and the exported CML topology. Where an IOSvL2 image did not expose a feature or a console debug, the text says so explicitly instead of presenting an expected message as captured evidence.

> Scope: PVST+, Rapid PVST+, RSTP mechanics, protection features, path engineering, and EtherChannel interaction. MSTP is intentionally documented as a separate future project and is not built here.

## Project objective

The goal was to move beyond “STP blocks loops” and demonstrate operational control of a redundant Layer 2 domain:

- predict the root, root port, designated port, alternate port, and forwarding state before checking IOS;
- migrate a live per-VLAN topology from classic PVST+ to Rapid PVST+ and distinguish timer-driven from handshake-driven convergence;
- place different VLAN roots deliberately instead of accepting MAC-address elections;
- force every meaningful election tie-breaker: root path cost, sender bridge ID, sender port ID, and local port ID;
- test edge behavior and guard features by injecting the failure each feature is intended to contain;
- distinguish protective inconsistency states from physical-down and error-disabled states;
- reason about STP’s view of an EtherChannel rather than treating member links as independent paths;
- retain a portable CML export so the topology and saved configurations can be audited or replayed.

## Topology

```text
                         SW1-DIST-A
                        /          \
                 Gi0/0 /            \ Gi0/1
                      /              \
             SW2-ACCESS-A -------- SW3-ACCESS-B
              |    \                  /    |
              |     \                /     |
              |      \              /      |
             PC1       SW4-DIST-B          PC2
                         \
                          SW5-ROGUE
```

The exported file contains seven nodes: `SW1-DIST-A`, `SW2-ACCESS-A`, `SW3-ACCESS-B`, `SW4-DIST-B`, `SW5-ROGUE`, `PC1`, and `PC2`. The core four-switch fabric has five redundant trunks. The rogue switch is attached to `SW4` and supplies superior BPDUs, unexpected BPDUs, and controlled trunk faults.

| Link | Purpose |
|---|---|
| SW1 Gi0/0 — SW2 Gi0/0 | Distribution-to-access trunk |
| SW1 Gi0/1 — SW3 Gi0/0 | Distribution-to-access trunk |
| SW2 Gi0/1 — SW4 Gi0/0 | Secondary distribution path |
| SW3 Gi0/1 — SW4 Gi0/1 | Secondary distribution path / network edge testing |
| SW2 Gi0/2 — SW3 Gi0/2 | Access cross-link and alternate-path laboratory |
| SW2 Gi0/3 — PC1 | VLAN 10 edge port |
| SW3 Gi0/3 — PC2 | VLAN 10 edge port |
| SW4 Gi0/2 — SW5 Gi0/0 | Rogue-switch fault-injection trunk |

All switch trunks carry VLANs 10, 20, 30, and 40. DTP is suppressed with `switchport nonegotiate`. The saved host-facing interfaces use `spanning-tree portfast edge` and `spanning-tree bpduguard enable`.

## VLAN and root design

The final saved configuration uses a deterministic, split-root design.

| VLANs | Primary/root preference | Priority | Secondary preference | Priority |
|---|---|---:|---|---:|
| 10, 20 | SW1-DIST-A | 24576 | SW4-DIST-B | 28672 |
| 30, 40 | SW4-DIST-B | 24576 | SW1-DIST-A | 28672 |

This makes the Layer 2 forwarding policy intentional and gives both distribution switches an active role. Because Cisco uses the extended system ID, the value displayed for VLAN 10 is configured priority plus VLAN ID. During a root-change experiment, `SW4` was set to priority 4096 and IOS displayed 4106:

```text
VLAN0010
Spanning tree enabled protocol rstp
Root ID    Priority    4106
Address     5254.000d.a2e1
This bridge is the root
```

`SW2` then selected the direct path to SW4:

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

That capture is important evidence: it ties a configuration change to a new root ID, a new root port, and preserved edge behavior.

## Protocol progression

1. **PVST+ baseline.** Build VLANs and trunks, inspect one 802.1D-derived tree per VLAN, identify the elected root and blocked redundancy, and establish the classic blocking/listening/learning/forwarding model.
2. **Rapid PVST+ migration.** Change the control plane with `spanning-tree mode rapid-pvst`, then verify `protocol rstp`, RSTP roles, `P2p`/`Edge` types, and rapid reconvergence.
3. **Election mechanics.** Change bridge priorities and path costs, then create equal-cost conditions to exercise sender bridge ID and sender port ID tie-breaks.
4. **Root-controlled behavior.** Observe that the active root originates hello, max-age, and forward-delay values distributed in BPDUs; compare those displayed timers with the rapid synchronization mechanism.
5. **Edge and protection.** Validate PortFast/RSTP edge behavior, BPDU Guard, Root Guard, Loop Guard, BPDU Filter, Bridge Assurance concepts, UDLD recognition, and inconsistency states.
6. **Trunk and EtherChannel faults.** Inject native-VLAN/PVID inconsistency, port-type inconsistency, passive/passive LACP, allowed-VLAN mismatch/suspension, and EtherChannel configuration inconsistency.
7. **Path engineering.** Move forwarding decisions with path cost, port priority, sender port ID, bridge priority, and short-versus-long cost methods.
8. **Legacy feature recognition.** Place UplinkFast and BackboneFast in historical context without misrepresenting them as Rapid PVST+ mechanisms.

## Key engineering decisions

### Deterministic roots

Leaving all bridges at priority 32768 makes a hardware MAC address decide the campus root. The lab instead sets primary and secondary distribution priorities explicitly and verifies the effective per-VLAN bridge ID.

### Long path-cost method

Every saved switch uses:

```cisco
spanning-tree pathcost method long
```

The observed GigabitEthernet cost was `4`, consistent with the long method. The lab also compared the shorter legacy scale so a reviewer can interpret outputs from both styles without confusing a numerical difference with a topology change.

### Edge protection at the access boundary

Host ports are optimized and protected as a pair:

```cisco
interface GigabitEthernet0/3
 switchport access vlan 10
 switchport mode access
 spanning-tree portfast edge
 spanning-tree bpduguard enable
```

PortFast/edge reduces host startup delay; BPDU Guard removes the port if the assumption “this is an end host, not a bridge” becomes false.

### A dedicated rogue switch

`SW5-ROGUE` is not decorative. It provides a repeatable source of superior BPDUs and unexpected switch adjacency. This separates protection testing from normal production-like links and makes recovery behavior observable.

### Evidence before conclusions

Every experiment follows the same sequence:

```text
Predict → capture baseline → inject one change → capture evidence
        → identify the decision process → remediate → prove recovery
```

The main evidence set is:

```cisco
show spanning-tree vlan <id>
show spanning-tree vlan <id> detail
show spanning-tree inconsistentports
show interfaces trunk
show interfaces switchport
show etherchannel summary
show lacp neighbor
show logging
show errdisable recovery
```

## Major outcomes

- A live VLAN 10 root move to SW4 was proven by effective priority `4106`, root MAC `5254.000d.a2e1`, and SW2 changing Gi0/1 to `Root FWD` at cost 4.
- RSTP transition counts changed during repeated topology work; SW2 showed two forwarding transitions on Gi0/1 and Gi0/2 and six on the repeatedly exercised edge interface.
- The lab distinguished displayed 2/20/15 timer values from the actual RSTP proposal/agreement and role-based convergence model.
- Root placement was converted from an incidental election into a VLAN-aware design split across SW1 and SW4.
- Faults were categorized by outcome: automatic inconsistency with automatic recovery, error-disable requiring port recovery, protocol suspension, or retained discarding.
- EtherChannel was treated as one logical STP port only after successful bundling; negotiation/configuration failures were diagnosed below the STP layer first.
- Limitations of IOSvL2 were documented. In particular, `debug spanning-tree synchronization` enabled but did not print the proposal/agreement exchange in the tested image, so final roles and transition counters were used as evidence.

## Repository files

- [LAB-NOTES.md](LAB-NOTES.md) — chronological experiment journal, commands, observations, and interpretation.
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) — failure-oriented case studies with injected fault, evidence, root cause, and recovery.
- [CCNP_MASTERCLASS_STP.yaml](CCNP_MASTERCLASS_STP.yaml) — importable Cisco Modeling Labs topology with final saved configurations.

## Replay notes

Import the YAML into CML, start all nodes, and allow the trunks to settle. The export is a final-state artifact, not a snapshot of every temporary fault. Several experiments deliberately changed priorities, guard features, channel modes, VLAN masks, and native VLANs and were then reverted. Use the journal as the runbook and capture a fresh baseline before replaying a fault.

