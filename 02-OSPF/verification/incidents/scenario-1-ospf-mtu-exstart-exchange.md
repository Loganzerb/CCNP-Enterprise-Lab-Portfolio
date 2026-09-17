# Case 01 — Original excerpts and commands

[Read the case study](../../troubleshooting/scenario-1-ospf-mtu-exstart-exchange.md) · [Evidence index](README.md)

All fenced blocks from the original case are retained verbatim and in order. They include selected device-output excerpts, documented configuration changes, and command lists. A command list alone does not establish that its result was captured. Section labels are added for navigation.

## Block 1

Fault Injection

```cisco
configure terminal
interface GigabitEthernet0/2
 ip mtu 1400
 shutdown
 no shutdown
end
```

## Block 2

Observed Symptoms

```text
Neighbor 10.100.2.2, interface address 10.100.24.1
   In the area 10 via interface GigabitEthernet0/0
   Neighbor priority is 1, State is EXSTART, 9 state changes
   DR is 10.100.24.2 BDR is 10.100.24.1
   Number of retransmissions for last database description packet 20
```

## Block 3

Observed Symptoms

```text
O2-ABR#ping 10.100.24.2
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 10.100.24.2, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 1/1/2 ms
```

## Block 4

3. Compare the physical interface MTU

```text
O2-ABR#show interfaces GigabitEthernet0/2 | include MTU
  MTU 1500 bytes, BW 1000000 Kbit/sec, DLY 10 usec,

O4-EDGE#show interfaces GigabitEthernet0/0 | include MTU
  MTU 1500 bytes, BW 1000000 Kbit/sec, DLY 10 usec,
```

## Block 5

4. Inspect the Layer 3 IP MTU and interface configuration

```text
O2-ABR#show ip interface GigabitEthernet0/2 | include MTU
  MTU is 1400 bytes
```

## Block 6

4. Inspect the Layer 3 IP MTU and interface configuration

```text
O2-ABR#show running-config interface GigabitEthernet0/2
interface GigabitEthernet0/2
 description LINK-TO-O4-EDGE
 ip address 10.100.24.1 255.255.255.252
 ip mtu 1400
 duplex auto
 speed auto
 media-type rj45
```

## Block 7

5. Correlate the configuration with OSPF debug output

```text
Rcv DBD from 10.100.2.2 ... mtu 1400 state EXSTART
Nbr 10.100.2.2 has smaller interface MTU
Retransmitting DBD to 10.100.2.2
```

## Block 8

Remediation

```cisco
configure terminal
interface GigabitEthernet0/2
 no ip mtu
end
```

## Block 9

Post-Fix Verification

```text
O2-ABR#show ip interface GigabitEthernet0/2 | include MTU
  MTU is 1500 bytes
```

## Block 10

Post-Fix Verification

```text
O2-ABR#show ip ospf neighbor 10.100.4.4
 Neighbor 10.100.4.4, interface address 10.100.24.2
   In the area 10 via interface GigabitEthernet0/2
   Neighbor priority is 1, State is FULL, 6 state changes
   DR is 10.100.24.2 BDR is 10.100.24.1
   retransmission queue length 0, number of retransmission 0
```

## Block 11

Post-Fix Verification

```text
O4-EDGE#show ip ospf neighbor 10.100.2.2
 Neighbor 10.100.2.2, interface address 10.100.24.1
   In the area 10 via interface GigabitEthernet0/0
   Neighbor priority is 1, State is FULL, 9 state changes
   DR is 10.100.24.2 BDR is 10.100.24.1
   retransmission queue length 0, number of retransmission 0
```

## Block 12

Baseline and neighbor-state validation

```cisco
show ip ospf neighbor 10.100.4.4
show ip ospf neighbor 10.100.2.2
```

## Block 13

Reachability testing

```cisco
ping 10.100.24.2
```

## Block 14

MTU comparison and configuration validation

```cisco
show interfaces GigabitEthernet0/2 | include MTU
show interfaces GigabitEthernet0/0 | include MTU
show ip interface GigabitEthernet0/2 | include MTU
show running-config interface GigabitEthernet0/2
```

## Block 15

Protocol-level diagnosis

```cisco
debug ip ospf adj
```

## Block 16

Remediation

```cisco
configure terminal
interface GigabitEthernet0/2
 no ip mtu
end
```

## Block 17

Post-fix verification

```cisco
show ip interface GigabitEthernet0/2 | include MTU
show ip ospf neighbor 10.100.4.4
show ip ospf neighbor 10.100.2.2
```

