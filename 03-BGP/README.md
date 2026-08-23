# BGP — Multi-AS Routing, Policy, and Troubleshooting

This lab implements a multi-AS BGP environment that combines enterprise route reflection with redundant external connectivity. It demonstrates IPv4 unicast BGP, iBGP route reflection, conventional eBGP, eBGP multihop, IPv6 peering, and an IPv4 VRF customer example—then validates the healthy control and forwarding planes and documents three focused break/fix scenarios.

![BGP lab topology](topology.png)

## Architecture

The enterprise runs AS 65000 across **O1-CORE**, **O2-ABR**, and **O4-EDGE**. O2 (router ID `10.100.2.2`) is the route reflector; O1 (`10.100.1.1`) and O4 (`10.100.4.4`) are RR clients. These iBGP sessions use Loopback0 addresses and `update-source Loopback0`.

External reachability is deliberately redundant:

- O1 peers with **B1-ISP-A** (AS 65100) on `10.250.1.0/30`.
- O4 peers with both **B2-ISP-B** (AS 65200) and B1 on the shared `10.250.2.0/29` segment.
- B1 peers with **X1-OUTSIDE** (AS 65300) using direct IPv4 and loopback-based eBGP multihop sessions. The same B1–X1 path also carries IPv6 eBGP and a CUSTOMER-A IPv4 VRF session.
- B2 peers directly with X1 on `10.250.4.0/30`.

This design makes BGP path selection, next-hop behavior, route reflection, redundancy, and policy effects visible without obscuring them behind unnecessary underlay detail.

## Routing and policy highlights

- O2 originates `172.31.250.0/24`, B1 originates `172.31.251.0/24`, and B2 originates `203.0.113.0/24`; each network statement is supported by an exact static route to Null0.
- X1 aggregates `192.0.2.0/24` from more-specific routes with `summary-only`, originates `198.51.100.0/24`, and redistributes `10.50.50.0/24` through the `STATIC-REDIST` route-map.
- Toward B1's direct session, X1 tags `198.51.100.0/24` with community `65300:100`; B1 matches that community and lowers Local Preference to 50.
- Toward B1's loopback multihop session, X1 advertises the same prefix with `no-export`.

The configurations also retain selected prefix-lists and route-maps from study exercises. Objects that were present but not attached to a neighbor or redistribution process in the captured running state are lab artifacts—not claimed here as active baseline policy.

## Verification

The [verification guide](verification/) organizes healthy-state checks for neighbor establishment, the BGP table, policy attributes, and forwarding. The evidence emphasizes both control-plane correctness and route installation rather than treating an Established session alone as proof of end-to-end health.

## Troubleshooting

The [troubleshooting case studies](troubleshooting/) document three reproducible failures and their recovery:

- **Wrong remote AS / Bad Peer AS** — corrected an eBGP adjacency failure caused by a mismatched neighbor AS.
- **iBGP next-hop reachability (`next-hop-self`)** — restored a reachable next hop while redundant paths preserved service.
- **Route-map implicit deny** — recovered unintentionally filtered advertisements by adding the required catch-all permit.

## Configurations

The [device configurations](configs/) contain the captured router configurations for O1-CORE, O2-ABR, O4-EDGE, B1-ISP-A, B2-ISP-B, and X1-OUTSIDE. They are the authoritative source for interface-level and address-family detail; the topology intentionally focuses on BGP relationships.
