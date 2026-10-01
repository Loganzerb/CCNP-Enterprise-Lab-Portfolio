# 14 — GRE and IPsec: A routed overlay with verified protection

GRE connects two sites across an intermediate IP network and carries their private traffic and routing updates. IPsec protects that GRE traffic between the site routers. Together, they provide a routed connection while the transit router only forwards packets between the WAN endpoints.

I built the GRE overlay, established OSPF across it, and added IKEv1/IPsec transport-mode protection. Three controlled faults then tested peer authentication, encryption agreement, and traffic selection. Each repair restored the tunnel's routing adjacency without restarting OSPF.

**Final result: 20/20 sourced private-to-private replies, active ESP SAs, increasing encryption/decryption counters, and zero recorded crypto send/receive errors.**

**Process diagrams:** [Protected packet flow](operation.md#how-private-traffic-crosses-the-transit-network) · [Configuration dependencies](configs/ipsec.md#how-the-configuration-pieces-connect) · [Fault diagnosis](troubleshooting/README.md#locate-the-failing-layer)

## Results at a glance

| Stage | What I verified | Result |
|---|---|---|
| GRE | Interface display versus actual overlay reachability | Up/up appeared before the remote tunnel existed; overlay ping succeeded after both ends were configured |
| OSPF | Private routing across Tunnel0 | FULL adjacency; remote loopback host routes learned through the overlay |
| Protected traffic | Current IKE and ESP state, routing, and a sourced traffic test | QM_IDLE/ACTIVE; active transport-mode ESP; 20/20 replies |
| Authentication fault | Fresh negotiation after a PSK mismatch | Main Mode attempts failed; correcting the key restored IKE, ESP, and OSPF |
| Transform fault | IKE remained established while ESP could not rebuild | AES-256 restoration brought back ESP and FULL adjacency |
| Selector fault | Correct peer, incorrect protected destination | Correcting 192.0.2.5 to 192.0.2.1 restored encrypted forwarding |

## Start with these files

For a quick review, read [final validation](verification/03-final-validation.md): the sourced ping, FULL adjacency, active SAs, and counter changes establish a complete request/reply path.

For the strongest troubleshooting example, read [Case 03 — A healthy IKE session with the wrong selector](troubleshooting/03-selector-mismatch.md). R1 retained 102 encrypted/decrypted packets from earlier operation while its current outbound SPI was zero and traffic failed.

## Topology and objective

![GRE and IPsec overlay between R1-VPN and R3-VPN across R2-TRANSIT](topology.png)

R1-VPN and R3-VPN terminate GRE and IPsec. R2-TRANSIT provides the routed WAN path and participates in neither the tunnel nor OSPF. The overlay uses 172.16.13.0/30; the private test endpoints are 10.10.10.1 and 10.30.30.1.

The project addresses **CCNP ENCOR 350-401 v1.2, objective 2.2.b — GRE and IPsec tunneling**, under configuring and verifying data path virtualization technologies.

[Roles, addresses and wiring](topology.md) · [Packet behavior](operation.md)

## Explore the section

| Guide | Purpose |
|---|---|
| [Configurations](configs/README.md) | Sanitized device extracts and the relationship between IKE, ESP, selectors, and the WAN crypto map |
| [Verification](verification/README.md) | Numbered CLI blocks, initial GRE/OSPF observations, and final protected traffic checks |
| [Troubleshooting](troubleshooting/README.md) | Three controlled faults with symptoms, investigation, correction, and recovery evidence |

## Engineering lessons

- GRE supplies the overlay; IPsec adds confidentiality and integrity. R2 needs only the outer endpoint routes.
- Tunnel up/up and IKE QM_IDLE are useful checks, but service validation also needs current ESP SAs and traffic tests.
- The crypto ACL selects GRE between the WAN endpoints. The crypto map activates protection on Gi0/0.
- Verify inbound and outbound SAs separately. Cross-peer SPI correlation identifies the two traffic directions.
- Existing SAs can mask a configuration mismatch until renegotiation. Historical counters can also survive a failed current state.
- Repair the failing dependency and observe recovery; the recorded cases did not require an OSPF process restart.

## Evidence scope

The initial GRE/OSPF milestones come from the completed-lab handoff. The linked CLI captures establish the IPsec failures, repairs, and final validation. Device configuration files are clearly labeled reconstructions, with the lab key replaced by a placeholder. [Source and measurement boundaries](scope.md) identify partial captures and unmeasured behavior.

[Back to portfolio](../README.md)
