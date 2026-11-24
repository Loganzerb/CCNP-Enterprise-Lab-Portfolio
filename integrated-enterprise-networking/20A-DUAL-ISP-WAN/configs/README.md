# Lab 20A configuration

The implementation notes and selected commands below were checked against the privately retained CML checkpoint. The complete checkpoint and full IOS configuration extracts are withheld from the public portfolio pending redistribution clearance. The screened desktop startup scripts are included. [Evidence scope](../scope.md)

| Device | Role in the saved configuration |
|---|---|
| R1-CORE | VLAN gateways, OSPF transit, IP SLA 10, Track 10, and static routes |
| R2-EDGE-A | OSPF into the core, iBGP toward R3, and eBGP to ISP-A |
| R3-EDGE-B | OSPF into the core, iBGP toward R2, and eBGP to ISP-B |
| R4-ISP-A | Originates `4.4.4.4/32`, peers with R2 and R5, and provides static return routes |
| R5-ISP-B | Originates `5.5.5.5/32`, peers with R3 and R4, and provides a static return route |
| SW1-ACCESS | 802.1Q trunk and access ports for VLANs 10 and 20 |
| [PC-USERS.sh](PC-USERS.sh) · [PC-SERVERS.sh](PC-SERVERS.sh) | Desktop interface addresses and default gateways |

## Track the primary default on R1

Selected implementation commands checked against the saved R1 configuration.

```cisco
track 10 ip sla 10 reachability
ip route 0.0.0.0 0.0.0.0 10.20.12.2 track 10
ip route 0.0.0.0 0.0.0.0 10.20.13.2 10
ip route 4.4.4.4 255.255.255.255 10.20.12.2
ip route 5.5.5.5 255.255.255.255 10.20.13.2
ip sla 10
 icmp-echo 4.4.4.4 source-ip 10.20.12.1
 frequency 5
ip sla schedule 10 life forever start-time now
```

The first default uses the static route's normal distance of 1. The second explicitly sets distance 10. The `4.4.4.4/32` entry keeps the probe pointed at R2 even after the default moves to R3, provided R2 remains reachable from R1. The ISP-B host route independently directs traffic to `5.5.5.5/32` through R3. [Cisco IOS IP SLA command reference](https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/ipsla/command/sla-cr-book/sla_i1.html)

## Exchange routes at the WAN edges

| Session | Saved neighbor endpoints | Configured behavior |
|---|---|---|
| Enterprise iBGP | R2 Lo0 `2.2.2.2` and R3 Lo0 `3.3.3.3`, AS 65000 | Both peers source the session from Lo0 and rely on OSPF reachability. Only R2 configures `next-hop-self`, toward R3. |
| ISP-A eBGP | R2 `198.51.100.1`, AS 65000, and R4 `198.51.100.2`, AS 65100 | R4 originates `4.4.4.4/32`. |
| ISP-B eBGP | R3 `203.0.113.1`, AS 65000, and R5 `203.0.113.2`, AS 65200 | R5 originates `5.5.5.5/32`. |
| Inter-provider eBGP | R4 `192.0.2.1`, AS 65100, and R5 `192.0.2.2`, AS 65200 | The saved providers peer over their direct link. |

Use the [interface map](../topology.md) for the OSPF Area 0 underlay. The R1 transit links are configured for adjacencies with the edges. The VLAN 10 and 20 subinterfaces advertise their networks as passive interfaces. Route choice for R1's static defaults depends on tracking and next-hop reachability.

## Provide ISP return routes

| ISP router | Destination prefix | Next hop |
|---|---|---|
| R4-ISP-A | `10.20.12.0/30` | `198.51.100.1` |
| R4-ISP-A | `10.20.13.0/30` | `198.51.100.1` |
| R5-ISP-B | `10.20.13.0/30` | `203.0.113.1` |

R4's first route covers the configured SLA source, `10.20.12.1`. R5's route covers a ping sourced from R1's backup transit IP, `10.20.13.1`. Both appear in the [captured route and ping excerpts](../verification/return-path.md). Testing from the core loopback or a desktop requires checking the return route for that different source.

[Overview](../README.md) · [Interface map](../topology.md) · [Route selection](../operation.md) · [Replay procedure](../verification/README.md#replay-and-capture)
