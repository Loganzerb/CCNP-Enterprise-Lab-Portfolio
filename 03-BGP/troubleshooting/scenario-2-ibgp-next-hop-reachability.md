# iBGP Next-Hop Reachability Failure After Removing `next-hop-self`

## Scenario

This case study documents a partial BGP path failure inside AS 65000. `next-hop-self` was removed on O1-CORE for its iBGP neighbor O2-ABR. The iBGP TCP session stayed established, but O2 could not recursively resolve the external BGP next hop carried by the route from O1.

The affected prefix was `172.31.251.0/24`. Route-reflector redundancy prevented a traffic outage because O2 retained a second usable path through O4-EDGE.

## Healthy Context

B1-ISP-A originated `172.31.251.0/24` locally in BGP. A static route to Null0 backed the advertisement, confirming that the source prefix itself was healthy.

```text
B1-ISP-A#show ip bgp 172.31.251.0
BGP routing table entry for 172.31.251.0/24, version 4
Paths: (1 available, best #1, table default)
Advertised to update-groups:
1\
Refresh Epoch 1
Local
0.0.0.0 from 0.0.0.0 (10.255.1.1)
Origin IGP, metric 0, localpref 100, weight 32768, valid, sourced, local, best
rx pathid: 0, tx pathid: 0x0
B1-ISP-A#show ip route 172.31.251.0
Routing entry for 172.31.251.0/24
Known via "static", distance 1, metric 0 (connected)
Advertised by bgp 65100
Routing Descriptor Blocks:

- directly connected, via Null0
  Route metric is 0, traffic share count is 1
  B1-ISP-A#
```

## Fault Injection

On O1-CORE in AS 65000, `next-hop-self` was removed only for iBGP neighbor `10.100.2.2`. A soft outbound clear then caused O1 to readvertise its routes with the changed next-hop behavior.

```cisco
configure terminal
router bgp 65000
 no neighbor 10.100.2.2 next-hop-self
end

clear ip bgp 10.100.2.2 soft out
```

## Observed Symptoms

O1 remained healthy at the session level. Its iBGP neighbor `10.100.2.2` and eBGP neighbor `10.250.1.2` were both established. O1 also retained the valid, external, best path to `172.31.251.0/24` through `10.250.1.2`.

```text
O1-CORE#show ip bgp summary

BGP router identifier 10.100.1.1, local AS number 65000

BGP table version is 13, main routing table version 13

7 network entries using 1008 bytes of memory

12 path entries using 1008 bytes of memory

10/6 BGP path/bestpath attribute entries using 1600 bytes of memory

1 BGP rrinfo entries using 24 bytes of memory

5 BGP AS-PATH entries using 120 bytes of memory

0 BGP route-map cache entries using 0 bytes of memory

0 BGP filter-list cache entries using 0 bytes of memory

BGP using 3760 total bytes of memory

BGP activity 8/1 prefixes, 14/2 paths, scan interval 60 secs


Neighbor        V           AS MsgRcvd MsgSent   TblVer  InQ OutQ Up/Down  State/PfxRcd

10.100.2.2      4        65000      74      73       13    0    0 00:53:41        7

10.250.1.2      4        65100      66      66       13    0    0 00:53:50        5

O1-CORE#show ip bgp 172.31.251.0

BGP routing table entry for 172.31.251.0/24, version 4

Paths: (2 available, best #2, table default)

  Advertised to update-groups:

     3

  Refresh Epoch 1

  65100

    10.100.4.4 (metric 21) from 10.100.2.2 (10.100.2.2)

      Origin IGP, metric 0, localpref 100, valid, internal

      Originator: 10.100.4.4, Cluster list: 10.100.2.2

      rx pathid: 0, tx pathid: 0

  Refresh Epoch 1

  65100

    10.250.1.2 from 10.250.1.2 (10.255.1.1)

      Origin IGP, metric 0, localpref 100, valid, external, best

      rx pathid: 0, tx pathid: 0x0

O1-CORE#
```

On O2, both iBGP sessions also remained established. This ruled out loss of the BGP adjacency as the cause.

```text
O2-ABR#show ip bgp summary
BGP router identifier 10.100.2.2, local AS number 65000
BGP table version is 18, main routing table version 18
7 network entries using 1008 bytes of memory
11 path entries using 924 bytes of memory
6/6 BGP path/bestpath attribute entries using 960 bytes of memory
4 BGP AS-PATH entries using 96 bytes of memory
0 BGP route-map cache entries using 0 bytes of memory
0 BGP filter-list cache entries using 0 bytes of memory
BGP using 2988 total bytes of memory
BGP activity 8/1 prefixes, 14/3 paths, scan interval 60 secs

Neighbor        V           AS MsgRcvd MsgSent   TblVer  InQ OutQ Up/Down  State/PfxRcd
10.100.1.1      4        65000      73      74       18    0    0 00:54:03        4
10.100.4.4      4        65000      70      74       18    0    0 00:53:54        6
```

