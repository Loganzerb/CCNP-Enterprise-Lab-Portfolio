# BGP topology and addressing

![BGP logical peering diagram](topology.png)

The diagram shows **BGP sessions**, not physical wiring or measured traffic flow. Addresses inside the device cards are Loopback0 addresses. A dashed B1–X1 session uses the same underlying connection as their direct session; it is not a second physical circuit.

## Routing domains and roles

| Router | AS | Loopback0 | BGP role |
|---|---|---|---|
| O1-CORE | 65000 | `10.100.1.1/32` | Enterprise edge; O2 route-reflector client |
| O2-ABR | 65000 | `10.100.2.2/32` | Route reflector; enterprise test-prefix origin |
| O4-EDGE | 65000 | `10.100.4.4/32` | Enterprise edge; O2 route-reflector client |
| B1-ISP-A | 65100 | `10.255.1.1/32` | Provider A |
| B2-ISP-B | 65200 | `10.255.2.2/32` | Provider B |
| X1-OUTSIDE | 65300 | `10.255.3.3/32` | Outside routing domain |

O1 and O4 peer internally with O2 using their loopbacks. O2 marks both as route-reflector clients. There is no direct O1–O4 BGP session in the extracts.

## Interfaces and supporting networks

| Network | Endpoints from the configuration extracts |
|---|---|
| `10.100.12.0/30` | O1 Gi0/0 `10.100.12.1` ↔ O2 Gi0/0 `10.100.12.2` |
| `10.100.24.0/30` | O2 Gi0/2 `10.100.24.1` ↔ O4 Gi0/0 `10.100.24.2` |
| `10.250.1.0/30` | O1 Gi0/2 `10.250.1.1` ↔ B1 Gi0/0 `10.250.1.2` |
| `10.250.2.0/29` | Shared segment: O4 Gi0/3 `10.250.2.1`; B2 Gi0/0 `10.250.2.2`; B1 Gi0/2 `10.250.2.3` |
| `10.250.3.0/30` | B1 Gi0/1 `10.250.3.1` ↔ X1 Gi0/0 `10.250.3.2` |
| `10.250.4.0/30` | B2 Gi0/1 `10.250.4.1` ↔ X1 Gi0/1 `10.250.4.2` |

The shared segment supports O4–B1 and O4–B2 sessions. **B1 and B2 do not have a configured BGP session to each other.** A path learned from O4 can retain another router on this shared subnet as its next hop; compare the “from” and next-hop fields in [Case 03](troubleshooting/scenario-3-route-map-implicit-deny.md).

The internal links support loopback reachability, but the corresponding internal routing configuration is not included in these extracts. The physical device providing the shared segment is not documented here.

## Global IPv4 BGP sessions

| Pair | Peering addresses | Type |
|---|---|---|
| O1–O2 | `10.100.1.1` ↔ `10.100.2.2` | iBGP, Loopback0 sources |
| O2–O4 | `10.100.2.2` ↔ `10.100.4.4` | iBGP, Loopback0 sources |
| O1–B1 | `10.250.1.1` ↔ `10.250.1.2` | Direct eBGP |
| O4–B1 | `10.250.2.1` ↔ `10.250.2.3` | Direct eBGP |
| O4–B2 | `10.250.2.1` ↔ `10.250.2.2` | Direct eBGP |
| B1–X1 | `10.250.3.1` ↔ `10.250.3.2` | Direct eBGP |
| B1–X1 | `10.255.1.1` ↔ `10.255.3.3` | Loopback eBGP, `ebgp-multihop 2` |
| B2–X1 | `10.250.4.1` ↔ `10.250.4.2` | Direct eBGP |

[Peer-state captures](verification/neighbors/README.md)

## Test destinations

| Origin | Prefix or group | Purpose |
|---|---|---|
| O2 | `172.31.250.0/24` | Enterprise advertisement; Null0-backed |
| B1 | `172.31.251.0/24` | Next-hop and export-policy cases; Null0-backed |
| B1 | `10.255.1.1/32` | Loopback advertisement |
| B2 | `203.0.113.0/24` | External route selection; Null0-backed |
| X1 | `198.51.100.0/24` | Community policies; Null0-backed |
| X1 | `10.50.50.0/24` | Selected static redistribution; Null0-backed |
| X1 | `192.0.2.0/25`, `192.0.2.128/26`, `192.0.2.224/27` | Null0-backed components of the `192.0.2.0/24 summary-only` aggregate |

The aggregate covers addresses beyond the three component ranges. Its advertisement does not establish a live endpoint throughout the summary.

## Additional configured address families

B1–X1 also has IPv6 eBGP configured on `2001:DB8:31::1/64` and `2001:DB8:31::2/64`, with local prefixes `2001:DB8:6510::/64` and `2001:DB8:6530::/64`.

CUSTOMER-A uses dot1q 100 subinterfaces: B1 Gi0/1.100 `10.60.0.1/30` and X1 Gi0/0.100 `10.60.0.2/30`. X1's VRF loopback is `172.20.20.1/24`. These settings have no dedicated session, route, or endpoint verification in the retained evidence.

[Configuration guide](configs/README.md) · [Module overview](README.md)
