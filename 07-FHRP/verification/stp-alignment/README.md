# STP and HSRP path alignment

Before, misaligned, and restored VLAN 20 paths, correlated through STP port roles, gateway MAC learning, HSRP state, ping, and traceroute.

## Retained captures

| File | What it records |
|---|---|
| [FHRP-ACCESS-1-and-DIST-A-show-mac-address-table-misaligned.txt](FHRP-ACCESS-1-and-DIST-A-show-mac-address-table-misaligned.txt) | Gateway MAC learned toward DIST-A and across Po10 |
| [FHRP-ACCESS-1-show-mac-address-table-alignment-restored.txt](FHRP-ACCESS-1-show-mac-address-table-alignment-restored.txt) | Gateway MAC returned to the direct Gi0/1 path |
| [FHRP-ACCESS-1-show-spanning-tree-vlan20-aligned.txt](FHRP-ACCESS-1-show-spanning-tree-vlan20-aligned.txt) | VLAN 20 access path before root misalignment |
| [FHRP-ACCESS-1-show-spanning-tree-vlan20-alignment-restored.txt](FHRP-ACCESS-1-show-spanning-tree-vlan20-alignment-restored.txt) | Original access root-port placement restored |
| [FHRP-ACCESS-1-show-spanning-tree-vlan20-misaligned.txt](FHRP-ACCESS-1-show-spanning-tree-vlan20-misaligned.txt) | Access root port moves toward DIST-A |
| [FHRP-DIST-A-and-DIST-B-show-standby-misaligned-path.txt](FHRP-DIST-A-and-DIST-B-show-standby-misaligned-path.txt) | HSRP gateway stays on DIST-B during STP misalignment |
| [FHRP-DIST-A-show-startup-config-vlan20-priority.txt](FHRP-DIST-A-show-startup-config-vlan20-priority.txt) | Saved VLAN 20 STP priority |
| [PC-B-ping-and-traceroute-misaligned-path.txt](PC-B-ping-and-traceroute-misaligned-path.txt) | Client forwarding while Layer 2 and gateway placement differ |

[Verification index](../README.md) · [Source mapping](../source-map.md) · [FHRP overview](../../README.md)
