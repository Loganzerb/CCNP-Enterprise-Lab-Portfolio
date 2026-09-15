# Topology and experiment stages

The four-switch main region provides multiple internal paths. A fifth switch creates an external boundary so the lab can examine both separate-region operation and Rapid PVST+ interoperability.

![MSTP topology](topology.png)

## Physical wiring

All five nodes use IOSvL2. The CML export references `iosvl2-2020`.

| Link | First endpoint | Second endpoint | Allowed VLANs in saved configs |
|---|---|---|---|
| Upper left | MST1-DIST-A Gi0/0 | MST2-ACCESS-A Gi0/0 | 10,20,30,40 |
| Upper right | MST1-DIST-A Gi0/1 | MST3-ACCESS-B Gi0/0 | 10,20,30,40 |
| Lower left | MST2-ACCESS-A Gi0/1 | MST4-DIST-B Gi0/0 | 10,20,30,40 |
| Lower right | MST3-ACCESS-B Gi0/1 | MST4-DIST-B Gi0/1 | 10,20,30,40 |
| Access-to-access | MST2-ACCESS-A Gi0/2 | MST3-ACCESS-B Gi0/2 | 10,20,30,40 |
| Boundary | MST4-DIST-B Gi0/2 | MST5-BOUNDARY Gi0/0 | 1,10,20,30,40 |

There are six physical trunks, no port-channels and no endpoint hosts in this export. The diagram shows wiring, not a single forwarding/blocking snapshot.

## Instance design

| Instance | VLAN mapping | Root preference retained in configurations |
|---|---|---|
| MST0 / IST | All unmapped VLANs | No explicit MST0 priority override in the saved files |
| MSTI 1 | 10,20 | MST1-DIST-A, configured priority 24576 |
| MSTI 2 | 30,40 | MST4-DIST-B, configured priority 24576 |

MST1–MST4 share name `CCNP_MST`, revision `1` and these mappings. The [access-switch capture](verification/instances/mst2-access-a-instance-paths.txt) shows the different root ports resulting from that design.

## Read each stage in context

| Stage | MST5 behavior | Evidence to use |
|---|---|---|
| Earlier external-root test | Separate MST region, `BOUNDARY_MST`; temporary MST0 priority 16384 | [Root/Master roles](verification/boundary-master/README.md) |
| Interoperability tests | Rapid PVST+ with deliberate changes to external root information | [PVST Simulation](verification/pvst-simulation/README.md) |
| Saved configuration | `spanning-tree mode rapid-pvst`; no explicit per-VLAN root-priority overrides | [Configuration guide](configs/README.md) |

MST5 retains an MST configuration block named `BOUNDARY_MST`, but that block does not make it operate in MST mode. The mode command determines which protocol is active.

[Section overview](README.md) · [Case index](troubleshooting/README.md)
