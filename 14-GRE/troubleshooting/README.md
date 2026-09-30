# Troubleshooting — check the tunnel’s dependencies

| Case | Symptom | Decisive evidence | Result |
|---|---|---|---|
| [01 — Missing underlay route](01-underlay-route-loss.md) | Overlay traffic fails while early displays remain healthy | No RIB/CEF transport route and 0/5 probes | Restored route, up/up tunnel and FULL OSPF |
| [02 — Recursive routing](02-recursive-routing.md) | Tunnel and routing adjacency fail despite the configured covering route | Looped midchain and RECURDOWN syslogs after adding the bad /32 | Tunnel, adjacency and remote route recover |
| [03 — MTU boundary](03-mtu-boundary.md) | Small probes work but larger DF probes fail | 1476/1477 tests with one variable changed at a time | 1477 succeeds when fragmentation is permitted |

The first two cases deliberately changed routing configuration. The third diagnoses a packet-size constraint through controlled probes; it does not claim a configuration repair.

[Evidence index](../verification/README.md) · [GRE overview](../README.md)
