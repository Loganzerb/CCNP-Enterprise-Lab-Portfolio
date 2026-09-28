# Troubleshooting — locate the failed dependency

| Case | Symptom | Decisive evidence | Repair and result |
|---|---|---|---|
| [01 — Bad next hop](01-bad-next-hop.md) | The route installs, but the loopback is unreachable | ARP for 10.10.10.99 is Incomplete while the real CE replies | Restore 10.10.10.2; 5/5 replies |
| [02 — Wrong routing table](02-wrong-table.md) | Static route appears in configuration but not the RIB | The global table cannot resolve a next hop reachable in RED | Restore the VRF-specific route; 5/5 replies |
| [03 — Missing return paths](03-return-path.md) | Forward leaks install, but service access fails | Unique CE destinations are absent from R1’s global table | Add explicit return routes and CE service routes; final 5/5 to both CEs |

These were controlled lab exercises. The common method is to identify the routing context, check route installation, inspect CEF and ARP, and test the relevant endpoints after correction.

[Full verification record](../verification/README.md) · [VRF overview](../README.md)
