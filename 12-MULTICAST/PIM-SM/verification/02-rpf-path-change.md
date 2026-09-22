# RPF path change — move the source tree and restore it

A temporary static route on R4 changes the reverse path toward 10.1.1.10. These captures establish a changed forwarding tree and its restoration; they do not measure packet loss or an RPF-drop incident.

Captured CLI from the September 20–21, 2026 lab. Blocks preserve the submitted output with formatting cleanup only; shortened prompts, logs, timers and flags remain as recorded.

## Block 01

**Static route changes the source lookup.** R4 now selects Gi0/1 through 10.24.0.1; the lookup identifies static routing.

```text
R4-LHR#show ip rpf 10.1.1.10
RPF information for ? (10.1.1.10)
  RPF interface: GigabitEthernet0/1
  RPF neighbor: ? (10.24.0.1)
  RPF route/mask: 10.1.1.0/24
  RPF type: unicast (static)
  Doing distance-preferred lookups across tables
  RPF topology: ipv4 multicast base, originated from ipv4 unicast base
R4-LHR#
```

## Block 02

**Source state follows the new path.** R4's (10.1.1.10,239.1.1.1) incoming interface becomes Gi0/1. The JT flags remain: sharing the RP-facing interface does not turn this into a shared-tree-only result.

```text
R4-LHR#show ip mroute 239.1.1.1
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

(*, 239.1.1.1), 00:37:30/stopped, RP 2.2.2.2, flags: SJC
  Incoming interface: GigabitEthernet0/1, RPF nbr 10.24.0.1
  Outgoing interface list:
    GigabitEthernet0/0, Forward/Sparse, 00:37:30/00:02:26

(10.1.1.10, 239.1.1.1), 00:00:55/00:02:04, flags: JT
  Incoming interface: GigabitEthernet0/1, RPF nbr 10.24.0.1
  Outgoing interface list:
    GigabitEthernet0/0, Forward/Sparse, 00:00:55/00:02:26

R4-LHR#
```

## Block 03

**R2 forwards the source toward R4.** R2's source entry now has Gi0/1 in its outgoing list.

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

(*, 239.1.1.1), 00:39:03/00:02:45, RP 2.2.2.2, flags: S
  Incoming interface: Null, RPF nbr 0.0.0.0
  Outgoing interface list:
    GigabitEthernet0/1, Forward/Sparse, 00:39:03/00:02:45

(10.1.1.10, 239.1.1.1), 00:02:28/00:01:32, flags: T
  Incoming interface: GigabitEthernet0/0, RPF nbr 10.12.0.1
  Outgoing interface list:
    GigabitEthernet0/1, Forward/Sparse, 00:02:28/00:02:59

R2-RP#
```

## Block 04

**The old R3 branch disappears.** R3 reports the group not found after the path change.

```text
R3-TRANSIT#show ip mroute 239.1.1.1
Group 239.1.1.1 not found
R3-TRANSIT#
```

## Block 05

**R4 returns to its OSPF source path.** After the temporary route is removed, both the source entry and RPF lookup return to Gi0/2 through R3.

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

(*, 239.1.1.1), 00:41:33/stopped, RP 2.2.2.2, flags: SJC
  Incoming interface: GigabitEthernet0/1, RPF nbr 10.24.0.1
  Outgoing interface list:
    GigabitEthernet0/0, Forward/Sparse, 00:41:33/00:02:23

(10.1.1.10, 239.1.1.1), 00:04:58/00:01:53, flags: JT
  Incoming interface: GigabitEthernet0/2, RPF nbr 10.34.0.1
  Outgoing interface list:
    GigabitEthernet0/0, Forward/Sparse, 00:04:58/00:02:23

R4-LHR#
R4-LHR#
R4-LHR#
R4-LHR#
R4-LHR#show ip rpf 10.1.1.10
RPF information for ? (10.1.1.10)
  RPF interface: GigabitEthernet0/2
  RPF neighbor: ? (10.34.0.1)
  RPF route/mask: 10.1.1.0/24
  RPF type: unicast (ospf 1)
  Doing distance-preferred lookups across tables
  RPF topology: ipv4 multicast base, originated from ipv4 unicast base
R4-LHR#
R4-LHR#
```

## Block 06

**R3 carries the source again.** The source-specific entry returns, receiving on Gi0/0 and forwarding on Gi0/1.

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

(*, 239.1.1.1), 00:01:55/stopped, RP 2.2.2.2, flags: SP
  Incoming interface: GigabitEthernet0/0, RPF nbr 10.13.0.1
  Outgoing interface list: Null

(10.1.1.10, 239.1.1.1), 00:01:55/00:01:04, flags: T
  Incoming interface: GigabitEthernet0/0, RPF nbr 10.13.0.1
  Outgoing interface list:
    GigabitEthernet0/1, Forward/Sparse, 00:01:55/00:02:43

R3-TRANSIT#
```

## Block 07

**The RP branch is pruned again.** R2's source entry returns to PT with a Null outgoing list.

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

(*, 239.1.1.1), 00:44:41/00:03:01, RP 2.2.2.2, flags: S
  Incoming interface: Null, RPF nbr 0.0.0.0
  Outgoing interface list:
    GigabitEthernet0/1, Forward/Sparse, 00:44:41/00:03:01

(10.1.1.10, 239.1.1.1), 00:08:06/00:01:24, flags: PT
  Incoming interface: GigabitEthernet0/0, RPF nbr 10.12.0.1
  Outgoing interface list: Null

R2-RP#
```

[Back to verification](README.md) · [Back to PIM-SM](../README.md)

