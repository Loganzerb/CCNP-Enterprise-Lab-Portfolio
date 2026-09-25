# BSR transition — remove fallback and add R5

Retrieved from MASTERCLASS CCNP LAB PART 5, September 24–25, 2026. Each block states what the supplied evidence establishes. Formatting cleanup decodes escaped spaces and Markdown characters and normalizes line endings; interleaved logs and incomplete prompts remain. These are sequential snapshots.

## Block 01

**R3 still has prior mechanisms.** Static RP, Auto-RP listener and Mapping Agent settings were present at the new session checkpoint. Earlier cleanup was therefore rechecked rather than assumed.

```text
R3-TRANSIT#sh running-config | section pim
 ip pim sparse-mode
 ip pim sparse-mode
ip pim rp-address 2.2.2.2
ip pim autorp listener
ip pim send-rp-discovery scope 16
R3-TRANSIT#
```

## Block 02

**R3 after cleanup.** Only interface-level sparse-mode lines remain in the filtered view. This filter does not identify the interfaces; later interface-specific evidence is still necessary.

```text
R3-TRANSIT#sh running-config | section pim
 ip pim sparse-mode
 ip pim sparse-mode
R3-TRANSIT#
```

## Block 03

**R2 before cleanup.** The Candidate RP announcement command and static mapping still exist.

```text
R2-RP#show running-config | section pim
 ip pim sparse-mode
 ip pim sparse-mode
 ip pim sparse-mode
ip pim rp-address 2.2.2.2
ip pim send-rp-announce 2.2.2.2 scope 16
R2-RP#
```

## Block 04

**R2 after cleanup.** The filtered configuration no longer includes static RP or Auto-RP announcements.

```text
R2-RP#show running-config | section pim
 ip pim sparse-mode
 ip pim sparse-mode
 ip pim sparse-mode
R2-RP#
```

## Block 05

**R1 before cleanup.** The static mapping and Auto-RP listener are both present.

```text
R1-FHR#show running-config | section pim
 ip pim sparse-mode
 ip pim sparse-mode
 ip pim sparse-mode
ip pim rp-address 2.2.2.2
ip pim autorp listener
R1-FHR#
```

## Block 06

**R1 after cleanup.** Only sparse-mode interface settings remain in this view.

```text
R1-FHR#
*Sep 24 22:51:26.078: %SYS-5-CONFIG_I: Configured from console by consoleshow running-config | section pim
 ip pim sparse-mode
 ip pim sparse-mode
 ip pim sparse-mode
R1-FHR#
```

## Block 07

**R4 before cleanup.** The remaining Auto-RP listener is visible.

```text
R4-LHR#show running-config | section pim
 ip pim sparse-mode
 ip pim sparse-mode
 ip pim sparse-mode
ip pim autorp listener
R4-LHR#
```

## Block 08

**R4 after cleanup.** The listener has been removed while interface-level sparse mode remains.

```text
R4-LHR#show running-config | section pim
 ip pim sparse-mode
 ip pim sparse-mode
 ip pim sparse-mode
R4-LHR#
```

## Block 09

**No RP mapping yet.** R4 has an empty mapping table before BSR is configured. This is an intentional transition checkpoint.

```text
R4-LHR#show ip pim rp mapping
PIM Group-to-RP Mappings

R4-LHR#
```

## Block 10

**R5 joins OSPF.** The new R3–R5 link reaches FULL adjacency. The first prompt was supplied without its leading R.

```text
5-BSR2#
*Sep 24 23:13:01.193: %OSPF-5-ADJCHG: Process 1, Nbr 3.3.3.3 on GigabitEthernet0/0 from LOADING to FULL, Loading Done
R5-BSR2#show ip ospf neighbor 

Neighbor ID     Pri   State           Dead Time   Address         Interface
3.3.3.3           1   FULL/BDR        00:00:33    10.35.0.1       GigabitEthernet0/0
R5-BSR2#
```

## Block 11

**Candidate addresses are reachable.** R5 sources five unicast probes from 5.5.5.5 to 3.3.3.3; all five succeed. This is underlay reachability, not a multicast delivery test.

```text
R5-BSR2#ping 3.3.3.3 source loopback 0
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 3.3.3.3, timeout is 2 seconds:
Packet sent with a source address of 5.5.5.5 
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 1/1/2 ms
R5-BSR2#
```

## Block 12

**PIM adjacency on the new link.** R5 sees R3 at 10.35.0.1 through Gi0/0. The command itself was not included in this paste.

```text
PIM Neighbor Table
Mode: B - Bidir Capable, DR - Designated Router, N - Default DR Priority,
      P - Proxy Capable, S - State Refresh Capable, G - GenID Capable,
      L - DR Load-balancing Capable
Neighbor          Interface                Uptime/Expires    Ver   DR
Address                                                            Prio/Mode
10.35.0.1         GigabitEthernet0/0       00:00:11/00:01:34 v2    1 / S P G
R5-BSR2#
```

## Block 13

**PIM on R5 transit and loopback.** Gi0/0 and Loopback0 both report v2/S. R5 can participate in the PIM domain; candidate role configuration is a separate step.

```text
R5-BSR2#show ip pim interface

Address          Interface                Ver/   Nbr    Query  DR         DR
                                          Mode   Count  Intvl  Prior
10.35.0.2        GigabitEthernet0/0       v2/S   1      30     1          10.35.0.2
5.5.5.5          Loopback0                v2/S   0      30     1          5.5.5.5
R5-BSR2#
```

[BSR overview](../bsr.md) · [BSR configuration](../configs/bsr.md) · [Evidence guide](README.md)
