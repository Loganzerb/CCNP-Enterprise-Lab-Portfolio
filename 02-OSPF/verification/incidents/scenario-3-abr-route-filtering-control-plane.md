# Case 03 — Original excerpts and commands

[Read the case study](../../troubleshooting/scenario-3-abr-route-filtering-control-plane.md) · [Evidence index](README.md)

All fenced blocks from the original case are retained verbatim and in order. They include selected device-output excerpts, documented configuration changes, and command lists. A command list alone does not establish that its result was captured. Section labels are added for navigation.

## Block 1

Topology and Route Roles

```cisco
area 10 range 172.20.32.0 255.255.252.0
```

## Block 2

Healthy Baseline

```cisco
router ospf 1
 area 10 range 172.20.32.0 255.255.252.0
```

## Block 3

Fault Injection

```cisco
ip prefix-list AREA10-TO-AREA0 seq 5 deny 172.20.32.0/22 le 32
ip prefix-list AREA10-TO-AREA0 seq 10 permit 0.0.0.0/0 le 32
```

## Block 4

Fault Injection

```cisco
router ospf 1
 area 10 filter-list prefix AREA10-TO-AREA0 out
```

## Block 5

Fault Injection

```cisco
router ospf 1
 router-id 10.100.2.2
 no compatible rfc1583
 auto-cost reference-bandwidth 10000
 area 10 nssa no-summary
 area 10 range 172.20.32.0 255.255.252.0
 area 10 filter-list prefix AREA10-TO-AREA0 out
 passive-interface default
 no passive-interface GigabitEthernet0/0
 no passive-interface GigabitEthernet0/1
 no passive-interface GigabitEthernet0/2
 network 10.100.2.2 0.0.0.0 area 0
 network 10.100.12.0 0.0.0.3 area 0
 network 10.100.23.0 0.0.0.3 area 10
 network 10.100.24.0 0.0.0.3 area 10
```

## Block 6

Observed Symptoms

```text
O1-CORE#show ip route 172.20.32.0
% Network not in table
```

## Block 7

Observed Symptoms

```text
O1-CORE#show ip ospf database summary 172.20.32.0

        OSPF Router with ID (10.100.1.1) (Process ID 1)
```

## Block 8

Observed Symptoms

```text
Neighbor ID     Pri   State           Address         Interface
10.100.1.1        1   FULL/BDR        10.100.12.1     GigabitEthernet0/0
10.100.4.4        1   FULL/DR         10.100.24.2     GigabitEthernet0/2
10.100.3.3        0   FULL/  -        10.100.23.2     GigabitEthernet0/1
```

## Block 9

3. Confirm Area 10 remained healthy

```text
O 172.20.32.0/24 [110/11] via 10.100.23.2, GigabitEthernet0/1
O 172.20.33.0/24 [110/11] via 10.100.23.2, GigabitEthernet0/1
O 172.20.34.0/24 [110/11] via 10.100.23.2, GigabitEthernet0/1
O 172.20.35.0/24 [110/11] via 10.100.23.2, GigabitEthernet0/1
```

## Block 10

3. Confirm Area 10 remained healthy

```text
O 172.20.32.0/24 [110/21] via 10.100.45.1, GigabitEthernet0/1
O 172.20.33.0/24 [110/21] via 10.100.45.1, GigabitEthernet0/1
O 172.20.34.0/24 [110/21] via 10.100.45.1, GigabitEthernet0/1
O 172.20.35.0/24 [110/21] via 10.100.45.1, GigabitEthernet0/1
```

## Block 11

4. Inspect ABR policy

```text
ip prefix-list AREA10-TO-AREA0: 2 entries
   seq 5 deny 172.20.32.0/22 le 32
   seq 10 permit 0.0.0.0/0 le 32
```

## Block 12

Root Cause

```cisco
area 10 filter-list prefix AREA10-TO-AREA0 out
```

## Block 13

Remediation

```cisco
configure terminal
router ospf 1
 no area 10 filter-list prefix AREA10-TO-AREA0 out
end
```

## Block 14

O2 route state

```text
O 172.20.32.0/22 is a summary, Null0
O 172.20.32.0/24 [110/11] via 10.100.23.2, GigabitEthernet0/1
O 172.20.33.0/24 [110/11] via 10.100.23.2, GigabitEthernet0/1
O 172.20.34.0/24 [110/11] via 10.100.23.2, GigabitEthernet0/1
O 172.20.35.0/24 [110/11] via 10.100.23.2, GigabitEthernet0/1
```

## Block 15

O1 routing table

```text
Routing entry for 172.20.32.0/22
Known via "ospf 1", distance 110, metric 21, type inter area
Last update from 10.100.12.2 on GigabitEthernet0/0
```

## Block 16

O1 link-state database

```text
LS Type: Summary Links(Network)
Link State ID: 172.20.32.0 (summary Network Number)
Advertising Router: 10.100.2.2
Network Mask: /22
MTID: 0         Metric: 11
```

## Block 17

Routing and OSPF verification

```cisco
show ip route 172.20.32.0
show ip ospf database summary 172.20.32.0
show ip ospf neighbor
show ip route ospf | include 172.20.32.0|172.20.33.0|172.20.34.0|172.20.35.0
```

## Block 18

Policy and configuration inspection

```cisco
show ip prefix-list AREA10-TO-AREA0
show running-config | section router ospf
```

## Block 19

Fault injection

```cisco
configure terminal
ip prefix-list AREA10-TO-AREA0 seq 5 deny 172.20.32.0/22 le 32
ip prefix-list AREA10-TO-AREA0 seq 10 permit 0.0.0.0/0 le 32
router ospf 1
 area 10 filter-list prefix AREA10-TO-AREA0 out
end
```

## Block 20

Remediation

```cisco
configure terminal
router ospf 1
 no area 10 filter-list prefix AREA10-TO-AREA0 out
end
```

