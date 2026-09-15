# Configurations: what each device contributes

These five original files preserve the saved switch configurations. Read them alongside the evidence: a saved setting explains the design, while a capture shows what the switch reported at a particular experiment stage.

## Device guide

| File | Settings worth reviewing |
|---|---|
| [MST1-DIST-A.cfg](MST1-DIST-A.cfg) | Main region identity, two internal trunks and `spanning-tree mst 1 priority 24576` |
| [MST2-ACCESS-A.cfg](MST2-ACCESS-A.cfg) | Main region identity and three internal trunks |
| [MST3-ACCESS-B.cfg](MST3-ACCESS-B.cfg) | Restored `CCNP_MST`, revision 1 and original mapping after the mismatch exercises |
| [MST4-DIST-B.cfg](MST4-DIST-B.cfg) | Instance 2 priority 24576; two internal trunks and a boundary trunk that also allows VLAN 1 |
| [MST5-BOUNDARY.cfg](MST5-BOUNDARY.cfg) | Active Rapid PVST+ mode; one boundary trunk; retained, inactive MST region definition |

MST1–MST4 map VLANs 10/20 to instance 1 and VLANs 30/40 to instance 2. The mapping digest and observed root roles are explained in the [verification guide](../verification/README.md).

## Saved state versus earlier tests

The saved MST5 file runs **Rapid PVST+**, not MST. Its `BOUNDARY_MST` configuration block remains present from earlier work. The external-root capture belongs to that earlier MST stage, when MST5 advertised MST0 priority 16384.

The final files do not preserve every temporary fault or priority change. They cannot serve as the exact starting configuration for all seven cases. The [topology stage table](../topology.md) distinguishes the experiments.

## Rebuild from the export

The [original CML YAML](../CCNP_MASTERCLASS_MSTP.yaml) contains five IOSvL2 nodes and six links. The device files correspond to its embedded configuration blocks; their original content is retained.

Before replaying an exercise:

1. Import the YAML into a separate CML lab and check the `iosvl2-2020` image mapping.
2. Verify VLAN creation. The saved configuration blocks contain trunk allow-lists and MST mappings but no explicit VLAN-creation stanzas. Create VLANs 10,20,30,40 where needed; VLAN 1 is also allowed on the boundary trunk.
3. Verify the operating mode, main-region identity and trunks before applying the case-specific change.
4. Collect fresh state and traffic checks appropriate to the exercise.

Useful **replay checks**, not additional results collected for this package:

```cisco
show vlan brief
show interfaces trunk
show spanning-tree summary
show spanning-tree mst configuration
show spanning-tree mst configuration digest
show spanning-tree mst
show spanning-tree inconsistentports
```

The `.cfg` files include captured display headers and banners. They are inspection artifacts; use the YAML for import or select the relevant configuration commands when rebuilding manually.

[Section overview](../README.md) · [Troubleshooting](../troubleshooting/README.md)
