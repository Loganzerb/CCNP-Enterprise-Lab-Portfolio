# EIGRP Troubleshooting Scenario 1

## Feasible Successor Promotion and DUAL Convergence

## Objective

Demonstrate how EIGRP uses a Feasible Successor to provide immediate, loop-free convergence when the current Successor fails.

This scenario validates:

- Successor selection
- Feasible Successor eligibility
- The Feasibility Condition
- Feasible Distance (FD)
- Reported Distance (RD)
- Diffusing Update Algorithm (DUAL) convergence
- Passive versus Active route state

---

## Initial Healthy State

The destination prefix used for this test was:

```text
172.16.40.0/22
```

R1-CORE initially had two equal-cost Successors toward the destination.

Verification:

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

Both paths had:

```text
Feasible Distance = 131072
Reported Distance = 130816
```

The routing table confirmed that both equal-cost paths were installed:

```cisco
show ip route 172.16.40.0
```

---

## Creating a Successor and Feasible Successor

To create a true Successor and Feasible Successor relationship, the delay on R1-CORE GigabitEthernet0/1 was increased.

```cisco
configure terminal
interface GigabitEthernet0/1
 delay 100
end
```

Cisco IOS expresses the `delay` command in tens of microseconds. Therefore:

```text
delay 100 = 1000 microseconds
```

This increased R1's total EIGRP metric through R3 without changing the Reported Distance advertised by R3.

Verification:

```cisco
show interfaces GigabitEthernet0/1 | include DLY
```

Result:

```text
MTU 1500 bytes, BW 1000000 Kbit/sec, DLY 1000 usec
```

---

## Resulting Topology

The topology table was checked again:

```cisco
show ip eigrp topology 172.16.40.0/22
```

Relevant output:

```text
State is Passive, Query origin flag is 1, 1 Successor(s), FD is 131072

10.12.0.2 (GigabitEthernet0/0)
Composite metric is (131072/130816)

10.13.0.2 (GigabitEthernet0/1)
Composite metric is (156416/130816)
```

The path through R2 remained the Successor:

```text
Successor via 10.12.0.2
FD = 131072
```

The path through R3 became an alternate path with:

```text
Total metric = 156416
RD = 130816
```

---

## Feasibility Condition Analysis

For an alternate path to qualify as a Feasible Successor, its Reported Distance must be lower than the current Successor's Feasible Distance:

```text
Alternate path RD < Current Successor FD
```

For the R3 path:

```text
130816 < 131072
```

The Feasibility Condition was satisfied. Therefore, the R3 path qualified as a loop-free Feasible Successor.

The routing table confirmed that only the lower-metric Successor through R2 was installed:

```cisco
show ip route 172.16.40.0
```

Relevant output:

```text
Known via "eigrp 100", distance 90, metric 131072, type internal

10.12.0.2, via GigabitEthernet0/0
Route metric is 131072
```

---

## Failure Injection

The current Successor path through R2 was intentionally failed by shutting down R1-CORE GigabitEthernet0/0:

```cisco
configure terminal
interface GigabitEthernet0/0
 shutdown
end
```

This removed the current Successor from the topology.

---

## Observed Convergence

Immediately after the failure, the topology table was checked:

```cisco
show ip eigrp topology 172.16.40.0/22
```

Relevant output:

```text
State is Passive, Query origin flag is 1, 1 Successor(s), FD is 131072

10.13.0.2 (GigabitEthernet0/1)
Composite metric is (156416/130816)
```

The R3 path was promoted and became the new forwarding path. The routing table confirmed the new route:

```cisco
show ip route 172.16.40.0
```

Relevant output:

```text
Known via "eigrp 100", distance 90, metric 156416, type internal

10.13.0.2, via GigabitEthernet0/1
Route metric is 156416
```

---

## DUAL Active-State Verification

The EIGRP topology table was checked for Active routes:

```cisco
show ip eigrp topology active
```

Result:

```text
EIGRP-IPv4 Topology Table for AS(100)/ID(10.1.1.1)
```

No Active prefixes were present. Because the R3 path already satisfied the Feasibility Condition, DUAL could promote the precomputed loop-free backup without a diffusing Query/Reply computation.

---

## Root Cause

The route change was caused by the intentional failure of the current Successor path through R2. The destination remained reachable because R1 already had a valid Feasible Successor through R3.

---

## Resolution

The failed interface was restored and the temporary delay modification was removed:

```cisco
configure terminal

interface GigabitEthernet0/0
 no shutdown

interface GigabitEthernet0/1
 no delay 100

end
```

---

## Post-Resolution Validation

Neighbor state was verified:

```cisco
show ip eigrp neighbors
```

Relevant output confirmed both neighbors were restored:

```text
10.12.0.2 via GigabitEthernet0/0
10.13.0.2 via GigabitEthernet0/1
```

Interface status was verified:

```cisco
show ip interface brief | include GigabitEthernet0/0
```

Result:

```text
GigabitEthernet0/0  10.12.0.1  up  up
```

Finally, the topology table returned to the original healthy state:

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

1. Verify the healthy-state topology.
2. Identify the current Successor paths.
3. Modify one path to create a Feasible Successor.
4. Compare Feasible Distance and Reported Distance.
5. Confirm Feasibility Condition eligibility.
6. Fail the current Successor.
7. Observe DUAL convergence behavior.
8. Verify whether the route entered Active state.
9. Confirm installation of the replacement path.
10. Restore the original topology.
11. Validate neighbor, interface, topology, and routing-table recovery.

---

## Key Concepts Demonstrated

- EIGRP topology-table analysis
- Successor and Feasible Successor behavior
- Feasibility Condition evaluation
- Feasible Distance and Reported Distance comparison
- Immediate loop-free convergence
- DUAL local computation
- Passive route-state behavior
- Difference between topology-table paths and routing-table paths

A precomputed Feasible Successor allows EIGRP to recover from a Successor failure without querying neighboring routers, providing rapid and loop-free convergence.
