# NAT/PAT verification guide

The `.txt` files preserve console output recorded during **MASTERCLASS CCNP LAB PART 3** (`6a94caeb-6ca4-83ea-93e3-f4eccdd6cbb5`). Each capture identifies its source message UUID. Only relevant NAT material is included.

HTML space entities, Markdown escapes, and line endings are normalized. Prompts, partial commands, original counters, timing variation, and occasional lab notes remain where they were part of a selected message. Separators and introductory provenance text are editorial metadata, not terminal output.

The [guided lab narrative](guided-labs.md) explains the progression. The [capture index](#capture-index) below links all 14 evidence files; the [configuration guide](../configs/README.md) covers fault exports, repaired settings, and diffs.

## Read captures correctly

- A source message may contain several sequential commands. A translation table and statistics collected afterward may differ because state ages.
- Cumulative counters are not per-test deltas unless paired before/after measurements establish that.
- NAT's top-level Misses and a pool's allocation misses are different reported fields; both are preserved.
- Protocol entries can appear alongside base mappings. Entry counts are not automatically client or allocated-address counts.
- ICMP rows contain identifiers; TCP rows contain port information. An extended row alone does not establish that overload is configured.
- Configuration snapshots, reported symptoms, interpretation, and measured results are labelled separately in the incident write-ups.

The [original fault exports](../configs/README.md) establish the starting configuration where initial CLI captures are unavailable. 

## Capture index

| Capture | What it records |
|---|---|
| [01-baseline-routing.txt](01-baseline-routing.txt) | Shows a successful routed baseline when ISP had a route to the private subnet, followed by 0/5 after that route was removed to make NAT necessary. |
| [02-static-nat.txt](02-static-nat.txt) | Shows the permanent static mapping, ISP host route, and successful inside- and outside-initiated tests for CLIENT-A. |
| [03-static-mapping-removal.txt](03-static-mapping-removal.txt) | Shows 0/5 and an alternating ISP/NAT-EDGE traceroute after removing the static mapping, then 5/5 after restoration. |
| [04-dynamic-nat.txt](04-dynamic-nat.txt) | Shows an empty dynamic pool before traffic and allocation of separate global addresses to CLIENT-A and CLIENT-B. |
| [05-pool-exhaustion.txt](05-pool-exhaustion.txt) | Shows two addresses fully allocated, failure from the third source 10.10.10.30, and successful reuse of an address after one mapping was deliberately cleared. |
| [06-interface-pat.txt](06-interface-pat.txt) | Shows interface overload on Gi0/0, both clients sharing 198.51.100.2, and two TCP sessions confirmed ESTAB on OUTSIDE-SRV. |
| [07-pool-pat.txt](07-pool-pat.txt) | Shows PAT-POOL overload and three inside source addresses sharing 192.0.2.10 while only one of two pool addresses is allocated. |
| [08-translation-aging.txt](08-translation-aging.txt) | Shows an ICMP entry with its captured timeout and remaining lifetime, followed by an empty table and released pool allocation. |
| [09-acl-failure-recovery.txt](09-acl-failure-recovery.txt) | Shows CLIENT-A succeeding while CLIENT-B fails under a host-only NAT ACL, then CLIENT-B recovering after subnet eligibility is restored. |
| [10-inside-role-failure-recovery.txt](10-inside-role-failure-recovery.txt) | Shows Gi0/1 missing its NAT inside role, an empty inside-interface list and 0/5, then restored classification, 5/5, and a translation. |
| [11-return-route-failure-recovery.txt](11-return-route-failure-recovery.txt) | Shows a PAT entry existing during 0/5 failure with no ISP route to its global address, then route restoration and 5/5 recovery. |
| [incident-01-repair-checkpoint.txt](incident-01-repair-checkpoint.txt) | Captures the temporary DYANIMIC-NAT typo: ACL matches and repaired routes were present, but the rule referenced DYNAMIC-NAT and no translations formed. |
| [incident-01-final.txt](incident-01-final.txt) | Preserves both 5/5 pings, two simultaneous one-to-one mappings, 29 hits, 0 misses, and 2/2 dynamic pool allocation. |
| [incident-02-final.txt](incident-02-final.txt) | Preserves final interface PAT configuration, both clients’ 20/20 and 50/50 pings, simultaneous ICMP and TCP tables, and 642 hits with 0 misses. |

## Primary commands

```cisco
show running-config | include ^ip nat
show running-config interface GigabitEthernet0/0
show running-config interface GigabitEthernet0/1
show access-lists NAT-SOURCES
show ip nat translations
show ip nat translations verbose
show ip nat statistics
show ip route
show tcp brief
```

Run endpoint tests as well as router checks. In the final PAT exercise, persistent sessions to `203.0.113.10:23` made simultaneous mappings easier to capture.

## Protocol references

Cisco describes overload as sharing global addresses through protocol/port state; both interface and pool forms are supported. See the Cisco NAT FAQ. The global translation limit is documented in the IOS IP Addressing Services Command Reference. These references explain mechanisms; the lab captures above establish this project's measured results.

[Module overview](../README.md) · [Case index](../troubleshooting/README.md)
