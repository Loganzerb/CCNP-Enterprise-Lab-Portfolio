# CCNP Enterprise Lab Portfolio

Hands-on enterprise networking in **Cisco Modeling Labs (CML)**: routing, switching, gateway redundancy, address translation, and DHCP services, documented through configurations, device output, and troubleshooting case studies.

I built these labs to understand how networks behave when configurations change and components fail. The work includes designing redundant paths, establishing healthy baselines, introducing controlled faults, investigating symptoms, and verifying recovery. Each module connects technical decisions to the evidence retained from the lab.

**9 technology modules · 233 text evidence files · 10 topology diagrams · 5 CML lab exports**

## Start with these three cases

These cases show how I connect a reported problem to an explanation, a targeted repair, and a measured result. You can review them without running CML.

### 1. Restore outside access through multiple NAT faults

Two clients could not reach an outside server. The original lab contained four faults affecting traffic classification, eligible source addresses, return routing, and address-pool capacity. A temporary pool-name typo during repair created an additional diagnostic checkpoint.

The final capture shows both clients receiving **5/5 replies**, with two different translated addresses allocated at the same time. The case explains why fixing one part of the path was insufficient and why matching traffic to an access list did not prove translation was working.

**Review:** [NAT incident case study](08-NAT/troubleshooting/incident-01-external-connectivity-outage.md) · [Final evidence](08-NAT/verification/incident-01-final.txt) · [Configuration changes](08-NAT/configs/incident-01-NAT-EDGE-changes.diff)

### 2. Diagnose an active gateway that cannot forward upstream

A client lost all ten test probes after its gateway's upstream link failed, even though the gateway remained HSRP Active. Tracking tied the upstream link's health to gateway priority, allowing the other distribution device to take over.

The alternate path then delivered **10/10 replies**. Recovery testing exposed a second concern: the preferred gateway could reclaim traffic before OSPF routing was ready. The case compares recovery ordering with and without a preemption delay and retains the packet loss observed in both runs.

**Review:** [HSRP upstream black-hole case study](07-FHRP/troubleshooting/scenario-1-hsrp-upstream-black-hole.md) · [Failure evidence](07-FHRP/verification/hsrp-tracking/FHRP-DIST-A-and-PC-A-untracked-upstream-black-hole.txt) · [Alternate-path verification](07-FHRP/verification/hsrp-tracking/PC-A-ping-and-traceroute-tracking-failover.txt)

### 3. Repair an OSPF adjacency when ping still works

O2 received replies to all five ping probes sent to O4, but their OSPF relationship stalled in `EXSTART`, preventing database synchronization. Both physical interfaces reported an MTU of 1500 bytes; the IP-specific check exposed a one-sided setting of 1400.

Removing that override restored **FULL adjacency on both routers**, without clearing the OSPF process. The case demonstrates how comparing different views of the same interface can reveal a fault that a successful ping misses.

**Review:** [OSPF MTU case study and captured excerpts](02-OSPF/troubleshooting/scenario-1-ospf-mtu-exstart-exchange.md) · [OSPF verification guide](02-OSPF/verification/README.md)

## Explore all nine modules

