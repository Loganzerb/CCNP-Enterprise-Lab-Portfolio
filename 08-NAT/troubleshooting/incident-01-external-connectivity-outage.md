# Incident 01 — External connectivity outage

## Incident summary and impact

CLIENT-A (`10.10.10.10`) and CLIENT-B (`10.10.10.20`) could not reach OUTSIDE-SRV (`203.0.113.10`). The task was to restore both clients while retaining the devices, links, and addressing. The intended service used dynamic one-to-one NAT, so each active inside identity needed an available global pool address.

The incident contained four original faults. A fifth problem, an object-name typo, was introduced temporarily during remediation. Restoring one component could not repair the complete path.

## Expected forwarding behavior

Clients use `10.10.10.1` as their gateway through NAT-SW. NAT-EDGE receives their traffic on inside Gi0/1, selects eligible sources using `NAT-SOURCES`, assigns a global address from `DYNAMIC-NAT`, and sends traffic out Gi0/0 toward ISP `198.51.100.1`. ISP needs a route for replies to `192.0.2.0/24` through NAT-EDGE at `198.51.100.2`.

The target result was two coexisting base mappings and successful traffic from both clients. The two-address pool meets this lab requirement; it has no spare address while both mappings remain allocated.

## Evidence and its limits

- [Original fault lab](../configs/incident-01-original.yaml): direct configuration evidence for all four starting faults. It is not a transcript of initial device commands.
- [Repair checkpoint](../verification/incident-01-repair-checkpoint.txt): captured configuration, ACL, NAT state, and routing after several repairs, while the typo still prevented allocation.
- [Final verification](../verification/incident-01-final.txt): original client pings, translation table, and statistics.

The complete repair history is unavailable. The analysis groups the retained evidence by dependency.

## Diagnosis 1 — Inside NAT role missing

The original NAT-EDGE configuration assigned `10.10.10.1/24` to Gi0/1 but omitted `ip nat inside`. Gi0/0 already had `ip nat outside`. The source rule alone was therefore insufficient to classify traffic across the intended NAT boundary.

**Inspection:** compare `show running-config interface GigabitEthernet0/1` with `show ip nat statistics`. The original export establishes the missing setting; the later checkpoint lists Gi0/1 under Inside interfaces, establishing that this component had been repaired before the typo was resolved.

**Repair:** add `ip nat inside` under Gi0/1. Preserve its address and other interface settings.

**Why this was not the only fault:** correct interface roles cannot make CLIENT-B match an ACL that excludes it, add an ISP route, or create more pool capacity.

## Diagnosis 2 — ACL eligible for only one client

The original `NAT-SOURCES` standard ACL contained `permit host 10.10.10.10`. CLIENT-A qualified for translation; CLIENT-B did not. This ACL selected NAT sources. Its implicit deny did not, by itself, prove a packet was dropped at an interface filter.

**Inspection:** `show access-lists NAT-SOURCES` and the source statement identify what traffic qualifies and which pool is referenced. The repair checkpoint shows the subnet permit with 10 matches.

**Repair:** replace the host-only permit with `permit 10.10.10.0 0.0.0.255`.

**Why matches were not enough:** a match shows eligibility, not successful global address allocation or completed return traffic. This distinction became decisive at the typo checkpoint.

## Diagnosis 3 — ISP missing the pool return route

The original ISP configuration lacked the route to `192.0.2.0/24`. Replies are addressed to the translated global address, so the outside network must be able to route that address back to NAT-EDGE.

**Inspection:** check NAT-EDGE's default route and ISP's route to a pool address separately. The repair checkpoint retains NAT-EDGE's default via `198.51.100.1` and ISP's restored `S 192.0.2.0/24 [1/0] via 198.51.100.2`.

**Repair on ISP:** `ip route 192.0.2.0 255.255.255.0 198.51.100.2`.

**Why it matters:** even a valid NAT translation cannot compensate for missing return routing. The guided return-route experiment independently demonstrated an existing translation during failed pings; the incident's starting-route diagnosis comes from its own exported configuration.

## Diagnosis 4 — One address for two active identities

The original pool was:

```cisco
ip nat pool DYNAMIC-NAT 192.0.2.10 192.0.2.10 netmask 255.255.255.0
ip nat inside source list NAT-SOURCES pool DYNAMIC-NAT
```

Its start and end were identical, and the source statement did not contain `overload`. Once one inside identity held the address, a second could not receive its own simultaneous one-to-one allocation.

