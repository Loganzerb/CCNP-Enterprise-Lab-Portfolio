# NTP topology and addressing

![NTP lab topology](topology.png)

Four routers and one Layer 2 switch form two IP networks. The graphic shows physical wiring and includes the Loopback0 address added in the later troubleshooting exercises.

## Physical links

| Endpoint | Endpoint | Network |
|---|---|---|
| R1 Gi0/0 — 10.12.0.1/30 | R2 Gi0/0 — 10.12.0.2/30 | 10.12.0.0/30 |
| R2 Gi0/1 — 10.20.0.1/24 | SW1 Gi0/0 | VLAN 1, 10.20.0.0/24 |
| R3 Gi0/0 — 10.20.0.3/24 | SW1 Gi0/1 | VLAN 1, 10.20.0.0/24 |
| R4 Gi0/0 — 10.20.0.4/24 | SW1 Gi0/2 | VLAN 1, 10.20.0.0/24 |

SW1 Gi0/3 is unused and shut down. [CDP neighbors](verification/01-hierarchy.md#block-07) and [switch port state](verification/01-hierarchy.md#block-08) corroborate the exported wiring. SW1 does not participate in the NTP hierarchy.

## Timing relationships

| Stage | Selected source path | Recorded local strata |
|---|---|---|
| Initial hierarchy | R1 → R2 → R3 | 1 → 2 → 3 |
| Backup operation | R4 → R2 → R3 | 3 → 4 → 5 |

The arrows mean “supplies time to”; they are not extra cables. R2's exchanges with R4 and R3 cross SW1. R3 has only R2 configured as its time server.

## Routing and source address

The export contains R1's route to 10.20.0.0/24 through 10.12.0.2. R3 and R4 have default routes through 10.20.0.1.

Later, R3 gained Loopback0 **3.3.3.3/32** and used it as its NTP source. R2 needed a route to that address through **10.20.0.3**. The subsequent ACL exercise applied a temporary filter inbound on **R2 Gi0/1**, where R3's traffic arrived.

The supplied export predates these later changes. Use the [configuration guide](configs/README.md) to choose the intended stage.

[Back to NTP](README.md)
