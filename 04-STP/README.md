# 04 — Spanning Tree Protocol Masterclass

## Project objective

This project is an evidence-driven Layer 2 engineering lab built in Cisco Modeling Labs (CML). It documents how a redundant campus switching topology was designed, verified, intentionally broken, diagnosed, and recovered using Rapid PVST+, classic STP behavior, protection features, path engineering, EtherChannel, and Bridge Assurance.

The repository preserves the actual CML topology and final switch configurations. Raw CLI captures are included only where an exact lab output was retained; scenario write-ups clearly distinguish captured evidence from observed behavior.

> MSTP is intentionally excluded. It is a separate portfolio project.

## Topology

```text
                 SW1-DIST-A
                /          \
       SW2-ACCESS-A ------ SW3-ACCESS-B
                \          /
                 SW4-DIST-B
                    ||
                 SW5-ROGUE

PC1 attaches to SW2. PC2 attaches to SW3.
SW4–SW5 uses two parallel links in the saved topology.
```

The authoritative node/interface mapping is in [CCNP_MASTERCLASS_STP.yaml](CCNP_MASTERCLASS_STP.yaml). The lab contains five IOSvL2 switches and two endpoint nodes.

## VLAN and root design

All production trunks carry VLANs 10, 20, 30, and 40. The saved final configuration uses Rapid PVST+ and the long path-cost method on every switch.

| VLANs | Primary root | Saved priority | Secondary distribution switch | Saved priority |
|---|---|---:|---|---:|
| 10, 20 | SW1-DIST-A | 24576 | SW4-DIST-B | 28672 |
| 30, 40 | SW4-DIST-B | 24576 | SW1-DIST-A | 28672 |

The design deliberately splits root ownership across the two distribution switches. VLAN-specific root placement gives deterministic forwarding and demonstrates that Rapid PVST+ can select different logical topologies over the same physical fabric.

## Protocol progression

1. Built redundant 802.1Q trunks and verified VLAN propagation.
2. Examined bridge IDs, root elections, Root Ports, Designated Ports, and Alternate Ports.
3. Compared classic 802.1D timer-driven convergence with Rapid PVST+ proposal/agreement behavior.
4. Engineered root placement and alternate paths with bridge priority, path cost, and port priority.
5. Tested PortFast edge behavior and BPDU Guard against SW5 acting as a rogue switch.
6. Forced and recovered Root Guard and Loop Guard inconsistency states.
7. Diagnosed native VLAN/PVID and port-type inconsistencies.
8. Converted parallel physical trunks into an LACP Port-Channel and observed STP operate on the logical interface.
9. Broke LACP negotiation, member consistency, VLAN masks, and EtherChannel misconfiguration guard.
10. Enabled Bridge Assurance network-port behavior and forced a Bridge Assurance inconsistency.
11. Standardized the final topology on the long STP path-cost method.

## Major verified outcomes

- SW1 is the VLAN 10/20 root and SW4 is the VLAN 30/40 root in the saved configuration.
- SW3 VLAN 10 selected `Gi0/0` as `Root FWD`; an equal-cost redundant link remained `Altn BLK`.
- Switching from short to long path costs changed 1-Gb costs from `4` to `20000` without changing election logic.
- Before aggregation, SW5 exposed two parallel trunks: one Root Forwarding and one Alternate Blocking.
- After LACP formed, STP saw `Po1` as the Root Port, not the two individual member links.
- Losing one EtherChannel member kept `Po1` operational and changed its STP cost from `3` to `4`.
- Passive/passive LACP suspended both members and dropped the logical channel.
- Protection failures produced distinct operational states: `err-disabled`, `root-inconsistent`, `loop-inconsistent`, port-type/PVID inconsistency, suspended EtherChannel members, and Bridge Assurance inconsistency.

## Troubleshooting highlights

| Failure | Evidence/indicator | Operational lesson |
|---|---|---|
| BPDU Guard | Edge port err-disabled after rogue BPDU | Any BPDU is unacceptable on a protected edge port. |
| Root Guard | `root-inconsistent` | Superior BPDUs are blocked without err-disabling the interface. |
| Loop Guard | `loop-inconsistent` after expected BPDUs stopped | Prevents an unsafe non-designated-to-forwarding transition. |
| Native VLAN mismatch | PVID/native VLAN inconsistency | Control-plane inconsistency can block affected VLANs even when the trunk is physically up. |
| Trunk/access mismatch | Port Type Inconsistent | Both ends of an infrastructure link must agree on Layer 2 role. |
| EtherChannel VLAN mask | Member suspended | Bundle members must share compatible trunk attributes. |
| Misconfig guard | Member err-disabled | Parallel links must not be bundled toward different logical partners. |
| Bridge Assurance | `*BA_Inc` / inconsistent blocking | Network ports require continuous bidirectional BPDU participation. |

See [troubleshooting/README.md](troubleshooting/README.md) for the full case index.

## Repository map

```text
04-STP/
├── README.md
├── CCNP_MASTERCLASS_STP.yaml
├── configs/
│   ├── README.md
│   └── SW*.cfg
├── verification/
│   ├── README.md
│   ├── root-election/
│   ├── convergence/
│   ├── protection/
│   ├── path-engineering/
│   ├── etherchannel/
│   └── bridge-assurance/
└── troubleshooting/
    ├── README.md
    └── scenario-*.md
```

## Primary commands used

```text
show spanning-tree vlan 10
show spanning-tree detail
show spanning-tree interface <interface> detail
show spanning-tree inconsistentports
show spanning-tree summary
show interfaces trunk
show interfaces status err-disabled
show etherchannel summary
show interfaces port-channel 1
show running-config interface <interface>
show logging
```

## Skills demonstrated

- Deterministic per-VLAN root design
- Bridge-ID and port-role analysis
- Classic STP and Rapid STP convergence reasoning
- Root-path cost and port-ID tie-break analysis
- Safe edge-port configuration
- BPDU Guard, Root Guard, Loop Guard, and Bridge Assurance operations
- Trunk consistency and PVID diagnosis
- LACP formation and EtherChannel/STP interaction
- Failure injection, evidence collection, remediation, and post-change verification

## Reproducing the lab

Import `CCNP_MASTERCLASS_STP.yaml` into a compatible CML environment. Review the embedded node definitions and images before launch. The `.cfg` files in `configs/` are extracted snapshots from that YAML, not a promise that every intermediate failure state remains active in the saved topology.
