# Configurations — review the two designs separately

The classic GRE/IKEv1 files and the later IKEv2/VTI files describe **different stages** on the same routers. Their source and reconstruction status are identified below.

## Classic GRE over IPsec

| File | Purpose |
|---|---|
| [R1-VPN.cfg](R1-VPN.cfg) · [R3-VPN.cfg](R3-VPN.cfg) | Reconstructed GRE, OSPF, IKEv1, reciprocal selectors, and WAN crypto map |
| [R2-TRANSIT.cfg](R2-TRANSIT.cfg) | Reconstructed two-link underlay |
| [Classic IPsec dependencies](ipsec.md) | IKE policy, authentication, ESP transform, ACL, and crypto-map relationship |
| [Fault and repair commands](faults.md) | Reconstructed changes for the three retained investigations |

These extracts use the classic handoff and captured settings. Area 0, network statements, passive loopback setting, and sequence 10 complete the reconstruction. `REPLACE_WITH_SHARED_LAB_KEY` replaces the original key.

## IKEv2 VTI

| File | Purpose |
|---|---|
| [R1-VTI.cfg](R1-VTI.cfg) · [R3-VTI.cfg](R3-VTI.cfg) | Selected actual node configuration from the saved VTI CML export |
| [R2-VTI-TRANSIT.cfg](R2-VTI-TRANSIT.cfg) | Saved transit interface settings |
| [IKEv2/VTI configuration stages](vti.md) | Object roles, selected settings, and direct OSPF over Tunnel0 |
| [Sanitized CML export](IKEv2-VTI-CML-sanitized.yaml) | Complete three-node VTI checkpoint, preserving wiring and saved settings |

The source export was named `GRE with IPsec_Oct_1st.yaml`, but its saved nodes contain the completed IKEv2 VTI configuration. The published copy uses a clearer filename and replaces the two PSK values with `REPLACE_WITH_SHARED_VTI_LAB_KEY`. Other saved settings and the CML structure are retained. It has not been re-imported or rerun during documentation work.

[Shared topology](../topology.md) · [Verification](../verification/README.md) · [GRE/IPsec and VTI overview](../README.md)
