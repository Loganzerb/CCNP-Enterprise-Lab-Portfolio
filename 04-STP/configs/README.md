# Configuration Guide — What Each Switch Is Doing

These five files are the configuration snapshots supplied with the CML export. They retain their original headers, defaults, and lab settings. Start with the role descriptions below, then inspect the linked device file for the exact commands.

## Device-by-device guide

| File | Purpose | Important settings to look for |
|---|---|---|
| [SW1-DIST-A.cfg](SW1-DIST-A.cfg) | Preferred root for VLANs 10/20, backup preference for 30/40 | Rapid PVST+, long costs, priority 24576 for VLANs 10/20 and 28672 for VLANs 1/30/40; trunks Gi0/0–1 |
| [SW2-ACCESS-A.cfg](SW2-ACCESS-A.cfg) | Access switch serving PC1 | Trunks Gi0/0–2; Gi0/3 access VLAN 10 with PortFast edge and BPDU Guard |
| [SW3-ACCESS-B.cfg](SW3-ACCESS-B.cfg) | Access switch serving PC2 and observing the engineered paths | Trunks Gi0/0–2; Gi0/1 network-port setting; Gi0/3 access VLAN 10 with edge protection |
| [SW4-DIST-B.cfg](SW4-DIST-B.cfg) | Preferred root for VLANs 30/40 and attachment point for SW5 | Priority 24576 for VLANs 1/30/40 and 28672 for VLANs 10/20; Gi0/1 network-port setting; Gi0/2–3 trunks to SW5 |
| [SW5-ROGUE.cfg](SW5-ROGUE.cfg) | Controlled test switch connected to SW4 by two links | Rapid PVST+, long costs, separate trunks Gi0/0–1; no saved EtherChannel membership |

The word “rogue” describes SW5's role in deliberate lab exercises. It does not imply an uncontrolled device was connected to a production network.

## Configuration translated into intent

| Setting | Plain-English purpose | What it does not establish by itself |
|---|---|---|
| `spanning-tree mode rapid-pvst` | Runs a rapid spanning-tree instance for each VLAN | An exact failover time |
| `spanning-tree pathcost method long` | Selects the long numerical scale used to compare path costs | Which interface wins without looking at the full topology |
| Per-VLAN priority | Expresses which distribution switch should become root | The elected result without operational output |
| `switchport trunk allowed vlan 10,20,30,40` | Allows the four intended VLANs across that trunk | That the VLANs exist or are forwarding |
| `spanning-tree portfast edge` and `spanning-tree bpduguard enable` | Mark an endpoint-facing port and configure a response to received BPDUs | A captured protection event |
| `spanning-tree portfast network` on SW3/SW4 Gi0/1 | Preserves the network-port configuration used for the Bridge Assurance exercise | A captured inconsistency or recovery |

For example, SW3's Gi0/3 contains the following saved policy:

```cisco
switchport access vlan 10
switchport mode access
spanning-tree portfast edge
spanning-tree bpduguard enable
```

This is the client-facing port policy discussed in [Case 01](../troubleshooting/01-bpdu-guard-rogue-switch.md). The case does not identify which protected port was used for the original fault, so this excerpt is configuration context.

## Why a saved file may differ from an experiment

- **The LACP Po1 test is temporary.** SW4 and SW5 are saved with separate trunks, without Po1 or channel-group commands. Use the [LACP guide](../verification/etherchannel/README.md) to interpret the earlier bundled states.
- **Root Guard and Loop Guard exercises are not final enabled-policy snapshots.** Their interface guard commands are absent from these saved configurations. The original case notes document those temporary exercises.
- **Some historical settings coexist.** SW4 Gi0/2 and SW5 Gi0/0 include an access VLAN setting while their explicit mode is trunk. The access-VLAN line alone should not be read as proof of access-port operation.
- **Global defaults and interface settings are different views.** SW3's [summary](../verification/convergence/SW3-show-spanning-tree-summary.txt) says default edge BPDU Guard is disabled; its Gi0/3 still explicitly enables the feature.
- **Cost examples span stages.** The later saved long-cost setting does not change the earlier captured bundle costs of 3 and 4.

## Reuse

Use [the CML export](../CCNP_MASTERCLASS_STP.yaml) for its complete node and link map. These separate files make the embedded switch settings easier to inspect. They contain console headers and platform boilerplate and have not been converted into clean paste-ready scripts.

Check VLAN creation after import: allowed-VLAN lists alone do not create the VLAN database. Establish a fresh baseline before applying a case's temporary changes.

[Module overview](../README.md) · [Verification](../verification/README.md) · [Cases](../troubleshooting/README.md)
