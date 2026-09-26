# BIDIR roles — capability, mapping and DF election

These checkpoints separate PIM adjacency, BIDIR capability, and the election associated with an RPA mapping.

CLI excerpts from the completed lab. Chat formatting is normalized; omitted legends are marked. The linked transcripts retain the supplied output, including incomplete captures and command errors.

## Block 05 — PIM neighbors before BIDIR capability

The neighbor rows do not yet contain the `B` capability flag. R2 is already DR on the source LAN.

```text
R1-DF-A#show ip pim neighbor
PIM Neighbor Table
Mode: B - Bidir Capable, DR - Designated Router, N - Default DR Priority,
      P - Proxy Capable, S - State Refresh Capable, G - GenID Capable,
      L - DR Load-balancing Capable
Neighbor          Interface                Uptime/Expires    Ver   DR
Address                                                            Prio/Mode
10.13.0.2         GigabitEthernet0/0       00:00:33/00:01:41 v2    1 / DR S P G
10.10.10.2        GigabitEthernet0/1       00:00:40/00:01:34 v2    1 / DR S P G
R1-DF-A#
R2-DF-B#show ip pim neighbor
PIM Neighbor Table
Mode: B - Bidir Capable, DR - Designated Router, N - Default DR Priority,
      P - Proxy Capable, S - State Refresh Capable, G - GenID Capable,
      L - DR Load-balancing Capable
Neighbor          Interface                Uptime/Expires    Ver   DR
Address                                                            Prio/Mode
10.10.10.1        GigabitEthernet0/0       00:00:53/00:01:19 v2    1 / S P G
10.23.0.2         GigabitEthernet0/1       00:00:47/00:01:28 v2    1 / DR S P G
R2-DF-B#
R3-BRANCH#show ip pim neighbor
PIM Neighbor Table
Mode: B - Bidir Capable, DR - Designated Router, N - Default DR Priority,
      P - Proxy Capable, S - State Refresh Capable, G - GenID Capable,
      L - DR Load-balancing Capable
Neighbor          Interface                Uptime/Expires    Ver   DR
Address                                                            Prio/Mode
10.13.0.1         GigabitEthernet0/0       00:01:02/00:01:40 v2    1 / S P G
10.23.0.1         GigabitEthernet0/1       00:01:02/00:01:40 v2    1 / S P G
10.34.0.2         GigabitEthernet0/2       00:00:50/00:01:24 v2    1 / DR S P G
R3-BRANCH#
R4-RPA#show ip pim neighbor
PIM Neighbor Table
Mode: B - Bidir Capable, DR - Designated Router, N - Default DR Priority,
      P - Proxy Capable, S - State Refresh Capable, G - GenID Capable,
      L - DR Load-balancing Capable
Neighbor          Interface                Uptime/Expires    Ver   DR
Address                                                            Prio/Mode
10.34.0.1         GigabitEthernet0/0       00:01:08/00:01:34 v2    1 / S P G
R4-RPA#
```

[Full captured text](block-05.txt)

## Block 06 — Neighbors advertise BIDIR capability

The neighbor rows now contain `B`. R2 remains DR, while R1 is not DR on the shared source LAN.

```text
R1-DF-A#sh ip pim neighbor 
PIM Neighbor Table
Mode: B - Bidir Capable, DR - Designated Router, N - Default DR Priority,
      P - Proxy Capable, S - State Refresh Capable, G - GenID Capable,
      L - DR Load-balancing Capable
Neighbor          Interface                Uptime/Expires    Ver   DR
Address                                                            Prio/Mode
10.13.0.2         GigabitEthernet0/0       00:04:30/00:01:40 v2    1 / DR B S P G
10.10.10.2        GigabitEthernet0/1       00:04:38/00:01:33 v2    1 / DR B S P G
R1-DF-A#
R2-DF-B#sh ip pim neighbor 
PIM Neighbor Table
Mode: B - Bidir Capable, DR - Designated Router, N - Default DR Priority,
      P - Proxy Capable, S - State Refresh Capable, G - GenID Capable,
      L - DR Load-balancing Capable
Neighbor          Interface                Uptime/Expires    Ver   DR
Address                                                            Prio/Mode
10.10.10.1        GigabitEthernet0/0       00:04:59/00:01:39 v2    1 / B S P G
10.23.0.2         GigabitEthernet0/1       00:04:52/00:01:18 v2    1 / DR B S P G
R2-DF-B#
```

