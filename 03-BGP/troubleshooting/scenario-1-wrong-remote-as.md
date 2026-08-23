# eBGP Wrong Remote AS — OPEN Message Error / Bad Peer AS Failure

## Healthy Context

The affected eBGP adjacency was between:

- **B2-ISP-B** — local AS `65200`, neighbor `10.250.2.1`
- **O4-EDGE** — local AS `65000`, neighbor `10.250.2.2`

Before fault injection, B2-ISP-B correctly expected O4-EDGE to use AS `65000`:

```cisco
neighbor 10.250.2.1 remote-as 65000
```

Only this adjacency was intentionally broken. The other BGP sessions remained available, providing a useful control during diagnosis.

## Fault Injection

On **B2-ISP-B**, the configured remote AS was deliberately changed from `65000` to `65001`:

```cisco
configure terminal
router bgp 65200
 no neighbor 10.250.2.1 remote-as 65000
 neighbor 10.250.2.1 remote-as 65001
end
```

## Observed Symptoms

### B2-ISP-B

`show ip bgp summary` placed neighbor `10.250.2.1` in `Idle`. It also showed the incorrect configured AS and no exchanged messages:

```text
B2-ISP-B#show ip bgp summary
BGP router identifier 10.255.2.2, local AS number 65200
BGP table version is 10, main routing table version 10
7 network entries using 1008 bytes of memory
7 path entries using 588 bytes of memory
8/6 BGP path/bestpath attribute entries using 1280 bytes of memory
5 BGP AS-PATH entries using 120 bytes of memory
0 BGP route-map cache entries using 0 bytes of memory
0 BGP filter-list cache entries using 0 bytes of memory
BGP using 2996 total bytes of memory
BGP activity 7/0 prefixes, 12/5 paths, scan interval 60 secs

Neighbor        V           AS MsgRcvd MsgSent   TblVer  InQ OutQ Up/Down  State/PfxRcd
10.250.2.1      4        65001       0       0        1    0    0 never    Idle
10.250.4.2      4        65300      62      61       10    0    0 00:50:25        6
```

The unaffected neighbor `10.250.4.2` remained established and continued to advertise six prefixes.

### O4-EDGE

O4-EDGE also showed the affected adjacency in `Idle`, while its other two BGP sessions stayed established:

```text
O4-EDGE#show ip bgp summary
BGP router identifier 10.100.4.4, local AS number 65000
BGP table version is 17, main routing table version 17
6 network entries using 864 bytes of memory
11 path entries using 924 bytes of memory
9/5 BGP path/bestpath attribute entries using 1440 bytes of memory
1 BGP rrinfo entries using 24 bytes of memory
3 BGP AS-PATH entries using 72 bytes of memory
0 BGP route-map cache entries using 0 bytes of memory
0 BGP filter-list cache entries using 0 bytes of memory
BGP using 3324 total bytes of memory
BGP activity 7/1 prefixes, 18/7 paths, scan interval 60 secs

Neighbor        V           AS MsgRcvd MsgSent   TblVer  InQ OutQ Up/Down  State/PfxRcd
10.100.2.2      4        65000      66      65       17    0    0 00:50:23        6
10.250.2.2      4        65200       0       0        1    0    0 00:00:36 Idle
10.250.2.3      4        65100      49      57       17    0    0 00:36:26        5
```

## Diagnostic Evidence

### Neighbor details on B2-ISP-B

The neighbor detail showed that B2-ISP-B expected AS `65001`, received one OPEN, sent one NOTIFICATION, had reachability to the peer, and had no active TCP connection:

```text
B2-ISP-B#show ip bgp neighbors 10.250.2.1
BGP neighbor is 10.250.2.1,  remote AS 65001, external link
BGP version 4, remote router ID 10.100.4.4
BGP state = Idle
Neighbor sessions:
0 active, is not multisession capable (disabled)
Stateful switchover support enabled: NO for session 0
Message statistics:
InQ depth is 0
OutQ depth is 0
                     Sent       Rcvd
Opens:                  0          1
Notifications:          1          0
Updates:                0          0
Keepalives:             0          0
Route Refresh:          0          0
Total:                  1          1
```

```text
Address tracking is enabled, the RIB does have a route to 10.250.2.1
Route to peer address reachability Up: 1; Down: 0
Last notification 00:00:10
Connections established 0; dropped 0
Last reset never
External BGP neighbor configured for connected checks (single-hop no-disable-connected-check)
Interface associated: (none) (peering address in same link)
Transport(tcp) path-mtu-discovery is enabled
Graceful-Restart is disabled
SSO is disabled
No active TCP connection
```

This evidence rules out loss of IP reachability to the peer and points to failure during BGP session establishment.

### Notification and reset messages on O4-EDGE

O4-EDGE recorded the explicit wrong-AS notification, followed by neighbor reset and adjacency-down messages:

```text
*Aug 23 23:12:39.106: %BGP-3-NOTIFICATION: received from neighbor 10.250.2.2 active 2/2 (peer in wrong AS) 2 bytes FDE8
*Aug 23 23:12:39.106: %BGP-5-NBR_RESET: Neighbor 10.250.2.2 active reset (BGP Notification received)
*Aug 23 23:12:39.107: %BGP-5-ADJCHANGE: neighbor 10.250.2.2 active Down BGP Notification received
*Aug 23 23:12:39.108: %BGP_SESSION-5-ADJCHANGE: neighbor 10.250.2.2 IPv4 Unicast topology base removed from session  BGP Notification received
```

