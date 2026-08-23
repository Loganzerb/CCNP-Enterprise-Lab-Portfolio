# Scenario 3: Inconsistent EIGRP Summarization Across Redundant Uplinks

## Objective

Demonstrate how inconsistent interface-level EIGRP summarization on redundant uplinks can create a mixed routing view without causing an immediate loss of reachability.

The fault was introduced on `R4-BRANCH` by removing the `172.16.40.0/22` summary from `GigabitEthernet0/1` only. This allowed the four component `/24` routes to be advertised toward `R3-DIST-B`, while the same networks continued to be advertised as a `/22` summary toward `R2-DIST-A` through `GigabitEthernet0/0`.

## Topology and Relevant Links

| Link | Addressing / next-hop relationship |
|---|---|
| R2-DIST-A ↔ R3-DIST-B | R3: `10.23.0.1`, R2: `10.23.0.2` |
| R2-DIST-A ↔ R4-BRANCH | R4: `10.24.0.1` |
| R3-DIST-B ↔ R4-BRANCH | R4: `10.34.0.2` |

Relevant R4 interfaces:

| R4-BRANCH interface | Neighbor | Intended advertisement |
|---|---|---|
| `GigabitEthernet0/0` | R2-DIST-A | `172.16.40.0/22` summary |
| `GigabitEthernet0/1` | R3-DIST-B | `172.16.40.0/22` summary |

The summary represents four component networks:

- `172.16.40.0/24`
- `172.16.41.0/24`
- `172.16.42.0/24`
- `172.16.43.0/24`

## Baseline

In the healthy state, R4 applies the same EIGRP summary on both distribution-facing interfaces:

```text
172.16.40.0/22 for Gi0/0, Gi0/1
  Summarizing 4 components
```

Consequently, both distribution routers learn only `172.16.40.0/22`. The component `/24` routes remain hidden behind the summary on both paths.

## Failure Injection

The summary was intentionally removed from only the R3-facing interface on `R4-BRANCH`:

```cisco
configure terminal
interface GigabitEthernet0/1
 no ip summary-address eigrp 100 172.16.40.0 255.255.252.0
end
```

The summary remained configured on `GigabitEthernet0/0` toward R2.

This produced asymmetric advertisements:

```text
R4 → R2: 172.16.40.0/22 summary
R4 → R3: 172.16.40.0/24 through 172.16.43.0/24 specifics
```

Because R2 and R3 were also EIGRP neighbors, each router propagated the routes learned from R4 to the other distribution router.

## Observed Symptoms

### R3-DIST-B: mixed summary and component routes

R3 learned two different representations of the branch networks:

- `172.16.40.0/22` indirectly from R2, with next hop `10.23.0.2`
- The component `/24` routes directly from R4, with next hop `10.34.0.2`

The verified source for `172.16.40.0/24` was R4:

```text
Routing entry for 172.16.40.0/24
Known via "eigrp 100", distance 90, type internal
Last update from 10.34.0.2
```

The `/22` summary reached R3 through R2:

```text
172.16.40.0/22 via 10.23.0.2
```

### R2-DIST-A: mixed summary and component routes

R2 also developed a mixed routing view:

- `172.16.40.0/22` directly from R4, with next hop `10.24.0.1`
- The component `/24` routes indirectly from R3, with next hop `10.23.0.1`

The `/22` route was verified as follows:

```text
Routing entry for 172.16.40.0/22
Known via "eigrp 100", distance 90, metric 130816, type internal
Last update from 10.24.0.1 on GigabitEthernet0/2

Routing Descriptor Blocks:
  10.24.0.1, from 10.24.0.1, via GigabitEthernet0/2
    Route metric is 130816
    Total delay is 5010 microseconds
    Minimum bandwidth is 1000000 Kbit
    Hops 1
```

The `172.16.40.0/24` route was verified independently:

```text
Routing entry for 172.16.40.0/24
Known via "eigrp 100", distance 90, metric 131072, type internal
Last update from 10.23.0.1 on GigabitEthernet0/1

Routing Descriptor Blocks:
  10.23.0.1, from 10.23.0.1, via GigabitEthernet0/1
    Route metric is 131072
    Total delay is 5020 microseconds
    Minimum bandwidth is 1000000 Kbit
    Hops 2
```

## Longest-Prefix-Match Implication

