# Source-side RP failure — a ready receiver with no replies

The receiver tree for fresh group 239.3.3.3 is established first. R1 then loses its RP mapping. The captured ping times out; after repair, device state is captured and a receiver reply is reported in the lab notes.

Captured CLI from the September 20–21, 2026 lab. Blocks preserve the submitted output with formatting cleanup only; shortened prompts, logs, timers and flags remain as recorded.

## Block 01

**Healthy receiver-side tree.** R4 already has (*,239.3.3.3), RP 2.2.2.2 and the receiver-facing outgoing interface.

```text
R4-LHR#sh ip mroute 239.3.3.3
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

(*, 239.3.3.3), 00:01:43/00:02:18, RP 2.2.2.2, flags: SJC
  Incoming interface: GigabitEthernet0/1, RPF nbr 10.24.0.1
  Outgoing interface list:
    GigabitEthernet0/0, Forward/Sparse, 00:01:43/00:02:18

R4-LHR#
```

## Block 02

**Healthy receiver branch at the RP.** R2 already has the group and Gi0/1 toward R4 in its outgoing list.

```text
R2-RP#sh ip mroute 239.3.3.3
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

(*, 239.3.3.3), 00:02:38/00:02:49, RP 2.2.2.2, flags: S
  Incoming interface: Null, RPF nbr 0.0.0.0
  Outgoing interface list:
    GigabitEthernet0/1, Forward/Sparse, 00:02:38/00:02:49

R2-RP#
```

## Block 03

**Remove RP knowledge on R1.** The captured command removes the static RP, and the mapping table is empty. The interleaved invalid-RP log concerns 224.0.1.40, not the test group.

```text
R1-FHR#configure terminal
Enter configuration commands, one per line.  End with CNTL/Z.
R1-FHR(config)# no ip pim rp-address 2.2.2.2
R1-FHR(config)#end
R1-FHR#
*Sep 21 22:52:11.025: %SYS-5-CONFIG_I: Configured from console by console
*Sep 21 22:52:54.081: %PIM-6-INVALID_RP_JOIN: Received (*, 224.0.1.40) Join from 10.13.0.2 for invalid RP 2.2.2.2
R1-FHR#
R1-FHR#sh ip pim rp map
R1-FHR#sh ip pim rp mapping
PIM Group-to-RP Mappings
R1-FHR#
```

## Block 04

**No PIM tunnel on R1.** The tunnel display is empty during the fault.

```text
R1-FHR#sh ip pim tunnel 
R1-FHR#
```

## Block 05

**All 20 probes time out.** MCAST-SOURCE's ping to 239.3.3.3 records twenty timeout markers and no receiver replies.

```text
MCAST-SOURCE#ping 239.3.3.3 re
MCAST-SOURCE#ping 239.3.3.3 repeat 20
Type escape sequence to abort.
Sending 20, 100-byte ICMP Echos to 239.3.3.3, timeout is 2 seconds:
....................
MCAST-SOURCE#
```

## Block 06

**Check the source address in every entry.** This diagnostic capture lists 10.12.0.1 and 10.13.0.1, both R1 interface addresses. Neither is the intended source 10.1.1.10. These incidental entries cannot verify that source's forwarding.

```text
R1-FHR#sh ip mroute 239.3.3.3
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

(*, 239.3.3.3), 00:05:36/stopped, RP 0.0.0.0, flags: SP
  Incoming interface: Null, RPF nbr 0.0.0.0
  Outgoing interface list: Null

(10.12.0.1, 239.3.3.3), 00:05:36/00:00:42, flags: T
  Incoming interface: GigabitEthernet0/1, RPF nbr 0.0.0.0
  Outgoing interface list:
    GigabitEthernet0/2, Forward/Sparse, 00:05:36/00:00:49

(10.13.0.1, 239.3.3.3), 00:05:36/00:00:12, flags: PT
  Incoming interface: GigabitEthernet0/2, RPF nbr 0.0.0.0
  Outgoing interface list: Null

R1-FHR#
```

