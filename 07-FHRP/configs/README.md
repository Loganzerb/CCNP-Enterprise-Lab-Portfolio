# FHRP configuration guide

The supplied FHRP package contains selected configuration commands and one explicit `show running-config interface Vlan10` excerpt. It does not contain full per-device running configurations or an importable CML YAML export.

| Artifact | Scope |
|---|---|
| [DIST-A Vlan10 configuration and HSRP state](../verification/hsrp-baseline/FHRP-DIST-A-show-standby-and-running-config-vlan10.txt) | Actual interface excerpt with HSRPv2, priority 120, a 10-second preemption delay, and track object 1 with decrement 21 |
| [HSRP configuration discussion](../verification/hsrp.md) | Selected observed settings and their verification |
| [VRRP election and configuration capture](../verification/vrrp/FHRP-DIST-A-and-DIST-B-vrrp-election-and-baseline.txt) | Entered commands and peer state during the VLAN 20 VRRP phase |
| [VRRP verification guide](../verification/vrrp.md) | Priority, tracking, and preemption-delay settings tied to captures |
| [GLBP verification guide](../verification/glbp.md) | Operational settings across separate load-balancing, tracking, authentication, and timer experiments |

The complete source message for the Vlan10 excerpt stays with its associated verification output. No configuration files were assembled from settings recorded at different stages. These artifacts support review of the documented settings; they are not complete restore files or a final all-device configuration snapshot.

[FHRP overview](../README.md) · [Verification index](../verification/README.md)