The same failure repeated:

```text
*Aug 23 23:12:47.298: %BGP-3-NOTIFICATION: received from neighbor 10.250.2.2 active 2/2 (peer in wrong AS) 2 bytes FDE8
*Aug 23 23:12:47.298: %BGP-5-NBR_RESET: Neighbor 10.250.2.2 active reset (BGP Notification received)
*Aug 23 23:12:47.300: %BGP-5-ADJCHANGE: neighbor 10.250.2.2 active Down BGP Notification received
*Aug 23 23:12:47.300: %BGP_SESSION-5-ADJCHANGE: neighbor 10.250.2.2 IPv4 Unicast topology base removed from session  BGP Notification received
```

> **Protocol interpretation (not raw captured output):** BGP Notification error `2/2` means **OPEN Message Error / Bad Peer AS**. The notification data `FDE8` is hexadecimal for decimal `65000`, the AS advertised by O4-EDGE in its OPEN. B2-ISP-B expected `65001`, rejected the OPEN, and sent the notification.

## Root Cause

B2-ISP-B was misconfigured to expect neighbor `10.250.2.1` in AS `65001`, but O4-EDGE's actual local AS was `65000`. Because the peer AS in the received BGP OPEN did not match the configured `remote-as`, the eBGP session could not advance to Established.

## Corrective Action

The incorrect neighbor statement was removed and the original remote AS was restored on **B2-ISP-B**:

```cisco
configure terminal
router bgp 65200
 no neighbor 10.250.2.1 remote-as 65001
 neighbor 10.250.2.1 remote-as 65000
end
```

## Recovery Verification

### B2-ISP-B

After the correction, B2-ISP-B showed neighbor `10.250.2.1` using AS `65000`, with the session established and five prefixes received:

```text
B2-ISP-B#show ip bgp summary
BGP router identifier 10.255.2.2, local AS number 65200
BGP table version is 11, main routing table version 11
7 network entries using 1008 bytes of memory
12 path entries using 1008 bytes of memory
10/6 BGP path/bestpath attribute entries using 1600 bytes of memory
6 BGP AS-PATH entries using 144 bytes of memory
0 BGP route-map cache entries using 0 bytes of memory
0 BGP filter-list cache entries using 0 bytes of memory
BGP using 3760 total bytes of memory
BGP activity 7/0 prefixes, 17/5 paths, scan interval 60 secs

Neighbor        V           AS MsgRcvd MsgSent   TblVer  InQ OutQ Up/Down  State/PfxRcd
10.250.2.1      4        65000      13      13       11    0    0 00:00:13        5
10.250.4.2      4        65300      64      63       11    0    0 00:52:04        6
```

### O4-EDGE

O4-EDGE showed neighbor `10.250.2.2` in AS `65200` established, with six prefixes received. Its other sessions remained established:

```text
O4-EDGE#show ip bgp summary
BGP router identifier 10.100.4.4, local AS number 65000
BGP table version is 19, main routing table version 19
7 network entries using 1008 bytes of memory
16 path entries using 1344 bytes of memory
14/6 BGP path/bestpath attribute entries using 2240 bytes of memory
1 BGP rrinfo entries using 24 bytes of memory
6 BGP AS-PATH entries using 144 bytes of memory
0 BGP route-map cache entries using 0 bytes of memory
0 BGP filter-list cache entries using 0 bytes of memory
BGP using 4760 total bytes of memory
BGP activity 8/1 prefixes, 24/8 paths, scan interval 60 secs

Neighbor        V           AS MsgRcvd MsgSent   TblVer  InQ OutQ Up/Down  State/PfxRcd
10.100.2.2      4        65000      69      68       19    0    0 00:51:50        5
10.250.2.2      4        65200      13      13       19    0    0 00:00:30        6
10.250.2.3      4        65100      51      60       19    0    0 00:37:53        5
```

Because `State/PfxRcd` contains numeric prefix counts rather than a BGP finite-state-machine label, both adjacencies are Established.

### Route restoration on O4-EDGE

The external BGP route to `203.0.113.0/24` was restored through B2-ISP-B. The routing table showed administrative distance `20`, tag `65200`, and one AS hop:

```text
O4-EDGE#show ip route 203.0.113.0
Routing entry for 203.0.113.0/24
Known via "bgp 65000", distance 20, metric 0
Tag 65200, type external
Last update from 10.250.2.2 00:00:36 ago
Routing Descriptor Blocks:

- 10.250.2.2, from 10.250.2.2, 00:00:36 ago
  Route metric is 0, traffic share count is 1
  AS Hops 1
  Route tag 65200
  MPLS label: none
  O4-EDGE#
```

## Key Engineering Takeaway

An eBGP neighbor stuck in `Idle` is not automatically a reachability failure. Here, peer reachability was explicitly up, an OPEN was received, and a NOTIFICATION was sent. Correlating neighbor message counters with the peer's `2/2 (peer in wrong AS)` log isolated the fault to the configured AS expectation. Restoring the correct `remote-as` recovered both the adjacency and the external route.
