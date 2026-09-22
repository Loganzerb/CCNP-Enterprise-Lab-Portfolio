# Baseline — from receiver interest to forwarding

The receiver joins before the source sends. The captures then show replies from the receiver and source-specific forwarding through R3. Read the short interpretation above each original output.

Captured CLI from the September 20–21, 2026 lab. Blocks preserve the submitted output with formatting cleanup only; shortened prompts, logs, timers and flags remain as recorded.

## Block 01

**Separate unicast paths.** R4 reaches the source LAN through R3 and the RP through R2. Both routes have OSPF metric 3 after the cost adjustment.

```text
R4-LHR#show ip route 10.1.1.0
Routing entry for 10.1.1.0/24
Known via "ospf 1", distance 110, metric 3, type intra area
Last update from 10.34.0.1 on GigabitEthernet0/2, 00:03:32 ago
Routing Descriptor Blocks:

- 10.34.0.1, from 1.1.1.1, 00:03:42 ago, via GigabitEthernet0/2
  Route metric is 3, traffic share count is 1
  R4-LHR#show ip route 2.2.2.2
  Routing entry for 2.2.2.2/32
  Known via "ospf 1", distance 110, metric 3, type intra area
  Last update from 10.24.0.1 on GigabitEthernet0/1, 00:00:08 ago
  Routing Descriptor Blocks:
- 10.24.0.1, from 2.2.2.2, 00:00:08 ago, via GigabitEthernet0/1
  Route metric is 3, traffic share count is 1
  R4-LHR#
```

## Block 02

**Endpoint reachability.** The receiver receives 5/5 replies from the source before multicast testing.

```text
MCAST-RECEIVER#ping 10.1.1.10
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 10.1.1.10, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 3/3/4 ms
MCAST-RECEIVER#
```

## Block 03

**PIM neighbors.** R4 has neighbors on both transit links. This establishes adjacency, not receiver delivery.

```text
PIM Neighbor Table
Mode: B - Bidir Capable, DR - Designated Router, N - Default DR Priority,
      P - Proxy Capable, S - State Refresh Capable, G - GenID Capable,
      L - DR Load-balancing Capable
Neighbor          Interface                Uptime/Expires    Ver   DR
Address                                                            Prio/Mode
10.24.0.1         GigabitEthernet0/1       00:00:07/00:01:37 v2    1 / S P G
10.34.0.1         GigabitEthernet0/2       00:00:07/00:01:37 v2    1 / S P G
R4-LHR#
```

## Block 04

**Static RP mapping.** R4 maps the multicast range to RP 2.2.2.2.

```text
R4-LHR#sh ip pim rp mapping 
PIM Group-to-RP Mappings

Group(s): 224.0.0.0/4, Static
    RP: 2.2.2.2 (?)
R4-LHR#
```

## Block 05

**Source-side registration mechanism.** R1 shows an UP PIM Encap tunnel to 2.2.2.2. This is device state, not a packet capture of Register messages.

```text
1-FHR#sh ip pim tun
R1-FHR#sh ip pim tunnel 
Tunnel0 
  Type       : PIM Encap
  RP         : 2.2.2.2
  Source     : 10.12.0.1
  State      : UP
  Last event : Created (00:05:42)
R1-FHR#
```

## Block 06

**Receiver membership.** R4 lists 239.1.1.1 on Gi0/0 with last reporter 10.4.4.10. The separate 224.0.1.40 entry does not establish that Auto-RP has been configured.

```text
R4-LHR#sh ip igmp groups 
IGMP Connected Group Membership
Group Address    Interface                Uptime    Expires   Last Reporter   Group Accounted
239.1.1.1        GigabitEthernet0/0       00:00:12  00:02:47  10.4.4.10       
224.0.1.40       GigabitEthernet0/0       00:24:17  00:02:50  10.4.4.1        
R4-LHR#
```

## Block 07

**Shared-tree state at R4.** Before source traffic, (*,239.1.1.1) points toward R2 on Gi0/1 and toward the receiver on Gi0/0.

