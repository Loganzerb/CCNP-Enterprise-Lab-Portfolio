# Integrated Enterprise Networking

Start with the campus and dual-provider WAN flagships, then review the QoS project. These three CML topologies complement the 22 standalone modules in the 25-project portfolio.

| Review order | Engineering focus | Evidence from the completed lab | Build reference |
|---|---|---|---|
| **1.** [19A — Integrated Enterprise Network](19A-INTEGRATED-ENTERPRISE-NETWORK/README.md) | Campus switching, redundant gateways, upstream routing, PAT, and consistent access policy | [Reported observations](19A-INTEGRATED-ENTERPRISE-NETWORK/verification/README.md) | [Diagram](19A-INTEGRATED-ENTERPRISE-NETWORK/README.md#lab-design) · [Wiring](19A-INTEGRATED-ENTERPRISE-NETWORK/topology.md) · [Configuration](19A-INTEGRATED-ENTERPRISE-NETWORK/configs/README.md) |
| **2.** [20A — Dual-ISP Enterprise WAN](20A-DUAL-ISP-WAN/README.md) | BGP peering, return paths, monitored defaults, and forwarding recovery | [Captured CLI and reported observations](20A-DUAL-ISP-WAN/verification/README.md) | [Diagram](20A-DUAL-ISP-WAN/README.md#lab-design) · [Wiring](20A-DUAL-ISP-WAN/topology.md) · [Configuration](20A-DUAL-ISP-WAN/configs/README.md) |
| **3.** [20B — Enterprise WAN QoS](20B-ENTERPRISE-WAN-QOS/README.md) | Classification, marking, priority and bandwidth queues, policing, and shaping | [Captured CLI and iPerf excerpts](20B-ENTERPRISE-WAN-QOS/verification/README.md) | [Diagram](20B-ENTERPRISE-WAN-QOS/README.md#lab-design) · [Wiring](20B-ENTERPRISE-WAN-QOS/topology.md) · [Configuration](20B-ENTERPRISE-WAN-QOS/configs/README.md) |
| **4.** [Standalone modules](../README.md#explore-the-modules) | Deeper practice with individual technologies | [Standalone featured cases](../README.md#start-with-these-three-cases) | [Reading guide](../READING-GUIDE.md#project-highlights) |

The verification guides identify **captured CLI**, **captured iPerf output**, and **reported observations** where each applies. Configuration guides explain implementation from the inspected saved settings. Complete CML checkpoints are retained privately pending redistribution clearance. Fresh CML import, boot, and runtime replay remain pending.

[Standalone modules](../README.md#explore-the-modules) · [Reading guide](../READING-GUIDE.md#integrated-projects) · [Back to portfolio](../README.md)
