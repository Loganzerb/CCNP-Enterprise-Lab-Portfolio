# STP topology and device roles

![STP lab: two distribution switches, two access switches, two endpoints, and a dedicated test switch](topology.png)

| Device | Device role |
|---|---|
| SW1-DIST-A | Distribution switch preferred as the spanning-tree root for VLANs 10 and 20 |
| SW4-DIST-B | Distribution switch preferred as root for VLANs 30 and 40 |
| SW2-ACCESS-A | Connects PC1 and provides redundant paths toward the distribution switches |
| SW3-ACCESS-B | Connects PC2 and provides a second access-side observation point |
| SW5-ROGUE | Deliberately controlled test switch used to introduce conditions the network should detect |
| PC1 and PC2 | VLAN 10 endpoints included in the topology; no standalone endpoint ping capture is retained in this section |

The infrastructure trunks carry VLANs 10, 20, 30, and 40. The diagram shows physical wiring; forwarding and blocked states change with the VLAN and experiment.

## Terms used in the evidence

| Term | Meaning in this lab |
|---|---|
| VLAN | A logical network carried through the switches |
| Trunk | A switch link that carries multiple VLANs |
| Root bridge | The reference switch used to calculate a VLAN's spanning tree; it is not necessarily the path for every packet |
| Root port | A switch's selected path toward that root |
| Alternate / blocked | A redundant path kept out of normal forwarding to prevent a loop |
| BPDU | A control message switches exchange to maintain spanning-tree information |
| EtherChannel / port-channel | Several physical links represented as one logical link |
| Inconsistent / err-disabled | Protective states; the cases explain whether an STP instance or an interface is affected |

[Configuration guide](configs/README.md) · [Module overview](README.md)
