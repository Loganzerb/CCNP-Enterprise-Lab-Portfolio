# Auto-RP troubleshooting — separate role, transport and mapping

Retrieved CLI from MASTERCLASS CCNP LAB PART 4, September 22–23, 2026. Formatting cleanup decodes escaped spaces and Markdown characters and normalizes line endings. Snapshots are sequential, not simultaneous.

## Block 01

**A static fallback reappears.** During the later Mapping Agent withdrawal exercise, R4's running configuration again contains the static RP. It is removed before interpreting the dynamic-discovery failure.

```text
R4-LHR#show running-config | include ip pim rp-address
ip pim rp-address 2.2.2.2
R4-LHR#
```

## Block 02

**No remaining RP mapping.** After static fallback removal and loss of discovery refreshes, R4 has an empty mapping table.

```text
R4-LHR#sh ip pim rp mapping 
PIM Group-to-RP Mappings

R4-LHR#
```

## Block 03

**Receiver branch without an upstream direction.** R4 retains (*,239.1.1.1), but RP is 0.0.0.0 and IIF is Null. No source-specific entry appears in this snapshot.

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

(*, 239.1.1.1), 00:28:36/00:02:01, RP 0.0.0.0, flags: SJC
  Incoming interface: Null, RPF nbr 0.0.0.0
  Outgoing interface list:
    GigabitEthernet0/0, Forward/Sparse, 00:28:36/00:02:01

R4-LHR#
```

## Block 04

**Receiver interest remains.** IGMP still lists 10.4.4.10 on Gi0/0. Membership in 224.0.1.40 does not establish a usable RP mapping.

```text
R4-LHR# sh ip igmp groups 
IGMP Connected Group Membership
Group Address    Interface                Uptime    Expires   Last Reporter   Group Accounted
239.1.1.1        GigabitEthernet0/0       00:29:47  00:02:50  10.4.4.10       
224.0.1.40       GigabitEthernet0/0       00:30:13  00:02:50  10.4.4.1        
R4-LHR#
```

## Block 05

**Traffic failure during the outage.** All twenty probes time out. This capture belongs to the Mapping Agent withdrawal/outage stage; it is not an isolated listener-only failure measurement.

```text
MCAST-SOURCE#ping 239.1.1.1 repeat 20
Type escape sequence to abort.
Sending 20, 100-byte ICMP Echos to 239.1.1.1, timeout is 2 seconds:
....................
MCAST-SOURCE#
```

## Block 06

**Mapping Agent and local listener restored.** R3 now has both role and listener commands. This intermediate repair does not establish that listener configuration is present elsewhere.

```text
R3-TRANSIT#show running-config | include ip pim autorp|send-rp-discovery
ip pim autorp listener
ip pim send-rp-discovery scope 16
R3-TRANSIT#
```

## Block 07

**Reception still stalled.** Despite R3's restored role and listener status line, Announce and Discovery remain 0/0. Check upstream generation and transport before reconfiguring the Mapping Agent again.

```text
R3-TRANSIT#show ip pim autorp
AutoRP Information: 
  AutoRP is enabled.
  RP Discovery packet MTU is 1500.
  224.0.1.40 is joined on GigabitEthernet0/0.
  AutoRP groups over sparse mode interface is enabled

PIM AutoRP Statistics: Sent/Received
  RP Announce: 0/0, RP Discovery: 0/0
R3-TRANSIT#
```

## Block 08

**The Candidate RP still exists.** R2's running configuration retains the candidate command and its Announce sent counter is 3. The listener status line is absent. This is a selected CLI excerpt; conversational text around it is omitted.

```text
R2-RP#show running-config | include send-rp-announce
ip pim send-rp-announce 2.2.2.2 scope 16
R2-RP#sh ip autorp
               ^
% Invalid input detected at '^' marker.

R2-RP#sh ip pim autorp
AutoRP Information: 
  AutoRP is enabled.
  RP Discovery packet MTU is 0.
  224.0.1.40 is joined on Loopback0.

PIM AutoRP Statistics: Sent/Received
  RP Announce: 3/0, RP Discovery: 0/0
R2-RP#
```

## Block 09

**Missing listener confirmed on R2.** The filtered running configuration is empty. The completed lab handoff reports that listener omissions were found across all four routers during the investigation and corrected.

```text
R2-RP#show running-config | include ip pim autorp
R2-RP#
```

## Block 10

**Mapping Agent recovery.** R3 — show ip pim autorp. Selected lines supplied in the completed lab handoff. After the listener was restored across the domain, R3 received five announcements and sent ten discovery messages.

```text
AutoRP is enabled.
224.0.1.40 is joined on GigabitEthernet0/0.
AutoRP groups over sparse mode interface is enabled

PIM AutoRP Statistics: Sent/Received
RP Announce: 0/5, RP Discovery: 10/0
```

## Block 11

**Dynamic mapping returns to R4.** R4 — show ip pim rp mapping. Selected lines supplied in the completed handoff. R3's 10.34.0.1 is the information source; 2.2.2.2 is the elected RP. These are different roles.

```text
PIM Group-to-RP Mappings

Group(s) 224.0.0.0/4
  RP 2.2.2.2 (?), v2v1
    Info source: 10.34.0.1 (?), elected via Auto-RP
Uptime: 00:04:40, expires: 00:02:14
```

[Back to Auto-RP](../auto-rp.md) · [Back to verification](README.md)

