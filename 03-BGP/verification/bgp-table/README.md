# BGP tables — what paths were available and selected?

These files retain each router's complete captured `show ip bgp` output.

| Capture | Useful detail |
|---|---|
| [O1-CORE](O1-show-ip-bgp.txt) | External paths through B1 and reflected internal paths through O4 |
| [O2-ABR](O2-show-ip-bgp.txt) | Candidate paths through both enterprise edges; locally originated `172.31.250.0/24` |
| [O4-EDGE](O4-show-ip-bgp.txt) | Provider alternatives and a selected direct path to `203.0.113.0/24` through B2 |
| [B1-ISP-A](B1-show-ip-bgp.txt) | Several paths to `198.51.100.0/24`; the direct X1 path has local preference 50 |
| [B2-ISP-B](B2-show-ip-bgp.txt) | Alternatives for enterprise/provider prefixes and locally originated `203.0.113.0/24` |
| [X1-OUTSIDE](X1-show-ip-bgp.txt) | The `192.0.2.0/24` aggregate and three suppressed component prefixes |

## Interpret the markers

| Marker | Meaning in these outputs |
|---|---|
| `*` | BGP's valid-path marker; inspect detailed next-hop reachability when diagnosing a specific path |
| `>` | BGP's selected best path |
| `i` beside the status markers | Learned through iBGP |
| `i` at the end of the AS-path field | IGP origin attribute; a different use of the same character |
| `?` at the end of the AS-path field | Incomplete origin, visible on the statically redistributed prefix |
| `s` | Suppressed path; X1 retains component prefixes while advertising the aggregate |
| `r` | RIB failure: the BGP path was not installed in the main IP routing table |

An entry can carry both `r` and `>`: BGP selected it, but that does not make it the installed IP route. The files do not retain the detailed RIB-failure diagnostic for each such entry, so the exact competing route or reason is not established here.

For an installation check, use the [route and traceroute evidence](../forwarding/README.md). For a directly captured inaccessible next hop, use [Case 02](../../troubleshooting/scenario-2-ibgp-next-hop-reachability.md).

[Verification guide](../README.md)