## Diagnostic Evidence

O2 received two paths to the prefix. The path from O1 preserved B1's external next hop, `10.250.1.2`, and O2 marked that next hop inaccessible. The alternate path through O4 used reachable next hop `10.100.4.4` and remained valid, internal, and best.

```text
O2-ABR#show ip bgp 172.31.251.0
BGP routing table entry for 172.31.251.0/24, version 16
Paths: (2 available, best #1, table default)
Advertised to update-groups:
1\
Refresh Epoch 1
65100, (Received from a RR-client)
10.100.4.4 (metric 11) from 10.100.4.4 (10.100.4.4)
Origin IGP, metric 0, localpref 100, valid, internal, best
rx pathid: 0, tx pathid: 0x0
Refresh Epoch 1
65100, (Received from a RR-client)
10.250.1.2 (inaccessible) from 10.100.1.1 (10.100.1.1)
Origin IGP, metric 0, localpref 100, valid, internal
rx pathid: 0, tx pathid: 0
```

The routing table had no route with which to recursively resolve `10.250.1.2`.

```text
O2-ABR#show ip route 10.250.1.2
% Subnet not in table
```

Despite the failed O1 path, O2 kept the destination installed through O4. Redundancy therefore converted a potential outage into degradation of a single path.

```text
O2-ABR#show ip route 172.31.251.0
Routing entry for 172.31.251.0/24
Known via "bgp 65000", distance 200, metric 0
Tag 65100, type internal
Last update from 10.100.4.4 00:00:33 ago
Routing Descriptor Blocks:

- 10.100.4.4, from 10.100.4.4, 00:00:33 ago
  Route metric is 0, traffic share count is 1
  AS Hops 1
  Route tag 65100
  MPLS label: none
  O2-ABR#
```

## Root Cause

The failure was recursive reachability to the BGP `NEXT_HOP`, not loss of the iBGP TCP session.

O1 learned `172.31.251.0/24` from B1 over eBGP with next hop `10.250.1.2`. After `next-hop-self` was removed, O1 advertised that path to O2 without rewriting the next hop to its own reachable address. O2 received the route but had no route to `10.250.1.2`, so it could not use the path from O1.

The separate reflected path through O4 carried `10.100.4.4` as its next hop. Because O2 could resolve that address, the alternate path remained eligible and preserved connectivity.

## Corrective Action

Restore `next-hop-self` on O1 for O2 and issue another soft outbound clear so O1 readvertises the route with itself as the next hop.

```cisco
configure terminal
router bgp 65000
 neighbor 10.100.2.2 next-hop-self
end

clear ip bgp 10.100.2.2 soft out
```

## Recovery Verification

After the correction, O2 again had two paths with reachable next hops. The alternate path remained reachable through `10.100.4.4`, while the path received from O1 now carried `10.100.1.1` and became best.

```text
O2-ABR#show ip bgp 172.31.251.0
BGP routing table entry for 172.31.251.0/24, version 20
Paths: (2 available, best #2, table default)
Advertised to update-groups:
1\
Refresh Epoch 1
65100, (Received from a RR-client)
10.100.4.4 (metric 11) from 10.100.4.4 (10.100.4.4)
Origin IGP, metric 0, localpref 100, valid, internal
rx pathid: 0, tx pathid: 0
Refresh Epoch 1
65100, (Received from a RR-client)
10.100.1.1 (metric 11) from 10.100.1.1 (10.100.1.1)
Origin IGP, metric 0, localpref 100, valid, internal, best
rx pathid: 0, tx pathid: 0x0
```

O2 installed the recovered O1 path in the routing table with iBGP administrative distance 200, route tag 65100, and one AS hop.

```text
O2-ABR#show ip route 172.31.251.0
Routing entry for 172.31.251.0/24
Known via "bgp 65000", distance 200, metric 0
Tag 65100, type internal
Last update from 10.100.1.1 00:01:26 ago
Routing Descriptor Blocks:

- 10.100.1.1, from 10.100.1.1, 00:01:26 ago
  Route metric is 0, traffic share count is 1
  AS Hops 1
  Route tag 65100
  MPLS label: none
  O2-ABR#
```

## Key Engineering Takeaway

An established BGP session proves only that the peers can maintain their control-plane relationship; it does not prove that every advertised BGP next hop is recursively reachable.

When an iBGP peer advertises an eBGP-learned route, the receiving router must be able to resolve the route's `NEXT_HOP`. In this case, removing `next-hop-self` exposed O2 to B1's external address, which was absent from O2's routing table. The O1 path therefore became unusable even though the O1-O2 session stayed established.

The alternate reflected path through O4 demonstrates the operational value of path redundancy: it preserved forwarding while one control-plane path was invalid. Troubleshooting should therefore correlate BGP session state, per-prefix next-hop status, recursive route availability, and the installed RIB path rather than treating an established neighbor as proof that routing is healthy.
