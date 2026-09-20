# PBR configurations and reproduction guide

These five files reconstruct the relevant baseline settings from the recorded configuration steps and device checks. They are **not complete running-config exports**. No PBR CML YAML was attached to the recovered lab record.

## Device files

| File | Role and important settings |
|---|---|
| [R1-PBR-SOURCE.cfg](R1-PBR-SOURCE.cfg) | Two source loopbacks, transit link and OSPF area 0 |
| [R2-PBR-POLICY.cfg](R2-PBR-POLICY.cfg) | Three transit links, source-A ACL and ingress PBR |
| [R3-PBR-ALT.cfg](R3-PBR-ALT.cfg) | Alternate branch between R2 and R4 |
| [R4-PBR-PRIMARY.cfg](R4-PBR-PRIMARY.cfg) | Normal branch and shared path to R5 |
| [R5-PBR-DEST.cfg](R5-PBR-DEST.cfg) | Destination loopback 10.5.5.5 and OSPF |

The files represent the **restored baseline policy**, not any deliberate fault state. Platform defaults, management access and unrelated settings are omitted.

## Build and verify

1. Create five IOSv routers and connect the five links in the [wiring guide](../topology.md).
2. Apply each device's file in configuration mode to a clean lab node. R2's file includes the final ingress-policy attachment.
3. To observe normal routing first, remove only `ip policy route-map PBR-TO-R3` from R2 Gi0/0 using its `no` form.
4. Verify OSPF neighbors and R2's route to 10.5.5.5. With the recorded topology and default costs, the baseline route used R4.
5. From R1, trace to 10.5.5.5 using source 10.1.1.1. Record the pre-policy path.
6. Reapply `ip policy route-map PBR-TO-R3` under R2 Gi0/0. Run both source-specific traces below and inspect R2's policy and destination route.

```cisco
traceroute 10.5.5.5 source 10.1.1.1
traceroute 10.5.5.5 source 10.11.11.11
```

The captured baseline uses R3 for source A and R4 directly for source B. Compare paths rather than expecting identical probe timings or counters. [Baseline evidence](../verification/01-baseline.md#block-06)

## Controlled changes

[Exercise commands](exercise-commands.md) reconstruct the classification, next-hop and sequencing tests. Establish the baseline before each exercise and restore it afterward.

| Test | Change | Restoration check |
|---|---|---|
| ACL classification | Deny source A, then permit any | ACL permits source A only |
| Next-hop fault | Shut R2 Gi0/1 | Next-hop subnet connected again; source A traverses R3 |
| Route-map sequencing | Deny 10 for source A, catch-all permit 20 | Single permit 10; source A uses R3 and source B uses R4 |

R1-generated traffic arrives at R2's ingress interface, so no local-policy command is required for these tests. The policy sets a normal next hop; recursive lookup and availability tracking are not configured.

[Back to PBR](../README.md)
