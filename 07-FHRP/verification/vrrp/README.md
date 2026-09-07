# VRRP election, tracking, and recovery  VLAN 20 Master/Backup election, interface failure, tracked priority reduction, and recovery ordering relative to OSPF. These captures cover different experiment stages.  ## Retained captures  | File | What it records | |---|---|
| [FHRP-DIST-A-and-DIST-B-vrrp-election-and-baseline.txt](FHRP-DIST-A-and-DIST-B-vrrp-election-and-baseline.txt) | VRRP configuration, election and stable Master/Backup roles |
| [FHRP-DIST-A-and-PC-B-gateway-interface-failover.txt](FHRP-DIST-A-and-PC-B-gateway-interface-failover.txt) | DIST-A Master state and converged client forwarding |
| [FHRP-DIST-B-and-PC-B-delayed-recovery-logs-and-ping.txt](FHRP-DIST-B-and-PC-B-delayed-recovery-logs-and-ping.txt) | Delayed VRRP recovery ordering and combined client ping capture |
| [FHRP-DIST-B-and-PC-B-tracked-uplink-failover.txt](FHRP-DIST-B-and-PC-B-tracked-uplink-failover.txt) | VRRP priority decrement and converged client forwarding |
| [FHRP-DIST-B-show-vrrp-preemption-delay.txt](FHRP-DIST-B-show-vrrp-preemption-delay.txt) | Master state with a 10-second preemption delay |
| [FHRP-DIST-B-uplink-recovery-without-preemption-delay.txt](FHRP-DIST-B-uplink-recovery-without-preemption-delay.txt) | VRRP Master transition precedes OSPF FULL |

The `.txt` contents are unchanged from the supplied FHRP archive. File names and surrounding explanations are editorial labels; they do not add measured output.

[Verification index](../README.md) · [Source mapping](../source-map.md) · [FHRP overview](../../README.md)
