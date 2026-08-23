# BGP Route-Map Implicit Deny Causes Unintended Outbound Filtering

## Healthy context

O4-EDGE runs BGP in AS 65000 and peers with B2-ISP-B at `10.250.2.2`. Under normal conditions, O4 advertises multiple prefixes to B2. B2 also has an alternate external path through AS 65300, providing redundancy.

This scenario demonstrates a policy failure rather than an adjacency failure: the BGP session stays established, but an incomplete outbound route-map silently removes most advertisements. The alternate path prevents a full loss of reachability and therefore masks the policy defect.

## Fault injection

On O4-EDGE, a prefix list was created to match only `172.31.250.0/24`. A route-map containing only one permit sequence was then applied outbound toward B2-ISP-B:

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

## Observed symptoms

- The BGP adjacency between O4-EDGE and B2-ISP-B remained established.
- O4-EDGE advertised only one prefix to B2: `172.31.250.0/24`.
- B2's received-prefix count from O4 fell to 1.
- B2 lost the AS 65000 path for `172.31.251.0/24` but retained reachability through the alternate AS 65300 path.
- Redundancy masked a full outage even though the intended outbound advertisements from O4 were filtered.

## Diagnostic evidence

### O4-EDGE route-map

The applied route-map contained only sequence 10, which matched the single-prefix prefix list:

```text
O4-EDGE#show route-map BROKEN-TO-B2
route-map BROKEN-TO-B2, permit, sequence 10
Match clauses:
ip address prefix-lists: ONLY-ENTERPRISE-TO-B2
Set clauses:
Policy routing matches: 0 packets, 0 bytes
```

### O4-EDGE advertised routes during the failure

Only `172.31.250.0/24` was advertised toward B2:

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

### B2-ISP-B session state

The neighbor remained established, while `State/PfxRcd` for `10.250.2.1` fell to 1:

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

Because the neighbor row shows an uptime and a received-prefix count rather than an FSM state such as `Idle` or `Active`, the adjacency itself was healthy.

### B2-ISP-B path for 172.31.251.0/24 during the failure

B2 retained only the alternate external path through AS 65300:

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

The captured output ended after the final line above. The path count, AS path, and next hop are sufficient to show that the AS 65000 path was absent and the redundant AS 65300 path remained.

## Root cause

Cisco route-maps have an implicit deny at the end. Sequence 10 permitted only routes matching `ONLY-ENTERPRISE-TO-B2`, and that prefix list permitted only `172.31.250.0/24`. With no later catch-all permit sequence, every other BGP route failed to match and was denied from the outbound update to B2.

The BGP adjacency did not fail. The neighbor relationship continued exchanging messages while the outbound routing policy reduced the advertised route set to one prefix.

## Corrective action

A second permit sequence with no `match` clause was added. It acts as a catch-all for every route not matched by sequence 10:

```cisco
configure terminal

route-map BROKEN-TO-B2 permit 20

end


clear ip bgp 10.250.2.2 soft out
```

The soft outbound clear caused O4-EDGE to re-evaluate and resend advertisements without tearing down the BGP session.

## Recovery verification

### O4-EDGE corrected route-map

The route-map now contained both the specific match and the catch-all permit:

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

### O4-EDGE advertisements after the fix

The advertised set returned from one prefix to five:

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

### B2-ISP-B path restoration

B2 again learned two paths for `172.31.251.0/24`. The AS 65000 path was restored through the O4 neighbor, while the alternate AS 65300 path remained best:

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

Recovery did not require the restored route to become best. The decisive evidence was that the previously filtered `65000 65100` path returned and the intended five-prefix advertisement set was restored.

## Key engineering takeaway

A healthy BGP adjacency does not prove that routing policy is healthy. When reachability or path diversity changes but the session remains established, inspect the routes actually advertised and received—not only the neighbor state.

Every route-map should also be reviewed for its terminal behavior. If unmatched routes are meant to pass, add an explicit catch-all permit sequence. In redundant networks, alternate paths can preserve reachability while hiding a serious policy error, so verify both service availability and expected path diversity.
