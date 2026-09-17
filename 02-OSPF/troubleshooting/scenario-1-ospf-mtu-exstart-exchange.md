# Case 01 — Repair OSPF while ping still works

O2 could ping O4 successfully, but their OSPF relationship stalled before the routers could synchronize routing information. The physical interface view looked consistent. The IP-specific view revealed a one-sided MTU override, and removing it restored the adjacency.

## Expected behavior and fault

O2-ABR Gi0/2 (`10.100.24.1/30`) connects to O4-EDGE Gi0/0 (`10.100.24.2/30`) in Area 10. The healthy adjacency is `FULL`, with O4 as designated router and O2 as backup.

The controlled fault set `ip mtu 1400` on O2's interface and bounced that interface. Its physical MTU remained 1500. The original record describes both neighbors stalling in `EXSTART`; the retained failure-state neighbor excerpt is from O4.

[Fault commands](../verification/incidents/scenario-1-ospf-mtu-exstart-exchange.md#block-1) · [O4's stalled neighbor](../verification/incidents/scenario-1-ospf-mtu-exstart-exchange.md#block-2)

## How I isolated the cause

| Check | Captured result | Why it mattered |
|---|---|---|
| Ping from O2 to O4 | **5/5 replies**, using 100-byte probes | Basic IP connectivity worked despite the OSPF failure |
| `show interfaces` on both ends | MTU 1500 | This view did not expose O2's IP override |
| `show ip interface` on O2 | IP MTU 1400 | Revealed the effective Layer 3 setting |
| O2's interface configuration | `ip mtu 1400` | Identified the source of the mismatch |
| O4's OSPF debug excerpt | Received DBD with MTU 1400; smaller-neighbor-MTU message; retransmission | Connected the setting to database-description negotiation |

[Ping and MTU comparisons](../verification/incidents/scenario-1-ospf-mtu-exstart-exchange.md#block-3) · [Debug excerpt](../verification/incidents/scenario-1-ospf-mtu-exstart-exchange.md#block-7)

The small ping proved that those probes could cross the link. It did not test database synchronization or full-size packet handling.

## Repair and verification

I removed the override with `no ip mtu` on O2 Gi0/2. The documented repair did not clear the OSPF process or bounce the interface again.

| Post-change check | Captured result |
|---|---|
| O2 IP MTU | 1500 bytes |
| O2's neighbor view of O4 | `FULL`, retransmission queue length 0 |
| O4's neighbor view of O2 | `FULL`, retransmission queue length 0 |
| DR/BDR roles | O4 remained DR; O2 remained BDR |

[Repair commands](../verification/incidents/scenario-1-ospf-mtu-exstart-exchange.md#block-8) · [Recovery output from both devices](../verification/incidents/scenario-1-ospf-mtu-exstart-exchange.md#block-9)

The evidence establishes adjacency recovery. No timed convergence measurement or post-repair application test was retained.

## Engineering takeaway

Different commands can describe different settings on the same interface. Comparing the physical MTU, effective IP MTU, configuration, and protocol debug exposed a mismatch that successful ping and the standard interface view had missed.

[All original excerpts and commands](../verification/incidents/scenario-1-ospf-mtu-exstart-exchange.md) · [Case index](README.md)
