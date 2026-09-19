# 07 — FHRP: Gateway redundancy and recovery

An active gateway can remain reachable even when it has lost the route a client needs. This Cisco Modeling Labs project examines that failure and other gaps between gateway state, peer agreement, and working traffic.

The HSRP, VRRP, and GLBP exercises connect gateway selection to upstream routing, client ARP, controlled failures, and recovery.

**Three gateway protocols · Three case studies · Two topologies · 80 console captures**

**Start here:** [An active gateway with no upstream path](troubleshooting/scenario-1-hsrp-upstream-black-hole.md). PC-A lost all ten probes while DIST-A remained HSRP Active. Tracking shifted service to DIST-B, followed by 10/10 replies. Recovery testing then examined whether the preferred gateway reclaimed traffic before OSPF was ready.

## Lab design

![FHRP campus topology with redundant distribution gateways and client VLANs](topology.png)

The campus lab uses two distribution devices, a redundant access switch, and routed OSPF uplinks to CORE-R1. HSRP initially prefers DIST-A for VLAN 10 and DIST-B for VLAN 20. A later VRRP phase reuses VLAN 20.

![Separate GLBP topology with three gateway routers and three clients](topology-glbp.png)

The separate GLBP lab uses three routers sharing virtual gateway `10.30.30.1`. It examines gateway election, virtual-forwarder ownership, client assignment, and upstream tracking.

[Topology, addressing, and protocol stages](topology.md)

## Troubleshooting results

| Case | Problem | Retained result |
|---|---|---|
| [01 — Upstream black hole](troubleshooting/scenario-1-hsrp-upstream-black-hole.md) | The Active gateway lost its upstream route | Tracking reduced priority from 120 to 99 and the alternate carried client traffic; recovery runs compared gateway and OSPF ordering |
| [02 — Version mismatch](troubleshooting/scenario-2-hsrp-version-mismatch.md) | HSRPv1 and HSRPv2 peers both claimed Active for the same virtual IP | Restoring HSRPv2 recovered peer recognition; 19/20 successful probes during the fault had concealed the broken redundancy pair |
| [03 — STP/HSRP misalignment](troubleshooting/scenario-3-stp-hsrp-path-misalignment.md) | The spanning-tree root and Active gateway were on different devices | Port roles and MAC learning exposed the extra Layer 2 traversal; restoring root placement returned the direct path |

## What this work demonstrates

- **Service-aware verification:** compare gateway roles with routes, ARP, ping, and traceroute.
- **Failure tracking:** connect upstream health to gateway or forwarder eligibility.
- **Recovery analysis:** distinguish interface recovery, routing readiness, and gateway reclamation.
- **Protocol interpretation:** inspect GLBP gateway election separately from forwarding ownership and client assignment.

## Explore the files

| Guide | Contents |
|---|---|
| [Configurations](configs/README.md) | Retained configuration excerpts and observed settings |
| [Verification](verification/README.md) | Topic indexes linking all 80 captures |
| [HSRP](verification/hsrp.md) | Placement, tracking, authentication, and timers |
| [VRRP](verification/vrrp.md) | Election, upstream tracking, and delayed recovery |
| [GLBP](verification/glbp.md) | Gateway/forwarder roles, client assignment, failures, and timers |
| [Troubleshooting](troubleshooting/README.md) | The three investigations and supporting evidence |

## Evidence scope

Captures span different experiment stages. Complete device configurations and a CML export are not included; the configuration guide identifies the available excerpts.

Recovery tests retain their observed packet loss. The results do not establish seamless failover, precise convergence guarantees, or long-run GLBP bandwidth distribution. The [coverage table](verification/README.md#coverage-and-evidence-limits) records the limits of each experiment, and the [source map](verification/source-map.md) preserves capture provenance.

[Back to portfolio](../README.md)
