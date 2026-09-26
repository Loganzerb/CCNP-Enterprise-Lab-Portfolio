# BIDIR foundation — repair addressing before multicast

The initial failure occurred in the unicast foundation. Physical links were up, but the addresses on R1 did not match the actual connections.

CLI excerpts from the completed lab. Chat formatting is normalized; omitted legends are marked. The linked transcripts retain the supplied output, including incomplete captures and command errors.

## Block 01 — R1 cannot reach the future RPA

R3 lists R2 and R4 as OSPF neighbors but not R1. R1 has no route to `4.4.4.4` and receives 0/5 replies; R2 reaches it successfully.

```text
R3-BRANCH#show ip ospf neighbor

Neighbor ID     Pri   State           Dead Time   Address         Interface

4.4.4.4           1   FULL/DR         00:00:35    10.34.0.2       GigabitEthernet0/2

2.2.2.2           1   FULL/BDR        00:00:32    10.23.0.1       GigabitEthernet0/1

R3-BRANCH#

R1-DF-A#show ip route 4.4.4.4

% Network not in table

R1-DF-A#ping 4.4.4.4 source 1.1.1.1

Type escape sequence to abort.

Sending 5, 100-byte ICMP Echos to 4.4.4.4, timeout is 2 seconds:

Packet sent with a source address of 1.1.1.1 

.....

Success rate is 0 percent (0/5)

R1-DF-A#

R2-DF-B#show ip route 4.4.4.4
Routing entry for 4.4.4.4/32
Known via "ospf 1", distance 110, metric 32, type intra area
Last update from 10.23.0.2 on GigabitEthernet0/1, 00:03:01 ago
Routing Descriptor Blocks:

10.23.0.2, from 4.4.4.4, 00:03:01 ago, via GigabitEthernet0/1
Route metric is 32, traffic share count is 1
R2-DF-B#ping 4.4.4.4 source 2.2.2.2
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 4.4.4.4, timeout is 2 seconds:
Packet sent with a source address of 2.2.2.2
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 2/2/3 ms
R2-DF-B#

SRC-HOST#ping 10.30.30.100

Type escape sequence to abort.

Sending 5, 100-byte ICMP Echos to 10.30.30.100, timeout is 2 seconds:

.....

Success rate is 0 percent (0/5)

SRC-HOST#
```

[Full captured text](block-01.txt)

## Block 02 — Up interfaces with the wrong subnets

R1 has its source-LAN and transit addresses on the opposite interfaces from the cabling. R3's transit interface is `10.13.0.2` on Gi0/0.

```text
R1-DF-A#show ip interface brief
Interface                  IP-Address      OK? Method Status                Protocol
GigabitEthernet0/0         10.10.10.1      YES manual up                    up      
GigabitEthernet0/1         10.13.0.1       YES manual up                    up      
GigabitEthernet0/2         unassigned      YES unset  administratively down down    
GigabitEthernet0/3         unassigned      YES unset  administratively down down    
Loopback0                  1.1.1.1         YES manual up                    up      
R1-DF-A#
R3-BRANCH#show ip interface brief
Interface                  IP-Address      OK? Method Status                Protocol
GigabitEthernet0/0         10.13.0.2       YES manual up                    up      
GigabitEthernet0/1         10.23.0.2       YES manual up                    up      
GigabitEthernet0/2         10.34.0.1       YES manual up                    up      
GigabitEthernet0/3         10.30.30.1      YES manual up                    up      
Loopback0                  3.3.3.3         YES manual up                    up      
R3-BRANCH#
```

[Full captured text](block-02.txt)

## Block 03 — Corrected addressing restores OSPF and the RPA route

R1 now has transit address `10.13.0.1` on Gi0/0 and source-LAN address `10.10.10.1` on Gi0/1. R3 is FULL and the RPA route has metric 12.

```text
R1-DF-A#show ip interface brief
Interface                  IP-Address      OK? Method Status                Protocol
GigabitEthernet0/0         10.13.0.1       YES manual up                    up
GigabitEthernet0/1         10.10.10.1      YES manual up                    up
GigabitEthernet0/2         unassigned      YES unset  administratively down down
GigabitEthernet0/3         unassigned      YES unset  administratively down down
Loopback0                  1.1.1.1         YES manual up                    up
R1-DF-A#show ip ospf neighbor

Neighbor ID     Pri   State           Dead Time   Address         Interface
3.3.3.3           1   FULL/DR         00:00:37    10.13.0.2       GigabitEthernet0/0
R1-DF-A#show ip route 4.4.4.4
Routing entry for 4.4.4.4/32
Known via "ospf 1", distance 110, metric 12, type intra area
Last update from 10.13.0.2 on GigabitEthernet0/0, 00:00:08 ago
Routing Descriptor Blocks:

10.13.0.2, from 4.4.4.4, 00:00:08 ago, via GigabitEthernet0/0
Route metric is 12, traffic share count is 1
R1-DF-A#
```

[Full captured text](block-03.txt)

## Block 04 — Unicast reachability after repair

R1 receives 5/5 replies from `4.4.4.4`; the source receives 4/5 from `10.30.30.100`. The first missed endpoint probe has no captured cause. An isolated earlier 0/5 summary remains in the supplied text and is not assigned to a new test.

```text
R1-DF-A#ping 4.4.4.4 source 1.1.1.1
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 4.4.4.4, timeout is 2 seconds:
Packet sent with a source address of 1.1.1.1 
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 2/2/3 ms
R1-DF-A#
Success rate is 0 percent (0/5)
SRC-HOST#ping 10.30.30.100
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 10.30.30.100, timeout is 2 seconds:
.!!!!
Success rate is 80 percent (4/5), round-trip min/avg/max = 3/4/7 ms
SRC-HOST#
```

[Full captured text](block-04.txt)

[Evidence index](README.md) · [Section overview](../README.md)