The simultaneous presence of a `/22` and its component `/24` routes does not create equal alternatives for forwarding. Route selection first uses the longest matching prefix, before comparing EIGRP metrics between different prefix lengths.

For a destination such as `172.16.40.10`:

- `172.16.40.0/22` matches the destination.
- `172.16.40.0/24` also matches the destination.
- The `/24` is more specific and therefore wins.

As a result, traffic for the leaked component networks followed the `/24` paths, even though a valid `/22` summary was also present. On R2, for example, traffic matching `172.16.40.0/24` preferred the indirect path through R3 (`10.23.0.1`) over the directly learned summary through R4 (`10.24.0.1`).

This is why reachability alone was not a sufficient health check: traffic could continue to pass while following an unintended path.

## Troubleshooting Methodology

1. **Inspect the routing table by prefix length.** Confirm whether the summary and component routes coexist rather than checking only for general reachability.
2. **Query the `/22` and `/24` independently.** Commands such as `show ip route 172.16.40.0 255.255.252.0` and `show ip route 172.16.40.0 255.255.255.0` expose each route's exact source.
3. **Trace the next hops.** The next-hop addresses proved that the summary and specifics arrived over different paths.
4. **Compare both distribution routers.** Seeing the reciprocal propagation pattern on R2 and R3 established that the fault was not isolated to one routing table.
5. **Inspect EIGRP address summarization on R4.** The configuration difference between the two redundant uplinks identified the failed control-plane policy.
6. **Restore symmetry and verify convergence.** Reapply the summary, then confirm that the component routes disappear from both distribution routing tables.

## Root Cause

The root cause was inconsistent interface-level summarization on `R4-BRANCH`.

`GigabitEthernet0/0` continued to advertise `172.16.40.0/22` toward R2, while `GigabitEthernet0/1` advertised the four component `/24` networks toward R3 after its summary statement was removed. EIGRP then propagated those distinct advertisements across the R2–R3 adjacency, giving both routers a mixture of the aggregate and the more-specific routes.

## Resolution

Restore the intended summary on the R3-facing interface of `R4-BRANCH`:

```cisco
configure terminal
interface GigabitEthernet0/1
 ip summary-address eigrp 100 172.16.40.0 255.255.252.0
end
```

## Post-Fix Validation

### R4-BRANCH

`show ip protocols` confirmed that the summary was again applied consistently to both distribution-facing interfaces and was built from all four component routes:

```text
Routing Protocol is "eigrp 100"
EIGRP-IPv4 Protocol for AS(100)

Automatic Summarization: disabled
Address Summarization:
  172.16.40.0/22 for Gi0/0, Gi0/1
    Summarizing 4 components with metric 128256
```

### R3-DIST-B

After convergence, R3 returned to a summary-only view:

```text
R3-DIST-B#show ip route eigrp | include 172.16.4
D        172.16.40.0 [90/130816] via 10.34.0.2, GigabitEthernet0/1
```

The component `/24` routes were no longer present.

### R2-DIST-A

R2 likewise returned to a summary-only view:

```text
R2-DIST-A#show ip route eigrp | include 172.16.4
D        172.16.40.0/22 [90/130816] via 10.24.0.1, GigabitEthernet0/2
```

The component `/24` routes learned indirectly through R3 were removed after reconvergence.

## Key Concepts

- **EIGRP manual summaries are interface-specific.** Configuring a summary on one outbound interface does not automatically apply it to another.
- **Redundant links require consistent routing policy.** A missing summary on only one uplink can affect routing tables beyond the directly connected neighbor.
- **More-specific routes win.** A `/24` is selected over a covering `/22` for matching traffic, regardless of the fact that the `/22` may have a preferable physical path or a slightly lower EIGRP metric.
- **Reachability does not prove path correctness.** The network stayed reachable while traffic could take unintended paths.
- **Next-hop inspection reveals propagation.** Querying the exact prefix and mask made it possible to distinguish direct advertisements from routes learned through the other distribution router.
- **Post-change validation must test policy symmetry.** Confirm both the summarizing interfaces and the downstream routing tables after restoration.

## Final Result

The lab demonstrated that removing one EIGRP summary statement from one redundant uplink caused four component routes to leak into the distribution layer. R3 learned the `/24` routes directly from R4 and the `/22` through R2; R2 learned the `/22` directly from R4 and the `/24` routes through R3. Restoring the summary on `R4-BRANCH GigabitEthernet0/1` returned both distribution routers to the intended summary-only routing view.
