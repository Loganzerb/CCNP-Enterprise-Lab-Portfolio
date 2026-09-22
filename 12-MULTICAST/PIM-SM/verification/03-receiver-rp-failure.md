# Receiver-side RP failure — membership without an upstream tree

R4's static RP mapping is removed before the receiver joins the fresh group 239.2.2.2. This exercise verifies restoration of the receiver tree; no end-to-end ping for this group was captured.

Captured CLI from the September 20–21, 2026 lab. Blocks preserve the submitted output with formatting cleanup only; shortened prompts, logs, timers and flags remain as recorded.

## Block 01

**No RP mapping on R4.** The mapping table has no entry after the fault is introduced.

```text
R4-LHR#sh ip pim rp ma
R4-LHR#sh ip pim rp mapping 
PIM Group-to-RP Mappings

R4-LHR#
```

## Block 02

**Local membership still works.** R4 learns 239.2.2.2 from receiver 10.4.4.10 despite the missing mapping.

```text
R4-LHR#sh ip igmp groups 
IGMP Connected Group Membership
Group Address    Interface                Uptime    Expires   Last Reporter   Group Accounted
239.1.1.1        GigabitEthernet0/0       01:13:12  00:02:52  10.4.4.10       
239.2.2.2        GigabitEthernet0/0       00:00:23  00:02:46  10.4.4.10       
224.0.1.40       GigabitEthernet0/0       01:37:16  00:02:51  10.4.4.1        
R4-LHR#
```

## Block 03

**The group has no usable RP path.** R4 lists RP 0.0.0.0 and incoming interface Null, while Gi0/0 remains in the outgoing list.

```text
R4-LHR#sh ip mroute 239.2.2.2
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

(*, 239.2.2.2), 00:02:24/00:02:47, RP 0.0.0.0, flags: SJC
  Incoming interface: Null, RPF nbr 0.0.0.0
  Outgoing interface list:
    GigabitEthernet0/0, Forward/Sparse, 00:02:24/00:02:47

R4-LHR#
```

## Block 04

**The RP has no group state.** R2 reports 239.2.2.2 not found.

```text
R2-RP>en
R2-RP#show ip mroute 239.2.2.2
Group 239.2.2.2 not found
R2-RP#
```

## Block 05

**Restored RP knowledge on R4.** After restoring the static mapping, R4 names RP 2.2.2.2 and uses Gi0/1 toward it.

```text
R4-LHR#sh ip 
*Sep 21 22:44:55.177: %SYS-5-CONFIG_I: Configured from console by consolemroute 239.2.2.2
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

(*, 239.2.2.2), 00:09:03/00:02:13, RP 2.2.2.2, flags: SJC
  Incoming interface: GigabitEthernet0/1, RPF nbr 10.24.0.1
  Outgoing interface list:
    GigabitEthernet0/0, Forward/Sparse, 00:09:03/00:02:13

R4-LHR#
```

## Block 06

**The receiver branch reaches R2 again.** R2 now has (*,239.2.2.2) and Gi0/1 in the outgoing list. This establishes tree recovery, not a measured traffic result.

```text
R2-RP#sh ip mroute 239.2.2.2
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

(*, 239.2.2.2), 00:03:11/00:03:14, RP 2.2.2.2, flags: S
  Incoming interface: Null, RPF nbr 0.0.0.0
  Outgoing interface list:
    GigabitEthernet0/1, Forward/Sparse, 00:03:11/00:03:14

R2-RP#
```

[Back to verification](README.md) · [Back to PIM-SM](../README.md)

