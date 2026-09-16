# Retained evidence: scenario-2-ibgp-next-hop-reachability

[Read the case study](../../troubleshooting/scenario-2-ibgp-next-hop-reachability.md) · [Verification guide](../README.md)

These are the original fenced blocks from the case study, in their original order. Configuration blocks document the setup, fault, or repair; text blocks retain the captured device output. Only navigation and section labels have been added. These excerpts are separate from the general verification snapshots.

## Block 1

Healthy Context

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

## Block 2

Fault Injection

```cisco
configure terminal
router bgp 65000
 no neighbor 10.100.2.2 next-hop-self
end

clear ip bgp 10.100.2.2 soft out
```

## Block 3

Observed Symptoms

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

## Block 4

Observed Symptoms

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

## Block 5

Diagnostic Evidence

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

## Block 6

Diagnostic Evidence

```text
O2-ABR#show ip route 10.250.1.2
% Subnet not in table
```

## Block 7

Diagnostic Evidence

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

## Block 8

Corrective Action

```cisco
configure terminal
router bgp 65000
 neighbor 10.100.2.2 next-hop-self
end

clear ip bgp 10.100.2.2 soft out
```

## Block 9

Recovery Verification

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

## Block 10

Recovery Verification

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