[Full captured text](block-06.txt)

## Block 07 — Capability alone leaves the mapping and DF tables empty

Both displayed tables are empty before the BIDIR RP mapping is introduced.

```text
R1-DF-A#show ip pim rp mapping
PIM Group-to-RP Mappings

R1-DF-A#show ip pim interface GigabitEthernet0/1 df

implies this system is the DF
Interface                RP               DF Winner        Metric     Uptime
R1-DF-A#
```

[Full captured text](block-07.txt)

## Block 08 — R1 is DF while R2 remains DR

Both devices report `Static, Bidir Mode`. R1 marks itself as DF (`*10.10.10.1`, metric 12); R2 agrees on the same winner. Compare with Block 06 for the separate DR result.

```text
R1-DF-A#
*Sep 25 23:36:22.252: %SYS-5-CONFIG_I: Configured from console by consoleshow ip pim rp mapping
PIM Group-to-RP Mappings

Acl: 45, Static, Bidir Mode
RP: 4.4.4.4 (?)
R1-DF-A#show ip pim interface GigabitEthernet0/1 df

implies this system is the DF
Interface                RP               DF Winner        Metric     Uptime
GigabitEthernet0/1       4.4.4.4          *10.10.10.1       12         00:01:14
R1-DF-A#

R2-DF-B#show ip pim rp mapping
PIM Group-to-RP Mappings

Acl: 45, Static, Bidir Mode
RP: 4.4.4.4 (?)
R2-DF-B#show ip pim interface GigabitEthernet0/0 df

implies this system is the DF
Interface                RP               DF Winner        Metric     Uptime
GigabitEthernet0/0       4.4.4.4           10.10.10.1       12         00:01:03
R2-DF-B#
```

[Full captured text](block-08.txt)

## Block 09 — A pre-receiver display needs context

The supplied pre-receiver output contains a Bidir entry and accepting interfaces, while the IGMP table contains no test-group receiver. The pasted wildcard appears as `(,G)` and is preserved. An entry alone is insufficient proof of a local receiver.

```text
R3-BRANCH#show ip pim interface gigabitEthernet 0/0 df

implies this system is the DF
Interface                RP               DF Winner        Metric     Uptime
GigabitEthernet0/0       4.4.4.4          10.13.0.2        2          00:08:05
R3-BRANCH#sh ip mroute 239.100.100.100
(,239.100.100.100), 00:08:14/-, RP 4.4.4.4, flags: B
Bidir-Upstream: GigabitEthernet0/2, RPF nbr: 10.34.0.2
Incoming interface list:
GigabitEthernet0/3, Accepting/Sparse
GigabitEthernet0/1, Accepting/Sparse
GigabitEthernet0/0, Accepting/Sparse
GigabitEthernet0/2, Accepting/Sparse

R3-BRANCH#show ip igmp groups
IGMP Connected Group Membership
Group Address    Interface                Uptime    Expires   Last Reporter   Group Accounted
224.0.1.40       GigabitEthernet0/0       00:17:45  00:02:02  10.13.0.1
R3-BRANCH#
```

[Full captured text](block-09.txt)

## Block 10 — Clean group lookup after widening the mapping range

The lab changed ACL 45 from one host group to `239.100.100.0/24`. R3 then reports both queried group addresses absent while its receiver-LAN DF remains elected. This IOSv result differs from the predicted mapping-entry display.

```text
R3-BRANCH#show ip pim rp mapping
PIM Group-to-RP Mappings

Acl: 45, Static, Bidir Mode
RP: 4.4.4.4 (?)
R3-BRANCH#show ip mroute 239.100.100.0
Group 239.100.100.0 not found
R3-BRANCH#show ip mroute 239.100.100.100
Group 239.100.100.100 not found
R3-BRANCH#show ip pim interface GigabitEthernet0/3 df

implies this system is the DF
Interface                RP               DF Winner        Metric     Uptime
GigabitEthernet0/3       4.4.4.4          *10.30.30.1       2          00:10:47
R3-BRANCH#
```

[Full captured text](block-10.txt)

[Evidence index](README.md) · [Section overview](../README.md)
