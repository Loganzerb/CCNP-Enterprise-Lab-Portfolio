# GLBP AVG and AVF failover  Gateway election, inherited-forwarder service, client ARP continuity, ping results, and independent AVG/AVF recovery.  ## Retained captures  | File | What it records | |---|---|
| [GLBP-R1-show-glbp-brief-avf2-restored.txt](GLBP-R1-show-glbp-brief-avf2-restored.txt) | AVF2 returned to R2 |
| [GLBP-R1-show-glbp-brief-avf3-takeover.txt](GLBP-R1-show-glbp-brief-avf3-takeover.txt) | R1 view of R2 taking AVF3 |
| [GLBP-R2-show-glbp-avf3-takeover.txt](GLBP-R2-show-glbp-avf3-takeover.txt) | R2 services inherited AVF3 |
| [GLBP-R2-show-glbp-brief-avf3-restored.txt](GLBP-R2-show-glbp-brief-avf3-restored.txt) | R2 view after AVF3 returned to R3 |
| [GLBP-R2-show-glbp-brief-avg-failure.txt](GLBP-R2-show-glbp-brief-avg-failure.txt) | R2 becomes AVG while R3 takes AVF1 |
| [GLBP-R2-show-glbp-brief-r1-returned-without-avg-preemption.txt](GLBP-R2-show-glbp-brief-r1-returned-without-avg-preemption.txt) | R1 reclaimed AVF1 while R2 remained AVG |
| [GLBP-R3-show-glbp-avf2-takeover.txt](GLBP-R3-show-glbp-avf2-takeover.txt) | R3 services inherited AVF2 |
| [HOST-A-and-GLBP-R1-ping-arp-and-avf2-takeover.txt](HOST-A-and-GLBP-R1-ping-arp-and-avf2-takeover.txt) | HOST-A ping and ARP with R1 view of AVF2 takeover |
| [HOST-A-ping-during-avg-failure.txt](HOST-A-ping-during-avg-failure.txt) | HOST-A ping result during AVG failure |
| [HOST-A-show-arp-after-avf2-recovery.txt](HOST-A-show-arp-after-avf2-recovery.txt) | HOST-A gateway MAC after AVF2 recovery |
| [HOST-B-ping-during-avg-failure.txt](HOST-B-ping-during-avg-failure.txt) | HOST-B ping result during AVG failure |
| [HOST-C-ping-during-avg-failure.txt](HOST-C-ping-during-avg-failure.txt) | HOST-C ping result during AVG failure |
| [HOST-C-show-arp-during-avf3-takeover.txt](HOST-C-show-arp-during-avf3-takeover.txt) | HOST-C retains the AVF3 virtual MAC |

The `.txt` contents are unchanged from the supplied FHRP archive. File names and surrounding explanations are editorial labels; they do not add measured output.

[Verification index](../README.md) · [Source mapping](../source-map.md) · [FHRP overview](../../README.md)
