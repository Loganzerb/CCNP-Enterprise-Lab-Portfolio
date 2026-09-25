# BSR propagation — healthy routes, missing PIM

Retrieved from MASTERCLASS CCNP LAB PART 5, September 24–25, 2026. Each block states what the supplied evidence establishes. Formatting cleanup decodes escaped spaces and Markdown characters and normalizes line endings; interleaved logs and incomplete prompts remain. These are sequential snapshots.

## Block 01

**R2 local interfaces are ready.** R2 has PIM on Loopback0 and both active transit links, with neighbors on each transit interface.

```text
R2-RP#show ip pim interface

Address          Interface                Ver/   Nbr    Query  DR         DR
                                          Mode   Count  Intvl  Prior
2.2.2.2          Loopback0                v2/S   0      30     1          2.2.2.2
10.12.0.2        GigabitEthernet0/0       v2/S   1      30     1          10.12.0.2
10.24.0.1        GigabitEthernet0/1       v2/S   1      30     1          10.24.0.2
R2-RP#show ip interface brief
Interface                  IP-Address      OK? Method Status                Protocol
GigabitEthernet0/0         10.12.0.2       YES NVRAM  up                    up      
GigabitEthernet0/1         10.24.0.1       YES NVRAM  up                    up      
GigabitEthernet0/2         unassigned      YES NVRAM  administratively down down    
GigabitEthernet0/3         unassigned      YES NVRAM  administratively down down    
Loopback0                  2.2.2.2         YES NVRAM  up                    up      
R2-RP#
```

## Block 02

**Candidate configuration without BSR knowledge.** R2 has rp-candidate configured but no active BSR address or learned RP mapping; R5 is elected but its RP-set is empty.

```text
R2-RP#show ip pim bsr-router
PIMv2 Bootstrap information
  Candidate RP: 2.2.2.2(Loopback0)
    Holdtime 150 seconds
    Advertisement interval 60 seconds
    Next advertisement in 00:00:50
R2-RP#show ip pim rp mapping
PIM Group-to-RP Mappings
This system is a candidate RP (v2)

R2-RP#show running-config | include rp-candidate
ip pim rp-candidate Loopback0
R2-RP#
R5-BSR2#sh ip pim rp mapping 
PIM Group-to-RP Mappings
This system is the Bootstrap Router (v2)

R5-BSR2#
```

## Block 03

**The empty state persists.** Another check shows the same gap after multiple advertisement opportunities, supporting investigation beyond a first convergence snapshot.

```text
R2-RP#show ip pim bsr-router
PIMv2 Bootstrap information
  Candidate RP: 2.2.2.2(Loopback0)
    Holdtime 150 seconds
    Advertisement interval 60 seconds
    Next advertisement in 00:00:48
R2-RP#show ip pim rp mapping
PIM Group-to-RP Mappings
This system is a candidate RP (v2)

R2-RP#
R5-BSR2#show ip pim bsr-router
PIMv2 Bootstrap information
This system is the Bootstrap Router (BSR)
  BSR address: 5.5.5.5 (?)
  Uptime:      00:07:29, BSR Priority: 20, Hash mask length: 0
  Next bootstrap message in 00:00:37
R5-BSR2#show ip pim rp mapping
PIM Group-to-RP Mappings
This system is the Bootstrap Router (v2)

R5-BSR2#
```

## Block 04

**Trace the control-plane gap across routers.** OSPF routes to 5.5.5.5 exist on R1–R4. R1 and R3 show BSR knowledge; R2 and R4 do not. The pasted route formatting is retained, including list markers and a collapsed final R4 line.

