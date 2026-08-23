# Sanitized BGP Configurations

These files document the captured Border Gateway Protocol (BGP) lab state across enterprise Autonomous System (AS) 65000, two provider ASes, and outside AS 65300. They highlight internal BGP (iBGP), external BGP (eBGP), route reflection, IPv4/IPv6 address families, Virtual Routing and Forwarding (VRF), aggregation, redistribution, communities, Local Preference, AS-path manipulation, and Multi-Exit Discriminator (MED) exercises.

## Sanitization scope

The source was each device's full live `show running-config`. IOS banners, boot/licensing noise, management-line configuration, generic defaults, unused interfaces, and routing content unrelated to the BGP design were removed. Interfaces and static routes were retained only when they explain a peering, router ID/update source, BGP origination, multihop reachability, IPv6 session, or VRF session. The shared BGP authentication secret is replaced with `<REDACTED>` while preserving the configured authentication relationship.

These are portfolio extracts, not intended as complete restore configurations.

## Device roles

| Device | AS | BGP role |
|---|---:|---|
| O1-CORE | 65000 | iBGP client of O2; eBGP edge to B1 |
| O2-ABR | 65000 | Route reflector for O1 and O4; originates `172.31.250.0/24` |
| O4-EDGE | 65000 | iBGP client of O2; eBGP edge to B1 and B2 |
| B1-ISP-A | 65100 | Provider peer-group toward AS 65000; direct and multihop eBGP to X1; IPv6 and VRF BGP |
| B2-ISP-B | 65200 | eBGP transit between O4 and X1; originates `203.0.113.0/24` |
| X1-OUTSIDE | 65300 | External origin/aggregation and static redistribution; direct and multihop eBGP to B1; IPv6 and VRF BGP |

## Policy state in the capture

Active policies are attached under a BGP neighbor/address family or to BGP redistribution:

- B1: `COMMUNITY-IN` inbound from `10.250.3.2`, matching community `65300:100` and setting Local Preference 50.
- X1: `TAG-TO-B1` outbound to `10.250.3.1`, with `send-community`; `NOEXPORT-TO-B1` outbound to `10.255.1.1`, also with `send-community`.
- X1: `STATIC-REDIST` controls `redistribute static` and admits `10.50.50.0/24` through `STATIC-TO-BGP`.

Retained exercise objects were present in the running configuration but were not attached to a BGP neighbor in the captured state:

- O1: `B1-WEIGHT`, `ENTERPRISE-PREPEND`, `MED-TEST`, `B1-IN`, `PREPEND-TO-B1`, and `MED-TO-B1`.
- O4: `B2-PREFERRED`, `ENTERPRISE-PREPEND`, `MED-TEST`, `ORIGIN-TEST`, `B2-IN`, `PREPEND-TO-B2`, `MED-TO-B1`, and `ORIGIN-TO-B2`.
- B1: `X1-IN` and AS-path access list 10.
- X1: `B1-OUT`, `PREFER-B1-PREFIX`, `RANGE-TEST`, `B1-LOCALPREF`, and `FILTER-TO-B1`. (`COMMUNITY-TEST` is used by active maps; `STATIC-TO-BGP` is used by active redistribution.)

The files intentionally preserve the exact captured attachment state rather than presenting every completed exercise as simultaneously active.
