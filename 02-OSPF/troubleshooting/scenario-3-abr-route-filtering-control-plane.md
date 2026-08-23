# Scenario 3: ABR Route Filtering and Control-Plane Reachability Loss

## Objective

Diagnose and remediate a selective Open Shortest Path First (OSPF) inter-area reachability failure in which all neighbor adjacencies remained healthy, but a summarized branch prefix disappeared from Area 0.

This case demonstrates a core troubleshooting principle: an OSPF neighbor state of `FULL` confirms successful adjacency formation and database exchange between peers, but it does not guarantee that Area Border Router (ABR) policy is advertising every expected inter-area route.

## Topology and Route Roles

- **O2-ABR** is the ABR between Area 10 and Area 0.
- **O3-BRANCH** originates four component networks inside Area 10:
  - `172.20.32.0/24`
  - `172.20.33.0/24`
  - `172.20.34.0/24`
  - `172.20.35.0/24`
- **O2-ABR** summarizes those four routes with:

```cisco
area 10 range 172.20.32.0 255.255.252.0
```

- The range produces a local `172.20.32.0/22` Null0 summary on O2 and a Type 3 Summary Link-State Advertisement (LSA) toward Area 0.
- **O1-CORE**, in Area 0, normally installs the summary as an `O IA` (OSPF inter-area) route.
- **O4-EDGE** provides an additional Area 10 observation point for the four component routes.

## Healthy Baseline

Before fault injection, O2 generated the aggregate and advertised it into Area 0. The expected healthy state was:

- O2 had all four `/24` component routes from O3.
- O2 installed the local `172.20.32.0/22` summary toward Null0.
- O1 installed `172.20.32.0/22` as `O IA` with metric 21.
- O1's OSPF database contained a Type 3 Summary LSA for `172.20.32.0/22`, advertised by router ID `10.100.2.2` with metric 11.
- All O2 OSPF neighbors were `FULL`.

The relevant O2 summarization configuration was:

```cisco
router ospf 1
 area 10 range 172.20.32.0 255.255.252.0
```

## Fault Injection

The failure was introduced on O2 by creating a prefix list that denied the aggregate and permitted all other prefixes:

```cisco
ip prefix-list AREA10-TO-AREA0 seq 5 deny 172.20.32.0/22 le 32
ip prefix-list AREA10-TO-AREA0 seq 10 permit 0.0.0.0/0 le 32
```

The prefix list was then applied outbound from Area 10 under OSPF process 1:

```cisco
router ospf 1
 area 10 filter-list prefix AREA10-TO-AREA0 out
```

The captured running configuration confirmed that summarization and filtering were simultaneously active:

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

## Observed Symptoms

After the filter was applied, O1 no longer had the summarized branch route:

```text
O1-CORE#show ip route 172.20.32.0
% Network not in table
```

The matching Type 3 LSA was also absent from O1's link-state database. The query displayed only the local OSPF process heading and no summary entry:

```text
O1-CORE#show ip ospf database summary 172.20.32.0

        OSPF Router with ID (10.100.1.1) (Process ID 1)
```

Despite that reachability loss, every captured O2 adjacency remained `FULL`:

```text
Neighbor ID     Pri   State           Address         Interface
10.100.1.1        1   FULL/BDR        10.100.12.1     GigabitEthernet0/0
10.100.4.4        1   FULL/DR         10.100.24.2     GigabitEthernet0/2
10.100.3.3        0   FULL/  -        10.100.23.2     GigabitEthernet0/1
```

The failure therefore presented as a control-plane policy problem, not an adjacency outage.

## Troubleshooting Process

### 1. Validate the Area 0 failure

Two independent checks on O1 established the scope of the problem:

- `show ip route 172.20.32.0` confirmed the `/22` was absent from the routing table.
- `show ip ospf database summary 172.20.32.0` confirmed the corresponding Type 3 LSA was absent from the OSPF database.

The route was not merely failing best-path installation; its inter-area advertisement was missing altogether.

### 2. Verify adjacency health

`show ip ospf neighbor` on O2 showed all three neighbors in a `FULL` state. This ruled out adjacency formation as the cause and focused the investigation above the neighbor layer.

### 3. Confirm Area 10 remained healthy

O2 still learned all four intra-area component routes from O3 through `10.100.23.2`:

```text
O 172.20.32.0/24 [110/11] via 10.100.23.2, GigabitEthernet0/1
O 172.20.33.0/24 [110/11] via 10.100.23.2, GigabitEthernet0/1
O 172.20.34.0/24 [110/11] via 10.100.23.2, GigabitEthernet0/1
O 172.20.35.0/24 [110/11] via 10.100.23.2, GigabitEthernet0/1
```

O4 also retained the same four routes inside Area 10, each learned through `10.100.45.1` with metric 21:

```text
O 172.20.32.0/24 [110/21] via 10.100.45.1, GigabitEthernet0/1
O 172.20.33.0/24 [110/21] via 10.100.45.1, GigabitEthernet0/1
O 172.20.34.0/24 [110/21] via 10.100.45.1, GigabitEthernet0/1
O 172.20.35.0/24 [110/21] via 10.100.45.1, GigabitEthernet0/1
```

These observations proved that O3's routes and Area 10 reachability were intact. The fault was isolated to the ABR's inter-area advertisement behavior.

