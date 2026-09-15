# Root placement: confirm the intended switches were elected

The lab assigns different distribution switches as roots for the two VLAN groups. The retained output confirms those roles.

[Open the original engineered-root capture](engineered-roots.txt).

| Device | Captured result | Configuration that supports it |
|---|---|---|
| MST1-DIST-A | `Root this switch for MST1` | `spanning-tree mst 1 priority 24576` |
| MST4-DIST-B | `Root this switch for MST2` | `spanning-tree mst 2 priority 24576` |

The displayed priorities are 24577 and 24578 because the instance ID is included. These are distinct elections; neither result by itself identifies the overall CIST root.

The [access-switch evidence](../instances/README.md) adds the practical consequence: the two instances select different uplinks. These are recorded port roles, not a traffic-load measurement.

[Evidence index](../README.md) · [Device files](../../configs/README.md)