```text
R4-LHR#sh ip mroute 239.1.1.1
IP Multicast Routing Table
Flags: D - Dense, S - Sparse, B - Bidir Group, s - SSM Group, C - Connected,
       L - Local, P - Pruned, R - RP-bit set, F - Register flag,
       T - SPT-bit set, J - Join SPT, M - MSDP created entry, E - Extranet,
       X - Proxy Join Timer Running, A - Candidate for MSDP Advertisement,
       U - URD, I - Received Source Specific Host Report, 
       Z - Multicast Tunnel, z - MDT-data group sender, 
       Y - Joined MDT-data group, y - Sending to MDT-data group, 
       G - Received BGP C-Mroute, g - Sent BGP C-Mroute, 
       N - Received BGP Shared-Tree Prune, n - BGP C-Mroute suppressed, 
       Q - Received BGP S-A Route, q - Sent BGP S-A Route, 
       V - RD & Vector, v - Vector, p - PIM Joins on route, 
       x - VxLAN group
Outgoing interface flags: H - Hardware switched, A - Assert winner, p - PIM Join
 Timers: Uptime/Expires
 Interface state: Interface, Next-Hop or VCD, State/Mode

(*, 239.1.1.1), 00:01:24/00:02:37, RP 2.2.2.2, flags: SJC
  Incoming interface: GigabitEthernet0/1, RPF nbr 10.24.0.1
  Outgoing interface list:
    GigabitEthernet0/0, Forward/Sparse, 00:01:24/00:02:37

R4-LHR#
```

## Block 08

**Receiver branch reaches the RP.** R2 has the group and forwards toward R4 on Gi0/1. Its shared-tree incoming interface is Null because this router is the RP.

```text
R2-RP#sh ip mroute 239.1.1.1
IP Multicast Routing Table
Flags: D - Dense, S - Sparse, B - Bidir Group, s - SSM Group, C - Connected,
       L - Local, P - Pruned, R - RP-bit set, F - Register flag,
       T - SPT-bit set, J - Join SPT, M - MSDP created entry, E - Extranet,
       X - Proxy Join Timer Running, A - Candidate for MSDP Advertisement,
       U - URD, I - Received Source Specific Host Report, 
       Z - Multicast Tunnel, z - MDT-data group sender, 
       Y - Joined MDT-data group, y - Sending to MDT-data group, 
       G - Received BGP C-Mroute, g - Sent BGP C-Mroute, 
       N - Received BGP Shared-Tree Prune, n - BGP C-Mroute suppressed, 
       Q - Received BGP S-A Route, q - Sent BGP S-A Route, 
       V - RD & Vector, v - Vector, p - PIM Joins on route, 
       x - VxLAN group
Outgoing interface flags: H - Hardware switched, A - Assert winner, p - PIM Join
 Timers: Uptime/Expires
 Interface state: Interface, Next-Hop or VCD, State/Mode

(*, 239.1.1.1), 00:04:33/00:02:51, RP 2.2.2.2, flags: S
  Incoming interface: Null, RPF nbr 0.0.0.0
  Outgoing interface list:
    GigabitEthernet0/1, Forward/Sparse, 00:04:33/00:02:51

R2-RP#
```

## Block 09

**Replies from the receiver.** The multicast ping records replies from 10.4.4.10. It also retains an initial timeout marker and three replies to request 1. No packet capture establishes the cause of those duplicates, and this is not reported as 20/20 success.

```text
MCAST-SOURCE#ping 239.1.1.1 rep
MCAST-SOURCE#ping 239.1.1.1 repeat 20
Type escape sequence to abort.
Sending 20, 100-byte ICMP Echos to 239.1.1.1, timeout is 2 seconds:
.
Reply to request 1 from 10.4.4.10, 9 ms
Reply to request 1 from 10.4.4.10, 22 ms
Reply to request 1 from 10.4.4.10, 16 ms
Reply to request 2 from 10.4.4.10, 3 ms
Reply to request 3 from 10.4.4.10, 3 ms
Reply to request 4 from 10.4.4.10, 4 ms
Reply to request 5 from 10.4.4.10, 4 ms
Reply to request 6 from 10.4.4.10, 3 ms
Reply to request 7 from 10.4.4.10, 4 ms
Reply to request 8 from 10.4.4.10, 4 ms
Reply to request 9 from 10.4.4.10, 4 ms
Reply to request 10 from 10.4.4.10, 9 ms
Reply to request 11 from 10.4.4.10, 4 ms
Reply to request 12 from 10.4.4.10, 3 ms
Reply to request 13 from 10.4.4.10, 4 ms
Reply to request 14 from 10.4.4.10, 4 ms
Reply to request 15 from 10.4.4.10, 4 ms
Reply to request 16 from 10.4.4.10, 5 ms
Reply to request 17 from 10.4.4.10, 3 ms
Reply to request 18 from 10.4.4.10, 4 ms
Reply to request 19 from 10.4.4.10, 4 ms
MCAST-SOURCE#
```

## Block 10

