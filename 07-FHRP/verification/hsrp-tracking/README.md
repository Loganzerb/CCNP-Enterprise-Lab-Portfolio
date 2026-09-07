# HSRP upstream tracking and recovery  Untracked upstream failure, effective-priority reduction, alternate forwarding, and recovery ordering with and without preemption delay. Packet loss remains visible in the original captures.  ## Retained captures  | File | What it records | |---|---|
| [FHRP-DIST-A-and-PC-A-recovery-with-preemption-delay.txt](FHRP-DIST-A-and-PC-A-recovery-with-preemption-delay.txt) | OSPF FULL precedes delayed HSRP recovery; client loss retained |
| [FHRP-DIST-A-and-PC-A-recovery-without-preemption-delay.txt](FHRP-DIST-A-and-PC-A-recovery-without-preemption-delay.txt) | HSRP recovery precedes OSPF FULL; client loss retained |
| [FHRP-DIST-A-and-PC-A-tracked-uplink-failure.txt](FHRP-DIST-A-and-PC-A-tracked-uplink-failure.txt) | Tracked failure with client packet loss retained |
| [FHRP-DIST-A-and-PC-A-untracked-upstream-black-hole.txt](FHRP-DIST-A-and-PC-A-untracked-upstream-black-hole.txt) | Active gateway without upstream route and failed client probes |
| [FHRP-DIST-A-show-track-and-standby-uplink-down.txt](FHRP-DIST-A-show-track-and-standby-uplink-down.txt) | Tracking lowers effective HSRP priority to 99 |
| [PC-A-ping-and-traceroute-preferred-path-restored.txt](PC-A-ping-and-traceroute-preferred-path-restored.txt) | Final steady-state forwarding through DIST-A |
| [PC-A-ping-and-traceroute-tracking-failover.txt](PC-A-ping-and-traceroute-tracking-failover.txt) | Client forwarding through DIST-B with DIST-A uplink down |

The `.txt` contents are unchanged from the supplied FHRP archive. File names and surrounding explanations are editorial labels; they do not add measured output.

[Verification index](../README.md) · [Source mapping](../source-map.md) · [FHRP overview](../../README.md)
