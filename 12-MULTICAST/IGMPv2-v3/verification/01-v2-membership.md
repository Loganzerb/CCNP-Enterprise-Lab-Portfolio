# IGMPv2 — membership, expiry and return

Follow one receiver through three states: present, expired, and present again. The group is `239.1.1.1`; the receiver is `10.4.4.10` on R4 Gi0/0.

CLI excerpts from the completed lab. Chat formatting is normalized; omitted legends are marked. The linked transcripts retain the supplied output, including incomplete captures and command errors.

## Block 01 — Version, querier and receiver baseline

R4 is both the IGMP querier and PIM DR on this LAN. These are separate roles. The 60-second query interval and 120-second querier timeout are captured lab settings, not a claim about universal defaults.

```text
R4-LHR#show ip igmp interface GigabitEthernet0/0
GigabitEthernet0/0 is up, line protocol is up
  Internet address is 10.4.4.1/24
  IGMP is enabled on interface
  Current IGMP host version is 2
  Current IGMP router version is 2
  IGMP query interval is 60 seconds
  IGMP configured query interval is 60 seconds
  IGMP querier timeout is 120 seconds
  IGMP configured querier timeout is 120 seconds
  IGMP max query response time is 10 seconds
  Last member query count is 2
  Last member query response interval is 1000 ms
  Inbound IGMP access group is not set
  IGMP activity: 2 joins, 0 leaves
  Multicast routing is enabled on interface
  Multicast TTL threshold is 0
  Multicast designated router (DR) is 10.4.4.1 (this system)
  IGMP querying router is 10.4.4.1 (this system)
  Multicast groups joined by this system (number of users):
      224.0.1.40(1)
R4-LHR#show ip igmp groups
IGMP Connected Group Membership
Group Address    Interface                Uptime    Expires   Last Reporter   Group Accounted
239.1.1.1        GigabitEthernet0/0       01:02:06  00:02:38  10.4.4.10       
224.0.1.40       GigabitEthernet0/0       01:02:27  00:02:41  10.4.4.1        
R4-LHR#
```

[Full captured text](block-01.txt)

## Block 02 — Membership expires without a captured Leave

The group timer falls from 1:10 to 0:08. At 21:21:16.510, the debug removes Gi0/0 from the multicast routing state. No IGMPv2 Leave or resulting group-specific-query exchange is present in this capture.

