# Case 02 — An incorrect conform action breaks OSPF

A one-word policing-action change interrupted OSPF even though its CIR remained at 1 Mbps. Restoring transmission of conforming traffic recovered the adjacency, the learned route, and the endpoint path.

**Quick navigation:** [Starting state](#starting-state) · [Failure symptoms](#failure-symptoms) · [Investigation and mechanism](#investigation-and-mechanism) · [Correction](#correction) · [Post-fix validation](#post-fix-validation) · [Evidence limit](#evidence-limit)

## Starting state

R1-CoPP and R2-PEER run **OSPF process 10 in Area 0** over **10.1.12.0/30**. COPP-OSPF classifies OSPF sourced from R2 at **10.1.12.2** into CP-OSPF.

With the normal **1,000,000-bps CIR**, conform transmit, and exceed drop, the lab reports conforming packets, **zero exceeded packets**, and a **FULL** adjacency.

## Failure symptoms

The conform action was intentionally changed to **drop**, while the CIR stayed at 1 Mbps. R1 subsequently reported an **OSPF dead-timer expiration**, its neighbor transitioned **FULL to DOWN**, and the OSPF-learned **172.16.40.0/24** route disappeared.

## Investigation and mechanism

The traffic's rate was not the changed variable. The fault changed what happened to packets measured as conforming: they were discarded instead of transmitted. A healthy rate allowance cannot compensate for a drop action assigned to the traffic within it.

The observations connect the control-plane failure to forwarding: R1 lost its OSPF relationship with R2, then lost the remote network learned through that neighbor. This explains why control-plane policy review belongs in the investigation of a route-dependent service failure.

The SSH and OSPF classes do not classify CLIENT-A to APP-TEST ICMP traffic. The reported endpoint impact must be understood through the route dependency rather than described as an ICMP deny by these classes.

## Correction

The OSPF policer was corrected to **conform transmit**, retaining its **1,000,000-bps CIR** and exceed drop. The final saved CP-PROTECT configuration contains that corrected action.

## Post-fix validation

| Dependency | Reported recovery |
|---|---|
| OSPF adjacency | R1 reported LOADING to FULL |
| Remote route | 172.16.40.0/24 reinstalled through 10.1.12.2 |
| Endpoint path | CLIENT-A 10.10.10.25 to APP-TEST 172.16.40.10: 10/10 ICMP replies, zero loss |

This checks recovery beyond the policy text: the routing relationship returned, the learned network returned, and the final endpoint test succeeded.

## Evidence limit

The transitions, route loss and return, and ICMP result are reported observations. No raw logs, policy counters, neighbor and route output, or ping transcript was supplied. No exact OSPF packet totals or timer intervals are claimed. Cumulative conform counters must not be treated as an exact count of packets dropped during the temporary action change.

[Troubleshooting index](README.md) · [OSPF verification](../verification/ospf-protection.md) · [Final state](../verification/final-state.md) · [Overview](../README.md) · [Configurations](../configs/README.md) · [Operation](../operation.md) · [Evidence scope](../scope.md)
