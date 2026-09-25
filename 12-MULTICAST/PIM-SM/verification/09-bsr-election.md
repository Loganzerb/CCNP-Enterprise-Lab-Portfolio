# BSR election — participation, priority and recovery

Retrieved from MASTERCLASS CCNP LAB PART 5, September 24–25, 2026. Each block states what the supplied evidence establishes. Formatting cleanup decodes escaped spaces and Markdown characters and normalizes line endings; interleaved logs and incomplete prompts remain. These are sequential snapshots.

## Block 01

**R3 is the first elected BSR.** R3 becomes BSR at priority 10 with hash-mask length 0.

```text
R3-TRANSIT#show ip pim bsr-router 
PIMv2 Bootstrap information
This system is the Bootstrap Router (BSR)
  BSR address: 3.3.3.3 (?)
  Uptime:      00:00:09, BSR Priority: 10, Hash mask length: 0
  Next bootstrap message in 00:00:51
R3-TRANSIT#
```

## Block 02

**R5 keeps learning R3.** The expiry value refreshes across multiple checks. There is no local candidate line in these snapshots; waiting alone did not make R5 participate.

```text
R5-BSR2#show ip pim bsr-router 
PIMv2 Bootstrap information
  BSR address: 3.3.3.3 (?)
  Uptime:      00:03:30, BSR Priority: 10, Hash mask length: 0
  Expires:     00:01:47
R5-BSR2#show ip pim bsr-router 
PIMv2 Bootstrap information
  BSR address: 3.3.3.3 (?)
  Uptime:      00:04:34, BSR Priority: 10, Hash mask length: 0
  Expires:     00:01:44
R5-BSR2#show ip pim bsr-router 
PIMv2 Bootstrap information
  BSR address: 3.3.3.3 (?)
  Uptime:      00:05:19, BSR Priority: 10, Hash mask length: 0
  Expires:     00:01:59
R5-BSR2#
```

## Block 03

**Operator identifies the missing role command.** This is a contemporaneous user report, not a configuration transcript. The next captures show the changed election result.

> i figured out the issue, i never put the command on R5-BSR2, that is my fault

## Block 04

**R5 becomes BSR at priority 20.** R5 now identifies itself as the BSR. The trailing backslashes were present in the paste.

```text
R5-BSR2#show ip pim bsr-router 
PIMv2 Bootstrap information
This system is the Bootstrap Router (BSR)
  BSR address: 5.5.5.5 (?)
  Uptime:      00:00:27, BSR Priority: 20, Hash mask length: 0
  Next bootstrap message in 00:00:32
R5-BSR2#\\
```

## Block 05

**R3 confirms the higher-priority winner.** R3 remains a candidate at priority 10 while recognizing R5 at 20.

```text
R3-TRANSIT#show ip pim bsr-router 
PIMv2 Bootstrap information
  BSR address: 5.5.5.5 (?)
  Uptime:      00:01:44, BSR Priority: 20, Hash mask length: 0
  Expires:     00:01:26
This system is a candidate BSR
  Candidate BSR address: 3.3.3.3, priority: 10, hash mask length: 0
R3-TRANSIT#
```

## Block 06

**Equal priority, higher BSR address.** Both candidates now have priority 20; R3 still recognizes 5.5.5.5 as BSR. This is the BSR address tie-break, separate from RP hashing.

```text
R3-TRANSIT#show ip pi
*Sep 24 23:38:18.218: %SYS-5-CONFIG_I: Configured from console by consolem bsr
R3-TRANSIT#show ip pim bsr-router 
PIMv2 Bootstrap information
  BSR address: 5.5.5.5 (?)
  Uptime:      00:04:23, BSR Priority: 20, Hash mask length: 0
  Expires:     00:01:50
This system is a candidate BSR
  Candidate BSR address: 3.3.3.3, priority: 20, hash mask length: 0
R3-TRANSIT#
```

## Block 07

**R3 takes over after R5 isolation.** The capture spans retained R5 state, OSPF/PIM neighbor loss and R3 becoming BSR. Sampling gaps and interleaved output prevent an exact failover-duration claim.

