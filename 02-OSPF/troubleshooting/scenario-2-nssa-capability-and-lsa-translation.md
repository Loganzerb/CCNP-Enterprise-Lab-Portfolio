# Scenario 2: NSSA Capability Mismatch and Type 7-to-Type 5 LSA Translation Failure

## Objective

Diagnose and recover a multi-area Open Shortest Path First (OSPF) failure caused by a Not-So-Stubby Area (NSSA) capability mismatch in Area 10. The investigation follows two redistributed prefixes through the complete external-route pipeline:

- `192.0.2.0/24`
- `198.51.100.0/24`

The lab demonstrates how one incorrect area-level command on `O4-EDGE` disrupted neighbor formation, Type 7 Link-State Advertisement (LSA) propagation, Type 7-to-Type 5 translation, and route installation in Area 0.

## Topology and Device Roles

| Device | Role in this scenario |
|---|---|
| `O4-EDGE` | Autonomous System Boundary Router (ASBR) in Area 10; originates both external prefixes and normally participates in Area 10 as an NSSA router |
| `O2-ABR` | Area Border Router (ABR) between Area 10 NSSA and Area 0; performs Type 7-to-Type 5 LSA translation |
| `O5` | Area 10 OSPF neighbor of `O4-EDGE` |
| `O1-CORE` | Area 0 router that receives the translated Type 5 LSAs and installs the external routes as `O E1` |

## Healthy Baseline

Under normal operation, the external-route pipeline was:

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

`O4-EDGE` originated both prefixes as Type 7 LSAs with the following attributes:

| Prefix | LSA type | Metric type | Metric | Advertising Router |
|---|---:|---:|---:|---|
| `192.0.2.0/24` | 7 | 1 | 20 | `10.100.4.4` (`O4-EDGE`) |
| `198.51.100.0/24` | 7 | 1 | 20 | `10.100.4.4` (`O4-EDGE`) |

`O2-ABR` reported `Perform type-7/type-5 LSA translation`. It translated the Type 7 LSAs into Type 5 LSAs, with `O2-ABR` appearing as the Advertising Router for the translated advertisements. `O1-CORE` then installed both prefixes as OSPF external type 1 (`O E1`) routes.

## Fault Injection

The failure was introduced on `O4-EDGE` only:

```cisco
configure terminal
router ospf 1
 no area 10 nssa
end
```

No matching change was made on `O2-ABR` or `O5`.

## Observed Symptoms

Removing the NSSA declaration from `O4-EDGE` immediately reset its OSPF adjacencies to `O2-ABR` and `O5`. Both neighbors remained `DOWN`, and their dead timers later expired.

The area status exposed the inconsistency:

- `O2-ABR` still identified Area 10 as an NSSA and remained translation-capable.
- `O4-EDGE` no longer identified Area 10 as an NSSA.

This was direct evidence of an OSPF area capability mismatch rather than a loss of the external source prefixes.

The failure produced different database states on each router:

| Device | Failure-state evidence |
|---|---|
| `O4-EDGE` | No Type 7 LSAs; instead, it self-originated Type 5 LSAs for `192.0.2.0/24` and `198.51.100.0/24` |
| `O2-ABR` | Retained stale Type 7 LSAs originated by `O4-EDGE` while they aged, but had no translated Type 5 LSAs and no OSPF routes for either prefix |
| `O1-CORE` | Had neither Type 5 LSAs nor `O E1` routes for the prefixes |

## Troubleshooting Process

### 1. Verify neighbor state

The first check confirmed that the fault affected OSPF adjacency formation, not merely route selection. On `O4-EDGE`, the adjacencies to both `O2-ABR` and `O5` reset immediately after the configuration change, stayed down, and eventually aged out.

### 2. Compare area capabilities

The OSPF process output on both sides was compared. `O2-ABR` continued to report Area 10 as an NSSA and identified itself as able to perform Type 7-to-Type 5 translation. `O4-EDGE` no longer reported Area 10 as an NSSA.

Because OSPF neighbors must agree on the area type, the one-sided configuration change prevented the routers from reestablishing adjacency.

### 3. Trace the prefixes through each LSDB

The Link-State Database (LSDB) was inspected hop by hop rather than assuming that the presence of an LSA meant the route was usable:

- `O4-EDGE` no longer originated Type 7 LSAs in Area 10 and instead held self-originated Type 5 LSAs.
- `O2-ABR` still displayed the previously learned Type 7 LSAs while they aged.
- `O2-ABR` had no corresponding translated Type 5 LSAs.
- `O1-CORE` had no Type 5 LSAs for either external prefix.

### 4. Correlate the LSDB with the routing table

`O2-ABR` had no OSPF routes for either prefix during the failure even though stale Type 7 LSAs were still visible in its LSDB. `O1-CORE` likewise had no `O E1` routes.

