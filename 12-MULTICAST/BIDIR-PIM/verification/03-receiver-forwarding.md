# BIDIR receiver — find the join on the wrong host

The tree followed the configured receiver interest, which was initially on the source-side host. Comparing IGMP membership with outgoing interfaces located the mistake.

CLI excerpts from the completed lab. Chat formatting is normalized; omitted legends are marked. The linked transcripts retain the supplied output, including incomplete captures and command errors.

## Block 11 — R3 has a tree but no local test-group receiver

R3 forwards the group toward R1 on Gi0/0. Its IGMP table has no `239.100.100.100` receiver and Gi0/3 is absent from the outgoing list.

```text
R3-BRANCH#show ip igmp groups
IGMP Connected Group Membership
Group Address    Interface                Uptime    Expires   Last Reporter   Group Accounted
224.0.1.40       GigabitEthernet0/0       00:22:07  00:02:39  10.13.0.2       
R3-BRANCH#show ip mroute 239.100.100.100
[Multicast flag legend omitted]

(*, 239.100.100.100), 00:00:33/00:02:56, RP 4.4.4.4, flags: B
  Bidir-Upstream: GigabitEthernet0/2, RPF nbr 10.34.0.2
  Outgoing interface list:
    GigabitEthernet0/0, Forward/Sparse, 00:00:33/00:02:56
    GigabitEthernet0/2, Bidir-Upstream/Sparse, 00:00:33/stopped

R3-BRANCH#
```

[Full captured text](block-11.txt)

## Block 12 — The join belongs to the source host

The interface description and `10.10.10.100` address identify the source-side host despite the first pasted prompt being `RC-HOST`. R1 records that host as the reporter on its source LAN.

```text
RC-HOST#show running-config interface GigabitEthernet0/0
Building configuration...

Current configuration : 196 bytes
!
interface GigabitEthernet0/0
 description SOURCE-LAN
 ip address 10.10.10.100 255.255.255.0
 no ip route-cache
 ip igmp join-group 239.100.100.100
 duplex auto
 speed auto
 media-type rj45
end

SRC-HOST#show ip igmp groups
IGMP Connected Group Membership
Group Address    Interface                Uptime    Expires   Last Reporter   Group Accounted
239.100.100.100  GigabitEthernet0/0       00:01:56  never     10.10.10.100    
SRC-HOST#
R1-DF-A#show ip mroute 239.100.100.100
[Multicast flag legend omitted]

(*, 239.100.100.100), 00:02:15/00:01:57, RP 4.4.4.4, flags: BC
  Bidir-Upstream: GigabitEthernet0/0, RPF nbr 10.13.0.2
  Outgoing interface list:
    GigabitEthernet0/1, Forward/Sparse, 00:02:15/00:01:57
    GigabitEthernet0/0, Bidir-Upstream/Sparse, 00:02:15/stopped

R1-DF-A#show ip igmp groups
IGMP Connected Group Membership
Group Address    Interface                Uptime    Expires   Last Reporter   Group Accounted
239.100.100.100  GigabitEthernet0/1       00:02:17  00:01:55  10.10.10.100    
224.0.1.40       GigabitEthernet0/1       00:24:00  00:02:56  10.10.10.2      
224.0.1.40       GigabitEthernet0/0       00:24:07  00:02:53  10.13.0.2       
R1-DF-A#
```

[Full captured text](block-12.txt)

## Block 13 — Confirm the intended receiver identity

RCV-HOST has `10.30.30.100` on Gi0/0. This check establishes which node should receive the join configuration.

```text
RCV-HOST>EN
RCV-HOST#show ip interface brief
Interface                  IP-Address      OK? Method Status                Protocol
GigabitEthernet0/0         10.30.30.100    YES manual up                    up      
GigabitEthernet0/1         unassigned      YES unset  administratively down down    
GigabitEthernet0/2         unassigned      YES unset  administratively down down    
GigabitEthernet0/3         unassigned      YES unset  administratively down down    
RCV-HOST#
```

[Full captured text](block-13.txt)

## Block 14 — Correct receiver membership and outgoing interface

R3 now lists reporter `10.30.30.100` on Gi0/3. The multicast entry has `BC`, and Gi0/3 appears as Forward/Sparse.