**Source-specific state at R1.** The (10.1.1.10,239.1.1.1) entry receives on Gi0/0 and forwards toward R3 on Gi0/2. The capture includes the Registering label.

```text
R1-FHR#show ip mroute 239.1.1.1
IP Multicast Routing Table
Flags: D - Dense, S - Sparse, B - Bidir Group, s - SSM Group, C - Connected,
       L - Local, P - Pruned, R - RP-bit set, F - Register flag,
       T - SPT-bit set, J - Join SPT, M - MSDP created entry, E - Extranet,
       X - Proxy Join Timer Running, A - Candidate for MSDP Advertisement,
       U - URD, I - Received Source Specific Host Report, 
       Z - Multicast Tunnel, z - MDT-data group sender, 
       Y - Joined MDT-data group, y - Sending to MDT-data group, 
       G - Received BGP C-Mroute, g - Sent BGP C-Mroute, 
       N - Received BGP Shared-Tree Prune, n - BGP C-Mroute suppressed, 
       Q - Received BGP S-A Route, q - Sent BGP S-A Route, 
       V - RD & Vector, v - Vector, p - PIM Joins on route, 
       x - VxLAN group
Outgoing interface flags: H - Hardware switched, A - Assert winner, p - PIM Join
 Timers: Uptime/Expires
 Interface state: Interface, Next-Hop or VCD, State/Mode

(*, 239.1.1.1), 00:06:55/stopped, RP 2.2.2.2, flags: SPF
  Incoming interface: GigabitEthernet0/1, RPF nbr 10.12.0.2
  Outgoing interface list: Null

(10.1.1.10, 239.1.1.1), 00:06:55/00:00:32, flags: FT
  Incoming interface: GigabitEthernet0/0, RPF nbr 0.0.0.0, Registering
  Outgoing interface list:
    GigabitEthernet0/2, Forward/Sparse, 00:06:55/00:03:26

R1-FHR#
```

## Block 11

**Transit forwarding through R3.** R3 receives the source on Gi0/0 and forwards on Gi0/1 toward R4.

```text
R3-TRANSIT#show ip mroute 239.1.1.1
IP Multicast Routing Table
Flags: D - Dense, S - Sparse, B - Bidir Group, s - SSM Group, C - Connected,
       L - Local, P - Pruned, R - RP-bit set, F - Register flag,
       T - SPT-bit set, J - Join SPT, M - MSDP created entry, E - Extranet,
       X - Proxy Join Timer Running, A - Candidate for MSDP Advertisement,
       U - URD, I - Received Source Specific Host Report, 
       Z - Multicast Tunnel, z - MDT-data group sender, 
       Y - Joined MDT-data group, y - Sending to MDT-data group, 
       G - Received BGP C-Mroute, g - Sent BGP C-Mroute, 
       N - Received BGP Shared-Tree Prune, n - BGP C-Mroute suppressed, 
       Q - Received BGP S-A Route, q - Sent BGP S-A Route, 
       V - RD & Vector, v - Vector, p - PIM Joins on route, 
       x - VxLAN group
Outgoing interface flags: H - Hardware switched, A - Assert winner, p - PIM Join
 Timers: Uptime/Expires
 Interface state: Interface, Next-Hop or VCD, State/Mode

(*, 239.1.1.1), 00:00:17/stopped, RP 2.2.2.2, flags: SP
  Incoming interface: GigabitEthernet0/0, RPF nbr 10.13.0.1
  Outgoing interface list: Null

(10.1.1.10, 239.1.1.1), 00:00:17/00:02:42, flags: T
  Incoming interface: GigabitEthernet0/0, RPF nbr 10.13.0.1
  Outgoing interface list:
    GigabitEthernet0/1, Forward/Sparse, 00:00:17/00:03:12

R3-TRANSIT#
```

## Block 12

**Different incoming interfaces at R4.** (*,G) uses Gi0/1 toward the RP; (10.1.1.10,G) uses Gi0/2 toward R3. Both retain the receiver-facing outgoing interface.

