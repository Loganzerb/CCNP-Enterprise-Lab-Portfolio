# Different paths over the same wiring

The root choices affect the access switch's selected path. VLANs 10/20 point toward one distribution switch, while VLANs 30/40 point toward the other.

[Open MST2-ACCESS-A's original instance output](mst2-access-a-instance-paths.txt).

| Instance on MST2 | VLANs | Root port | Connected neighbor |
|---|---|---|---|
| MSTI 1 | 10,20 | Gi0/0, Root FWD | MST1-DIST-A |
| MSTI 2 | 30,40 | Gi0/1, Root FWD | MST4-DIST-B |

Both selected paths have cost `20000` and show `rem hops 19`. The root priority fields are `24577` for instance 1 and `24578` for instance 2, reflecting configured priority 24576 plus the instance ID.

This proves instance-specific root-port selection. It does not measure traffic distribution, throughput or application availability. A designated forwarding port in one instance is not necessarily that switch's root port.

To follow the reasoning, compare the [root-switch captures](../root-engineering/README.md) and [physical wiring](../../topology.md).

[Evidence index](../README.md)
