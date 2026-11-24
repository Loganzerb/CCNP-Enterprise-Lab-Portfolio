# Lab 19A evidence scope

| Material | What it supports |
|---|---|
| Saved configuration | Inspection of the private CML export established six nodes, seven physical links, saved image choices, and device settings. The portfolio provides an independently authored topology and selected implementation examples. |
| Original documentation assignment | Reported switching, HSRP, OSPF, PAT and ACL outcomes and the recorded troubleshooting lessons. |
| Portfolio diagrams and test instructions | An interpretation of the saved configuration and a method for collecting fresh observations. |

The complete CML checkpoint and full device configurations are retained privately. The public portfolio excludes them pending redistribution clearance. The Lab 19A handoff supplies reported outcomes. Raw console output, NAT table dumps, ACL counter output, packet captures, convergence timing, and screenshots were unavailable. The selected implementation examples were checked against the private export. Inspection and testing commands are provided for a future run.

## Saved checkpoint and earlier test stages

- The original handoff describes IOL-L2 switches. The export specifies `iosvl2` with `iosvl2-2020` for both switches. The topology inventory follows that export.
- The export preserves trunk allow lists and spanning-tree settings for VLANs 10 and 20. It contains no explicit VLAN creation blocks or separate VLAN database file. Confirm VLANs after import and initialize them if needed.
- The final snapshot contains the inbound VLAN 10 ACL on both gateways. The successful VLAN 10 external echo and PAT observations describe a separate permitted test state. A fresh probe from VLAN 10 to the test loopback should hit the saved deny when the topology is operating as designed.
- VLAN 20 used a temporary host route during its PAT test. The exact original route command is unavailable. The saved R1 configuration contains the VLAN 10 default and no temporary host route.
- The lab record reports recovery of new probes after the HSRP role change. It does not supply convergence timing, existing-session continuity, independent VLAN 20 failover, or a WAN-only failover test. Dynamic NAT state is local to each gateway in the saved configuration.

A fresh CML import, boot, and runtime replay remain pending. R4 is a simulated ISP router and ICMP test endpoint inside the lab. [Configuration guide](configs/README.md) · [Verification matrix](verification/README.md)

[Overview](README.md) · [Topology](topology.md) · [Operation](operation.md) · [Troubleshooting](troubleshooting/README.md)