```text
R4-LHR#sh ip mroute 239.1.1.1
IP Multicast Routing Table
Flags: D - Dense, S - Sparse, B - Bidir Group, s - SSM Group, C - Connected,
       L - Local, P - Pruned, R - RP-bit set, F - Register flag,
       T - SPT-bit set, J - Join SPT, M - MSDP created entry, E - Extranet,
       X - Proxy Join Timer Running, A - Candidate for MSDP Advertisement,
       U - URD, I - Received Source Specific Host Report, 
       Z - Multicast Tunnel, z - MDT-data group sender, 
       Y - Joined MDT-data group, y - Sending to MDT-data group, 
       G - Received BGP C-Mroute, g - Sent BGP C-Mroute, 
       N - Received BGP Shared-Tree Prune, n - BGP C-Mroute suppressed, 
       Q - Received BGP S-A Route, q - Sent BGP S-A Route, 
       V - RD & Vector, v - Vector, p - PIM Joins on route, 
       x - VxLAN group
Outgoing interface flags: H - Hardware switched, A - Assert winner, p - PIM Join
 Timers: Uptime/Expires
 Interface state: Interface, Next-Hop or VCD, State/Mode

(*, 239.1.1.1), 00:22:27/stopped, RP 2.2.2.2, flags: SJC
  Incoming interface: GigabitEthernet0/1, RPF nbr 10.24.0.1
  Outgoing interface list:
    GigabitEthernet0/0, Forward/Sparse, 00:22:27/00:02:36

(10.1.1.10, 239.1.1.1), 00:01:59/00:01:00, flags: JT
  Incoming interface: GigabitEthernet0/2, RPF nbr 10.34.0.1
  Outgoing interface list:
    GigabitEthernet0/0, Forward/Sparse, 00:01:59/00:02:36

R4-LHR#
```

## Block 13

**Pruned source branch at the RP.** R2 retains (*,G) state, while the source entry is PT with an empty outgoing interface list. Read that alongside R3 and R4's forwarding state.

```text
R2-RP#show ip mroute 239.1.1.1
IP Multicast Routing Table
Flags: D - Dense, S - Sparse, B - Bidir Group, s - SSM Group, C - Connected,
       L - Local, P - Pruned, R - RP-bit set, F - Register flag,
       T - SPT-bit set, J - Join SPT, M - MSDP created entry, E - Extranet,
       X - Proxy Join Timer Running, A - Candidate for MSDP Advertisement,
       U - URD, I - Received Source Specific Host Report, 
       Z - Multicast Tunnel, z - MDT-data group sender, 
       Y - Joined MDT-data group, y - Sending to MDT-data group, 
       G - Received BGP C-Mroute, g - Sent BGP C-Mroute, 
       N - Received BGP Shared-Tree Prune, n - BGP C-Mroute suppressed, 
       Q - Received BGP S-A Route, q - Sent BGP S-A Route, 
       V - RD & Vector, v - Vector, p - PIM Joins on route, 
       x - VxLAN group
Outgoing interface flags: H - Hardware switched, A - Assert winner, p - PIM Join
 Timers: Uptime/Expires
 Interface state: Interface, Next-Hop or VCD, State/Mode

(*, 239.1.1.1), 00:23:35/00:03:26, RP 2.2.2.2, flags: S
  Incoming interface: Null, RPF nbr 0.0.0.0
  Outgoing interface list:
    GigabitEthernet0/1, Forward/Sparse, 00:23:35/00:03:26

(10.1.1.10, 239.1.1.1), 00:03:07/00:02:22, flags: PT
  Incoming interface: GigabitEthernet0/0, RPF nbr 10.12.0.1
  Outgoing interface list: Null

R2-RP#
```

## Block 14

**RPF lookup toward the source.** R4's Reverse Path Forwarding lookup selects Gi0/2 and neighbor 10.34.0.1 using OSPF.

```text
R4-LHR#show ip rpf 10.1.1.10
RPF information for ? (10.1.1.10)
  RPF interface: GigabitEthernet0/2
  RPF neighbor: ? (10.34.0.1)
  RPF route/mask: 10.1.1.0/24
  RPF type: unicast (ospf 1)
  Doing distance-preferred lookups across tables
  RPF topology: ipv4 multicast base, originated from ipv4 unicast base
R4-LHR#
```

## Block 15

**RPF lookup toward the RP.** R4's lookup for 2.2.2.2 selects Gi0/1 and neighbor 10.24.0.1. The source and RP lookups answer different questions.

```text
R4-LHR#show ip rpf 2.2.2.2
RPF information for ? (2.2.2.2)
  RPF interface: GigabitEthernet0/1
  RPF neighbor: ? (10.24.0.1)
  RPF route/mask: 2.2.2.2/32
  RPF type: unicast (ospf 1)
  Doing distance-preferred lookups across tables
  RPF topology: ipv4 multicast base, originated from ipv4 unicast base
R4-LHR#
```

[Back to verification](README.md) · [Back to PIM-SM](../README.md)