### 4. Inspect ABR policy

The O2 prefix list showed an explicit deny matching `172.20.32.0/22`, followed by a permit-all entry:

```text
ip prefix-list AREA10-TO-AREA0: 2 entries
   seq 5 deny 172.20.32.0/22 le 32
   seq 10 permit 0.0.0.0/0 le 32
```

The OSPF configuration showed that this list was attached as an outbound Area 10 filter. This directly explained why the `/22` Type 3 LSA no longer crossed the ABR boundary into Area 0.

### Observed IOS behavior

During the filtered state, the captured `show ip route ospf` output on O2 did not display the local `/22` Null0 summary, although all four `/24` component routes remained present. After the filter was detached, the local Null0 summary reappeared.

This is recorded only as behavior observed on the lab's IOS platform and software image. It should not be generalized to every IOS release or OSPF implementation without independent validation.

## Root Cause

The root cause was an outbound OSPF area prefix filter on O2:

```cisco
area 10 filter-list prefix AREA10-TO-AREA0 out
```

Its referenced prefix list explicitly denied the `172.20.32.0/22` aggregate. As a result, O2 stopped originating that Type 3 Summary LSA into Area 0 even though:

- O2 continued to learn the four component routes from O3.
- Area 10 retained internal reachability.
- Every O2 neighbor adjacency remained `FULL`.

The failure was therefore selective inter-area route suppression at the ABR, not loss of an OSPF neighbor or loss of the originating networks.

## Remediation

Only the filter attachment was removed from OSPF:

```cisco
configure terminal
router ospf 1
 no area 10 filter-list prefix AREA10-TO-AREA0 out
end
```

The `AREA10-TO-AREA0` prefix-list object was deliberately left in place initially. This controlled change proved that detaching the policy from OSPF—not deleting the prefix-list definition—restored the advertisement.

## Post-Fix Verification

### O2 route state

O2 again displayed the local aggregate and all four component routes:

```text
O 172.20.32.0/22 is a summary, Null0
O 172.20.32.0/24 [110/11] via 10.100.23.2, GigabitEthernet0/1
O 172.20.33.0/24 [110/11] via 10.100.23.2, GigabitEthernet0/1
O 172.20.34.0/24 [110/11] via 10.100.23.2, GigabitEthernet0/1
O 172.20.35.0/24 [110/11] via 10.100.23.2, GigabitEthernet0/1
```

### O2 adjacency state

All O2 neighbors remained `FULL` after remediation, confirming that the repair changed route advertisement policy without disrupting neighbor relationships.

### O1 routing table

O1 reinstalled the summary as an OSPF inter-area route:

```text
Routing entry for 172.20.32.0/22
Known via "ospf 1", distance 110, metric 21, type inter area
Last update from 10.100.12.2 on GigabitEthernet0/0
```

### O1 link-state database

The Type 3 Summary LSA also returned:

```text
LS Type: Summary Links(Network)
Link State ID: 172.20.32.0 (summary Network Number)
Advertising Router: 10.100.2.2
Network Mask: /22
MTID: 0         Metric: 11
```

The restored LSA and routing-table entry completed the end-to-end control-plane verification.

## Key Technical Takeaways

1. **Adjacency health is not route-advertisement health.** A `FULL` neighbor state does not prove that an ABR is advertising every expected Type 3 LSA.
2. **Check both the routing table and the link-state database.** Their combined absence on O1 distinguished a missing advertisement from a route-selection issue.
3. **Use observation points on both sides of the ABR.** O2 and O4 retaining the four `/24` routes proved that Area 10 and the route origin remained healthy.
4. **Audit route policy when failures are selective.** The prefix-list and its OSPF attachment precisely matched the missing aggregate.
5. **Change one variable during remediation.** Removing only the OSPF filter attachment demonstrated causality while leaving the policy object available for inspection.
6. **Treat platform-specific output carefully.** The disappearance of O2's local Null0 summary during filtering was documented as an observed IOS behavior, not a universal protocol rule.

## Commands Used

### Routing and OSPF verification

```cisco
show ip route 172.20.32.0
show ip ospf database summary 172.20.32.0
show ip ospf neighbor
show ip route ospf | include 172.20.32.0|172.20.33.0|172.20.34.0|172.20.35.0
```

### Policy and configuration inspection

```cisco
show ip prefix-list AREA10-TO-AREA0
show running-config | section router ospf
```

### Fault injection

```cisco
configure terminal
ip prefix-list AREA10-TO-AREA0 seq 5 deny 172.20.32.0/22 le 32
ip prefix-list AREA10-TO-AREA0 seq 10 permit 0.0.0.0/0 le 32
router ospf 1
 area 10 filter-list prefix AREA10-TO-AREA0 out
end
```

### Remediation

```cisco
configure terminal
router ospf 1
 no area 10 filter-list prefix AREA10-TO-AREA0 out
end
```

## Outcome

The investigation isolated a selective ABR policy failure without mistaking healthy OSPF adjacencies for healthy inter-area reachability. Removing the outbound Area 10 filter restored the `172.20.32.0/22` Type 3 LSA and the corresponding `O IA` route on O1 while preserving all neighbor adjacencies and Area 10 component routes.
