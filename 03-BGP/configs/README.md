# BGP configuration guide

These six sanitized extracts explain the devices behind the evidence. They retain BGP, interface, policy, and selected static-route settings. They are **not complete startup configurations**: supporting internal routing is omitted, credentials are redacted, and no CML export is supplied.

## Device roles

| Configuration | Role | Settings to inspect |
|---|---|---|
| [O1-CORE](O1-CORE.cfg) | Enterprise edge and route-reflector client | External peer B1; loopback peering to O2; `next-hop-self` toward O2 |
| [O2-ABR](O2-ABR.cfg) | Route reflector in AS 65000 | O1 and O4 marked as clients; enterprise prefix `172.31.250.0/24` originated from a Null0 route |
| [O4-EDGE](O4-EDGE.cfg) | Enterprise edge and route-reflector client | Peers B1 and B2 on one shared subnet; loopback peering to O2; `next-hop-self` |
| [B1-ISP-A](B1-ISP-A.cfg) | Provider in AS 65100 | Enterprise peer group; two IPv4 sessions to X1; inbound community policy; IPv6 and VRF configuration |
| [B2-ISP-B](B2-ISP-B.cfg) | Provider in AS 65200 | External peers O4 and X1; `203.0.113.0/24` originated from a Null0 route |
| [X1-OUTSIDE](X1-OUTSIDE.cfg) | Outside routing domain in AS 65300 | Test prefixes, aggregation, filtered static redistribution, outbound communities, IPv6 and VRF configuration |

O2's retained hostname includes “ABR”; its role in this module is the **BGP route reflector**.

## Active policy versus retained exercise objects

A route map's presence does not establish that it was applied. Follow the neighbor or redistribution statement that references it.

| Device | Attached in the saved extract | Defined without an attachment in that extract |
|---|---|---|
| O1 | `next-hop-self` toward O2 | `MED-TO-B1`, `PREPEND-TO-B1`, `B1-IN` |
| O2 | Route-reflector-client settings for O1 and O4 | No route maps |
| O4 | `next-hop-self` toward O2 | `MED-TO-B1`, `PREPEND-TO-B2`, `B2-IN`, `ORIGIN-TO-B2` |
| B1 | `COMMUNITY-IN` inbound from X1's direct IPv4 peer | `X1-IN` prefix list and AS-path access list 10 |
| B2 | No neighbor route map | No route maps |
| X1 | `STATIC-REDIST` for static redistribution; `TAG-TO-B1` outbound to B1's direct peer; `NOEXPORT-TO-B1` outbound to B1's loopback peer | `B1-LOCALPREF`, `FILTER-TO-B1`, and other unattached prefix-list exercises |

The attached B1 policy gives routes tagged `65300:100` local preference 50. X1 supplies that community to the direct session and `no-export` to the loopback session for the community test prefix. Both sessions have `send-community`. The saved decimal community value `4279500900` represents `65300:100`.

[Compare the captured policy result](../verification/policy/README.md)

The `BROKEN-TO-B2` route map belongs to [Case 03](../troubleshooting/scenario-3-route-map-implicit-deny.md). Its fault and repair commands are preserved there; it is absent from the saved O4 extract. General extracts and incident captures should not be treated as one synchronized snapshot.

## Reconstruction notes

Use the [addressing tables](../topology.md) to review or rebuild the design. Rebuilding requires compatible router images, supporting reachability between enterprise loopbacks, interface mapping, and replacement of redacted authentication values.

B1 and X1 include supporting static routes to each other's loopbacks for multihop eBGP. Several other static routes point to Null0 to originate test prefixes. These represent routing exercises, not hosts or application services.

IPv6 and CUSTOMER-A VRF settings are configuration coverage only in this snapshot. The retained peer summaries and route tables verify global IPv4 behavior.

[Module overview](../README.md) · [Verification guide](../verification/README.md)
