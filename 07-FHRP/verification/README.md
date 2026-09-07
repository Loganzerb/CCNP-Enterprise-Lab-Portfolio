# Verification evidence

The 80 `.txt` files retain the supplied user-pasted console captures byte for byte, including source prompts, typographical errors, chat escaping, and occasional user commentary. They are conversation captures rather than direct device exports. Filenames identify the device, command or test, and observed state.

These captures span baseline, failure, and recovery stages; the directory is not a single final-state snapshot. One separate Markdown file preserves the user-reported cleanup confirmation.

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
| [GLBP timers and recovery](glbp-timers/) | 5 | Default/custom timer runs, configured versus operational timer values, and restored AVF ownership. The separate restoration note is user confirmation, not a device capture. |

## Provenance and interpretation

The [source map](source-map.md) records each original archive path, its source turn ID as listed in the supplied evidence index, its new location, and a SHA-256 digest of the original bytes. This preserves traceability without using conversation IDs as filenames.

Narrative excerpts retain whitespace and chat-escaping normalization from the supplied guides. Full captures remain unchanged. Configuration implications, illustrative diagrams, user reports, and limits on measurement are identified separately from observed CLI.

[FHRP overview](../README.md) · [Troubleshooting cases](../troubleshooting/README.md)
