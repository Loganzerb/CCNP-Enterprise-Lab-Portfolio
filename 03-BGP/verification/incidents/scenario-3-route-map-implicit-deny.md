# Retained evidence: scenario-3-route-map-implicit-deny

[Read the case study](../../troubleshooting/scenario-3-route-map-implicit-deny.md) · [Verification guide](../README.md)

These are the original fenced blocks from the case study, in their original order. Configuration blocks document the setup, fault, or repair; text blocks retain the captured device output. Only navigation and section labels have been added. These excerpts are separate from the general verification snapshots.

## Block 1

Fault injection

```cisco
configure terminal

ip prefix-list ONLY-ENTERPRISE-TO-B2 seq 5 permit 172.31.250.0/24

route-map BROKEN-TO-B2 permit 10
 match ip address prefix-list ONLY-ENTERPRISE-TO-B2

router bgp 65000
 neighbor 10.250.2.2 route-map BROKEN-TO-B2 out

end

clear ip bgp 10.250.2.2 soft out
```

## Block 2

O4-EDGE route-map

```text
O4-EDGE#show route-map BROKEN-TO-B2
route-map BROKEN-TO-B2, permit, sequence 10
Match clauses:
ip address prefix-lists: ONLY-ENTERPRISE-TO-B2
Set clauses:
Policy routing matches: 0 packets, 0 bytes
```

## Block 3

O4-EDGE advertised routes during the failure

```text
O4-EDGE#show ip bgp neighbors 10.250.2.2 advertised-routes
BGP table version is 19, local router ID is 10.100.4.4
Status codes: s suppressed, d damped, h history, * valid, > best, i - internal,
r RIB-failure, S Stale, m multipath, b backup-path, f RT-Filter,
x best-external, a additional-path, c RIB-compressed,
t secondary path,
Origin codes: i - IGP, e - EGP, ? - incomplete
RPKI validation codes: V valid, I invalid, N Not found

     Network          Next Hop            Metric LocPrf Weight Path
*>i  172.31.250.0/24  10.100.2.2               0    100      0 i

Total number of prefixes 1
O4-EDGE#
```

## Block 4

B2-ISP-B session state

```text
B2-ISP-B#show ip bgp summary

BGP router identifier 10.255.2.2, local AS number 65200

BGP table version is 11, main routing table version 11

7 network entries using 1008 bytes of memory

8 path entries using 672 bytes of memory

10/6 BGP path/bestpath attribute entries using 1600 bytes of memory

6 BGP AS-PATH entries using 144 bytes of memory

0 BGP route-map cache entries using 0 bytes of memory

0 BGP filter-list cache entries using 0 bytes of memory

BGP using 3424 total bytes of memory

BGP activity 7/0 prefixes, 17/9 paths, scan interval 60 secs

Neighbor        V           AS MsgRcvd MsgSent   TblVer  InQ OutQ Up/Down  State/PfxRcd

10.250.2.1      4        65000      26      20       11    0    0 00:06:53        1

10.250.4.2      4        65300      71      70       11    0    0 00:58:44        6

B2-ISP-B#
```

## Block 5

B2-ISP-B path for 172.31.251.0/24 during the failure

```text
B2-ISP-B#show ip bgp 172.31.251.0

BGP routing table entry for 172.31.251.0/24, version 7

Paths: (1 available, best #1, table default)

  Advertised to update-groups:

     1

  Refresh Epoch 1

  65300 65100

    10.250.4.2 from 10.250.4.2 (10.255.3.3)

      Origin IGP, localpref 100,
```

## Block 6

Corrective action

```cisco
configure terminal

route-map BROKEN-TO-B2 permit 20

end


clear ip bgp 10.250.2.2 soft out
```

## Block 7

O4-EDGE corrected route-map

```text
O4-EDGE#show route-map BROKEN-TO-B2
route-map BROKEN-TO-B2, permit, sequence 10
Match clauses:
ip address prefix-lists: ONLY-ENTERPRISE-TO-B2
Set clauses:
Policy routing matches: 0 packets, 0 bytes
route-map BROKEN-TO-B2, permit, sequence 20
Match clauses:
Set clauses:
Policy routing matches: 0 packets, 0 bytes
```

## Block 8

O4-EDGE advertisements after the fix

```text
O4-EDGE#show ip bgp neighbors 10.250.2.2 advertised-routes
BGP table version is 19, local router ID is 10.100.4.4
Status codes: s suppressed, d damped, h history, * valid, > best, i - internal,
r RIB-failure, S Stale, m multipath, b backup-path, f RT-Filter,
x best-external, a additional-path, c RIB-compressed,
t secondary path,
Origin codes: i - IGP, e - EGP, ? - incomplete
RPKI validation codes: V valid, I invalid, N Not found

     Network          Next Hop            Metric LocPrf Weight Path
*>   10.50.50.0/24    10.250.2.3                             0 65100 65300 ?
*>   10.255.1.1/32    10.250.2.3               0             0 65100 i
*>i  172.31.250.0/24  10.100.2.2               0    100      0 i
*>   172.31.251.0/24  10.250.2.3               0             0 65100 i
r>   192.0.2.0        10.250.2.3                             0 65100 65300 i

Total number of prefixes 5
O4-EDGE#
```

## Block 9

B2-ISP-B path restoration

```text
B2-ISP-B#show ip bgp 172.31.251.0

BGP routing table entry for 172.31.251.0/24, version 7

Paths: (2 available, best #2, table default)

  Advertised to update-groups:

     1

  Refresh Epoch 3

  65000 65100

    10.250.2.3 from 10.250.2.1 (10.100.4.4)

      Origin IGP, localpref 100, valid, external

      rx pathid: 0, tx pathid: 0

  Refresh Epoch 1

  65300 65100

    10.250.4.2 from 10.250.4.2 (10.255.3.3)

      Origin IGP, localpref 100, valid, external, best

      rx pathid: 0, tx pathid: 0x0

B2-ISP-B#
```