**Inspection:** compare start/end addresses and the active mapping, then inspect the pool allocation fields in `show ip nat statistics`. Counting table rows alone can be misleading because a base mapping and a protocol-specific entry may coexist.

**Repair:** expand the ending address to `192.0.2.11`, retaining dynamic NAT without overload. Migrating to PAT would change the exercise's intended mode rather than demonstrate the repaired two-address design.

**Capacity result:** final pool allocation was 2/2 (100%) with zero allocation misses. Full utilization is expected here and shows both available addresses were in use; it does not establish spare capacity for a third identity.

## Repair complication — DYANIMIC-NAT versus DYNAMIC-NAT

The retained checkpoint contains:

```cisco
ip nat pool DYANIMIC-NAT 192.0.2.10 192.0.2.11 netmask 255.255.255.0
ip nat inside source list NAT-SOURCES pool DYNAMIC-NAT
```

At this point the inside role, subnet ACL, and ISP route were already repaired. The ACL had 10 matches, but NAT reported zero active translations and the source mapping had `refcount 0`. No pool address range was displayed beneath the referenced mapping.

Those observations narrowed the remaining investigation to the referenced pool object. The rule used `DYNAMIC-NAT`, while the actual definition used `DYANIMIC-NAT`. Correcting the object name aligned the intended design with the configured reference. This was a temporary repair entry error, distinct from the four faults in the original YAML.

The checkpoint also showed top-level `Hits: 0  Misses: 0`. Zero misses alone did not establish a working service: no valid translations existed and no successful endpoint result had yet been captured.

## Consolidated repair reference

The following summarizes the intended changes; it is not a captured paste sequence. Pool edits may require stopping test traffic and clearing affected lab translations before editing an in-use mapping. State clearing is a transition step, not a recurring workaround.

```cisco
! NAT-EDGE, target repair settings
interface GigabitEthernet0/1
 ip nat inside
ip access-list standard NAT-SOURCES
 no permit host 10.10.10.10
 permit 10.10.10.0 0.0.0.255
exit
! Replace the original one-address pool with this definition.
ip nat pool DYNAMIC-NAT 192.0.2.10 192.0.2.11 netmask 255.255.255.0
ip nat inside source list NAT-SOURCES pool DYNAMIC-NAT
! If present from the intermediate repair, remove the unused DYANIMIC-NAT object.
```

```cisco
! ISP
ip route 192.0.2.0 255.255.255.0 198.51.100.2
```

Review the [NAT-EDGE final configuration](../configs/incident-01-NAT-EDGE-final.cfg), [ISP final configuration](../configs/incident-01-ISP-final.cfg), and their [NAT-EDGE](../configs/incident-01-NAT-EDGE-changes.diff) / [ISP](../configs/incident-01-ISP-changes.diff) diffs for the exact reconstructed final state.

## Final verification and closure

| Captured check | Result | What it establishes |
|---|---|---|
| CLIENT-A ping to `203.0.113.10` | 5/5, 100%; 4/4/5 ms | Successful endpoint reachability in this run. |
| CLIENT-B ping to `203.0.113.10` | 5/5, 100%; 3/204/1006 ms | Successful endpoint reachability; retains the actual latency variation. |
| Base translation 1 | `10.10.10.10 → 192.0.2.10` | CLIENT-A had a global address. |
| Base translation 2, same table | `10.10.10.20 → 192.0.2.11` | CLIENT-B had a different global address concurrently. |
| Active translations | 2: 0 static, 2 dynamic, 0 extended | Both base dynamic mappings remained present at capture time. |
| NAT statistics | 29 hits; 0 misses | Recorded cumulative counters at closure, not a per-ping packet accounting. |
| Pool | 2 addresses; 2 allocated (100%); 0 misses | Both required allocations were available without allocation misses in this snapshot. |
| Other counters | 29 CEF translated; 15 CEF punted; 0 queued | Actual reported values; the nonzero punt count is retained. |

The pings establish reachability and the same translation table establishes coexistence. The retained text does not time-stamp both ping runs to prove their exact overlap. It does support two simultaneously allocated identities. Save confirmation, packet captures, and long-duration stability measurements are unavailable.

## Lessons carried forward

Check the whole dependency chain: interface role → source eligibility → mapping reference → pool capacity → forward and return routing → endpoint proof. The strongest clue at the intermediate checkpoint was the combination of ACL matches with zero translations and an unresolved pool reference. It prevented repeating repairs to components already shown healthy.

Keep measurement and interpretation separate. A full pool can be healthy for two clients but inadequate for three; zero misses can coexist with failure; successful short pings do not erase an observed latency spike or prove sustained performance.
