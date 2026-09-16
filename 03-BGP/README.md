# BGP — Route selection, policy, and recovery

A network can maintain its routing connections while losing an intended path. In this six-router lab, I investigated three different causes: a peer configured with the wrong autonomous system, an unreachable next hop, and an outbound policy that silently excluded routes.

The work demonstrates how I separate a connection problem from a route-selection or policy problem, make a targeted correction, and verify the result at the affected devices.

**Six routers · Four autonomous systems · Three troubleshooting cases**

**Start here:** [A healthy session with an unusable path](troubleshooting/scenario-2-ibgp-next-hop-reachability.md). Both internal BGP sessions stayed established, but one advertised next hop was unreachable. The alternate route remained installed; restoring `next-hop-self` made the original path eligible again.

## Lab design

![BGP topology showing six routers across four autonomous systems and their IPv4 BGP sessions](topology.png)

The enterprise uses two edge routers and a central route reflector to exchange routes with two simulated providers. An outside router supplies additional destinations and policy exercises. An autonomous system (AS) is a routing domain with its own routing policy.

[Topology, addressing, and peering details](topology.md)

## Troubleshooting results

| Case | What went wrong | Captured recovery |
|---|---|---|
| [01 — Wrong remote AS](troubleshooting/scenario-1-wrong-remote-as.md) | B2 expected O4 to belong to AS 65001 instead of 65000; the session was rejected | Both peers resumed exchanging routes, and O4 installed the route to `203.0.113.0/24` through B2 |
| [02 — Unreachable next hop](troubleshooting/scenario-2-ibgp-next-hop-reachability.md) | O1 advertised a provider address that O2 could not resolve, despite an established session | O2 could resolve both candidate paths again and installed the path through O1 |
| [03 — Incomplete outbound policy](troubleshooting/scenario-3-route-map-implicit-deny.md) | A route map allowed one prefix and implicitly excluded the rest | O4's advertised set increased from one to five prefixes; B2 regained the missing path while retaining its existing best path |

Each case links the symptom, decisive evidence, repair, and recovery. Original command blocks are retained in linked evidence pages.

## What the supporting evidence shows

- **Routing relationships:** internal route reflection, external peering, and a second B1–X1 session using loopback addresses.
- **Route decisions:** multiple candidate paths, next-hop resolution, and the difference between a BGP best path and an installed IP route.
- **Policy behavior:** aggregate suppression, community-based preference, and a selected path carrying `no-export`.
- **Forwarding observations:** installed routes and recorded traceroute responses, with the limits explained alongside the output.

| Review path | Contents |
|---|---|
| [Configuration guide](configs/README.md) | Six device extracts, their roles, and which policy objects are actually attached |
| [Verification guide](verification/README.md) | Twenty original text captures organized by the question they answer |
| [Case index](troubleshooting/README.md) | Three investigations and direct links to their retained command blocks |

## Evidence scope

This is controlled lab work. The configuration extracts omit parts of the supporting network and are not complete deployment files; no BGP CML export is included. IPv6 and CUSTOMER-A VRF settings are present, but dedicated verification here covers global IPv4 BGP.

Several test destinations are originated through discard routes (`Null0`). The traceroutes do not demonstrate successful endpoint delivery, and the troubleshooting cases establish routing recovery rather than measured application availability. General captures and incident excerpts come from different stages, so prefix counts and selected paths can differ.

[Back to portfolio](../README.md)