```text
R3-BRANCH#show ip igmp groups
IGMP Connected Group Membership
Group Address    Interface                Uptime    Expires   Last Reporter   Group Accounted
239.100.100.100  GigabitEthernet0/3       00:00:31  00:02:41  10.30.30.100    
224.0.1.40       GigabitEthernet0/0       00:26:21  00:02:27  10.13.0.2       
R3-BRANCH#show ip mroute 239.100.100.100
[Multicast flag legend omitted]

(*, 239.100.100.100), 00:04:47/00:02:39, RP 4.4.4.4, flags: BC
  Bidir-Upstream: GigabitEthernet0/2, RPF nbr 10.34.0.2
  Outgoing interface list:
    GigabitEthernet0/3, Forward/Sparse, 00:00:32/00:02:39
    GigabitEthernet0/2, Bidir-Upstream/Sparse, 00:04:47/stopped

R3-BRANCH#
```

[Full captured text](block-14.txt)

## Block 15 — Receiver replies with no group entry on the source-side routers

R1 and R2 return Group not found, while R3 retains the receiver tree and the source receives replies. The supplied 100-probe transcript stops at request 42: it contains 43 replies, not proof of 100/100 success. The ping is not a protocol-speed benchmark.

```text
R2-DF-B#show ip mroute 239.100.100.100
Group 239.100.100.100 not found
R2-DF-B#
R1-DF-A#show ip mroute 239.100.100.100
Group 239.100.100.100 not found
R1-DF-A#
R3-BRANCH#show ip mroute 239.100.100.100
[Multicast flag legend omitted]

(*, 239.100.100.100), 00:09:33/00:02:59, RP 4.4.4.4, flags: BC
  Bidir-Upstream: GigabitEthernet0/2, RPF nbr 10.34.0.2
  Outgoing interface list:
    GigabitEthernet0/3, Forward/Sparse, 00:05:18/00:02:59
    GigabitEthernet0/2, Bidir-Upstream/Sparse, 00:09:33/stopped

R3-BRANCH#
SRC-HOST#ping 239.100.100.100 source 10.10.10.100 repeat 100
Type escape sequence to abort.
Sending 100, 100-byte ICMP Echos to 239.100.100.100, timeout is 2 seconds:
Packet sent with a source address of 10.10.10.100 

Reply to request 0 from 10.30.30.100, 3 ms
Reply to request 1 from 10.30.30.100, 3 ms
Reply to request 2 from 10.30.30.100, 3 ms
Reply to request 3 from 10.30.30.100, 3 ms
Reply to request 4 from 10.30.30.100, 5 ms
Reply to request 5 from 10.30.30.100, 3 ms
Reply to request 6 from 10.30.30.100, 4 ms
Reply to request 7 from 10.30.30.100, 3 ms
Reply to request 8 from 10.30.30.100, 3 ms
Reply to request 9 from 10.30.30.100, 3 ms
Reply to request 10 from 10.30.30.100, 4 ms
Reply to request 11 from 10.30.30.100, 4 ms
Reply to request 12 from 10.30.30.100, 3 ms
Reply to request 13 from 10.30.30.100, 3 ms
Reply to request 14 from 10.30.30.100, 3 ms
Reply to request 15 from 10.30.30.100, 4 ms
Reply to request 16 from 10.30.30.100, 6 ms
Reply to request 17 from 10.30.30.100, 3 ms
Reply to request 18 from 10.30.30.100, 3 ms
Reply to request 19 from 10.30.30.100, 3 ms
Reply to request 20 from 10.30.30.100, 3 ms
Reply to request 21 from 10.30.30.100, 3 ms
Reply to request 22 from 10.30.30.100, 4 ms
Reply to request 23 from 10.30.30.100, 3 ms
Reply to request 24 from 10.30.30.100, 3 ms
Reply to request 25 from 10.30.30.100, 4 ms
Reply to request 26 from 10.30.30.100, 4 ms
Reply to request 27 from 10.30.30.100, 4 ms
Reply to request 28 from 10.30.30.100, 3 ms
Reply to request 29 from 10.30.30.100, 3 ms
Reply to request 30 from 10.30.30.100, 11 ms
Reply to request 31 from 10.30.30.100, 3 ms
Reply to request 32 from 10.30.30.100, 3 ms
Reply to request 33 from 10.30.30.100, 3 ms
Reply to request 34 from 10.30.30.100, 3 ms
Reply to request 35 from 10.30.30.100, 4 ms
Reply to request 36 from 10.30.30.100, 3 ms
Reply to request 37 from 10.30.30.100, 3 ms
Reply to request 38 from 10.30.30.100, 3 ms
Reply to request 39 from 10.30.30.100, 3 ms
Reply to request 40 from 10.30.30.100, 3 ms
Reply to request 41 from 10.30.30.100, 3 ms
Reply to request 42 from 10.30.30.100, 3 ms
```

[Full captured text](block-15.txt)

[Evidence index](README.md) · [Section overview](../README.md)
