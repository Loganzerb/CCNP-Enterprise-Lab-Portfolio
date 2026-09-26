# BIDIR DF transition — routing cost changes the forwarder

A controlled OSPF cost change on R1 moves the source-LAN DF role to R2. The subsequent traffic test validates delivery after the change.

CLI excerpts from the completed lab. Chat formatting is normalized; omitted legends are marked. The linked transcripts retain the supplied output, including incomplete captures and command errors.

## Block 16 — Both routers agree that R2 is now DF

R1's RPA route changes to metric 52; R2 remains at 32. Both DF tables select `10.10.10.2`. Markdown bullet and spacing artifacts from the original paste remain in the full text.

```text
R1-DF-A#show ip route 4.4.4.4
Routing entry for 4.4.4.4/32
Known via "ospf 1", distance 110, metric 52, type intra area
Last update from 10.13.0.2 on GigabitEthernet0/0, 00:00:54 ago
Routing Descriptor Blocks:

- 10.13.0.2, from 4.4.4.4, 00:00:54 ago, via GigabitEthernet0/0
  Route metric is 52, traffic share count is 1
  R1-DF-A#show ip pim interface GigabitEthernet0/1 df
- implies this system is the DF
  Interface                RP               DF Winner        Metric     Uptime
  GigabitEthernet0/1       4.4.4.4           10.10.10.2       32         00:00:54
  R1-DF-A#
- R2-DF-B#show ip route 4.4.4.4
  Routing entry for 4.4.4.4/32
    Known via "ospf 1", distance 110, metric 32, type intra area
    Last update from 10.23.0.2 on GigabitEthernet0/1, 00:03:35 ago
    Routing Descriptor Blocks:
    * 10.23.0.2, from 4.4.4.4, 00:03:35 ago, via GigabitEthernet0/1
        Route metric is 32, traffic share count is 1
  R2-DF-B#show ip pim interface GigabitEthernet0/0 df
  * implies this system is the DF
  Interface                RP               DF Winner        Metric     Uptime
  GigabitEthernet0/0       4.4.4.4          *10.10.10.2       32         00:01:32
  R2-DF-B#
```

[Full captured text](block-16.txt)

## Block 17 — Receiver state and PIM DR after the change

R2 marks itself as DF. R3 still has `(*,239.100.100.100)` with Gi0/3 toward the receiver; R1 still sees R2 as PIM DR.

```text
R2-DF-B#show ip pim interface GigabitEthernet0/0 df
* implies this system is the DF
Interface                RP               DF Winner        Metric     Uptime
GigabitEthernet0/0       4.4.4.4          *10.10.10.2       32         00:07:30
R2-DF-B#
R3-BRANCH#show ip mroute 239.100.100.100
[Multicast flag legend omitted]

(*, 239.100.100.100), 00:10:40/00:02:46, RP 4.4.4.4, flags: BC
  Bidir-Upstream: GigabitEthernet0/2, RPF nbr 10.34.0.2
  Outgoing interface list:
    GigabitEthernet0/3, Forward/Sparse, 00:09:58/00:02:46
    GigabitEthernet0/2, Bidir-Upstream/Sparse, 00:09:58/stopped

R3-BRANCH#
R1-DF-A#show ip pim neighbor
PIM Neighbor Table
Mode: B - Bidir Capable, DR - Designated Router, N - Default DR Priority,
      P - Proxy Capable, S - State Refresh Capable, G - GenID Capable,
      L - DR Load-balancing Capable
Neighbor          Interface                Uptime/Expires    Ver   DR
Address                                                            Prio/Mode
10.13.0.2         GigabitEthernet0/0       00:11:34/00:01:27 v2    1 / DR B S P G
10.10.10.2        GigabitEthernet0/1       00:11:29/00:01:35 v2    1 / DR B S P G
R1-DF-A#
```

[Full captured text](block-17.txt)

## Block 18 — Delivery through the changed topology

The complete test shows one timeout followed by replies 1–29 from `10.30.30.100`: 29/30 responses. It was run after the DF transition, so it does not measure loss during the transition or prove uninterrupted forwarding.

```text
SRC-HOST#ping 239.100.100.100 source 10.10.10.100 repeat 30
Type escape sequence to abort.
Sending 30, 100-byte ICMP Echos to 239.100.100.100, timeout is 2 seconds:
Packet sent with a source address of 10.10.10.100 
.
Reply to request 1 from 10.30.30.100, 7 ms
Reply to request 2 from 10.30.30.100, 4 ms
Reply to request 3 from 10.30.30.100, 3 ms
Reply to request 4 from 10.30.30.100, 3 ms
Reply to request 5 from 10.30.30.100, 3 ms
Reply to request 6 from 10.30.30.100, 3 ms
Reply to request 7 from 10.30.30.100, 3 ms
Reply to request 8 from 10.30.30.100, 3 ms
Reply to request 9 from 10.30.30.100, 3 ms
Reply to request 10 from 10.30.30.100, 3 ms
Reply to request 11 from 10.30.30.100, 3 ms
Reply to request 12 from 10.30.30.100, 3 ms
Reply to request 13 from 10.30.30.100, 3 ms
Reply to request 14 from 10.30.30.100, 5 ms
Reply to request 15 from 10.30.30.100, 2 ms
Reply to request 16 from 10.30.30.100, 3 ms
Reply to request 17 from 10.30.30.100, 3 ms
Reply to request 18 from 10.30.30.100, 3 ms
Reply to request 19 from 10.30.30.100, 2 ms
Reply to request 20 from 10.30.30.100, 3 ms
Reply to request 21 from 10.30.30.100, 3 ms
Reply to request 22 from 10.30.30.100, 3 ms
Reply to request 23 from 10.30.30.100, 3 ms
Reply to request 24 from 10.30.30.100, 3 ms
Reply to request 25 from 10.30.30.100, 3 ms
Reply to request 26 from 10.30.30.100, 3 ms
Reply to request 27 from 10.30.30.100, 3 ms
Reply to request 28 from 10.30.30.100, 3 ms
Reply to request 29 from 10.30.30.100, 3 ms
SRC-HOST#
```

[Full captured text](block-18.txt)

[Evidence index](README.md) · [Section overview](../README.md)
