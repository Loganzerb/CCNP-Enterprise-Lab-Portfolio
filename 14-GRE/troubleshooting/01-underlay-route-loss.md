# Case 01 — Forwarding fails before the display catches up

**Outcome:** restoring R1’s transport static route brought Tunnel0 back to up/up and OSPF back to FULL.

## Failure symptoms

The exercise removed R1’s route to 198.51.100.0/30. The first sample still displayed Tunnel0 up/up, OSPF FULL and the private route. A subsequent destination lookup showed no route, and the static-route configuration filter was empty.

[Blocks 06–07 — early display and missing route](../verification/02-underlay-failure.md)

## Troubleshooting methodology

The next checks moved from the displayed tunnel state to its transport dependency:

| Check | Captured result | Interpretation |
|---|---|---|
| RIB lookup for 198.51.100.2 | Network not in table | The outer destination lacks a route |
| CEF lookup for 198.51.100.2 | No route | Forwarding has no usable entry |
| Ping endpoint using source 192.0.2.1 | 0/5 | The actual transport endpoints cannot complete the exchange |
| Ping overlay peer 172.16.13.2 | 0/5 | The GRE data path also fails |
| Later tunnel and neighbor sample | Up/down; no OSPF neighbor | Displayed operational state catches up |

[Block 08 — CEF, failed probes and later state](../verification/02-underlay-failure.md#block-08--cef-and-traffic-reveal-the-failure)

## Root cause and remediation

The remote tunnel destination depended on the removed static route. Interface and adjacency displays briefly retained healthy state even though the route and forwarding tests exposed the missing dependency.

The fault and repair commands below are reconstructed from the recorded exercise sequence; the resulting device states are captured separately.

```ios
! Fault on R1-GRE
no ip route 198.51.100.0 255.255.255.252 192.0.2.2
! Restore the underlay route
ip route 198.51.100.0 255.255.255.252 192.0.2.2
```

## Post-fix validation and lesson

The covering /30 again resolves through 192.0.2.2, Tunnel0 is up/up, and neighbor 3.3.3.3 is FULL. [Block 09](../verification/02-underlay-failure.md#block-09--restore-the-underlay-route) retains that recovery.

This delay is **observed IOSv behavior**. The sampling does not identify an exact convergence time or establish whether the OSPF dead timer or tunnel transition caused adjacency loss first. Route, CEF and actual packet tests are essential when displayed state and forwarding disagree.

[Next: recursive routing](02-recursive-routing.md) · [Case index](README.md)
