# 07 — FHRP

CCNP ENCOR portfolio lab demonstrating HSRP, VRRP, and GLBP gateway redundancy in Cisco Modeling Labs. The exercises connect gateway state to upstream routing, host ARP, Layer 2 forwarding, controlled failures, and recovery.

The engineering workflow is **build → verify → break → diagnose → restore**. The retained record includes 80 console-capture files, three troubleshooting case studies, two explanatory topology diagrams, and a separate user-reported cleanup note.

## Evidence policy

This module preserves the lab material supplied in `ccnp-fhrp-portfolio.zip`, which identifies its source as **MASTERCLASS CCNP LAB PART 3**, covering the September 5–7 exercises. Console captures remain unchanged, including prompts, chat escaping, occasional prose, and source formatting artifacts. They are user-pasted conversation captures, not direct device exports.

The protocol guides use selected observed lines and summary tables. Their excerpts normalize whitespace and chat escaping; omitted output is not reconstructed. Prior assistant predictions are not treated as measured evidence. The [source map](verification/source-map.md) retains the original file-to-turn mapping and capture hashes.

No complete FHRP running-config files or CML YAML exports were included in the supplied package. The [configuration index](configs/README.md) links the retained configuration excerpt and observed settings without presenting them as complete restore files. Captures span several experiment stages rather than one final configuration.

## Topology

### HSRP and VRRP campus lab

![FHRP campus topology](topology.png)

Two distribution devices serve the client VLANs through a redundant access switch. An inter-distribution EtherChannel connects DIST-A and DIST-B, and routed OSPF uplinks connect both distribution devices to CORE-R1.

| Network | Virtual gateway | DIST-A | DIST-B | Preferred HSRP gateway |
|---|---|---|---|---|
| VLAN 10 | `10.10.10.1` | `10.10.10.2` | `10.10.10.3` | DIST-A |
| VLAN 20 | `10.20.20.1` | `10.20.20.2` | `10.20.20.3` | DIST-B |

HSRP initially served both VLANs. The later VRRP phase reused VLAN 20 with DIST-B as the preferred Master and DIST-A as Backup. The upstream test destination was CORE-R1's `10.255.255.1` loopback.

### GLBP lab

![GLBP logical topology](topology-glbp.png)

GLBP used a separate three-router topology with IOSv endpoints HOST-A, HOST-B, and HOST-C. Each GLBP router had an independently verified OSPF path to CORE-R1. Group 30 used virtual gateway **10.30.30.1** and the same upstream test destination, **10.255.255.1**.

| Device | Client-facing address | Preferred gateway role after AVG preemption | Initial virtual forwarder |
|---|---|---|---|
| GLBP-R1 | `10.30.30.2` | AVG, priority 130 | AVF1 — `0007.b400.1e01` |
| GLBP-R2 | `10.30.30.3` | Standby AVG, priority 110 | AVF2 — `0007.b400.1e02` |
| GLBP-R3 | `10.30.30.4` | Listen, priority 100 | AVF3 — `0007.b400.1e03` |

Both images are supplied explanatory illustrations, not captured experimental evidence. The campus image shows healthy HSRP placement; the GLBP image abstracts access-switch wiring as a shared Layer 2 segment. Device roles changed during the documented tests.

## Design objectives

- Establish complementary HSRP gateway placement across two client VLANs.
- Verify gateway state together with upstream routes, host ARP, ping, and traceroute.
- Connect gateway preference to upstream health through tracking.
- Compare gateway reclamation with routing readiness and preemption delay.
- Diagnose HSRP version mismatch and STP/HSRP path misalignment.
- Inspect GLBP AVG election, AVF ownership, forwarding eligibility, and client assignment separately.
- Record authentication failures, timer behavior, takeover, and recovery with the available evidence.

## Protocol verification

| Protocol | Retained work | Detailed guide |
|---|---|---|
| HSRP | Dual-VLAN Active/Standby placement, upstream tracking, preemption delay, version consistency, authentication, and custom timers | [HSRP verification](verification/hsrp.md) |
| VRRP | Master/Backup election, enabled preemption, gateway-interface failure, upstream tracking, and delayed recovery | [VRRP verification](verification/vrrp.md) |
| GLBP | AVG/AVF roles, round-robin, weighted and host-dependent assignment, takeover, weighting thresholds, authentication, and timers | [GLBP verification](verification/glbp.md) |

The guides retain the substantive analysis and selected console excerpts. The [verification index](verification/README.md) groups the full captures by operational topic, with device-and-test filenames and an index in each folder.

## Troubleshooting highlights

### Scenario 1 — HSRP upstream black hole

DIST-A remained Active after its upstream interface failed, while the destination route disappeared and PC-A lost all ten test probes. Tracking reduced effective priority from 120 to 99, allowing DIST-B to carry client traffic. Recovery testing then showed why gateway reclamation needed to account for OSPF readiness; the delayed run still contained packet loss.

