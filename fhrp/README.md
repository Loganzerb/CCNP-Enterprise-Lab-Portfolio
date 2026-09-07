# First Hop Redundancy: HSRP, VRRP, and GLBP

Cisco Modeling Labs exercises demonstrating gateway redundancy, forwarding behavior, controlled failures, and recovery.

The work connects protocol state to host connectivity using device logs, routing tables, ARP entries, spanning-tree state, MAC tables, ping, and traceroute.

## Topology

![FHRP campus topology](assets/fhrp-campus-topology.png)

The campus diagram shows the healthy HSRP placement. VLAN 20 was subsequently used for VRRP. GLBP used a separate topology:

![GLBP logical topology](assets/glbp-topology.png)

These are explanatory diagrams based on the lab record, not screenshots or additional experimental evidence. The GLBP access layer is shown as a shared Layer 2 segment; switch port wiring is intentionally abstracted.

## Portfolio sections

| Section | Demonstrated work |
|---|---|
| [HSRP](hsrp/README.md) | Dual-VLAN gateway placement, priority, preemption, tracking, authentication, and timers |
| [VRRP](vrrp/README.md) | Master/Backup operation, default preemption, gateway failure, upstream tracking, and recovery delay |
| [GLBP](glbp/README.md) | AVG/AVF roles, three load-balancing modes, forwarder takeover, tracking, authentication, and timers |
| [Troubleshooting](troubleshooting/README.md) | Three focused engineering case studies |

## Lab environments

**HSRP and VRRP:** Two distribution devices, an access switch, an inter-distribution EtherChannel, two client VLANs, and routed OSPF uplinks to CORE-R1.

| Network | Virtual gateway | DIST-A | DIST-B |
|---|---|---|---|
| VLAN 10 | 10.10.10.1 | 10.10.10.2 | 10.10.10.3 |
| VLAN 20 | 10.20.20.1 | 10.20.20.2 | 10.20.20.3 |

HSRP initially served both VLANs. VLAN 20 was subsequently used for the VRRP exercises.

**GLBP:** A separate three-router topology with IOSv endpoints HOST-A, HOST-B, and HOST-C. Each GLBP router had an independently verified OSPF path to CORE-R1.

| Device | Client-facing address | Initial virtual forwarder |
|---|---|---|
| GLBP-R1 | 10.30.30.2 | AVF1 — 0007.b400.1e01 |
| GLBP-R2 | 10.30.30.3 | AVF2 — 0007.b400.1e02 |
| GLBP-R3 | 10.30.30.4 | AVF3 — 0007.b400.1e03 |

GLBP group 30 used virtual gateway **10.30.30.1**. The upstream test destination in both environments was **10.255.255.1**.

## Evidence standard

Evidence comes from user-pasted lab output in **MASTERCLASS CCNP LAB PART 3**, conversation ID `6a94caeb-6ca4-83ea-93e3-f4eccdd6cbb5`, covering the September 5–7 exercises.

- CLI blocks contain selected observed lines. Omitted lines are not reconstructed.
- Chat transport escaping and whitespace are normalized for readability.
- Tables summarize captures; they are not presented as terminal output.
- Source references identify the originating conversation turn by its unique ID prefix. The [evidence index](evidence/README.md) links those references to the preserved source messages.
- Configuration summaries describe settings supported by captures. They are not complete running-config exports.
- Prior assistant predictions and explanations are not treated as measured evidence.
- Packet counts are reported as captured. Separate runs do not establish precise convergence guarantees.
- Unrelated endpoint persistence problems and the accidentally powered-off access switch are excluded from FHRP fault conclusions.

## Engineering findings

1. An Active gateway can remain reachable while its upstream forwarding path is broken.
2. Successful ping does not establish healthy redundancy.
3. Traceroute cannot expose a transit device that only switches the frame.
4. Link recovery and routing recovery are separate events.
5. GLBP gateway election, forwarder eligibility, and client assignment must be inspected separately.
