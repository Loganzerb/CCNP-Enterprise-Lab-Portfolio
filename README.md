# CCNP Enterprise Lab Portfolio

Hands-on enterprise networking in **Cisco Modeling Labs (CML)**: routing, traffic policy, multicast, switching, gateway redundancy, address translation, DHCP, and time synchronization.

I built these labs to understand how networks behave when configurations change and components fail. Each section connects the intended design to troubleshooting decisions, targeted repairs, and the results recorded on the devices.

**12 technology modules · 233 text evidence files · 13 topology diagrams · 6 CML lab exports**

## Start with these three cases

### Restore outside access through multiple NAT faults

Two clients could not reach an outside server. Four starting faults affected traffic classification, source eligibility, return routing, and address-pool capacity; a temporary pool-name typo added another diagnostic checkpoint. Final captures show **5/5 replies from each client** and two different translated addresses allocated in the same table.

[Read the NAT case](08-NAT/troubleshooting/incident-01-external-connectivity-outage.md) · [Inspect the final evidence](08-NAT/verification/incident-01-final.txt)

### Diagnose an active gateway that cannot forward upstream

A client lost all ten test probes after its gateway's upstream link failed, although the gateway remained HSRP Active. Tracking allowed the alternate gateway to take over, followed by **10/10 replies**. Recovery testing then exposed a second issue: gateway reclamation could precede OSPF readiness.

[Read the HSRP case](07-FHRP/troubleshooting/scenario-1-hsrp-upstream-black-hole.md) · [Inspect alternate-path verification](07-FHRP/verification/hsrp-tracking/PC-A-ping-and-traceroute-tracking-failover.txt)

### Repair an OSPF adjacency when ping still works

O2 received replies to all five probes sent to O4, but OSPF stalled in `EXSTART`. Both physical interfaces reported MTU 1500; the IP-specific check exposed a one-sided 1400-byte setting. Removing the override restored **FULL adjacency on both routers**.

[Read the OSPF case and evidence](02-OSPF/troubleshooting/scenario-1-ospf-mtu-exstart-exchange.md)

## Explore the modules

| Module | Engineering focus | Suggested case |
|---|---|---|
| [01 — EIGRP](01-EIGRP/README.md) | Backup eligibility, failover, and route policy | [A qualified backup takes over](01-EIGRP/troubleshooting/scenario-1-feasible-successor-promotion.md) |
| [02 — OSPF](02-OSPF/README.md) | Neighbor synchronization and routing across areas | [A missing route with healthy neighbors](02-OSPF/troubleshooting/scenario-3-abr-route-filtering-control-plane.md) |
| [03 — BGP](03-BGP/README.md) | Peering, next-hop resolution, and advertisement policy | [A healthy session with an unusable path](03-BGP/troubleshooting/scenario-2-ibgp-next-hop-reachability.md) |
| [04 — STP](04-STP/README.md) | Loop prevention, root placement, and link protection | [Member failure versus bundle failure](04-STP/troubleshooting/11-lacp-negotiation-and-member-failure.md) |
| [05 — MSTP](05-MSTP/README.md) | VLAN-group paths and protocol-boundary protection | [Inconsistent root information blocks a boundary](05-MSTP/troubleshooting/scenario-6-pvst-sim-inferior-vlan/README.md) |
| [06 — EtherChannel](06-ETHERCHANNEL/README.md) | Link aggregation, resilience, and forwarding checks | [A VLAN mismatch suspends one member](06-ETHERCHANNEL/troubleshooting/case-01-vlan-mask-mismatch.md) |
| [07 — FHRP](07-FHRP/README.md) | Gateway redundancy, upstream tracking, and recovery | [Successful traffic conceals a version mismatch](07-FHRP/troubleshooting/scenario-2-hsrp-version-mismatch.md) |
| [08 — NAT/PAT](08-NAT/README.md) | Translation, address sharing, and integrated faults | [Restore access after PAT migration](08-NAT/troubleshooting/incident-02-pat-migration.md) |
| [09 — DHCP](09-DHCP/README.md) | Address assignment, relay, and lease-state diagnosis | [A valid address without remote access](09-DHCP/troubleshooting/02-incorrect-default-gateway.md) |
| [10 — NTP](10-NTP/README.md) | Time hierarchy, source failover, and service-specific diagnosis | [Ping works while time updates stop](10-NTP/troubleshooting/03-acl-udp123.md) |
| [11 — PBR](11-PBR/README.md) | Selective forwarding, policy logic, and next-hop recovery | [A next-hop route remains while the policy path changes](11-PBR/troubleshooting/02-next-hop-failure.md) |
| [12 — Multicast (in progress)](12-MULTICAST/README.md) | Static RP, Auto-RP discovery, source registration, and path diagnosis | [Auto-RP discovery cannot recover](12-MULTICAST/PIM-SM/troubleshooting/04-autorp-listener-recovery.md) |

## How to review the work

**Predict → configure → verify → explain → break → diagnose → repair → capture evidence**

Start with a module's overview or featured case, then follow its supporting guides. Multicast groups these guides under each protocol subsection, starting with PIM-SM:

| Directory | Purpose |
|---|---|
| `configs/` | Device roles, important settings, and configuration source or reconstruction status |
| `verification/` | Captured output, interpretation, and links to individual evidence files |
| `troubleshooting/` | Symptoms, diagnosis, corrective actions, and available recovery checks |

The cases distinguish configured intent, observed device state, and tested service outcomes. A healthy routing session, active gateway, or assigned address can coexist with a forwarding problem.

## Reuse a lab

CML exports are available for [STP](04-STP/CCNP_MASTERCLASS_STP.yaml), [MSTP](05-MSTP/CCNP_MASTERCLASS_MSTP.yaml), [EtherChannel](06-ETHERCHANNEL/CML-LAB.yaml), [NTP](10-NTP/CCNP_MASTERCLASS_LAB_September_18th.yaml), and the two NAT fault states: [Incident 01](08-NAT/configs/incident-01-original.yaml) and [Incident 02](08-NAT/configs/incident-02-original.yaml).

Read the module's configuration guide before import. Exports represent different experiment stages; check image mappings, interface wiring, and VLAN creation before establishing a fresh baseline. Other modules provide extracts, selected settings, or reconstructed configurations, with their scope explained in the guides.

## Evidence scope

This portfolio records controlled lab work. Cases identify whether a result comes from captured output, a recorded observation, or configuration analysis. Missing measurements and reconstructed commands are labeled where relevant.

The file totals count evidence `.txt` files under verification and troubleshooting, not independent tests. They exclude five configuration text files. Additional excerpts appear in Markdown, including 34 numbered NTP blocks, 30 numbered PBR blocks, and 69 numbered Multicast blocks, including labeled Auto-RP handoff excerpts. Diagrams explain the designs; the linked captures establish the recorded behavior.
