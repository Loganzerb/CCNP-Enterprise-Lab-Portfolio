# Policy evidence — why did this prefix behave differently?

These five focused captures make individual route decisions easier to inspect than a full table.

| Capture | What it shows |
|---|---|
| [O2: enterprise prefix](O2-show-ip-bgp-172.31.250.0.txt) | `172.31.250.0/24` locally sourced and selected, with next hop `0.0.0.0` |
| [O4: enterprise prefix](O4-show-ip-bgp-172.31.250.0.txt) | The same prefix learned internally from O2, next hop `10.100.2.2` |
| [X1: enterprise prefix](X1-show-ip-bgp-172.31.250.0.txt) | Three candidate paths; the direct B1 path is selected in this snapshot |
| [X1: aggregate component](X1-show-ip-bgp-192.0.2.0.txt) | The returned entry is **`192.0.2.0/25`**, suppressed by an aggregate and not advertised |
| [B1: community test prefix](B1-show-ip-bgp-198.51.100.0.txt) | Community-based preference on one path and `no-export` on the selected path |

## Aggregation: read the returned prefix length

The filename and command omit a mask, but X1's detailed result identifies `192.0.2.0/25`. It is a component-prefix capture, not the detailed `/24` aggregate entry. X1's [full BGP table](../bgp-table/X1-show-ip-bgp.txt) shows the `/24` aggregate alongside its three suppressed components.

## Communities: compare the two X1 sessions

B1 receives `198.51.100.0/24` through several paths. Two come directly from X1's AS:

| X1 session | Captured attribute | Outcome |
|---|---|---|
| Direct, next hop `10.250.3.2` | Community `65300:100`; local preference 50 | Available but not selected |
| Loopback, next hop `10.255.3.3` | Community `no-export`; local preference 100 | Selected; the output reports no advertisement to any peer |

The [saved configurations](../../configs/README.md) explain the attached community policies. The `no-export` community limits external propagation; it does not itself remove the route from local use. B1's [IP route capture](../forwarding/B1-bgp-forwarding-198.51.100.0.txt) shows a route installed through X1's loopback.

The snapshot's “Not advertised to any peer” is an observed result, not a definition that `no-export` prohibits all internal advertisement.

The [outbound filtering case](../../troubleshooting/scenario-3-route-map-implicit-deny.md) separately demonstrates how an incomplete route map changes the advertised prefix set.

[Verification guide](../README.md)
