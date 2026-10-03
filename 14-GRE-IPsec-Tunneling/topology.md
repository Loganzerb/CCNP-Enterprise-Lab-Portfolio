# Topology — one WAN, two VPN implementations

![Shared VPN topology](topology-vti.png)

## Addressing and roles

| Device | Interface | Address | Role |
|---|---|---|---|
| R1-VPN | Gi0/0 | 192.0.2.1/30 | WAN/VPN endpoint |
| R1-VPN | Loopback0 | 10.10.10.1/24 | Private site A test endpoint |
| R1-VPN | Tunnel0 | 172.16.13.1/30 | GRE overlay or VTI, depending on the stage |
| R2-TRANSIT | Gi0/0 | 192.0.2.2/30 | Transit toward R1 |
| R2-TRANSIT | Gi0/1 | 198.51.100.1/30 | Transit toward R3 |
| R3-VPN | Gi0/0 | 198.51.100.2/30 | WAN/VPN endpoint |
| R3-VPN | Loopback0 | 10.30.30.1/24 | Private site B test endpoint |
| R3-VPN | Tunnel0 | 172.16.13.2/30 | GRE overlay or VTI, depending on the stage |

## Physical transport

| Link | Endpoint A | Endpoint B | Subnet |
|---|---|---|---|
| R1–R2 | R1 Gi0/0 | R2 Gi0/0 | 192.0.2.0/30 |
| R2–R3 | R2 Gi0/1 | R3 Gi0/0 | 198.51.100.0/30 |

R1's static route reaches 198.51.100.0/30 through 192.0.2.2. R3's static route reaches 192.0.2.0/30 through 198.51.100.1. R2 carries the outer packets using its connected routes and has no tunnel, IPsec, or OSPF process.

## Logical tunnel and routing

The designs were tested sequentially, using the same Tunnel0 addresses. In the classic stage, GRE carries OSPF and private traffic, and transport-mode IPsec protects GRE. In the VTI stage, Tunnel0 uses `tunnel mode ipsec ipv4` and profile-based tunnel-mode protection.

VTI OSPF process 10 runs in area 0 across 172.16.13.0/30, with router IDs 1.1.1.1 and 3.3.3.3. Each loopback is configured with a /24 mask but advertised as an OSPF /32 host route.

[Saved VTI configuration](configs/vti.md) · [Classic topology illustration](topology.png) · [Packet flow](operation.md) · [Overview](README.md)
