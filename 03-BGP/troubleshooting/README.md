# BGP troubleshooting

These three controlled faults affect different parts of routing: establishing the peer relationship, resolving a learned path, and deciding what to advertise.

| Case | Decisive check | Result | Original blocks |
|---|---|---|---|
| [01 — Wrong remote AS](scenario-1-wrong-remote-as.md) | Wrong-AS notification plus the configured peer AS | Session and external route restored | [12 blocks](../verification/incidents/scenario-1-wrong-remote-as.md) |
| [02 — Unreachable next hop](scenario-2-ibgp-next-hop-reachability.md) | Per-prefix BGP output compared with an IP route lookup | Original path became usable again; installed next hop changed | [10 blocks](../verification/incidents/scenario-2-ibgp-next-hop-reachability.md) |
| [03 — Incomplete outbound policy](scenario-3-route-map-implicit-deny.md) | Advertised prefixes compared with the neighbor's path list | Missing advertisements and an alternate path restored | [9 blocks](../verification/incidents/scenario-3-route-map-implicit-deny.md) |

**Recommended first read:** Case 02. It shows why a healthy peer summary is only one part of verification.

All original configuration and output blocks are preserved in the linked evidence pages. They are excerpts from the recorded experiments. Each case identifies what its recovery captures establish.

[Module overview](../README.md) · [Topology](../topology.md) · [Verification guide](../verification/README.md)
