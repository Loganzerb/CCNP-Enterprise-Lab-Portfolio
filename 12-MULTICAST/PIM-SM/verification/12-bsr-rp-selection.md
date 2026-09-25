# BSR RP selection — test the hash, then clean up

Retrieved from MASTERCLASS CCNP LAB PART 5, September 24–25, 2026. Each block states what the supplied evidence establishes. Formatting cleanup decodes escaped spaces and Markdown characters and normalizes line endings; interleaved logs and incomplete prompts remain. These are sequential snapshots.

## Block 01

**A second Candidate RP enters the set.** R2 has RP priority 0 and R3 has 10. R5 receives both candidates and R4 learns both through R5; BSR priority 20 is a different field.

```text
R3-TRANSIT#show ip pim bsr-router
PIMv2 Bootstrap information
  BSR address: 5.5.5.5 (?)
  Uptime:      00:26:30, BSR Priority: 20, Hash mask length: 0
  Expires:     00:01:57
This system is a candidate BSR
  Candidate BSR address: 3.3.3.3, priority: 20, hash mask length: 0
  Candidate RP: 3.3.3.3(Loopback0)
    Holdtime 150 seconds
    Advertisement interval 60 seconds
    Next advertisement in 00:00:11
    Candidate RP priority : 10
R3-TRANSIT#
R4-LHR#show ip pim rp mapping
PIM Group-to-RP Mappings

Group(s) 224.0.0.0/4
  RP 2.2.2.2 (?), v2
    Info source: 5.5.5.5 (?), via bootstrap, priority 0, holdtime 150
         Uptime: 00:17:30, expires: 00:02:05
  RP 3.3.3.3 (?), v2
    Info source: 5.5.5.5 (?), via bootstrap, priority 10, holdtime 150
         Uptime: 00:02:05, expires: 00:01:49
R4-LHR#
R5-BSR2#show ip pim rp mapping
PIM Group-to-RP Mappings
This system is the Bootstrap Router (v2)

Group(s) 224.0.0.0/4
  RP 2.2.2.2 (?), v2
    Info source: 2.2.2.2 (?), via bootstrap, priority 0, holdtime 150
         Uptime: 00:17:35, expires: 00:01:51
  RP 3.3.3.3 (?), v2
    Info source: 3.3.3.3 (?), via bootstrap, priority 10, holdtime 150
         Uptime: 00:02:11, expires: 00:02:14
R5-BSR2#
```

## Block 02

**Equal RP priorities do not change this group to R3.** Both RPs now have priority 0, but R4 retains shared-tree state using 2.2.2.2. Existing state alone is not enough to explain the selection.

```text
R4-LHR#show ip pim rp mapping
PIM Group-to-RP Mappings

Group(s) 224.0.0.0/4
  RP 2.2.2.2 (?), v2
    Info source: 5.5.5.5 (?), via bootstrap, priority 0, holdtime 150
         Uptime: 00:20:56, expires: 00:01:43
  RP 3.3.3.3 (?), v2
    Info source: 5.5.5.5 (?), via bootstrap, priority 0, holdtime 150
         Uptime: 00:05:32, expires: 00:02:27
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

(*, 239.1.1.1), 00:32:02/00:02:45, RP 2.2.2.2, flags: SJC
  Incoming interface: GigabitEthernet0/1, RPF nbr 10.24.0.1
  Outgoing interface list:
    GigabitEthernet0/0, Forward/Sparse, 00:32:02/00:02:45

R4-LHR#
```

## Block 03

**The group-specific hash resolves the prediction.** With mask 0.0.0.0, R2 has hash 1524600152 and R3 has 450145259. The larger hash selects 2.2.2.2 despite its smaller IP address.

```text
R4-LHR#show ip pim rp-hash 239.1.1.1
  RP 2.2.2.2 (?), v2
    Info source: 5.5.5.5 (?), via bootstrap, priority 0, holdtime 150
         Uptime: 00:22:49, expires: 00:01:53
  PIMv2 Hash Value (mask 0.0.0.0)
    RP 2.2.2.2, via bootstrap, priority 0, hash value 1524600152
    RP 3.3.3.3, via bootstrap, priority 0, hash value 450145259
R4-LHR#
```

## Block 04

**The final RP-set contains only R2.** After the temporary R3 Candidate RP role is removed, R4 retains only RP 2.2.2.2 via bootstrap from R5. R3 remains a Candidate BSR.

```text
R4-LHR#show ip pim rp mapping
PIM Group-to-RP Mappings

Group(s) 224.0.0.0/4
  RP 2.2.2.2 (?), v2
    Info source: 5.5.5.5 (?), via bootstrap, priority 0, holdtime 150
         Uptime: 00:29:36, expires: 00:02:10
R4-LHR#
```

[BSR overview](../bsr.md) · [BSR configuration](../configs/bsr.md) · [Evidence guide](README.md)