```text
R4-LHR#debug ip igmp
IGMP debugging is on
R4-LHR#
*Sep 25 21:19:00.424: IGMP(0): Received v2 Query on GigabitEthernet0/2 from 10.34.0.1
*Sep 25 21:19:15.051: IGMP(0): Send v2 general Query on GigabitEthernet0/0
*Sep 25 21:19:15.051: IGMP(0): Set report delay time to 1.7 seconds for 224.0.1.40 on GigabitEthernet0/0
*Sep 25 21:19:16.810: IGMP(0): Send v2 Report for 224.0.1.40 on GigabitEthernet0/0
*Sep 25 21:19:16.810: IGMP(0): Received v2 Report on GigabitEthernet0/0 from 10.4.4.1 for 224.0.1.40
*Sep 25 21:19:16.810: IGMP(0): Received Group record for group 224.0.1.40, mode 2 from 10.4.4.1 for 0 sources
*Sep 25 21:19:16.810: IGMP(0): Updating EXCLUDE group timer for 224.0.1.40
Sep 25 21:19:16.810: IGMP(0): MRT Add/Update GigabitEthernet0/0 for (,224.0.1.40) by 0
*Sep 25 21:19:28.671: IGMP(0): Received v2 Query on GigabitEthernet0/1 from 10.24.0.1
R4-LHR#
R4-LHR#
*Sep 25 21:20:00.442: IGMP(0): Received v2 Query on GigabitEthernet0/2 from 10.34.0.1undebug all
All possible debugging has been turned off
R4-LHR#show ip igmp groups
IGMP Connected Group Membership
Group Address    Interface                Uptime    Expires   Last Reporter   Group Accounted
239.1.1.1        GigabitEthernet0/0       01:06:30  00:01:10  10.4.4.10
224.0.1.40       GigabitEthernet0/0       01:06:50  00:02:11  10.4.4.1
R4-LHR#debug igmp
^
% Invalid input detected at '^' marker.
R4-LHR#debug ip igmp
IGMP debugging is on
R4-LHR#
*Sep 25 21:20:18.810: IGMP(0): Send v2 Report for 224.0.1.40 on GigabitEthernet0/0
*Sep 25 21:20:18.810: IGMP(0): Received v2 Report on GigabitEthernet0/0 from 10.4.4.1 for 224.0.1.40
*Sep 25 21:20:18.810: IGMP(0): Received Group record for group 224.0.1.40, mode 2 from 10.4.4.1 for 0 sources
*Sep 25 21:20:18.810: IGMP(0): Updating EXCLUDE group timer for 224.0.1.40
Sep 25 21:20:18.811: IGMP(0): MRT Add/Update GigabitEthernet0/0 for (,224.0.1.40) by 0
*Sep 25 21:20:28.671: IGMP(0): Received v2 Query on GigabitEthernet0/1 from 10.24.0.1
R4-LHR#
R4-LHR#
R4-LHR#
*Sep 25 21:21:00.434: IGMP(0): Received v2 Query on GigabitEthernet0/2 from 10.34.0.1
R4-LHR#
R4-LHR#
R4-LHR#show ip igmp groups
IGMP Connected Group Membership
Group Address    Interface                Uptime    Expires   Last Reporter   Group Accounted
239.1.1.1        GigabitEthernet0/0       01:07:32  00:00:08  10.4.4.10
224.0.1.40       GigabitEthernet0/0       01:07:53  00:02:10  10.4.4.1
R4-LHR#show ip mroute 239.1.1.1
[Multicast flag legend omitted]
(*, 239.1.1.1), 01:07:33/00:00:07, RP 2.2.2.2, flags: SJC
Incoming interface: GigabitEthernet0/1, RPF nbr 10.24.0.1
Outgoing interface list:
GigabitEthernet0/0, Forward/Sparse, 01:07:33/00:00:07
R4-LHR#
*Sep 25 21:21:15.051: IGMP(0): Send v2 general Query on GigabitEthernet0/0
*Sep 25 21:21:15.051: IGMP(0): Set report delay time to 3.9 seconds for 224.0.1.40 on GigabitEthernet0/0
*Sep 25 21:21:16.510: IGMP(0): Switching to INCLUDE mode for 239.1.1.1 on GigabitEthernet0/0
Sep 25 21:21:16.510: IGMP(0): MRT delete GigabitEthernet0/0 for (,239.1.1.1) by 0
*Sep 25 21:21:19.010: IGMP(0): Send v2 Report for 224.0.1.40 on GigabitEthernet0/0
*Sep 25 21:21:19.010: IGMP(0): Received v2 Report on GigabitEthernet0/0 from 10.4.4.1 for 224.0.1.40
*Sep 25 21:21:19.010: IGMP(0): Received Group record for group 224.0.1.40, mode 2 from 10.4.4.1 for 0 sources
*Sep 25 21:21:19.010: IGMP(0): Updating EXCLUDE group timer for 224.0.1.40
Sep 25 21:21:19.011: IGMP(0): MRT Add/Update GigabitEthernet0/0 for (,224.0.1.40) by 0
*Sep 25 21:21:28.669: IGMP(0): Received v2 Query on GigabitEthernet0/1 from 10.24.0.1
```

[Full captured text](block-02.txt)

## Block 03 — Receiver reports restore the outgoing branch

The report at 21:23:48.034 precedes R4's next general query at 21:24:15.052. The receiver membership and Gi0/0 forwarding branch return. Reports for `224.0.1.40` belong to a different group.