| Module | Engineering focus | A useful starting point |
|---|---|---|
| [01 — EIGRP](01-EIGRP/README.md) | Internal routing, loop-free backup paths, summarization, and route control across five routers | [Inconsistent summaries](01-EIGRP/troubleshooting/scenario-3-inconsistent-eigrp-summarization.md): more-specific routes change the intended path while reachability can remain available |
| [02 — OSPF](02-OSPF/README.md) | Multi-area routing, neighbor synchronization, routing databases, and policy at area boundaries | [ABR filtering](02-OSPF/troubleshooting/scenario-3-abr-route-filtering-control-plane.md): a branch route disappears while every captured adjacency remains FULL |
| [03 — BGP](03-BGP/README.md) | Routing between autonomous systems, route reflection, next-hop resolution, and advertisement policy | [Healthy session, unusable path](03-BGP/troubleshooting/scenario-2-ibgp-next-hop-reachability.md): diagnose an unreachable next hop, retain the installed alternate, and verify the original path's recovery |
| [04 — STP](04-STP/README.md) | Loop prevention, predictable switch-root placement, protection features, and link-bundle interaction | [LACP member and negotiation failures](04-STP/troubleshooting/11-lacp-negotiation-and-member-failure.md): distinguish a degraded bundle from one that cannot form |
| [05 — MSTP](05-MSTP/README.md) | VLAN-to-instance mapping, region membership, independent forwarding paths, and interoperability | [Boundary protection case](05-MSTP/troubleshooting/scenario-6-pvst-sim-inferior-vlan/README.md): trace a blocked root port to conflicting VLAN information and verify that the inconsistency clears |
| [06 — EtherChannel](06-ETHERCHANNEL/README.md) | Static, LACP, and PAgP bundles; trunk consistency; member resilience; and forwarding checks | [Troubleshooting evidence](06-ETHERCHANNEL/troubleshooting/README.md): member suspension, alternate-path forwarding, and the observed `max-bundle` anomaly |
| [07 — FHRP](07-FHRP/README.md) | HSRP, VRRP, and GLBP gateway redundancy, upstream tracking, and recovery behavior | [HSRP version mismatch](07-FHRP/troubleshooting/scenario-2-hsrp-version-mismatch.md): substantial ping success conceals a broken redundancy pair |
| [08 — NAT/PAT](08-NAT/README.md) | Static and dynamic translation, address-pool exhaustion, shared-address translation, and integrated incidents | [PAT migration incident](08-NAT/troubleshooting/incident-02-pat-migration.md): repair the selected interface and translation limit, then verify both clients sharing one address |
| [09 — DHCP](09-DHCP/README.md) | Address assignment, DHCP relay, lease behavior, and client/server troubleshooting | [Incorrect gateway case](09-DHCP/troubleshooting/02-incorrect-default-gateway.md): trace failed remote access to a DHCP-supplied gateway and verify recovery |

## How I approach the work

**Predict → configure → verify → explain → break → diagnose → repair → capture evidence**

Guided exercises isolate individual behaviors. Integrated NAT incidents combine several dependencies in the same service path. Across the portfolio, the investigation connects:

- **Design intent:** which device, route, gateway, or link should carry traffic, and why.
- **Device state:** what the configuration, protocol tables, logs, and forwarding information actually show.
- **Service checks:** whether the relevant endpoints receive replies and whether the intended path or redundancy has returned.
- **Repair scope:** which change addresses the cause and what the available post-change evidence establishes.

The cases demonstrate that a working ping, established routing neighbor, active gateway, or assigned IP address can coexist with a fault. They also distinguish restored steady-state service from measured behavior during a failure or recovery.

## Find the supporting artifacts

Each module contains a README, topology diagram, and three supporting directories:

| Location | What to look for |
|---|---|
| `configs/` | Device configuration material and its source or scope: sanitized extracts, exported snapshots, selected settings, or labeled reconstructions |
| `verification/` | Device output, interpretation guides, and retained baseline, failure, or recovery captures |
| `troubleshooting/` | Case studies, controlled experiments, or grouped failure evidence explaining symptoms and corrective actions |

| Module | Configuration guide | Verification guide | Troubleshooting |
|---|---|---|---|
| EIGRP | [Configurations](01-EIGRP/configs/README.md) | [Evidence](01-EIGRP/verification/README.md) | [Cases](01-EIGRP/troubleshooting/) |
| OSPF | [Device roles and area policy](02-OSPF/configs/README.md) | [Interfaces, neighbors, databases, and routes](02-OSPF/verification/README.md) | [Three cases and original excerpts](02-OSPF/troubleshooting/README.md) |
| BGP | [Device roles and active policies](03-BGP/configs/README.md) | [Peer, path, and forwarding evidence](03-BGP/verification/README.md) | [Three cases and original command blocks](03-BGP/troubleshooting/README.md) |
| STP | [Configurations](04-STP/configs/README.md) | [Evidence](04-STP/verification/README.md) | [Cases](04-STP/troubleshooting/) |
| MSTP | [Configurations](05-MSTP/configs/README.md) | [Evidence](05-MSTP/verification/README.md) | [Case index](05-MSTP/troubleshooting/README.md) |
| EtherChannel | [Configurations](06-ETHERCHANNEL/configs/README.md) | [Final-state evidence](06-ETHERCHANNEL/verification/README.md) | [Failure evidence](06-ETHERCHANNEL/troubleshooting/README.md) |
| FHRP | [Configuration excerpts](07-FHRP/configs/README.md) | [Protocol guides and evidence](07-FHRP/verification/README.md) | [Case index](07-FHRP/troubleshooting/README.md) |
| NAT/PAT | [Original and repaired states](08-NAT/configs/README.md) | [Evidence](08-NAT/verification/README.md) | [Incident index](08-NAT/troubleshooting/README.md) |
| DHCP | [Working configurations and captured pools](09-DHCP/configs/README.md) | [Evidence](09-DHCP/verification/README.md) | [Case index](09-DHCP/troubleshooting/README.md) |