[Read the case study](troubleshooting/scenario-1-hsrp-upstream-black-hole.md)

### Scenario 2 — HSRP version mismatch

DIST-A reverted to HSRPv1 while DIST-B remained on HSRPv2. Both claimed Active state and used different virtual MACs for the same gateway IP. PC-B still completed 19 of 20 probes, demonstrating that successful traffic alone did not prove a healthy redundancy pair. Restoring HSRPv2 recovered peer recognition and the intended roles.

[Read the case study](troubleshooting/scenario-2-hsrp-version-mismatch.md)

### Scenario 3 — STP/HSRP path misalignment

VLAN 20's STP root moved to DIST-A while its HSRP Active gateway remained DIST-B. STP port roles and virtual-MAC learning showed the additional Layer 2 traversal across Po10. Traceroute still showed DIST-B as the first routed hop. Restoring the original root placement returned gateway-bound traffic to the direct path.

[Read the case study](troubleshooting/scenario-3-stp-hsrp-path-misalignment.md)

## Coverage and evidence limits

| Area | Captured result | Boundary |
|---|---|---|
| HSRP placement and tracking | Peer state, tracked priority, routes, and client forwarding | Recovery runs contained loss; no fast-convergence guarantee |
| HSRP version mismatch | Dual-active state, different virtual MACs, duplicate-address logs, and repair | No claim of repeated ARP oscillation or alternating loss |
| STP/HSRP alignment | Changed root port, MAC learning across Po10, and restored direct path | Small ping samples do not quantify a latency penalty |
| HSRP authentication and timers | Rejected peer authentication, repaired roles, operational 1/4 timers, and takeover | No precise elapsed takeover measurement |
| VRRP recovery delay | OSPF FULL preceded the delayed Master transition | Combined failure/recovery ping includes loss and unusually high RTT; no clean recovery-only outage measure |
| GLBP round-robin | Three hosts received different forwarder MACs and completed upstream pings | Does not measure equal bandwidth use |
| GLBP weighted mode | Configured 60/30/10 weights; ten ARP observations counted 4/3/3 | Does not establish a long-run 60/30/10 ratio |
| GLBP host-dependent mode | Three HOST-A trials retained AVF2; HOST-B used AVF2 and HOST-C used AVF3 | Different hosts sharing an AVF is not itself a fault |
| GLBP AVG and AVF failover | Gateway election, inherited virtual-MAC service, and independent role recovery | Packet losses are reported per capture without assigning unsupported causes |
| GLBP weighting and tracking | Weighting 100 → 70 withdrew AVF1 while R1 remained AVG | Later 60 − 35 = 25 is a configuration implication, not the captured threshold test |
| GLBP authentication | Rejection logs, conflicting group views, and recovered placement | Claims remain tied to the captured device views |
| GLBP hello/hold timers | Default run had a six-loss cluster; custom run had a three-loss cluster | Separate runs do not prove a percentage improvement or convert loss counts into seconds |
| GLBP configured/operational timers | R2 displayed operational 3/10 with local configured 1/4 | Final all-router default cleanup was user-confirmed without a full post-cleanup export |
| Redirect and forwarder timers | Displayed values of 600 and 14400 seconds | Timer expiration was not observed |

Unrelated endpoint persistence problems and the accidentally powered-off access switch are excluded from the FHRP fault conclusions, as in the supplied package.

## Artifact map

```text
07-FHRP/
├── README.md
├── topology.png
├── topology-glbp.png
├── configs/
│   └── README.md
├── verification/
│   ├── README.md
│   ├── hsrp.md
│   ├── vrrp.md
│   ├── glbp.md
│   ├── source-map.md
│   ├── hsrp-baseline/
│   ├── hsrp-tracking/
│   ├── hsrp-version-mismatch/
│   ├── hsrp-authentication/
│   ├── hsrp-timers/
│   ├── stp-alignment/
│   ├── vrrp/
│   ├── glbp-baseline/
│   ├── glbp-load-balancing/
│   ├── glbp-failover/
│   ├── glbp-tracking/
│   ├── glbp-authentication/
│   └── glbp-timers/
└── troubleshooting/
    ├── README.md
    ├── scenario-1-hsrp-upstream-black-hole.md
    ├── scenario-2-hsrp-version-mismatch.md
    └── scenario-3-stp-hsrp-path-misalignment.md
```

## Engineering findings

1. An Active gateway can remain reachable while its upstream forwarding path is broken.
2. Successful ping does not establish healthy redundancy.
3. Traceroute cannot expose a transit device that only switches the frame.
4. Link recovery and routing recovery are separate events.
5. GLBP gateway election, forwarder eligibility, and client assignment require separate inspection.

**Review:** [Configuration evidence](configs/README.md) · [Verification](verification/README.md) · [Troubleshooting](troubleshooting/README.md)
