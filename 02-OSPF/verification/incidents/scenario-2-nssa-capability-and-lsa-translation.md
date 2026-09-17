# Case 02 — Original excerpts and commands

[Read the case study](../../troubleshooting/scenario-2-nssa-capability-and-lsa-translation.md) · [Evidence index](README.md)

All fenced blocks from the original case are retained verbatim and in order. They include selected device-output excerpts, documented configuration changes, and command lists. A command list alone does not establish that its result was captured. Section labels are added for navigation.

Case 02's first block is a conceptual route-flow diagram, not device output. Its only device-output blocks are the two recovery excerpts (blocks 5 and 6). Failure-state observations and the rest of the recovery sequence were described in the original narrative without matching retained CLI excerpts.

## Block 1

Healthy Baseline

```text
O4-EDGE originates Type 7 LSAs in Area 10
                    |
                    v
O2-ABR learns the NSSA external routes as O N1
                    |
                    v
O2-ABR translates Type 7 LSAs into Type 5 LSAs
                    |
                    v
O1-CORE receives Type 5 LSAs and installs O E1 routes
```

## Block 2

Fault Injection

```cisco
configure terminal
router ospf 1
 no area 10 nssa
end
```

## Block 3

Root Cause

```cisco
no area 10 nssa
```

## Block 4

Remediation

```cisco
configure terminal
router ospf 1
 area 10 nssa
end
```

## Block 5

Post-Fix Verification

```text
O N1  192.0.2.0/24 [110/31] via 10.100.24.2, GigabitEthernet0/2
O N1  198.51.100.0/24 [110/31] via 10.100.24.2, GigabitEthernet0/2
```

## Block 6

Post-Fix Verification

```text
Link State ID: 192.0.2.0
Advertising Router: 10.100.4.4
Metric Type: 1
Metric: 20

Link State ID: 198.51.100.0
Advertising Router: 10.100.4.4
Metric Type: 1
Metric: 20
```

## Block 7

Neighbor and area-capability checks

```cisco
show ip ospf neighbor
show ip ospf | section Area 10
```

## Block 8

Type 7 and Type 5 LSA inspection

```cisco
show ip ospf database nssa-external
show ip ospf database external
```

## Block 9

Prefix-specific routing-table verification

```cisco
show ip route ospf | include 192.0.2.0|198.51.100.0
```

## Block 10

Fault injection

```cisco
configure terminal
router ospf 1
 no area 10 nssa
end
```

## Block 11

Remediation

```cisco
configure terminal
router ospf 1
 area 10 nssa
end
```

