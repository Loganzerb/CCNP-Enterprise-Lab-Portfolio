# Configurations — healthy baseline and controlled changes

The [original CCNP_GRE_Sept_27th.yaml](CCNP_GRE_Sept_27th.yaml) is preserved unchanged. It contains three IOSv routers, two physical links, Tunnel0 on R1/R3, static transport routes and OSPF process 10 across the overlay. Image definition: `iosv-159-3-m3`.

| Device | Role | Captured configuration |
|---|---|---|
| R1-GRE | Encapsulates traffic toward R3; OSPF RID 1.1.1.1 | [R1-GRE.cfg](R1-GRE.cfg) |
| R2-TRANSIT | Routes outer transport packets between connected networks | [R2-TRANSIT.cfg](R2-TRANSIT.cfg) |
| R3-GRE | Terminates the remote tunnel; OSPF RID 3.3.3.3 | [R3-GRE.cfg](R3-GRE.cfg) |

The `.cfg` files are extracted device records, including export preambles and IOS defaults. They are not cleaned deployment templates. The fault states are separate from this healthy baseline.

The source YAML's R3 display label has a trailing space. Its original label is preserved in the export; the extracted configuration filename uses the device hostname, `R3-GRE`.

## Important settings

| Setting | R1 | R3 |
|---|---|---|
| Tunnel0 address | 172.16.13.1/30 | 172.16.13.2/30 |
| Tunnel source | 192.0.2.1 | 198.51.100.2 |
| Tunnel destination | 198.51.100.2 | 192.0.2.1 |
| Underlay static route | 198.51.100.0/30 via 192.0.2.2 | 192.0.2.1/32 via 198.51.100.1 |
| Loopback0 | 10.1.1.1/24 | 10.3.3.1/24 |
| OSPF | Process 10, RID 1.1.1.1, area 0 | Process 10, RID 3.3.3.3, area 0 |

The export uses tunnel source/destination commands and the image’s default GRE/IP mode. Actual `show interfaces Tunnel0` verifies GRE/IP rather than assuming the mode from omitted defaults. No GRE keepalive, key, sequence or checksum is configured.

The loopbacks retain their original **/24 interface masks**. OSPF advertises the loopback host address as a **/32**, matching the learned route; the export has not been silently changed to /32 addressing.

[Fault and repair commands](faults.md) · [Topology and wiring](../topology.md) · [Verification](../verification/README.md) · [GRE overview](../README.md)
