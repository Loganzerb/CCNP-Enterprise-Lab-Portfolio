# Root Selection — Why One Link Forwards and Another Waits

**Main finding:** SW3's VLAN 10 capture shows an intentional forwarding path and a separate alternate path. A blocked port here is part of loop prevention.

Open [the original VLAN 10 output](SW3-show-spanning-tree-vlan-10.txt) alongside this table:

| Captured field | Plain-English interpretation |
|---|---|
| Root address 5254.0007.0f1b, priority 24586 | Identifies the root recorded for VLAN 10; the lab documentation maps it to SW1 |
| Root priority 24586 | Combines the configured base priority 24576 with VLAN ID 10 |
| Gi0/0 Root FWD, cost 20000 | SW3 selects this interface toward the root |
| Gi0/2 Altn BLK | The lateral redundant path is held out of forwarding for VLAN 10 |
| Gi0/1 Desg FWD | This interface has a designated forwarding role for VLAN 10 |
| Gi0/3 Desg FWD, Edge | The endpoint-facing port is forwarding |

The [saved SW1/SW4 priorities](../../configs/README.md) explain the intended split: SW1 for VLANs 10/20 and SW4 for 30/40. The separate [Gi0/1 detail](../bridge-assurance/README.md) shows that SW3's same physical link has different roles across the two VLAN groups.

This capture establishes the reported topology at one moment. It does not time a failover or measure client delivery.

[Verification index](../README.md) · [Module overview](../../README.md)
