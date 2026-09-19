# EtherChannel verification guide

These 14 files are the retained final-state evidence set. Read bundle membership, trunk eligibility, spanning-tree state, and endpoint reachability together. The [guided lab narrative](guided-labs.md) covers failure and recovery experiments separately.

## Read the key fields

| Field | Meaning in these captures |
|---|---|
| `Po20(SU)` | A Layer 2 port-channel that is in use |
| Member `(P)` | Bundled into the port-channel |
| Member `(D)`, `(s)`, or `(H)` | Down, suspended, or hot standby respectively; these are different states |
| Trunk allowed/active VLAN lists | Which VLANs the trunk admits and which exist as active VLANs |
| STP `Altn BLK` | Spanning tree has selected this logical link as an alternate, blocked path |
| Ping sent/received counts | Endpoint replies during that specific run; no automatic bandwidth or convergence-time claim |

## Every final-state capture

| Artifact | What it records and why it matters |
|---|---|
| [SW1 bundle summary](EC-SW1-DIST-A-etherchannel-summary.txt) | Po10 static and Po20 LACP both show SU, with two P members each |
| [SW1 trunks](EC-SW1-DIST-A-interfaces-trunk.txt) | Po10/Po20 use native VLAN 99; all five intended VLANs are allowed, active, and forwarding here |
| [SW1 LACP neighbors](EC-SW1-DIST-A-lacp-neighbor.txt) | Both Po20 members identify the same partner; SP flags indicate the partner's slow/passive state |
| [SW1 VLAN database](EC-SW1-DIST-A-vlan-brief.txt) | VLANs 10, 20, 30, and 99 exist and are active on SW1; this is not an all-switch database capture |
| [SW2 bundle summary](EC-SW2-DIST-B-etherchannel-summary.txt) | Static Po10 and PAgP Po30 are SU with both members bundled |
| [SW2 trunks](EC-SW2-DIST-B-interfaces-trunk.txt) | Po30 is trunking with the intended VLAN lists, but its forwarding/not-pruned list is none |
| [SW2 PAgP neighbors](EC-SW2-DIST-B-pagp-neighbor.txt) | Both members identify SW4 and its corresponding Gi0/0–1 partner ports; flags include Auto and Consistent |
| [SW2 Po30 spanning tree](EC-SW2-DIST-B-spanning-tree-Po30.txt) | All five VLANs are Alternate/Blocked on the logical bundle, explaining the empty forwarding list above |
| [SW3 bundle summary](EC-SW3-ACCESS-A-etherchannel-summary.txt) | Po20 is SU with Gi0/0(P) and Gi0/1(P) |
| [SW3 trunks](EC-SW3-ACCESS-A-interfaces-trunk.txt) | Both direct Gi0/2 and logical Po20 have the intended trunk settings and forwarding VLANs |
| [SW3 load-balancing setting](EC-SW3-ACCESS-A-load-balance.txt) | Reports src-dst-ip and the per-protocol address inputs; no traffic counters or throughput measurement |
| [SW4 bundle summary](EC-SW4-ACCESS-B-etherchannel-summary.txt) | PAgP Po30 is SU with both Gi0/0–1 members bundled |
| [SW4 trunks](EC-SW4-ACCESS-B-interfaces-trunk.txt) | Gi0/2 and Po30 use native VLAN 99 and the intended allowed/active VLAN set |
| [PC-A final ping](PC-A-final-ping.txt) | 10/10 replies from 10.10.10.20; min/average/max RTT is 2.390/2.708/3.995 ms |

## A useful comparison: healthy bundle, blocked path

SW2's summary records Po30 in use with both members bundled. Its trunk output records no forwarding VLANs on Po30. The STP capture resolves the apparent contradiction: all five VLANs are Alternate/Blocked on that logical interface.

This is why bundle formation and VLAN forwarding are separate checks. The final successful ping can use an available path without proving every alternate link is carrying traffic.

## Evidence handling

The original text files are unchanged, including chat escapes, partial prompts, and formatting artifacts. Explanations in this guide are editorial context. These captures are separate observations, not a synchronized all-device snapshot.

For failure-specific validation, use the [troubleshooting index](../troubleshooting/README.md). For the selected algorithm's actual CLI choices, see the [capability capture](../troubleshooting/platform-load-balance-options.txt). Neither it nor the final setting establishes per-member load distribution.

## Coverage and boundaries

| Area | What this package supports |
|---|---|
| Static, LACP, and PAgP formation | Saved configurations and final bundle summaries; LACP and PAgP peer captures |
| Direct-trunk failover | Interrupted ping run and MAC learning through Po20 → Po10 → Po30; return to the direct trunk |
| Single LACP member failure | One down member, continued Po20 forwarding, 60/60 failure-run replies, and 75/75 recovery-run replies |
| Member VLAN consistency | Captured configuration change, explicit incompatibility log, suspension, and recovered membership |
| `max-bundle 1` | Captured enable transition, failed endpoint probes, and recovery evidence; internal defect mechanism remains unproven |
| Hashing | CLI lists MAC/IP choices and the final capture selects `src-dst-ip`. The earlier lab summary reported traffic-counter experiments, but those counter captures are absent |
| LACP system priority | Captured removal of priority 1, restored system ID priority 32768, and subsequent link/bundle transitions |
| LACP port priority | Earlier summary reports a selection experiment; no dedicated priority-change capture is retained |
| Negotiation variants and static asymmetry | Earlier summary reports active/active, passive/passive, auto/auto, and asymmetric-static tests; separate raw test records are not included |
| LACP fast rate and Layer 4 hashing | Captured CLI help does not offer these choices in the shown contexts on this image |
| `min-links` and `test etherchannel load-balance` | Unsupported-command reports are retained in the earlier summary only; raw rejection captures are absent |
| Fast switchover and standalone forwarding | Fast switchover was skipped; standalone-disable configuration was inspected, but a standalone forwarding-failure test was not performed |
| Layer 3 EtherChannel | Temporary routed Po40 configuration and removal are captured; no addressed, physically bundled Layer 3 forwarding test |

[Module overview](../README.md) · [Configuration guide](../configs/README.md)
