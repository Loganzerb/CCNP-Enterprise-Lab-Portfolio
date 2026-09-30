# Topology — a direct overlay across two physical links

![GRE underlay and overlay topology](topology.png)

## Physical transport

| Link | First endpoint | Second endpoint | Subnet |
|---|---|---|---|
| R1–R2 | R1 Gi0/0: 192.0.2.1/30 | R2 Gi0/0: 192.0.2.2/30 | 192.0.2.0/30 |
| R2–R3 | R2 Gi0/1: 198.51.100.1/30 | R3 Gi0/0: 198.51.100.2/30 | 198.51.100.0/30 |

R1 has a transport static route to the remote /30 via R2. R3 has a host route to R1’s transport endpoint through R2. R2’s connected routes carry the outer GRE packets; it has no tunnel or OSPF configuration.

## Overlay and test endpoints

| Device | Tunnel0 | Outer source → destination | Loopback0 | OSPF RID |
|---|---|---|---|---|
| R1-GRE | 172.16.13.1/30 | 192.0.2.1 → 198.51.100.2 | 10.1.1.1/24 | 1.1.1.1 |
| R3-GRE | 172.16.13.2/30 | 198.51.100.2 → 192.0.2.1 | 10.3.3.1/24 | 3.3.3.3 |

OSPF process 10 runs in area 0 across Tunnel0. R1 learns R3’s loopback host route as 10.3.3.1/32; that OSPF advertisement differs from the configured /24 loopback mask.

The green overlay line is a logical connection, not an additional physical cable. The actual encapsulated packet follows R1–R2–R3. The illustration’s packet fields explain the sourced ping; they are not a packet capture.

[Original CML baseline](configs/CCNP_GRE_Sept_27th.yaml) · [Configurations](configs/README.md) · [Packet flow](operation.md) · [Overview](README.md)
