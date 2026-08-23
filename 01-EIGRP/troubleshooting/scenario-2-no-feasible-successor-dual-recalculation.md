# EIGRP Troubleshooting Scenario 2

## No Feasible Successor and DUAL Route Recalculation

## Objective

Demonstrate how EIGRP behaves when the current Successor fails and no alternate path satisfies the Feasibility Condition.

This scenario validates:

- Successor selection
- The Feasibility Condition
- Feasible Distance (FD)
- Reported Distance (RD)
- Non-Feasible Successor paths
- Diffusing Update Algorithm (DUAL) route recalculation
- Active and Passive route-state concepts
- The difference between immediate Feasible Successor promotion and full route recomputation

---

## Initial Healthy State

The destination prefix used for this test was:

```text
172.16.40.0/22
```

R1-CORE initially had two equal-cost Successors toward the destination.

```cisco
show ip eigrp topology 172.16.40.0/22
```

Relevant output:

```text
State is Passive, Query origin flag is 1, 2 Successor(s), FD is 131072

10.12.0.2 (GigabitEthernet0/0)
Composite metric is (131072/130816)

10.13.0.2 (GigabitEthernet0/1)
Composite metric is (131072/130816)
```

Both paths initially had:

```text
Feasible Distance = 131072
Reported Distance = 130816
```

---

## Failure Preparation

The goal was to make the alternate path through R3 fail the EIGRP Feasibility Condition. R3-DIST-B reaches the branch network through GigabitEthernet0/2.

Baseline verification on R3-DIST-B:

```cisco
show ip interface brief
show interfaces GigabitEthernet0/2 | include Internet address|DLY
```

Relevant output:

```text
GigabitEthernet0/2  10.34.0.1  up  up

Internet address is 10.34.0.1/30
MTU 1500 bytes, BW 1000000 Kbit/sec, DLY 10 usec
```

The interface delay on R3-DIST-B was then increased:

```cisco
configure terminal
interface GigabitEthernet0/2
 delay 100
end
```

Cisco IOS expresses the `delay` command in tens of microseconds. Therefore:

```text
delay 100 = 1000 microseconds
```

Unlike Scenario 1, this metric manipulation was performed downstream on R3. It changed the metric that R3 advertised toward R1 and therefore increased R3's Reported Distance.

---

## Topology Analysis

The topology was examined from R1-CORE:

```cisco
show ip eigrp topology 172.16.40.0/22
show ip eigrp topology all-links | section 172.16.40.0/22
show ip route 172.16.40.0
```

Relevant topology output:

```text
State is Passive, Query origin flag is 1, 1 Successor(s), FD is 131072

10.12.0.2 (GigabitEthernet0/0)
Composite metric is (131072/130816)

10.13.0.2 (GigabitEthernet0/1)
Composite metric is (156672/131072)
```

The all-links topology output confirmed both known paths:

```text
P 172.16.40.0/22, 1 successors, FD is 131072

via 10.12.0.2 (131072/130816), GigabitEthernet0/0
via 10.13.0.2 (156672/131072), GigabitEthernet0/1
```

The routing table contained only the path through R2:

```text
Known via "eigrp 100", distance 90, metric 131072, type internal

10.12.0.2, via GigabitEthernet0/0
Route metric is 131072
```

---

## Feasibility Condition Analysis

The Feasibility Condition requires:

```text
Alternate path RD < Current Successor FD
```

The current Successor through R2 had:

```text
FD = 131072
```

The alternate path through R3 advertised:

```text
RD = 131072
```

The comparison was therefore:

```text
131072 < 131072
```

This statement is false. The Feasibility Condition requires the Reported Distance to be strictly lower than the current Feasible Distance. Because the values were equal, the R3 path did not qualify as a Feasible Successor.

```text
R2 = Successor

R3 = Known alternate path
R3 is not a Feasible Successor
```

---

## Failure Injection

The current Successor path through R2 was intentionally removed on R1-CORE:

```cisco
configure terminal
interface GigabitEthernet0/0
 shutdown
end
```

At the moment of failure, R1 did not have a precomputed Feasible Successor available for immediate promotion.

---

## DUAL Investigation

EIGRP debugging was enabled before the failure in an attempt to observe Query and Reply processing:

```cisco
debug eigrp packets query reply
```

The route was also checked for an Active state:

```cisco
show ip eigrp topology active
```

Observed output:

```text
EIGRP-IPv4 Topology Table for AS(100)/ID(10.1.1.1)
```

