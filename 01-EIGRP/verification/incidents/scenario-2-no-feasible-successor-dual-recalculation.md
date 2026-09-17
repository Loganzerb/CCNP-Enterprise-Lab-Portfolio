# Case 02 — Original excerpts and commands

[Read the case study](../../troubleshooting/scenario-2-no-feasible-successor-dual-recalculation.md) · [Evidence index](README.md)

All fenced blocks from the original case are retained verbatim and in order. They include selected device-output excerpts, documented configuration changes, and command lists. A command list alone does not establish that its result was captured. Section labels are added for navigation.

## Block 1

Initial Healthy State

```text
172.16.40.0/22
```

## Block 2

Initial Healthy State

```cisco
show ip eigrp topology 172.16.40.0/22
```

## Block 3

Initial Healthy State

```text
State is Passive, Query origin flag is 1, 2 Successor(s), FD is 131072

10.12.0.2 (GigabitEthernet0/0)
Composite metric is (131072/130816)

10.13.0.2 (GigabitEthernet0/1)
Composite metric is (131072/130816)
```

## Block 4

Initial Healthy State

```text
Feasible Distance = 131072
Reported Distance = 130816
```

## Block 5

Failure Preparation

```cisco
show ip interface brief
show interfaces GigabitEthernet0/2 | include Internet address|DLY
```

## Block 6

Failure Preparation

```text
GigabitEthernet0/2  10.34.0.1  up  up

Internet address is 10.34.0.1/30
MTU 1500 bytes, BW 1000000 Kbit/sec, DLY 10 usec
```

## Block 7

Failure Preparation

```cisco
configure terminal
interface GigabitEthernet0/2
 delay 100
end
```

## Block 8

Failure Preparation

```text
delay 100 = 1000 microseconds
```

## Block 9

Topology Analysis

```cisco
show ip eigrp topology 172.16.40.0/22
show ip eigrp topology all-links | section 172.16.40.0/22
show ip route 172.16.40.0
```

## Block 10

Topology Analysis

```text
State is Passive, Query origin flag is 1, 1 Successor(s), FD is 131072

10.12.0.2 (GigabitEthernet0/0)
Composite metric is (131072/130816)

10.13.0.2 (GigabitEthernet0/1)
Composite metric is (156672/131072)
```

## Block 11

Topology Analysis

```text
P 172.16.40.0/22, 1 successors, FD is 131072

via 10.12.0.2 (131072/130816), GigabitEthernet0/0
via 10.13.0.2 (156672/131072), GigabitEthernet0/1
```

## Block 12

Topology Analysis

```text
Known via "eigrp 100", distance 90, metric 131072, type internal

10.12.0.2, via GigabitEthernet0/0
Route metric is 131072
```

## Block 13

Feasibility Condition Analysis

```text
Alternate path RD < Current Successor FD
```

## Block 14

Feasibility Condition Analysis

```text
FD = 131072
```

## Block 15

Feasibility Condition Analysis

```text
RD = 131072
```

## Block 16

Feasibility Condition Analysis

```text
131072 < 131072
```

## Block 17

Feasibility Condition Analysis

```text
R2 = Successor

R3 = Known alternate path
R3 is not a Feasible Successor
```

## Block 18

Failure Injection

```cisco
configure terminal
interface GigabitEthernet0/0
 shutdown
end
```

## Block 19

DUAL Investigation

```cisco
debug eigrp packets query reply
```

## Block 20

DUAL Investigation

```cisco
show ip eigrp topology active
```

## Block 21

DUAL Investigation

```text
EIGRP-IPv4 Topology Table for AS(100)/ID(10.1.1.1)
```

## Block 22

Resulting Topology

```cisco
show ip eigrp topology 172.16.40.0/22
```

## Block 23

Resulting Topology

```text
State is Passive, Query origin flag is 1, 1 Successor(s), FD is 156672

10.13.0.2 (GigabitEthernet0/1)
Composite metric is (156672/131072)
```

## Block 24

Resulting Topology

```cisco
show ip route 172.16.40.0
```

## Block 25

Resulting Topology

```text
Known via "eigrp 100", distance 90, metric 156672, type internal

10.13.0.2, via GigabitEthernet0/1
Route metric is 156672
```

## Block 26

Comparison with Scenario 1

```text
R3 RD = 130816
Current FD = 131072

130816 < 131072
```

## Block 27

Comparison with Scenario 1

```text
R3 RD = 131072
Current FD = 131072

131072 < 131072 = FALSE
```

## Block 28

Resolution

```cisco
configure terminal
interface GigabitEthernet0/0
 no shutdown
end
```

## Block 29

Resolution

```cisco
configure terminal
interface GigabitEthernet0/2
 no delay 100
end
```

## Block 30

Resolution

```cisco
configure terminal
interface GigabitEthernet0/1
 no delay 100
end
```

## Block 31

Post-Resolution Validation

```cisco
show interfaces GigabitEthernet0/1 | include DLY
```

## Block 32

Post-Resolution Validation

```text
MTU 1500 bytes, BW 1000000 Kbit/sec, DLY 10 usec
```

## Block 33

Post-Resolution Validation

```cisco
show ip eigrp topology 172.16.40.0/22
```

## Block 34

Post-Resolution Validation

```text
State is Passive, Query origin flag is 1, 2 Successor(s), FD is 131072

10.12.0.2 (GigabitEthernet0/0)
Composite metric is (131072/130816)

10.13.0.2 (GigabitEthernet0/1)
Composite metric is (131072/130816)
```

## Block 35

Key Concepts Demonstrated

```text
Reported Distance < Current Feasible Distance
```

