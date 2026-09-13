# Bridge Assurance — Separate the Starting View from the Protection Test

**The retained interface detail was captured before the network-port change.** It is useful evidence of spanning-tree roles and BPDU activity, but it does not show a Bridge Assurance failure.

Open [SW3 Gi0/1 detail](SW3-Gi0-1-detail-before-network-port.txt):

| VLAN group | Captured role | What the reader can infer |
|---|---|---|
| 10 and 20 | Designated/Forwarding | Gi0/1 is forwarding in a designated role for these VLANs |
| 30 and 40 | Root/Forwarding | The same physical interface is SW3's selected path toward those roots |
| All four VLANs | Point-to-point link detail and BPDU counters | The file records control-message activity at that stage |

The original lab notes identify the SW3–SW4 Gi0/1 link as the Bridge Assurance test connection. Both [SW3](../../configs/SW3-ACCESS-B.cfg) and [SW4](../../configs/SW4-DIST-B.cfg) later preserve `spanning-tree portfast network` on that interface.

Those artifacts establish a starting view and saved configuration context. They do not show the reported `*BA_Inc` state, the exact failure action, or post-repair clearing of the condition. [Case 08](../../troubleshooting/08-bridge-assurance-inconsistency.md) explains the documented test and the missing observations.

BPDU counts are cumulative fields from one capture; they do not provide a measured control-message loss rate or proof of recovery.

[Verification index](../README.md) · [Module overview](../../README.md)
