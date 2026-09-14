# 09 — DHCP: Reliable Addressing and Troubleshooting

DHCP gives devices the network settings they need to communicate. This lab examines what happens when those settings are missing, incorrect, or out of sync—and how to verify that service has actually recovered.

I built a four-device Cisco Modeling Labs environment serving two client networks from one DHCP server. Through controlled failures, I restored address assignment across network boundaries, traced a connectivity failure to an incorrect gateway, and reconciled conflicting client and server lease records.

**4 devices · 2 client networks · 3 troubleshooting cases**

## Results at a glance

| Problem | What I established | Result |
|---|---|---|
| A connected client could not obtain an address | Requests needed DHCP relay to reach the server on another subnet | Both client networks received addresses from the appropriate pools |
| CLIENT-B had an address but could not reach a remote resource | DHCP supplied the wrong default gateway; ARP debugging exposed the failed next hop | Correcting the pool and refreshing the client restored 5/5 replies |
| The client retained an address the server no longer recorded | Client and server maintained independent lease state; changing renewal policy produced a server-side rejection | A fresh acquisition restored a matching binding and 5/5 remote replies |

## Start with the evidence

For a quick review, read [Case 02 — An address without remote access](troubleshooting/02-incorrect-default-gateway.md). It follows one symptom through diagnosis, a targeted correction, and verification.

For deeper technical discussion, read [Case 03 — Client and server disagree about a lease](troubleshooting/03-lease-state-mismatch.md). It compares evidence from both devices and distinguishes a server sending a response from a client processing it.

## Lab topology

![DHCP lab: two clients connect through DIST-SW to a server on VLAN 99; all three links are access links](topology.png)

| Device | Responsibility |
|---|---|
| CLIENT-A / CLIENT-B | IOSv routers operating as hosts; request settings for VLANs 10 and 20 |
| DIST-SW | Routes between the three VLANs and relays client DHCP requests |
| DHCP-SRV | Assigns addresses and gateway settings from two separate pools |

CLIENT-A received `10.10.10.21/24`. CLIENT-B progressed from `10.10.20.21` to `.22` and finally `.23` during testing. The DHCP server is `10.99.99.50`; each client's gateway is `.1` in its own subnet.

[View the addressing and wiring guide](topology.md). The illustration shows recovered addressing, not a packet capture.

## What this work demonstrates

- **Fault isolation:** use client state, server records and packet debugging to narrow a failure.
- **Controlled changes:** change one condition, inspect the effect, and restore the baseline.
- **Recovery verification:** confirm the client's settings, the server's matching record and communication across the network boundary.
- **Technical judgment:** separate observed results from explanations that still require more evidence.

## Explore the section

| Location | What you will find |
|---|---|
| [Troubleshooting](troubleshooting/README.md) | Three concise cases: symptom, reasoning, correction and outcome |
| [Verification](verification/README.md) | Guided evidence index, DORA explanation and lease progression |
| [Configurations](configs/README.md) | Four reconstruction files and the actual captured DHCP pool settings |
| [Technical references](references.md) | Cisco documentation and the DHCP standard supporting the explanations |

## Evidence scope

The cases use console output pasted during the September 12–13 lab in **MASTERCLASS CCNP LAB PART 3** and **MASTERCLASS CCNP LAB PART 4**. The 15 evidence files retain 45 source messages, with chat formatting normalized and source IDs recorded. These were guided, controlled exercises.

Configuration files reconstruct the working setup from the lab record; they are not complete running-config exports. No DHCP CML export was attached. The recorded results establish address assignment, selected protocol behavior and CLIENT-B-to-server reachability. DNS resolution, Internet access, natural T2/lease-expiry behavior and a DHCPDECLINE incident were not demonstrated.

