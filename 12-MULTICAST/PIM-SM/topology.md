# PIM-SM topology and addressing

The diamond separates the path toward the Rendezvous Point from the baseline path toward the source. All six nodes are IOSv; the two endpoints use `no ip routing` and a default gateway.

![Static-RP multicast topology](topology.png)

## Auto-RP phase

The physical diagram above depicts the original static-RP baseline. Auto-RP retains the same wiring and RP address: R2 becomes the Candidate RP and R3 the Mapping Agent. R3 still carries the native source-tree traffic through Gi0/1 toward R4. [Discovery roles and control-message flow](auto-rp.md#same-topology-separate-discovery-roles)

## Wiring

| Endpoint A | Interface and address | Endpoint B | Interface and address | Subnet |
|---|---|---|---|---|
| MCAST-SOURCE | Gi0/0 — 10.1.1.10 | R1-FHR | Gi0/0 — 10.1.1.1 | 10.1.1.0/24 |
| R1-FHR | Gi0/1 — 10.12.0.1 | R2-RP | Gi0/0 — 10.12.0.2 | 10.12.0.0/30 |
| R1-FHR | Gi0/2 — 10.13.0.1 | R3-TRANSIT | Gi0/0 — 10.13.0.2 | 10.13.0.0/30 |
| R2-RP | Gi0/1 — 10.24.0.1 | R4-LHR | Gi0/1 — 10.24.0.2 | 10.24.0.0/30 |
| R3-TRANSIT | Gi0/1 — 10.34.0.1 | R4-LHR | Gi0/2 — 10.34.0.2 | 10.34.0.0/30 |
| R4-LHR | Gi0/0 — 10.4.4.1 | MCAST-RECEIVER | Gi0/0 — 10.4.4.10 | 10.4.4.0/24 |

R2's Loopback0 is `2.2.2.2/32`. OSPF router IDs are `1.1.1.1` through `4.4.4.4`; only R2's RP address requires a loopback in this baseline.

## Why the paths differ

R4's Gi0/1 has OSPF cost 2. The captured routing table shows a single path toward the source LAN through R3 and a path toward the RP directly through R2, both with metric 3.

| R4 lookup | Incoming direction selected | Supporting capture |
|---|---|---|
| Source 10.1.1.10 | Gi0/2, neighbor 10.34.0.1 | [Source RPF](verification/01-baseline.md#block-14) |
| RP 2.2.2.2 | Gi0/1, neighbor 10.24.0.1 | [RP RPF](verification/01-baseline.md#block-15) |

The resulting source-tree path is **Source → R1 → R3 → R4 → Receiver**. The receiver's shared-tree branch runs **R2 → R4 → Receiver**. The diagram shows this baseline; [Case 01](troubleshooting/01-rpf-path-change.md) temporarily moves the source path through R2.

## Test groups

| Group | Use | State at checkpoint |
|---|---|---|
| 239.1.1.1 | Baseline membership and RPF exercise | Receiver join retained |
| 239.2.2.2 | Receiver-side RP fault | Temporary join removed |
| 239.3.3.3 | Source-side RP fault | Temporary join removed |

The static RP mapping covers the multicast range in this isolated lab. The group-specific tests above are the scope of the evidence.

[Back to PIM-SM](README.md)