```text
R3-TRANSIT#show ip pi
*Sep 24 23:38:18.218: %SYS-5-CONFIG_I: Configured from console by consolem bsr
R3-TRANSIT#show ip pim bsr-router 
PIMv2 Bootstrap information
  BSR address: 5.5.5.5 (?)
  Uptime:      00:04:23, BSR Priority: 20, Hash mask length: 0
  Expires:     00:01:50
This system is a candidate BSR
  Candidate BSR address: 3.3.3.3, priority: 20, hash mask length: 0
R3-TRANSIT#show ip pim bsr-router
PIMv2 Bootstrap information
  BSR address: 5.5.5.5 (?)
  Uptime:      00:07:24, BSR Priority: 20, Hash mask length: 0
  Expires:     00:01:51
This system is a candidate BSR
  Candidate BSR address: 3.3.3.3, priority: 20, hash mask length: 0
R3-TRANSIT#show ip pim bsr-router
PIMv2 Bootstrap information
*Sep 24 23:41:48.692: %OSPF-5-ADJCHG: Process 1, Nbr 5.5.5.5 on GigabitEthernet0/2 from FULL to DOWN, Neighbor Down: Dead timer expired
  BSR address: 5.5.5.5 (?)
  Uptime:      00:07:50, BSR Priority: 20, Hash mask length: 0
  Expires:     00:01:25
This system is a candidate BSR
  Candidate BSR address: 3.3.3.3, priority: 20, hash mask length: 0
R3-TRANSIT#show ip pim bsr-router
PIMv2 Bootstrap information
  BSR address: 5.5.5.5 (?)
  Uptime:      00:08:04, BSR Priority: 20, Hash mask length: 0
  Expires:     00:01:11
This system is a candidate BSR
  Candidate BSR address: 3.3.3.3, priority: 20, hash mask length: 0
R3-TRANSIT#
*Sep 24 23:42:34.099: %PIM-5-NBRCHG: neighbor 10.35.0.2 DOWN on interface GigabitEthernet0/2 DR
*Sep 24 23:42:34.099: %PIM-5-DRCHG: DR change from neighbor 10.35.0.2 to 10.35.0.1 on interface GigabitEthernet0/2show ip pim bsr-router
PIMv2 Bootstrap information
This system is the Bootstrap Router (BSR)
  BSR address: 3.3.3.3 (?)
  Uptime:      00:02:06, BSR Priority: 20, Hash mask length: 0
  Next bootstrap message in 00:00:55
R3-TRANSIT#
```

## Block 08

**R5 link and local BSR state return.** PIM and OSPF adjacencies recover; R5 reports itself as BSR. R5 was isolated, not powered off, so its local uptime is not a domain-wide convergence measurement.

```text
R5-BSR2#
*Sep 24 23:49:02.353: %SYS-5-CONFIG_I: Configured from console by console
*Sep 24 23:49:03.144: %PIM-5-NBRCHG: neighbor 10.35.0.1 UP on interface GigabitEthernet0/0 
*Sep 24 23:49:03.145: %PIM-5-DRCHG: DR change from neighbor 0.0.0.0 to 10.35.0.2 on interface GigabitEthernet0/0
*Sep 24 23:49:03.319: %LINK-3-UPDOWN: Interface GigabitEthernet0/0, changed state to up
*Sep 24 23:49:04.334: %LINEPROTO-5-UPDOWN: Line protocol on Interface GigabitEthernet0/0, changed state to up
*Sep 24 23:49:04.499: %OSPF-5-ADJCHG: Process 1, Nbr 3.3.3.3 on GigabitEthernet0/0 from LOADING to FULL, Loading Done
R5-BSR2#sh ip pim bsr
R5-BSR2#sh ip pim bsr-router 
PIMv2 Bootstrap information
This system is the Bootstrap Router (BSR)
  BSR address: 5.5.5.5 (?)
  Uptime:      00:15:13, BSR Priority: 20, Hash mask length: 0
  Next bootstrap message in 00:00:58
R5-BSR2#
```

## Block 09

**R3 accepts R5 again.** R3 recognizes the preferred BSR after connectivity returns. The test predates Candidate RP setup; it does not measure multicast traffic continuity.

```text
R3-TRANSIT#
*Sep 24 23:48:59.411: %PIM-5-NBRCHG: neighbor 10.35.0.2 UP on interface GigabitEthernet0/2 
*Sep 24 23:48:59.412: %PIM-5-DRCHG: DR change from neighbor 10.35.0.1 to 10.35.0.2 on interface GigabitEthernet0/2
*Sep 24 23:49:00.759: %OSPF-5-ADJCHG: Process 1, Nbr 5.5.5.5 on GigabitEthernet0/2 from LOADING to FULL, Loading Done
R3-TRANSIT#
R3-TRANSIT#
R3-TRANSIT#
R3-TRANSIT#sh ip pim bs
R3-TRANSIT#sh ip pim bsr-router 
PIMv2 Bootstrap information
  BSR address: 5.5.5.5 (?)
  Uptime:      00:02:48, BSR Priority: 20, Hash mask length: 0
  Expires:     00:01:23
This system is a candidate BSR
  Candidate BSR address: 3.3.3.3, priority: 20, hash mask length: 0
R3-TRANSIT#
```

[BSR overview](../bsr.md) · [BSR configuration](../configs/bsr.md) · [Evidence guide](README.md)
