# Region identity: verify the whole definition

Switches must agree on the region definition to participate in the same MST region. The main-region capture provides the comparison point for the three mismatch exercises.

[Open the original region configuration and digest](main-region-configuration-and-digest.txt).

| Field | Recorded value |
|---|---|
| Name | `CCNP_MST` |
| Revision | `1` |
| Instance 1 | VLANs `10,20` |
| Instance 2 | VLANs `30,40` |
| Instance 0 | Remaining VLANs |
| Digest | `0xCA136A235706B316C8DB8F921067A68F` |

The displayed count of **three configured instances** includes instance 0. It does not mean three explicitly assigned VLAN groups.

The file captures MST1's definition. The other saved main-region configurations agree, but this is not a simultaneous four-switch command transcript. Its note also records that the definition could be displayed before MST mode was enabled; check `show spanning-tree summary` to distinguish configured identity from active mode.

**Technical follow-through:** compare name, revision and mapping on both ends. The [mismatch evidence](../region-mismatch/README.md) shows why checking only the digest is insufficient.

[Evidence index](../README.md) · [Configurations](../../configs/README.md)
