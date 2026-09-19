# FHRP verification guide

The 80 text files preserve console output recorded during the lab, including original prompts, formatting, and occasional notes. Filenames identify the device, test, and observed state. The files were collected through the lab conversation rather than direct device exports.

These captures span baseline, failure, and recovery stages; the directory is not a single final-state snapshot. A separate Markdown note records cleanup confirmation without a post-cleanup device export.

## Protocol guides

- [HSRP — gateway placement, tracking, authentication, and timers](hsrp.md)
- [VRRP — election, upstream tracking, and delayed recovery](vrrp.md)
- [GLBP — gateway/forwarder roles, client assignment, failures, and timers](glbp.md)

## Capture index

| Area | Captures | Scope |
|---|---:|---|
| [HSRP baseline](hsrp-baseline/) | 2 | Campus client forwarding and the retained DIST-A Vlan10 configuration excerpt. Complementary dual-VLAN peer roles are also captured after version repair in the HSRP version-mismatch folder. |
| [HSRP upstream tracking and recovery](hsrp-tracking/) | 7 | Untracked upstream failure, effective-priority reduction, alternate forwarding, and recovery ordering with and without preemption delay. Packet loss remains visible in the original captures. |
| [HSRP version mismatch](hsrp-version-mismatch/) | 4 | The version change, independent Active claims, virtual-MAC differences, client behavior, and restored HSRPv2 peer relationship. |
| [HSRP authentication](hsrp-authentication/) | 3 | Authentication rejection, independent Active state, and restored peer recognition. |
| [HSRP timers](hsrp-timers/) | 2 | Operational 1/4 hello and hold timers and the observed gateway takeover. No exact elapsed failover measurement was retained. |
| [STP and HSRP path alignment](stp-alignment/) | 8 | Before, misaligned, and restored VLAN 20 paths, correlated through STP port roles, gateway MAC learning, HSRP state, ping, and traceroute. |
| [VRRP election, tracking, and recovery](vrrp/) | 6 | VLAN 20 Master/Backup election, interface failure, tracked priority reduction, and recovery ordering relative to OSPF. These captures cover different experiment stages. |
| [GLBP baseline and round-robin assignments](glbp-baseline/) | 6 | Independent upstream routes, host pings and initial virtual-MAC assignments, plus preferred AVG placement after preemption was enabled. |
| [GLBP client assignment](glbp-load-balancing/) | 18 | Weighted and host-dependent settings and recorded ARP observations. Weighted trial numbers follow the supplied guide; the ten observations do not prove long-run 60/30/10 distribution. |
| [GLBP AVG and AVF failover](glbp-failover/) | 13 | Gateway election, inherited-forwarder service, client ARP continuity, ping results, and independent AVG/AVF recovery. |
| [GLBP weighting and upstream tracking](glbp-tracking/) | 2 | The captured threshold experiment uses weighting 100 to 70 and back to 100. It demonstrates AVF withdrawal while the router remains AVG. |
| [GLBP authentication](glbp-authentication/) | 4 | Authentication rejection, conflicting gateway/forwarder claims, and restored group placement. |
| [GLBP timers and recovery](glbp-timers/) | 5 | Default/custom timer runs, configured versus operational timer values, and restored AVF ownership. The separate restoration note records completion without a device capture. |

## Provenance and interpretation

The [source map](source-map.md) records each original archive path, its source turn ID as listed in the supplied evidence index, its new location, and a SHA-256 digest of the original bytes. This preserves traceability without using conversation IDs as filenames.

Narrative excerpts retain whitespace and chat-escaping normalization from the supplied guides. Full captures remain unchanged. Configuration implications, illustrative diagrams, user reports, and limits on measurement are identified separately from observed CLI.

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
| GLBP configured/operational timers | R2 displayed operational 3/10 with local configured 1/4 | Final all-router default cleanup was confirmed in the lab notes without a full post-cleanup export |
| Redirect and forwarder timers | Displayed values of 600 and 14400 seconds | Timer expiration was not observed |

Unrelated endpoint persistence problems and the accidentally powered-off access switch are excluded from the FHRP fault conclusions, as in the supplied package.

[FHRP overview](../README.md) · [Troubleshooting cases](../troubleshooting/README.md)
