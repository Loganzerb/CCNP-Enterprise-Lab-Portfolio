# Interfaces — where does OSPF participate?

Each capture contains `show ip ospf interface brief`: process ID, area, local address, cost, state, and full/current neighbor counts.

| Capture | What to inspect |
|---|---|
| [O1-CORE](O1-show-ip-ospf-interface-brief.txt) | Area 0; Gi0/0 is BDR with one full neighbor; the additional Gi0/1 has `0/0` neighbors |
| [O2-ABR](O2-show-ip-ospf-interface-brief.txt) | Area 0 on Gi0/0 and Loopback0; Area 10 on Gi0/1 and Gi0/2 |
| [O3-BRANCH](O3-show-ip-ospf-interface-brief.txt) | Two point-to-point neighbors and four branch loopbacks with `/24` masks |
| [O4-EDGE](O4-show-ip-ospf-interface-brief.txt) | Gi0/0 is DR toward O2; Gi0/1 is point-to-point toward O5; extra Gi0/2 has `0/0` neighbors |
| [O5-TRANSIT](O5-show-ip-ospf-interface-brief.txt) | Two point-to-point interfaces, each with one full neighbor |

The five primary transit links have cost 10; loopbacks have cost 1. `P2P` is a network/interface state, not proof that a neighbor exists: O3's branch loopbacks and the two extra transit interfaces show `0/0`.

This command does not display IP MTU, authentication keys, or detailed Hello/Dead timers. [Case 01](../../troubleshooting/scenario-1-ospf-mtu-exstart-exchange.md) uses `show ip interface` and configuration output to expose the MTU mismatch.

[Verification guide](../README.md) · [Addressing table](../../topology.md)
