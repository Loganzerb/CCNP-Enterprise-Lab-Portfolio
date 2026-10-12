# IP SLA configuration and controlled failover

The [public CML export](../CML-LAB.yaml) preserves the supplied, already sanitized four-router configuration. The router files are exact extracts of its decoded configuration fields. The package describes them as a sanitized reconstruction of the original working lab; they are not new running-config captures.

| Artifact | Purpose |
|---|---|
| [R1-BRANCH.cfg](R1-BRANCH.cfg) | Probe, Track 10, primary and floating defaults, pinned probe route |
| [R2-ISP-A.cfg](R2-ISP-A.cfg) | Primary path to both R4 test addresses and return route to R1 |
| [R3-ISP-B.cfg](R3-ISP-B.cfg) | Backup path to both R4 test addresses and return route to R1 |
| [R4-TARGET.cfg](R4-TARGET.cfg) | Separate probe/application loopbacks and floating return routes |

## Probe and route settings

**Saved configuration excerpt — R1 YAML.** This is configuration, not runtime output.

```cisco
ip sla 10
 icmp-echo 10.40.40.40 source-ip 10.100.1.1
 threshold 1000
 timeout 2000
 frequency 10
ip sla schedule 10 life forever start-time now
track 10 ip sla 10 reachability
ip route 0.0.0.0 0.0.0.0 10.12.12.2 track 10
ip route 0.0.0.0 0.0.0.0 10.13.13.2 200
ip route 10.40.40.40 255.255.255.255 10.12.12.2
```

| Setting | Role in this exercise |
|---|---|
| Operation 10 | ICMP Echo to R4 `10.40.40.40`, sourced from R1 `10.100.1.1` |
| Frequency / timeout / threshold | 10 seconds / 2000 ms / 1000 ms; the supplied lab demonstrated the threshold/timeout scheduling pitfall |
| Track 10 | Uses operation 10 reachability to control the primary default |
| Default through `10.12.12.2` | Primary ISP-A route, tied to Track 10; observed AD 1 |
| Default through `10.13.13.2`, AD 200 | Floating ISP-B route available after the primary default is withdrawn |
| Host route for `10.40.40.40/32` | Keeps the probe through ISP-A while its primary next hop remains resolvable |

The application test address is **`10.40.40.41`**. R1 has no separate host route for it, so its traffic follows the active default. Keeping the probe target distinct prevents backup-path success from being mistaken for primary-path recovery in the controlled outage.

**Saved return-route excerpt — R4 YAML.**

```cisco
ip route 10.100.1.1 255.255.255.255 10.24.24.1
ip route 10.100.1.1 255.255.255.255 10.34.34.1 200
```

R4 is configured to prefer the return path through ISP-A, with an AD 200 alternative through ISP-B. These routes depend on next-hop resolution; Track 10 runs on R1. No R4 route-output excerpt was supplied to demonstrate return-route selection. Preserve both routes when repeating the experiment.

## Import and baseline checks

**Reproduction instructions — fresh import and runtime execution remain pending.** The following steps describe how to repeat the supplied lab; they are not additional test evidence.

1. Import `CML-LAB.yaml` with compatible CSR1000v and IOSv images. Check the [four port-specific links](../topology.md#physical-wiring), especially R2 Gi0/1 to R4 Gi0/1 and R3 Gi0/1 to R4 Gi0/0.
2. Start the routers and inspect interfaces, neighbor identities, and saved routes. Check that the branch loopback can reach both R4 loopbacks. Use local CML access settings.
3. On R1, inspect `show ip sla configuration 10`, `show ip sla statistics 10`, `show track 10`, `show ip route 0.0.0.0`, and `show ip route 10.40.40.40`. Confirm the configured source/target, an operating probe, and the intended primary path before changing anything.

Historical counters, elapsed times, and RTT values are not stored in the YAML. Compare state and route selection with the [supplied verification](../verification/README.md), rather than expecting the historical measurements to repeat.

## Exercise the upstream outage and restore it

The controlled fault is **R2-ISP-A GigabitEthernet0/1**, its link to R4. Keep R1's Gi1 link to R2 in service so the probe can detect a failure beyond the branch's directly connected interface.

**Reproduction commands — temporary change on R2, not a supplied console transcript.**

```cisco
configure terminal
interface GigabitEthernet0/1
 shutdown
end
```

After probe failure is detected, inspect Track 10 and the active default on R1. Check that R1 Gi1 remains `up/up`, then test `10.40.40.41` from `10.100.1.1` and inspect its traceroute. The supplied lab recorded backup forwarding through R3; it did not measure uninterrupted traffic during the transition.

**Reproduction commands — restore the same R2 interface.**

```cisco
configure terminal
interface GigabitEthernet0/1
 no shutdown
end
```

Observe probe recovery, Track 10 Up, and the primary default through R2. Check the application traceroute again and leave the temporary fault removed. The supplied configuration remains in this restored state.

Probe frequency and timeout affect when state changes are detected. No exact cutover duration or zero-loss guarantee is inferred from the recorded state transitions and later forwarding tests.

## Export scope

The supplied sanitized YAML was independently scanned for actual PKI, device/license identifiers, and saved credentials; none required further removal. Its bytes, node/image definitions, interface IDs, links, and route behavior are preserved. All four router extracts match its configuration fields. Parsing and static consistency checks have passed; the public file has not been freshly imported, booted, or rerun during portfolio preparation.

[Overview](../README.md) · [Topology](../topology.md) · [Operation](../operation.md) · [Verification](../verification/README.md) · [Evidence scope](../scope.md)