No Active prefixes were visible by the time the command was executed, and no useful Query/Reply debug messages were captured. The convergence event completed too quickly for the transient processing to be observed manually.

This lab therefore does **not** claim that the Active state or Query/Reply exchange was directly captured. The recorded evidence demonstrates that:

- The original Successor failed.
- No Feasible Successor existed before the failure.
- The previously non-feasible R3 path became the new Successor after EIGRP reconverged.
- The route was Passive after convergence.

---

## Resulting Topology

After the R2 path failed, R1-CORE selected the path through R3.

```cisco
show ip eigrp topology 172.16.40.0/22
```

Relevant output:

```text
State is Passive, Query origin flag is 1, 1 Successor(s), FD is 156672

10.13.0.2 (GigabitEthernet0/1)
Composite metric is (156672/131072)
```

The routing table confirmed the new forwarding path:

```cisco
show ip route 172.16.40.0
```

Relevant output:

```text
Known via "eigrp 100", distance 90, metric 156672, type internal

10.13.0.2, via GigabitEthernet0/1
Route metric is 156672
```

The R3 path was successfully installed after EIGRP recalculated the topology.

---

## Comparison with Scenario 1

Scenario 1 demonstrated immediate Feasible Successor promotion:

```text
R3 RD = 130816
Current FD = 131072

130816 < 131072
```

The Feasibility Condition was satisfied, so EIGRP already knew the alternate path was loop-free and could promote it immediately.

In this scenario:

```text
R3 RD = 131072
Current FD = 131072

131072 < 131072 = FALSE
```

The alternate path was not a Feasible Successor. Therefore, EIGRP could not use the same precomputed Feasible Successor promotion demonstrated in Scenario 1.

---

## Root Cause

The route convergence event was caused by two deliberate changes:

1. The R3 path was modified so its Reported Distance no longer satisfied the Feasibility Condition.
2. The current Successor path through R2 was then failed.

This left R1 without a valid Feasible Successor at the instant the Successor disappeared.

---

## Resolution

The failed Successor interface was restored on R1-CORE:

```cisco
configure terminal
interface GigabitEthernet0/0
 no shutdown
end
```

The temporary metric manipulation was removed from R3-DIST-B:

```cisco
configure terminal
interface GigabitEthernet0/2
 no delay 100
end
```

A remaining temporary delay from previous testing was also removed from R1-CORE:

```cisco
configure terminal
interface GigabitEthernet0/1
 no delay 100
end
```

---

## Post-Resolution Validation

R1-CORE GigabitEthernet0/1 was verified to have returned to its original delay:

```cisco
show interfaces GigabitEthernet0/1 | include DLY
```

Result:

```text
MTU 1500 bytes, BW 1000000 Kbit/sec, DLY 10 usec
```

The topology table was then checked:

```cisco
show ip eigrp topology 172.16.40.0/22
```

Relevant output:

```text
State is Passive, Query origin flag is 1, 2 Successor(s), FD is 131072

10.12.0.2 (GigabitEthernet0/0)
Composite metric is (131072/130816)

10.13.0.2 (GigabitEthernet0/1)
Composite metric is (131072/130816)
```

The original equal-cost topology was fully restored.

---

## Troubleshooting Methodology

1. Establish the healthy EIGRP topology.
2. Identify the current Successor and alternate path.
3. Modify the downstream metric advertised by R3.
4. Inspect both normal and all-links EIGRP topology views.
5. Compare Reported Distance against the current Feasible Distance.
6. Confirm that the alternate path failed the Feasibility Condition.
7. Fail the current Successor.
8. Observe the resulting topology recalculation.
9. Verify the newly installed route in the routing table.
10. Restore all temporary configuration changes.
11. Validate return to the original two-Successor baseline.

---

## Key Concepts Demonstrated

- EIGRP Feasibility Condition analysis
- Feasible Distance and Reported Distance comparison
- Difference between a known alternate path and a Feasible Successor
- Use of `show ip eigrp topology all-links`
- DUAL behavior when no precomputed Feasible Successor is available
- Route recalculation following Successor failure
- Active and Passive route-state concepts
- Importance of validating complete topology restoration after troubleshooting

A known EIGRP alternate path is not automatically a Feasible Successor. It must satisfy:

```text
Reported Distance < Current Feasible Distance
```

If it does not, EIGRP cannot rely on that path as a precomputed loop-free backup and must perform additional DUAL processing after the Successor is lost.
