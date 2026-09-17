# OSPF troubleshooting

Each case follows a different failure boundary: neighbor synchronization, agreement on area type, or advertisement policy.

| Case | Decisive comparison | Evidence available |
|---|---|---|
| [01 — IP MTU mismatch](scenario-1-ospf-mtu-exstart-exchange.md) | Successful ping and interface MTU versus IP MTU and OSPF debug | Failure and recovery excerpts; [17 original blocks](../verification/incidents/scenario-1-ospf-mtu-exstart-exchange.md) |
| [02 — NSSA capability mismatch](scenario-2-nssa-capability-and-lsa-translation.md) | O4's area configuration versus the NSSA expected by its neighbors | Narrative observations, commands, and two recovery output excerpts; [11 original blocks](../verification/incidents/scenario-2-nssa-capability-and-lsa-translation.md) |
| [03 — Area-border filtering](scenario-3-abr-route-filtering-control-plane.md) | Missing backbone advertisement versus retained branch routes and healthy neighbors | Failure and recovery excerpts; [20 original blocks](../verification/incidents/scenario-3-abr-route-filtering-control-plane.md) |

Start with Case 01 for a compact investigation, then Case 03 for a route-policy problem that a neighbor check alone would miss.

The original 48 fenced blocks are preserved in linked evidence pages, including configuration commands, command lists, and a conceptual diagram. They are not 48 independent tests. Case 02's missing fault-state output has not been reconstructed.

[Module overview](../README.md) · [Topology](../topology.md) · [Verification guide](../verification/README.md)
