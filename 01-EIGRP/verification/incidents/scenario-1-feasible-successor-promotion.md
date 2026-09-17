# Case 01 — Original excerpts and commands

[Read the case study](../../troubleshooting/scenario-1-feasible-successor-promotion.md) · [Evidence index](README.md)

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

Initial Healthy State

```cisco
show ip route 172.16.40.0
```

## Block 6

Creating a Successor and Feasible Successor

```cisco
configure terminal
interface GigabitEthernet0/1
 delay 100
end
```

## Block 7

Creating a Successor and Feasible Successor

```text
delay 100 = 1000 microseconds
```

## Block 8

Creating a Successor and Feasible Successor

```cisco
show interfaces GigabitEthernet0/1 | include DLY
```

## Block 9

Creating a Successor and Feasible Successor

```text
MTU 1500 bytes, BW 1000000 Kbit/sec, DLY 1000 usec
```

## Block 10

Resulting Topology

```cisco
show ip eigrp topology 172.16.40.0/22
```

## Block 11

Resulting Topology

```text
State is Passive, Query origin flag is 1, 1 Successor(s), FD is 131072

10.12.0.2 (GigabitEthernet0/0)
Composite metric is (131072/130816)

10.13.0.2 (GigabitEthernet0/1)
Composite metric is (156416/130816)
```

## Block 12

Resulting Topology

```text
Successor via 10.12.0.2
FD = 131072
```

## Block 13

Resulting Topology

```text
Total metric = 156416
RD = 130816
```

## Block 14

Feasibility Condition Analysis

```text
Alternate path RD < Current Successor FD
```

## Block 15

Feasibility Condition Analysis

```text
130816 < 131072
```

## Block 16

Feasibility Condition Analysis

```cisco
show ip route 172.16.40.0
```

## Block 17

Feasibility Condition Analysis

```text
Known via "eigrp 100", distance 90, metric 131072, type internal

10.12.0.2, via GigabitEthernet0/0
Route metric is 131072
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

Observed Convergence

```cisco
show ip eigrp topology 172.16.40.0/22
```

## Block 20

Observed Convergence

```text
State is Passive, Query origin flag is 1, 1 Successor(s), FD is 131072

10.13.0.2 (GigabitEthernet0/1)
Composite metric is (156416/130816)
```

## Block 21

Observed Convergence

```cisco
show ip route 172.16.40.0
```

## Block 22

Observed Convergence

```text
Known via "eigrp 100", distance 90, metric 156416, type internal

10.13.0.2, via GigabitEthernet0/1
Route metric is 156416
```

## Block 23

DUAL Active-State Verification

```cisco
show ip eigrp topology active
```

## Block 24

DUAL Active-State Verification

```text
EIGRP-IPv4 Topology Table for AS(100)/ID(10.1.1.1)
```

## Block 25

Resolution

```cisco
configure terminal

interface GigabitEthernet0/0
 no shutdown

interface GigabitEthernet0/1
 no delay 100

end
```

## Block 26

Post-Resolution Validation

```cisco
show ip eigrp neighbors
```

## Block 27

Post-Resolution Validation

```text
10.12.0.2 via GigabitEthernet0/0
10.13.0.2 via GigabitEthernet0/1
```

## Block 28

Post-Resolution Validation

```cisco
show ip interface brief | include GigabitEthernet0/0
```

## Block 29

Post-Resolution Validation

```text
GigabitEthernet0/0  10.12.0.1  up  up
```

## Block 30

Post-Resolution Validation

```cisco
show ip eigrp topology 172.16.40.0/22
```

## Block 31

Post-Resolution Validation

```text
State is Passive, Query origin flag is 1, 2 Successor(s), FD is 131072

10.12.0.2 (GigabitEthernet0/0)
Composite metric is (131072/130816)

10.13.0.2 (GigabitEthernet0/1)
Composite metric is (131072/130816)
```

