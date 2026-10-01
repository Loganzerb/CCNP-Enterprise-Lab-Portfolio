# Configurations — understand the role of each setting

The files below are **sanitized, reconstructed configuration extracts**, not captured running-config exports. They use the completed lab's addresses, process IDs, algorithms, transform name, selectors, and crypto-map name. Area 0, the OSPF network statements, passive loopback setting, and policy/map sequence 10 complete the documented reconstruction.

| File | Purpose |
|---|---|
| [R1-VPN.cfg](R1-VPN.cfg) | Underlay route, GRE, OSPF, and policy-based IPsec at the first endpoint |
| [R2-TRANSIT.cfg](R2-TRANSIT.cfg) | Two connected transport networks; no overlay or crypto configuration |
| [R3-VPN.cfg](R3-VPN.cfg) | Reciprocal endpoint configuration |
| [IPsec settings and dependencies](ipsec.md) | Why the IKE policy, key, transform, ACL, and crypto map must agree |
| [Controlled fault and repair commands](faults.md) | Reconstructed changes used to explain the three investigations |

Both VPN extracts use `REPLACE_WITH_SHARED_LAB_KEY`. This placeholder replaces the original key; choose the same lab key at both endpoints when reviewing the configuration. The files contain relevant settings only and have not been imported or run during this documentation work.

The previous GRE-only CML export describes a different lab stage and private addressing. A combined GRE/IPsec export was not supplied, so it is not included as a current project artifact.

[Topology](../topology.md) · [Verification](../verification/README.md) · [GRE/IPsec overview](../README.md)
