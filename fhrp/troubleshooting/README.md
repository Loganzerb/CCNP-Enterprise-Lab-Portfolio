# FHRP Troubleshooting Case Studies

Three cases demonstrate different failure classes:

| Case | Failure class | Decisive evidence |
|---|---|---|
| [01 — HSRP upstream black hole](01-hsrp-upstream-black-hole/README.md) | Gateway remains Active without upstream reachability | Missing route, failed client probes, tracked priority reduction |
| [02 — HSRP version mismatch](02-hsrp-version-mismatch/README.md) | Broken peer relationship despite substantial connectivity | Dual-active state, different virtual MACs, duplicate-address logs |
| [03 — STP/HSRP path misalignment](03-stp-hsrp-path-misalignment/README.md) | Functional but indirect forwarding path | STP port roles and virtual-MAC learning across Po10 |

VRRP and GLBP remain protocol showcases with their own failure and recovery evidence. They do not add further numbered deep troubleshooting cases.

[FHRP overview](../README.md)