This distinction was decisive: an aging LSA can remain visible after the adjacency and valid forwarding path have disappeared. LSDB presence alone does not prove an active route, a usable next hop, or ongoing Type 7-to-Type 5 translation.

## Control-Plane Impact

The one-sided area-type change broke the control plane in stages:

1. `O4-EDGE` no longer agreed with its neighbors that Area 10 was an NSSA.
2. OSPF adjacencies from `O4-EDGE` to `O2-ABR` and `O5` could not remain established.
3. `O4-EDGE` stopped originating the two prefixes as Type 7 LSAs into Area 10.
4. `O2-ABR` lost the active NSSA external routes required for translation.
5. Type 7-to-Type 5 translation ceased, despite stale Type 7 LSAs remaining temporarily visible.
6. `O1-CORE` lost both Type 5 LSAs and both `O E1` routes.

`O2-ABR` retaining the NSSA and translator configuration was not sufficient: translation requires active, valid Type 7 information learned through a functioning NSSA control plane.

## Root Cause

The root cause was a one-sided removal of the Area 10 NSSA declaration under OSPF process 1 on `O4-EDGE`:

```cisco
no area 10 nssa
```

This created an OSPF area capability mismatch between `O4-EDGE` and its Area 10 neighbors. The mismatch prevented adjacency formation and severed the Type 7-to-Type 5 external-route pipeline.

## Remediation

The NSSA declaration was restored on `O4-EDGE`:

```cisco
configure terminal
router ospf 1
 area 10 nssa
end
```

The OSPF process was **not** cleared. Restoring the correct area capability allowed the protocol to converge normally without a disruptive process reset.

## Post-Fix Verification

After the correction:

- The `O4-EDGE` adjacencies to `O2-ABR` and `O5` returned to `FULL`.
- `O4-EDGE` again reported `It is a NSSA area` for Area 10.
- `O4-EDGE` resumed originating Type 7 LSAs for both prefixes with metric type 1 and metric 20.
- `O2-ABR` relearned both routes as NSSA external type 1 (`O N1`).
- `O2-ABR` translated the Type 7 LSAs into Type 5 LSAs, with `O2-ABR` as the Advertising Router.
- `O1-CORE` received the Type 5 LSAs and reinstalled both prefixes as `O E1` routes.

The recovered `O2-ABR` routing-table entries were:

```text
O N1  192.0.2.0/24 [110/31] via 10.100.24.2, GigabitEthernet0/2
O N1  198.51.100.0/24 [110/31] via 10.100.24.2, GigabitEthernet0/2
```

The restored Type 7 evidence on `O4-EDGE` included:

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

An incidental `%BGP-5-ADJCHANGE: neighbor 10.100.2.2 Up` message appeared as OSPF reachability recovered. This was a downstream effect of restored underlay connectivity, not the focus or root cause of the incident.

## Key Technical Takeaways

- OSPF area types must match between neighbors. A one-sided NSSA change can reset adjacencies and keep them down even when interfaces remain operational.
- An NSSA ASBR originates redistributed external routes as Type 7 LSAs inside the NSSA.
- An NSSA ABR translates eligible Type 7 LSAs into Type 5 LSAs for propagation into the OSPF backbone.
- In this lab, `O4-EDGE` was the Type 7 originator, while `O2-ABR` was the Type 5 Advertising Router after translation.
- Translator capability shown in configuration or process output does not prove that translation is currently occurring.
- Stale LSAs can outlive the adjacency and route that produced them. Always correlate LSDB state with neighbor state, LSA age, translated advertisements, and the routing table.
- The least disruptive repair was to restore the missing NSSA command and allow normal convergence; clearing the OSPF process was unnecessary.
- Following a route across the entire control-plane chain made the failure boundary explicit and prevented a stale LSDB entry from being mistaken for a healthy route.

## Commands Used

### Neighbor and area-capability checks

```cisco
show ip ospf neighbor
show ip ospf | section Area 10
```

### Type 7 and Type 5 LSA inspection

```cisco
show ip ospf database nssa-external
show ip ospf database external
```

### Prefix-specific routing-table verification

```cisco
show ip route ospf | include 192.0.2.0|198.51.100.0
```

### Fault injection

```cisco
configure terminal
router ospf 1
 no area 10 nssa
end
```

### Remediation

```cisco
configure terminal
router ospf 1
 area 10 nssa
end
```

## Final Result

Restoring Area 10's NSSA configuration on `O4-EDGE` repaired neighbor formation and reestablished the full external-route lifecycle: Type 7 origination by the ASBR, `O N1` route learning and Type 7-to-Type 5 translation by the ABR, and `O E1` installation on the Area 0 core router.
