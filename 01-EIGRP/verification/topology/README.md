# Topology tables — distinguish a known path from a qualified backup

These files contain saved `show ip eigrp topology` output. Several are partial excerpts; the incident pages contain the prefix-specific and `all-links` checks used for backup analysis.

| Capture | Useful entry |
|---|---|
| [R1-CORE](R1-show-ip-eigrp-topology.txt) | Branch `172.16.40.0/22` with two successors and FD 131072 |
| [R2-DIST-A](R2-show-ip-eigrp-topology.txt) | Branch summary through R4, metric/RD `130816/128256` |
| [R3-DIST-B](R3-show-ip-eigrp-topology.txt) | Branch summary through R4 and redistributed transit prefix tagged 200 |
| [R4-BRANCH](R4-show-ip-eigrp-topology.txt) | Connected branch components, local Null0 summary, and two successors toward R1's loopback |
| [R5-REMOTE](R5-show-ip-eigrp-topology.txt) | Connected remote prefixes, local summary, and a default through R4 using wide metrics |

## Read one path

In `via 10.13.0.2 (156416/130816)`, the first number is the local total path metric; the second is the neighbor's reported distance (RD). To evaluate a feasible successor, compare that RD with the destination's feasible distance (FD).

FD records the lowest known total distance since the last Active-to-Passive transition. It need not equal today's selected path metric. This distinction follows the [EIGRP specification](https://www.rfc-editor.org/rfc/rfc7868.html#section-2) and is visible in Case 01's post-failure values.

| Field | Interpretation |
|---|---|
| `P` / Passive | No active diffusing computation for that route at the captured moment |
| Successor count | Number of selected successor paths |
| FD | Stored feasibility bound for the destination |
| Metric/RD pair | Local path cost versus the distance advertised by that neighbor |
| `via Summary ... Null0` | Locally generated summary entry |

In [Case 01](../../troubleshooting/scenario-1-feasible-successor-promotion.md), RD 130816 is below FD 131072. In [Case 02](../../troubleshooting/scenario-2-no-feasible-successor-dual-recalculation.md), RD equals FD, which fails the strict test. Failure of the test does not prove an actual routing loop.

## Partial output and metric scaling

R1 and R2's files stop at a default-route heading; R3's stops at a prefix heading. Some routes in the routing files are absent from these excerpts. Do not interpret that as confirmed withdrawal.

R5 reports topology metric 9175040 for its default. Its protocol file reports RIB scale 128, and its IP route metric is 71680: **9175040 ÷ 128 = 71680**. That matches [Cisco's documented wide-metric scaling](https://www.cisco.com/c/en/us/td/docs/routers/ios-xe/ip-routing/b-ip-routing/m_ire-wid-met.html). The different display values do not indicate conflicting routes.

[Verification guide](../README.md) · [Routing guide](../routing/README.md)