```text
R4-LHR#
*Sep 25 21:23:21.010: IGMP(0): Send v2 Report for 224.0.1.40 on GigabitEthernet0/0
*Sep 25 21:23:21.010: IGMP(0): Received v2 Report on GigabitEthernet0/0 from 10.4.4.1 for 224.0.1.40
*Sep 25 21:23:21.010: IGMP(0): Received Group record for group 224.0.1.40, mode 2 from 10.4.4.1 for 0 sources
*Sep 25 21:23:21.010: IGMP(0): Updating EXCLUDE group timer for 224.0.1.40
Sep 25 21:23:21.011: IGMP(0): MRT Add/Update GigabitEthernet0/0 for (,224.0.1.40) by 0
*Sep 25 21:23:28.658: IGMP(0): Received v2 Query on GigabitEthernet0/1 from 10.24.0.1
*Sep 25 21:23:48.034: IGMP(0): Received v2 Report on GigabitEthernet0/0 from 10.4.4.10 for 239.1.1.1
*Sep 25 21:23:48.035: IGMP(0): Received Group record for group 239.1.1.1, mode 2 from 10.4.4.10 for 0 sources
*Sep 25 21:23:48.035: IGMP(0): WAVL Insert group: 239.1.1.1 interface: GigabitEthernet0/0Successful
*Sep 25 21:23:48.035: IGMP(0): Switching to EXCLUDE mode for 239.1.1.1 on GigabitEthernet0/0
*Sep 25 21:23:48.035: IGMP(0): Updating EXCLUDE group timer for 239.1.1.1
Sep 25 21:23:48.035: IGMP(0): MRT Add/Update GigabitEthernet0/0 for (,239.1.1.1) by 0
*Sep 25 21:24:00.470: IGMP(0): Received v2 Query on GigabitEthernet0/2 from 10.34.0.1
*Sep 25 21:24:15.052: IGMP(0): Send v2 general Query on GigabitEthernet0/0
*Sep 25 21:24:15.052: IGMP(0): Set report delay time to 8.1 seconds for 224.0.1.40 on GigabitEthernet0/0
*Sep 25 21:24:23.210: IGMP(0): Send v2 Report for 224.0.1.40 on GigabitEthernet0/0
*Sep 25 21:24:23.210: IGMP(0): Received v2 Report on GigabitEthernet0/0 from 10.4.4.1 for 224.0.1.40
*Sep 25 21:24:23.210: IGMP(0): Received Group record for group 224.0.1.40, mode 2 from 10.4.4.1 for 0 sources
*Sep 25 21:24:23.211: IGMP(0): Updating EXCLUDE group timer for 224.0.1.40
Sep 25 21:24:23.211: IGMP(0): MRT Add/Update GigabitEthernet0/0 for (,224.0.1.40) by 0
*Sep 25 21:24:24.380: IGMP(0): Received v2 Report on GigabitEthernet0/0 from 10.4.4.10 for 239.1.1.1
*Sep 25 21:24:24.380: IGMP(0): Received Group record for group 239.1.1.1, mode 2 from 10.4.4.10 for 0 sources
*Sep 25 21:24:24.380: IGMP(0): Updating EXCLUDE group timer for 239.1.1.1
Sep 25 21:24:24.380: IGMP(0): MRT Add/Update GigabitEthernet0/0 for (,239.1.1.1) by 0
*Sep 25 21:24:28.654: IGMP(0): Received v2 Query on GigabitEthernet0/1 from 10.24.0.1
*Sep 25 21:25:00.451: IGMP(0): Received v2 Query on GigabitEthernet0/2 from 10.34.0.1
*Sep 25 21:25:15.052: IGMP(0): Send v2 general Query on GigabitEthernet0/0
*Sep 25 21:25:15.052: IGMP(0): Set report delay time to 7.8 seconds for 224.0.1.40 on GigabitEthernet0/0
*Sep 25 21:25:21.867: IGMP(0): Received v2 Report on GigabitEthernet0/0 from 10.4.4.10 for 239.1.1.1
*Sep 25 21:25:21.868: IGMP(0): Received Group record for group 239.1.1.1, mode 2 from 10.4.4.10 for 0 sources
*Sep 25 21:25:21.868: IGMP(0): Updating EXCLUDE group timer for 239.1.1.1
Sep 25 21:25:21.868: IGMP(0): MRT Add/Update GigabitEthernet0/0 for (,239.1.1.1) by 0
*Sep 25 21:25:22.910: IGMP(0): Send v2 Report for 224.0.1.40 on GigabitEthernet0/0
*Sep 25 21:25:22.910: IGMP(0): Received v2 Report on GigabitEthernet0/0 from 10.4.4.1 for 224.0.1.40
*Sep 25 21:25:22.910: IGMP(0): Received Group record for group 224.0.1.40, mode 2 from 10.4.4.1 for 0 sources
*Sep 25 21:25:22.911: IGMP(0): Updating EXCLUDE group timer for 224.0.1.40
Sep 25 21:25:22.911: IGMP(0): MRT Add/Update GigabitEthernet0/0 for (,224.0.1.40) by 0
*Sep 25 21:25:28.639: IGMP(0): Received v2 Query on GigabitEthernet0/1 from 10.24.0.1
R4-LHR#
R4-LHR#undebug all
All possible debugging has been turned off
R4-LHR#show ip igmp groups
IGMP Connected Group Membership
Group Address    Interface                Uptime    Expires   Last Reporter   Group Accounted
239.1.1.1        GigabitEthernet0/0       00:02:07  00:02:26  10.4.4.10
224.0.1.40       GigabitEthernet0/0       01:12:40  00:02:27  10.4.4.1
R4-LHR#sh ip mroute 239.1.1.1
[Multicast flag legend omitted]
(*, 239.1.1.1), 01:12:25/00:02:20, RP 2.2.2.2, flags: SJC
Incoming interface: GigabitEthernet0/1, RPF nbr 10.24.0.1
Outgoing interface list:
GigabitEthernet0/0, Forward/Sparse, 00:02:12/00:02:20
R4-LHR#
```

[Full captured text](block-03.txt)

[Evidence index](README.md) · [Section overview](../README.md)
