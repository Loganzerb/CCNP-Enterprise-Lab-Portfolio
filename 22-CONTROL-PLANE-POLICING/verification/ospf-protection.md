# OSPF protection verification

OSPF process **10**, Area **0**, connects R1-CoPP and R2-PEER across **10.1.12.0/30**. The final R1 policy classifies OSPF sourced from R2 at **10.1.12.2** and applies a **1,000,000-bps** policer with conform transmit and exceed drop.

**Quick navigation:** [Reported state changes](#reported-state-changes) · [Routing and service validation](#routing-and-service-validation) · [Counter interpretation](#counter-interpretation) · [Evidence limit](#evidence-limit)

## Reported state changes

| Stage | Policer setting | Reported observation |
|---|---|---|
| Normal operation | 1-Mbps CIR; conform transmit | Conforming packets, zero exceeded packets, and FULL adjacency |
| Intentional fault | Same 1-Mbps CIR; conform drop | R1 reported a dead-timer expiration; neighbor changed from FULL to DOWN |
| Correction | Conform transmit restored | R1 reported LOADING to FULL |

The controlled change was the **conform action**, not a lower CIR. Traffic can be within the configured allowance and still be discarded when that action is set to drop. [Case 02](../troubleshooting/02-ospf-conform-action.md) explains the investigation and correction.

## Routing and service validation

The lab record reports that R1's OSPF-learned route to **172.16.40.0/24** disappeared after the neighbor failed. After recovery, the route returned through **10.1.12.2**.

The final CLIENT-A (**10.10.10.25**) to APP-TEST (**172.16.40.10**) regression received **10/10 ICMP replies with zero packet loss**. The neighbor, route, and endpoint tests check successive dependencies: the routing relationship recovered, the remote network was reinstalled, and the tested service path worked again.

The SSH and OSPF class definitions do not classify that endpoint-to-endpoint ICMP flow. The reported forwarding impact followed the loss of its learned route; it should not be described as a direct ICMP deny by either class.

## Counter interpretation

No exact OSPF packet totals were supplied. The normal-state report specifies conforming traffic and zero exceeded packets. Cumulative conform counters are not an exact count of packets dropped during the temporary conform-drop experiment: a total can include traffic processed under different policy actions.

## Evidence limit

All state transitions, route changes, and ping results on this page are reported lab observations. Raw policy output, console messages, neighbor and route displays, and ping transcripts were not supplied. The saved configuration supports the final corrected action and OSPF design, not the historical transitions or their timing.

[Verification index](README.md) · [OSPF troubleshooting case](../troubleshooting/02-ospf-conform-action.md) · [Final state](final-state.md) · [Overview](../README.md) · [Configurations](../configs/README.md) · [Operation](../operation.md) · [Evidence scope](../scope.md)
