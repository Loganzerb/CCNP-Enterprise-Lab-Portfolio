# Lab 19A lessons learned

## Verification lessons

| Observation | Engineering takeaway |
|---|---|
| A corrected NAT statement and working upstream route were both required. | Confirm the `ip nat inside source ... overload` statement and the inside/outside roles, then use actual traffic and a translation table to establish the chosen global address. |
| New traffic worked after HSRP changed owners. | HSRP moves gateway ownership. Each gateway creates its own dynamic NAT entries. Prove fresh reachability and continuity of an established session with separate tests. |
| A failed ping matched five ACL denies in each controlled policy trial. | Capture the specific counter delta with the probe count and the active device. That isolates the reason for the observed failure more precisely than the ping result alone. |
| The same policy applied when R3 took over. | Treat the ACL contents and interface attachment as paired configuration across redundant routers. Compare both and verify the data-plane result under each active gateway. |
| The temporary `/32` controlled the VLAN 20 path. | Verify longest-prefix selection on the client router. Remove test routes so they do not affect the next probe or become part of the final checkpoint. |

## Design limits and possible improvements

| Limit | Potential next design or measurement |
|---|---|
| SW1, SW2, and R4 are shared dependencies. The two LACP members protect a switch-to-switch link, and the gateway pair protects a first-hop role. | Add switch or provider diversity if the design needs to survive a chassis or provider failure. Test each failure domain independently. |
| The saved HSRP configuration has no tracking. | Evaluate interface or IP SLA object tracking and a priority decrement large enough to move the role when the active upstream path fails. |
| Each gateway uses independent PAT state and a different egress IP. | Measure loss and session survivability during role changes with timestamped probes and an established TCP flow. A requirement for stateful failover would call for a design that also preserves address and session state. |
| The ACL is scoped to VLAN 10 echo requests to one endpoint. | Translate broader access requirements into explicit policy and test other protocols or destinations as separate cases. |
| R4 provides only a controlled ISP and loopback endpoint inside CML. | The reported result covers the simulated path and does not establish Internet access or production scale. |

[Overview](README.md) · [Verification](verification/README.md) · [Troubleshooting](troubleshooting/README.md) · [Evidence scope](scope.md)
