# EtherChannel configuration guide

These four text files preserve the switch configurations supplied with the portfolio. They were extracted from the embedded configuration blocks in [CML-LAB.yaml](../CML-LAB.yaml), with YAML indentation removed. They represent the final exported state, including platform boilerplate.

## Choose a device

| Configuration | Role and settings to inspect | Corroborating output |
|---|---|---|
| [EC-SW1-DIST-A](EC-SW1-DIST-A-running-config.txt) | Joins SW2 through static Po10 and SW3 through LACP Po20. Gi0/2–3 initiate LACP in active mode. | [Bundle membership](../verification/EC-SW1-DIST-A-etherchannel-summary.txt), [LACP partner](../verification/EC-SW1-DIST-A-lacp-neighbor.txt) |
| [EC-SW2-DIST-B](EC-SW2-DIST-B-running-config.txt) | Joins SW1 through static Po10 and SW4 through PAgP Po30. Gi0/2–3 use desirable mode. | [Bundle membership](../verification/EC-SW2-DIST-B-etherchannel-summary.txt), [PAgP partner](../verification/EC-SW2-DIST-B-pagp-neighbor.txt) |
| [EC-SW3-ACCESS-A](EC-SW3-ACCESS-A-running-config.txt) | Uses passive LACP members Gi0/0–1, a direct Gi0/2 trunk to SW4, and a VLAN 10 access port for PC-A. | [Bundle membership](../verification/EC-SW3-ACCESS-A-etherchannel-summary.txt), [Trunks](../verification/EC-SW3-ACCESS-A-interfaces-trunk.txt) |
| [EC-SW4-ACCESS-B](EC-SW4-ACCESS-B-running-config.txt) | Uses auto-mode PAgP members Gi0/0–1 and a direct Gi0/2 trunk. Vlan10 at 10.10.10.20 is the test destination. | [Bundle membership](../verification/EC-SW4-ACCESS-B-etherchannel-summary.txt), [Endpoint replies](../verification/PC-A-final-ping.txt) |

## How the configuration relates to behavior

- **Port-channel interfaces describe the logical trunk.** The physical members also retain trunk settings and a `channel-group` assignment.
- **VLAN policy is consistent across the intended infrastructure trunks:** native VLAN 99 and allowed VLANs `1,10,20,30,99`. The [VLAN mismatch case](../troubleshooting/case-01-vlan-mask-mismatch.md) shows the consequence of changing only one member.
- **Classic PVST is configured on all four switches.** The final [SW2 Po30 output](../verification/EC-SW2-DIST-B-spanning-tree-Po30.txt) shows spanning tree blocking the logical bundle while its members remain bundled.
- **SW3's client-facing port uses access VLAN 10, PortFast edge, and BPDU Guard.** The endpoint connects outside the infrastructure bundles.
- **SW4 Vlan10 supplies the target address.** The unused PC-B position in the diagram is not an additional node in the export.

## Final state versus temporary experiments

The exported SW1/SW3 Po20 configurations do not retain a `lacp max-bundle` override. SW3's restored VLAN list includes VLAN 99, and temporary Po40 is absent. These final settings support configuration review but do not establish the exact order of prior repairs.

The separate [load-balancing capture](../verification/EC-SW3-ACCESS-A-load-balance.txt) reports `src-dst-ip`. The configuration extracts do not explicitly print that command; an omitted default should not be rewritten into the original files as though it was captured.

For replay, use the complete [CML export](../CML-LAB.yaml), which also contains PC-A and the wiring. Confirm image mappings and VLAN creation after import. The retained configuration text includes console headers and platform boilerplate and should be read as an exported artifact.

## Reuse the lab

Import [CML-LAB.yaml](../CML-LAB.yaml) into a separate lab and check its image mappings: the export uses `iosvl2-2020` switches and a `desktop-3-13-2-xfce` endpoint. Verify VLANs, interface mappings, PC-A addressing, and SW4's VLAN 10 interface before testing. The saved switch blocks do not contain explicit VLAN-creation stanzas; confirm the VLAN database after import.

Start with the [final-state checks](../verification/README.md), then reproduce a documented experiment. The export is the final saved lab, not a pre-fault snapshot for either case.

[Module overview](../README.md) · [Verification guide](../verification/README.md) · [Troubleshooting](../troubleshooting/README.md)
