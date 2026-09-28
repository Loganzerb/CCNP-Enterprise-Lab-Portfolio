# Configurations — distinguish the saved checkpoint from later work

## Original CML checkpoint

[CCNP_VRF_Sept_27th-baseline.yaml](CCNP_VRF_Sept_27th-baseline.yaml) preserves the complete readable contents of the requested `CCNP_VRF_Sept_27th (1).yaml` attachment. The filename is simplified for repository navigation; the source was recovered from the attachment’s numbered text preview with all lines present.

The checkpoint has **three IOSv routers and two links**, using image definition `iosv-159-3-m3`. It contains BLUE/RED VRF definitions, overlapping transit addresses and interface bindings. It precedes the CE Loopback0 additions, static-route faults and SHARED-SVC expansion. It is not a final four-node export.

| Device | Configuration extracted from that checkpoint |
|---|---|
| BLUE-CE | [BLUE-CE-checkpoint.cfg](BLUE-CE-checkpoint.cfg) |
| R1-VRF | [R1-VRF-checkpoint.cfg](R1-VRF-checkpoint.cfg) |
| RED-CE | [RED-CE-checkpoint.cfg](RED-CE-checkpoint.cfg) |

The configuration blocks preserve the export’s `Building configuration...` preamble and recorded IOS defaults. They are captured records, not cleaned deployment templates.

## Later lab stages

| Guide | Contents and status |
|---|---|
| [Later additions](later-additions.md) | Selected commands for the duplicate loopbacks, shared-service node, unique test endpoints and selective routes; reconstructed from the lab sequence and checked against output |
| [Fault and repair commands](faults.md) | Two controlled RED route changes with links to observed failures and repairs |

R1 uses modern `vrf definition` / `vrf forwarding` syntax. Binding an interface to a VRF removed its IPv4 address on this image, so the address was reapplied afterward. The [binding capture](../verification/01-isolation.md#block-01--interface-binding-removes-its-address) records the device message directly.

The saved checkpoint has no route distinguisher configured for either VRF. This lab uses local VRF-Lite and static routing; it does not demonstrate MPLS, MP-BGP or route-target import/export.

[Topology and addressing](../topology.md) · [Verification](../verification/README.md) · [VRF overview](../README.md)
