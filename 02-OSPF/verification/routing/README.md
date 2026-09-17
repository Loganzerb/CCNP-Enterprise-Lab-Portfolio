# Routing — which routes were installed?

The five `show ip route ospf` captures show OSPF-installed routes. They do not list every connected or static route, and they do not measure endpoint delivery.

| Capture | What to inspect |
|---|---|
| [O1-CORE](O1-show-ip-route-ospf.txt) | Branch `172.20.32.0/22` as `O IA`, metric 21; external test prefixes as `O E1`, metric 41 |
| [O2-ABR](O2-show-ip-route-ospf.txt) | Four branch `/24` routes and the local `/22` Null0 summary; external prefixes as `O N1`, metric 31 |
| [O3-BRANCH](O3-show-ip-route-ospf.txt) | Default toward O2; equal-cost next hops toward O4 and the external test prefixes |
| [O4-EDGE](O4-show-ip-route-ospf.txt) | Default toward O2; two next hops for each branch prefix |
| [O5-TRANSIT](O5-show-ip-route-ospf.txt) | Two next hops for the default; branch routes toward O3; external routes toward O4 |

## Read the route codes

| Code | Meaning |
|---|---|
| `O` | Intra-area OSPF route |
| `O IA` | Inter-area OSPF route |
| `O N1` | NSSA external route, metric type 1 |
| `O E1` | External route, metric type 1 |
| `O*IA 0.0.0.0/0` | Inter-area candidate default route |

In `[110/21]`, 110 is administrative distance and 21 is the route's OSPF metric. For a multipath entry, the following indented next-hop line belongs to the same destination.

## Concrete equal-cost examples

- O2 reaches O5's `10.100.5.5/32` through `10.100.23.2` and `10.100.24.2`, each metric 21.
- O3 reaches `192.0.2.0/24` through O2 and O5, each metric 41.
- O5's default has next hops through O3 and O4, each metric 21.

These captures establish equal-cost multipath (ECMP) installation. They do not demonstrate how flows were distributed or how quickly a failed path was removed.

## Default and discard-route context

O3, O4, and O5 have default routes toward the area border; O1 and O2 report no gateway of last resort in these snapshots. A default inside Area 10 therefore does not imply Internet access.

O2's Null0 summary coexists with the four more-specific branch routes. O4's external test prefixes are static Null0 routes in its configuration, so their local source routes do not appear in `show ip route ospf`. Their absence from O4's OSPF-only listing does not establish that they are missing from its full routing table.

[Verification guide](../README.md) · [Database guide](../database/README.md)