## Block 07

**Registration mechanism restored.** After ip pim rp-address 2.2.2.2 is restored, R1 shows an UP PIM Encap tunnel. The lab note reports that the source received a reply; the post-repair ping transcript was not retained.

```text
R1-FHR#sh ip pim tunne
R1-FHR#sh ip pim tunnel 
Tunnel0* 
  Type       : PIM Encap
  RP         : 2.2.2.2
  Source     : 10.12.0.1
  State      : UP
  Last event : Created (00:00:25)
R1-FHR#
```

## Block 08

**The intended source appears on R1.** The (10.1.1.10,239.3.3.3) entry receives on Gi0/0 and forwards toward R3 on Gi0/2. The incidental 10.12.0.1 entry remains visible and pruned.

```text
R1-FHR#sh ip mroute 239.3.3.3
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

(*, 239.3.3.3), 00:09:35/stopped, RP 2.2.2.2, flags: SPF
  Incoming interface: GigabitEthernet0/1, RPF nbr 10.12.0.2
  Outgoing interface list: Null

(10.1.1.10, 239.3.3.3), 00:02:05/00:01:52, flags: FT
  Incoming interface: GigabitEthernet0/0, RPF nbr 0.0.0.0
  Outgoing interface list:
    GigabitEthernet0/2, Forward/Sparse, 00:02:05/00:03:23

(10.12.0.1, 239.3.3.3), 00:02:43/00:00:16, flags: PT
  Incoming interface: GigabitEthernet0/1, RPF nbr 0.0.0.0
  Outgoing interface list: Null

R1-FHR#
```

## Block 09

**R4's source tree uses R3.** R4 receives the intended source on Gi0/2 and forwards toward the receiver on Gi0/0.

```text
R4-LHR#sh ip mroute 239.3.3.3
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

(*, 239.3.3.3), 00:20:25/stopped, RP 2.2.2.2, flags: SJC
  Incoming interface: GigabitEthernet0/1, RPF nbr 10.24.0.1
  Outgoing interface list:
    GigabitEthernet0/0, Forward/Sparse, 00:20:25/00:02:32

(10.1.1.10, 239.3.3.3), 00:03:31/00:02:27, flags: JT
  Incoming interface: GigabitEthernet0/2, RPF nbr 10.34.0.1
  Outgoing interface list:
    GigabitEthernet0/0, Forward/Sparse, 00:03:31/00:02:32

R4-LHR#
```

## Block 10

**RP source branch is pruned.** R2's intended-source entry has PT flags and a Null outgoing list.

```text
R2-RP#show ip mroute 239.3.3.3
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

(*, 239.3.3.3), 00:21:44/00:03:25, RP 2.2.2.2, flags: S
  Incoming interface: Null, RPF nbr 0.0.0.0
  Outgoing interface list:
    GigabitEthernet0/1, Forward/Sparse, 00:21:44/00:03:25

(10.1.1.10, 239.3.3.3), 00:04:51/00:02:48, flags: PT
  Incoming interface: GigabitEthernet0/0, RPF nbr 10.12.0.1
  Outgoing interface list: Null

R2-RP#
```

## Block 11

**Temporary memberships removed.** After cleanup, R4 retains test group 239.1.1.1 and the separate 224.0.1.40 entry. The temporary 239.2.2.2 and 239.3.3.3 memberships are absent.

```text
R4-LHR#show ip igmp groups
IGMP Connected Group Membership
Group Address    Interface                Uptime    Expires   Last Reporter   Group Accounted
239.1.1.1        GigabitEthernet0/0       01:50:04  00:02:52  10.4.4.10       
224.0.1.40       GigabitEthernet0/0       02:14:08  00:02:56  10.4.4.1        
R4-LHR#
```

[Back to verification](README.md) · [Back to PIM-SM](../README.md)