For a technical review, follow one case from its topology and expected behavior to the decisive output, repair, and recovery checks. The module guides provide context for longer captures.

## Reproduce a lab

The repository includes the following CML exports. Their starting states differ:

| Export | Starting state |
|---|---|
| [STP lab](04-STP/CCNP_MASTERCLASS_STP.yaml) | Saved lab topology with embedded switch and endpoint configuration material |
| [MSTP lab](05-MSTP/CCNP_MASTERCLASS_MSTP.yaml) | Saved main MST region; MST5 remains in Rapid PVST+ mode for interoperability |
| [EtherChannel lab](06-ETHERCHANNEL/CML-LAB.yaml) | Final exported lab; reachability testing uses PC-A and SW4's VLAN 10 interface |
| [NAT Incident 01](08-NAT/configs/incident-01-original.yaml) | Original fault state for the dynamic-NAT outage |
| [NAT Incident 02](08-NAT/configs/incident-02-original.yaml) | Original fault state for the PAT migration incident |

Import the selected export into a separate CML lab, check node/image mappings and VLAN availability, and establish its starting state before following the relevant case. STP and MSTP exports require particular attention to VLAN creation because their saved configuration blocks do not include explicit VLAN-creation stanzas. Record fresh verification after applying repairs.

EIGRP, OSPF, and BGP have sanitized configuration extracts but no CML export in this snapshot. FHRP provides selected configuration evidence without a complete configuration set or export. DHCP includes four reconstructed working configurations and a captured server-pool excerpt, but no CML export. These materials support review and reconstruction with additional setup; their configuration guides describe the boundaries.

## Evidence scope

This portfolio records controlled CML lab work. Captures vary from standalone transcripts to selected excerpts embedded in case studies. Configuration-only coverage, reported observations, reconstructed files, and missing captures are identified in the supporting documentation.

| Module or artifact | Interpretation boundary |
|---|---|
| EIGRP recalculation case | Direct Active/Query/Reply output was not retained; the case does not establish a captured Stuck-in-Active event |
| OSPF | MTU and filtering cases retain failure and recovery excerpts. The NSSA case retains two recovery output excerpts; its other observations are described in narrative. Equal-cost routes establish installation, not measured traffic distribution |
| BGP | Three cases establish session, next-hop, and advertisement recovery. General captures cover global IPv4; IPv6 and VRF settings have no dedicated verification. Null0-backed test prefixes and incomplete traceroutes do not establish endpoint delivery |
| STP | Several experiments have partial failure or recovery records; protection configuration and baseline output do not substitute for a captured failure |
| MSTP | Case 06 captures the inconsistency clearing, without a post-repair forwarding table or endpoint test. Other cases distinguish observed roles, documented corrections and saved configuration |
| EtherChannel | The `max-bundle` forwarding anomaly is scoped to the observed lab behavior. Capability output and selected hashing configuration do not measure throughput |
| FHRP | Captures span separate experiment stages. Recovery tests retain packet loss, and complete final device configurations are not supplied |
| NAT/PAT | Final configuration files are labeled reconstructions from original exports and documented repairs. Incident 02 lacks a time-ordered record of both ping start orders, intervening clears/reloads, and a save confirmation |
| DHCP | Guided relay, gateway, and lease-state experiments retain client/server output. Configurations are reconstructed; server-generated DHCPNAK output does not establish client receipt. Natural T2/lease expiry, DNS resolution, and Internet access were not demonstrated |

The snapshot totals count `.txt` files under verification and troubleshooting, excluding four EtherChannel configuration files and one DHCP configuration excerpt stored as `.txt`. They do not count independent tests or imply complete coverage of every configured feature. Additional evidence appears inside Markdown case studies. Topology diagrams illustrate the lab designs; device captures establish the recorded behavior.
