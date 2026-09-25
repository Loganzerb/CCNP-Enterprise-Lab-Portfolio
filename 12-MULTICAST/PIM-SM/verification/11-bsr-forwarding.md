# BSR forwarding — shared tree, source tree and prune

Retrieved from MASTERCLASS CCNP LAB PART 5, September 24–25, 2026. Each block states what the supplied evidence establishes. Formatting cleanup decodes escaped spaces and Markdown characters and normalizes line endings; interleaved logs and incomplete prompts remain. These are sequential snapshots.

These captures establish membership and forwarding state after BSR discovery recovered. The supplied BSR work has no complete source-to-group ping transcript, traffic-loss measurement or Register/Register-Stop packet capture. The earlier Auto-RP 19/20 result belongs to a different phase.

## Block 01

**Receiver interest creates shared-tree state.** R4 learns the receiver on Gi0/0 and has (*,G) toward R2 on Gi0/1 before source traffic is restarted. Membership in 224.0.1.40 also appears; by itself it does not establish active Auto-RP.

```text
R4-LHR#show ip igmp groups
IGMP Connected Group Membership
Group Address    Interface                Uptime    Expires   Last Reporter   Group Accounted
239.1.1.1        GigabitEthernet0/0       00:16:58  00:02:45  10.4.4.10       
224.0.1.40       GigabitEthernet0/0       00:17:18  00:02:45  10.4.4.1        
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

(*, 239.1.1.1), 00:16:59/00:02:44, RP 2.2.2.2, flags: SJC
  Incoming interface: GigabitEthernet0/1, RPF nbr 10.24.0.1
  Outgoing interface list:
    GigabitEthernet0/0, Forward/Sparse, 00:16:59/00:02:44

R4-LHR#
```

## Block 02

**R4 installs the source tree.** After source startup, (10.1.1.10,239.1.1.1) has JT flags, incoming Gi0/2 via R3 and outgoing Gi0/0. The shared entry still points toward R2.

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

(*, 239.1.1.1), 00:20:03/stopped, RP 2.2.2.2, flags: SJC
  Incoming interface: GigabitEthernet0/1, RPF nbr 10.24.0.1
  Outgoing interface list:
    GigabitEthernet0/0, Forward/Sparse, 00:20:03/00:02:41

(10.1.1.10, 239.1.1.1), 00:00:32/00:02:26, flags: JT
  Incoming interface: GigabitEthernet0/2, RPF nbr 10.34.0.1
  Outgoing interface list:
    GigabitEthernet0/0, Forward/Sparse, 00:00:32/00:02:41

R4-LHR#
```

## Block 03

**R2 prunes this source branch.** R2 retains its shared entry but the specific source entry is PT with a Null outgoing list. This matches the downstream SPT transition.

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

(*, 239.1.1.1), 00:09:54/00:03:25, RP 2.2.2.2, flags: S
  Incoming interface: Null, RPF nbr 0.0.0.0
  Outgoing interface list:
    GigabitEthernet0/1, Forward/Sparse, 00:09:54/00:03:25

(10.1.1.10, 239.1.1.1), 00:00:50/00:02:31, flags: PT
  Incoming interface: GigabitEthernet0/0, RPF nbr 10.12.0.1
  Outgoing interface list: Null

R2-RP#
```

[BSR overview](../bsr.md) · [BSR configuration](../configs/bsr.md) · [Evidence guide](README.md)
