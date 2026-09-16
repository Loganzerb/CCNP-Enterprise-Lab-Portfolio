# Installed routes and traceroutes

These captures pair an IP routing-table entry with a traffic probe. They show installed next hops and observed responses; **none demonstrates successful delivery to the destination address**.

| Capture | Installed route | Traceroute observation |
|---|---|---|
| [X1 → 172.31.250.1](X1-bgp-forwarding-172.31.250.0.txt) | `172.31.250.0/24` through B1 at `10.250.3.1` | B1 responds as hop 1; hops 2–30 time out |
| [O4 → 203.0.113.1](O4-bgp-forwarding-203.0.113.0.txt) | `203.0.113.0/24` through B2 at `10.250.2.2` | B2 responds, then returns host-unreachable indications (`!H`) |
| [B1 → 198.51.100.1](B1-bgp-forwarding-198.51.100.0.txt) | `198.51.100.0/24` through X1's loopback `10.255.3.3` | X1's connected address `10.250.3.2` responds, then returns `!H` |

## Why the BGP next hop and first responding hop differ

B1's installed route names X1's loopback, `10.255.3.3`. The [B1 configuration](../../configs/B1-ISP-A.cfg) contains a supporting static route to that loopback through `10.250.3.2`. Resolving one next hop through another route is recursive resolution. The trace's first physical hop is therefore consistent with the installed BGP route.

## What the destination represents

The relevant prefixes are backed by Null0 routes on O2, B2, and X1. Those discard routes support route origination and selection exercises; the destination addresses are not documented as live hosts.

The O4 and B1 results show responses from the destination-side router and host-unreachable indications. X1's repeated timeouts establish only that no further responses were captured; they do not identify the exact point where packets stopped.

For stronger service verification in a future lab, an addressed endpoint and a successful return-path test would be needed. That test is not part of this evidence set.

[Verification guide](../README.md) · [Topology and test prefixes](../../topology.md)
