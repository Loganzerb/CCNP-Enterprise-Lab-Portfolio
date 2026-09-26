# IGMPv3 — from group membership to a source-specific tree

The same receiver LAN is upgraded to IGMPv3. The ASM group remains present while `232.1.1.1` gains source-specific state for `10.1.1.10`.

CLI excerpts from the completed lab. Chat formatting is normalized; omitted legends are marked. The linked transcripts retain the supplied output, including incomplete captures and command errors.

## Block 04 — Version 3 with the existing membership retained

Both interface version fields now show 3. The older ASM group is still listed; a version change alone does not make that group source-specific.

```text
R4-LHR#show ip igmp interface g0/0
GigabitEthernet0/0 is up, line protocol is up
  Internet address is 10.4.4.1/24
  IGMP is enabled on interface
  Current IGMP host version is 3
  Current IGMP router version is 3
  IGMP query interval is 60 seconds
  IGMP configured query interval is 60 seconds
  IGMP querier timeout is 120 seconds
  IGMP configured querier timeout is 120 seconds
  IGMP max query response time is 10 seconds
  Last member query count is 2
  Last member query response interval is 1000 ms
  Inbound IGMP access group is not set
  IGMP activity: 3 joins, 1 leaves
  Multicast routing is enabled on interface
  Multicast TTL threshold is 0
  Multicast designated router (DR) is 10.4.4.1 (this system)
  IGMP querying router is 10.4.4.1 (this system)
  Multicast groups joined by this system (number of users):
      224.0.1.40(1)
R4-LHR#sh ip igmp grou
R4-LHR#sh ip igmp groups 
IGMP Connected Group Membership
Group Address    Interface                Uptime    Expires   Last Reporter   Group Accounted
239.1.1.1        GigabitEthernet0/0       00:14:43  00:02:49  10.4.4.10       
224.0.1.40       GigabitEthernet0/0       01:25:16  00:02:48  10.4.4.1        
R4-LHR#
```

[Full captured text](block-04.txt)

## Block 05 — An unavailable verification command

This IOSv CLI rejects `show ip pim ssm`. The parser result alone does not establish whether SSM is configured.

```text
R4-LHR#show ip pim ssm
                   ^
% Invalid input detected at '^' marker.

R4-LHR#
```

[Full captured text](block-05.txt)

## Block 06 — Verify SSM in the running configuration

The accepted check returns `ip pim ssm default`, confirming the configured default SSM range on R4.

```text
R4-LHR#sh running-config | include ip pim ssm
ip pim ssm default
R4-LHR#
```

[Full captured text](block-06.txt)

## Block 07 — Correlate the membership view with the multicast route

`239.1.1.1` has EXCLUDE mode with an empty list. `232.1.1.1` has INCLUDE/SSM state, but its displayed source-list rows are empty. The separate mroute output identifies `(10.1.1.10,232.1.1.1)` with `sTI`, Gi0/2 toward the source, and Gi0/0 toward the receiver. This is control-plane evidence; no SSM receiver-ping transcript was retained.

```text
R4-LHR#show ip igmp groups detail

Flags: L - Local, U - User, SG - Static Group, VG - Virtual Group,
       SS - Static Source, VS - Virtual Source,
       Ac - Group accounted towards access control limit

Interface:      GigabitEthernet0/0
Group:          239.1.1.1
Flags:
Uptime:         00:38:20
Group mode:     EXCLUDE (Expires: 00:02:35)
Last reporter:  10.4.4.10
Source list is empty

Interface:      GigabitEthernet0/0
Group:          232.1.1.1
Flags:          SSM 
Uptime:         00:00:09
Group mode:     INCLUDE
Last reporter:  10.4.4.10
Group source list: (C - Cisco Src Report, U - URD, R - Remote, S - Static,
                    V - Virtual, M - SSM Mapping, L - Local,
                    Ac - Channel accounted towards access control limit)
  Source Address   Uptime    v3 Exp   CSR Exp   Fwd  Flags
          
R4-LHR#how ip mroute 232.1.1.1
        ^
% Invalid input detected at '^' marker.

R4-LHR#show ip mroute 232.1.1.1  
[Multicast flag legend omitted]

(10.1.1.10, 232.1.1.1), 00:00:16/00:02:44, flags: sTI
  Incoming interface: GigabitEthernet0/2, RPF nbr 10.34.0.1
  Outgoing interface list:
    GigabitEthernet0/0, Forward/Sparse, 00:00:16/00:02:44

R4-LHR#
```

[Full captured text](block-07.txt)

[Evidence index](README.md) · [Section overview](../README.md)