```text
R2-RP#show ip pim bsr-router
PIMv2 Bootstrap information
Candidate RP: 2.2.2.2(Loopback0)
Holdtime 150 seconds
Advertisement interval 60 seconds
Next advertisement in 00:00:48
R2-RP#show ip pim rp mapping
PIM Group-to-RP Mappings
This system is a candidate RP (v2)

R2-RP#show ip pim bsr-router
PIMv2 Bootstrap information
Candidate RP: 2.2.2.2(Loopback0)
Holdtime 150 seconds
Advertisement interval 60 seconds
Next advertisement in 00:00:08
R2-RP#show ip route 5.5.5.5
Routing entry for 5.5.5.5/32
Known via "ospf 1", distance 110, metric 4, type intra area
Last update from 10.12.0.1 on GigabitEthernet0/0, 00:09:11 ago
Routing Descriptor Blocks:

- 10.24.0.2, from 5.5.5.5, 00:09:11 ago, via GigabitEthernet0/1
  Route metric is 4, traffic share count is 1
  10.12.0.1, from 5.5.5.5, 00:09:11 ago, via GigabitEthernet0/0
  Route metric is 4, traffic share count is 1
  R2-RP#

R1-FHR#show ip pim bsr-router
PIMv2 Bootstrap information
BSR address: 5.5.5.5 (?)
Uptime:      00:00:34, BSR Priority: 20, Hash mask length: 0
Expires:     00:01:35
R1-FHR#show ip route 5.5.5.5
Routing entry for 5.5.5.5/32
Known via "ospf 1", distance 110, metric 3, type intra area
Last update from 10.13.0.2 on GigabitEthernet0/2, 00:09:47 ago
Routing Descriptor Blocks:

- 10.13.0.2, from 5.5.5.5, 00:09:47 ago, via GigabitEthernet0/2
  Route metric is 3, traffic share count is 1
  R1-FHR#

R4-LHR#show ip pim bsr-router
PIMv2 Bootstrap information
R4-LHR#show ip route 5.5.5.5
Routing entry for 5.5.5.5/32
Known via "ospf 1", distance 110, metric 3, type intra area
Last update from 10.34.0.1 on GigabitEthernet0/2, 00:09:32 ago
Routing Descriptor Blocks:

- 10.34.0.1, from 5.5.5.5, 00:09:32 ago, via GigabitEthernet0/2 Route metric is 3, traffic share count is 1 R4-LHR#

R3-TRANSIT#show ip pim bsr-router
PIMv2 Bootstrap information
BSR address: 5.5.5.5 (?)
Uptime:      00:09:06, BSR Priority: 20, Hash mask length: 0
Expires:     00:02:09
This system is a candidate BSR
Candidate BSR address: 3.3.3.3, priority: 20, hash mask length: 0
R3-TRANSIT#show ip route 5.5.5.5
Routing entry for 5.5.5.5/32
Known via "ospf 1", distance 110, metric 2, type intra area
Last update from 10.35.0.2 on GigabitEthernet0/2, 00:10:37 ago
Routing Descriptor Blocks:

- 10.35.0.2, from 5.5.5.5, 00:10:37 ago, via GigabitEthernet0/2
  Route metric is 2, traffic share count is 1
  R3-TRANSIT#
```

## Block 05

**Saved R3 configuration corroborates the fault.** Excerpt from the September 24 CML export: Gi0/0 and Gi0/1 lack sparse-mode, while Gi0/2 toward R5 includes it. This saved checkpoint is not a simultaneous capture with Block 04.

```text
interface GigabitEthernet0/0
 description LINK-TO-R1-FHR
 ip address 10.13.0.2 255.255.255.252
 duplex auto
 speed auto
 media-type rj45
!
interface GigabitEthernet0/1
 description LINK-TO-R4-LHR
 ip address 10.34.0.1 255.255.255.252
 duplex auto
 speed auto
 media-type rj45
!
interface GigabitEthernet0/2
 description LINK-TO-R5-BSR2
 ip address 10.35.0.1 255.255.255.252
 ip pim sparse-mode
 duplex auto
 speed auto
 media-type rj45
!
```

## Block 06

**R5 has the Candidate RP after repair.** The operator reported restoring missing PIM on R3 Gi0/0 and Gi0/1. The accompanying CLI shows R5 learning RP 2.2.2.2; Info source is the Candidate RP itself.

```text
R5-BSR2#sh ip pim rp mapping 
PIM Group-to-RP Mappings
This system is the Bootstrap Router (v2)

Group(s) 224.0.0.0/4
  RP 2.2.2.2 (?), v2
    Info source: 2.2.2.2 (?), via bootstrap, priority 0, holdtime 150
         Uptime: 00:00:50, expires: 00:01:35
R5-BSR2#
```

## Block 07

**All four downstream routers learn the RP.** R1–R4 now show 2.2.2.2 for 224.0.0.0/4, via bootstrap from 5.5.5.5. This closes the RP-distribution check.

```text
R1-FHR#show ip pim rp mapping
PIM Group-to-RP Mappings

Group(s) 224.0.0.0/4
  RP 2.2.2.2 (?), v2
    Info source: 5.5.5.5 (?), via bootstrap, priority 0, holdtime 150
         Uptime: 00:03:23, expires: 00:02:03
R1-FHR#
R2-RP#show ip pim rp mapping
PIM Group-to-RP Mappings
This system is a candidate RP (v2)

Group(s) 224.0.0.0/4
  RP 2.2.2.2 (?), v2
    Info source: 5.5.5.5 (?), via bootstrap, priority 0, holdtime 150
         Uptime: 00:03:28, expires: 00:01:59
R2-RP#
R4-LHR#show ip pim rp mapping
PIM Group-to-RP Mappings

Group(s) 224.0.0.0/4
  RP 2.2.2.2 (?), v2
    Info source: 5.5.5.5 (?), via bootstrap, priority 0, holdtime 150
         Uptime: 00:03:33, expires: 00:01:54
R4-LHR#
R3-TRANSIT#show ip pim rp mapping
PIM Group-to-RP Mappings

Group(s) 224.0.0.0/4
  RP 2.2.2.2 (?), v2
    Info source: 5.5.5.5 (?), via bootstrap, priority 0, holdtime 150
         Uptime: 00:03:38, expires: 00:01:48
R3-TRANSIT#
```

[BSR overview](../bsr.md) · [BSR configuration](../configs/bsr.md) · [Evidence guide](README.md)
