# EtherChannel topology and interfaces

![EtherChannel lab topology](topology.png)

SW1–SW4 below abbreviate the `EC-SW1-DIST-A`, `EC-SW2-DIST-B`, `EC-SW3-ACCESS-A`, and `EC-SW4-ACCESS-B` device names.

| Connection | Member interfaces | Final configuration |
|---|---|---|
| Static Po10: SW1 ↔ SW2 | Gi0/0 and Gi0/1 on both switches | `on` ↔ `on` |
| LACP Po20: SW1 ↔ SW3 | SW1 Gi0/2–3; SW3 Gi0/0–1 | SW1 `active`; SW3 `passive` |
| PAgP Po30: SW2 ↔ SW4 | SW2 Gi0/2–3; SW4 Gi0/0–1 | SW2 `desirable`; SW4 `auto` |
| Direct trunk: SW3 ↔ SW4 | Gi0/2 on both switches | Independent 802.1Q trunk |
| PC-A ↔ SW3 | PC-A eth0; SW3 Gi0/3 | Access VLAN 10 |

Infrastructure trunks use native VLAN 99 and allow VLANs `1,10,20,30,99`. The saved switch configurations use **classic PVST**, rather than Rapid PVST+.

PC-A is `10.10.10.10/24`. Tests target SW4's VLAN 10 switch interface at `10.10.10.20/24`. PC-B appears in the supplied diagram as an unused endpoint position; it is absent from the [final CML export](CML-LAB.yaml). The diagram provides design context, not additional experimental proof.

[Configuration guide](configs/README.md) · [Module overview](README.md)
