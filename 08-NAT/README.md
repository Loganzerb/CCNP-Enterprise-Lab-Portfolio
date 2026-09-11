# 08 — Network Address Translation and PAT

## Project objective

This Cisco Modeling Labs project follows NAT from routed reachability through static translation, dynamic address allocation, pool exhaustion, interface PAT, pool PAT, state aging, and fault isolation. It concludes with two integrated incidents that connect symptoms to evidence, targeted repairs, and measured recovery.

The working method is **predict → configure → verify → explain → break → troubleshoot → repair → capture evidence**. Guided exercises are concise; the incident case studies document the reasoning in greater depth.

## Topology and addressing

![NAT lab topology in the portfolio visual style](topology.png)

Both clients reach NAT-EDGE through NAT-SW. Gi0/1 is NAT-EDGE's inside boundary; Gi0/0 connects to ISP. ISP forwards to OUTSIDE-SRV. The illustration redraws the recorded topology in the same visual style as the FHRP and EtherChannel portfolio diagrams. Device names, addressing, and port connections follow the lab record; the illustration is not additional verification evidence.

| Device / role | Address or connection |
|---|---|
| CLIENT-A Gi0/0 | `10.10.10.10/24`; gateway `10.10.10.1`; NAT-SW Gi0/0 |
| CLIENT-B Gi0/0 | `10.10.10.20/24`; gateway `10.10.10.1`; NAT-SW Gi0/1 |
| Extra guided source on CLIENT-B | Secondary `10.10.10.30/24`, used to test a third inside identity |
| NAT-SW Gi0/2 | Connects to NAT-EDGE Gi0/1; inside access VLAN 10 |
| NAT-EDGE inside Gi0/1 | `10.10.10.1/24` |
| NAT-EDGE outside Gi0/0 | `198.51.100.2/30`; default route via `198.51.100.1` |
| ISP Gi0/0 / Gi0/1 | `198.51.100.1/30` / `203.0.113.1/24` |
| OUTSIDE-SRV Gi0/0 | `203.0.113.10/24`; gateway `203.0.113.1` |
| Static NAT global | `198.51.100.10`, routed by an ISP `/32` toward NAT-EDGE |
| Dynamic NAT / pool PAT range | `192.0.2.10–192.0.2.11`, routed by ISP via `198.51.100.2` |
| Interface PAT global | `198.51.100.2` |

These are isolated lab addresses. Here, **inside local** is the client's original address, **inside global** is its translated identity, and the server's outside-local and outside-global values are both `203.0.113.10` in the retained tables.

## Guided lab progression

| Exercise | Demonstrated outcome |
|---|---|
| Routed baseline | A return route restores 5/5; removing it establishes the need for a translated identity with outside reachability. |
| Static NAT | Permanent one-to-one mapping; both directions tested; removal causes failure and a routing loop, restoration recovers service. |
| Dynamic NAT | Traffic creates mappings; two clients acquire different global addresses. |
| Pool exhaustion | A third source fails with both addresses allocated, then succeeds after an address is released. |
| Interface PAT | Both clients share Gi0/0's address; TCP sessions are also confirmed at the server. |
| Pool PAT | Three source identities share one allocated global address from a two-address pool. |
| Aging and controlled failures | Observe ICMP lifetime; isolate ACL selection, interface roles, and return routing independently. |

Read the [guided lab narrative](verification/guided-labs.md) for the short explanations and linked captures.

## Troubleshooting highlights

### Incident 01 — External connectivity outage

Four original faults affected inside classification, source ACL coverage, ISP return routing, and dynamic pool capacity. A temporary `DYANIMIC-NAT` versus `DYNAMIC-NAT` typo then prevented allocation despite ACL matches and repaired routes. Final proof shows both clients at 5/5, coexisting `.10 → 192.0.2.10` and `.20 → 192.0.2.11` mappings, two active dynamic translations, 29 hits, zero misses, and 2/2 pool allocation.

[Read the full Incident 01 case study](troubleshooting/incident-01-external-connectivity-outage.md).

### Incident 02 — External access after PAT migration

The overload rule selected inside Gi0/1 rather than outside Gi0/0, and a one-entry translation limit prevented the required concurrent state. Final evidence shows both clients achieving 20/20 and 50/50, simultaneous ICMP mappings, and persistent Telnet TCP mappings sharing `198.51.100.2`. The later statistics show two dynamic extended entries, 642 hits, zero misses, and zero queued packets.

Persistent TCP/Telnet sessions were intentionally used to capture stable simultaneous PAT state because ICMP entries were short-lived. The ping and TCP captures serve complementary purposes: endpoint reachability and inspectable concurrent state.

[Read the full Incident 02 case study](troubleshooting/incident-02-pat-migration.md).

## Repository map

```text
08-NAT/
├── README.md
├── topology.png
├── configs/          # Original fault labs, reconstructed final configs, exact diffs
├── verification/     # Guided summaries and retained CLI evidence
└── troubleshooting/  # Detailed incident case studies
```

## Evidence standard

The CLI evidence comes from user-pasted output in **MASTERCLASS CCNP LAB PART 3**, conversation `6a94caeb-6ca4-83ea-93e3-f4eccdd6cbb5`. Source message IDs are retained in each capture. Chat formatting is normalized; device results are not invented. Original incident YAMLs establish starting faults. Final configuration files are explicitly labelled reconstructions from those exports and the observed repairs, not fresh running-config captures.

Incident 02's unused `DYNAMIC-NAT` pool is removed only in the clean delivered configuration; the original successful verification output still shows it. All unrelated configuration is preserved. No new CML tests, device saves, Git commits, or pushes are claimed. The incident write-ups identify evidence limits, including the absence of a time-ordered reverse-start overlap capture for Incident 02.

## Artifact index

Every technical artifact is linked below with its purpose and interpretation. Folder guides: [Configurations](configs/README.md) · [Verification](verification/README.md) · [Troubleshooting](troubleshooting/README.md).

| Artifact | Plain-English summary |
|---|---|
| [verification/01-baseline-routing.txt](verification/01-baseline-routing.txt) | Shows a successful routed baseline when ISP had a route to the private subnet, followed by 0/5 after that route was removed to make NAT necessary. |
| [verification/02-static-nat.txt](verification/02-static-nat.txt) | Shows the permanent static mapping, ISP host route, and successful inside- and outside-initiated tests for CLIENT-A. |
| [verification/03-static-mapping-removal.txt](verification/03-static-mapping-removal.txt) | Shows 0/5 and an alternating ISP/NAT-EDGE traceroute after removing the static mapping, then 5/5 after restoration. |
| [verification/04-dynamic-nat.txt](verification/04-dynamic-nat.txt) | Shows an empty dynamic pool before traffic and allocation of separate global addresses to CLIENT-A and CLIENT-B. |
| [verification/05-pool-exhaustion.txt](verification/05-pool-exhaustion.txt) | Shows two addresses fully allocated, failure from the third source 10.10.10.30, and successful reuse of an address after one mapping was deliberately cleared. |
| [verification/06-interface-pat.txt](verification/06-interface-pat.txt) | Shows interface overload on Gi0/0, both clients sharing 198.51.100.2, and two TCP sessions confirmed ESTAB on OUTSIDE-SRV. |
| [verification/07-pool-pat.txt](verification/07-pool-pat.txt) | Shows PAT-POOL overload and three inside source addresses sharing 192.0.2.10 while only one of two pool addresses is allocated. |
| [verification/08-translation-aging.txt](verification/08-translation-aging.txt) | Shows an ICMP entry with its captured timeout and remaining lifetime, followed by an empty table and released pool allocation. |
| [verification/09-acl-failure-recovery.txt](verification/09-acl-failure-recovery.txt) | Shows CLIENT-A succeeding while CLIENT-B fails under a host-only NAT ACL, then CLIENT-B recovering after subnet eligibility is restored. |
| [verification/10-inside-role-failure-recovery.txt](verification/10-inside-role-failure-recovery.txt) | Shows Gi0/1 missing its NAT inside role, an empty inside-interface list and 0/5, then restored classification, 5/5, and a translation. |
| [verification/11-return-route-failure-recovery.txt](verification/11-return-route-failure-recovery.txt) | Shows a PAT entry existing during 0/5 failure with no ISP route to its global address, then route restoration and 5/5 recovery. |
| [verification/incident-01-repair-checkpoint.txt](verification/incident-01-repair-checkpoint.txt) | Captures the temporary DYANIMIC-NAT typo: ACL matches and repaired routes were present, but the rule referenced DYNAMIC-NAT and no translations formed. |
| [verification/incident-01-final.txt](verification/incident-01-final.txt) | Preserves both 5/5 pings, two simultaneous one-to-one mappings, 29 hits, 0 misses, and 2/2 dynamic pool allocation. |
| [verification/incident-02-final.txt](verification/incident-02-final.txt) | Preserves final interface PAT configuration, both clients’ 20/20 and 50/50 pings, simultaneous ICMP and TCP tables, and 642 hits with 0 misses. |
| [configs/incident-01-original.yaml](configs/incident-01-original.yaml) | Original, unchanged Incident 01 CML fault lab; preserves the starting configuration and topology for reproduction. |
| [configs/incident-02-original.yaml](configs/incident-02-original.yaml) | Original, unchanged Incident 02 CML fault lab; preserves the starting configuration and topology for reproduction. |
| [configs/incident-01-NAT-EDGE-final.cfg](configs/incident-01-NAT-EDGE-final.cfg) | Incident 01 NAT-EDGE configuration reconstructed from its original export; only the documented NAT/routing repairs are applied. |
| [configs/incident-01-NAT-EDGE-changes.diff](configs/incident-01-NAT-EDGE-changes.diff) | Exact comparison showing all changes to Incident 01 NAT-EDGE; unrelated configuration is preserved. |
| [configs/incident-01-ISP-final.cfg](configs/incident-01-ISP-final.cfg) | Incident 01 ISP configuration reconstructed from its original export; only the documented NAT/routing repairs are applied. |
| [configs/incident-01-ISP-changes.diff](configs/incident-01-ISP-changes.diff) | Exact comparison showing all changes to Incident 01 ISP; unrelated configuration is preserved. |
| [configs/incident-02-NAT-EDGE-final.cfg](configs/incident-02-NAT-EDGE-final.cfg) | Incident 02 NAT-EDGE configuration reconstructed from its original export; only the documented NAT/routing repairs are applied. |
| [configs/incident-02-NAT-EDGE-changes.diff](configs/incident-02-NAT-EDGE-changes.diff) | Exact comparison showing all changes to Incident 02 NAT-EDGE; unrelated configuration is preserved. |
| [configs/incident-02-ISP-final.cfg](configs/incident-02-ISP-final.cfg) | Incident 02 ISP configuration reconstructed from its original export; ISP is preserved unchanged, including its existing pool return route. |
| [configs/guided-mode-snippets.cfg](configs/guided-mode-snippets.cfg) | Explains the four guided NAT modes through separate reference snippets; device labels distinguish NAT-EDGE commands from ISP routes. |
| [topology.png](topology.png) | Portfolio-style illustration of the recorded lab topology, showing both clients, switch ports, NAT-EDGE, ISP, OUTSIDE-SRV, and the final shared PAT address. |
| [verification/guided-labs.md](verification/guided-labs.md) | Concise guided lab narrative connecting predictions, observed behavior, and recovery across all completed NAT/PAT exercises. |
| [troubleshooting/incident-01-external-connectivity-outage.md](troubleshooting/incident-01-external-connectivity-outage.md) | Detailed Incident 01 case study covering four original faults, the temporary pool-name typo, evidence-driven isolation, repairs, and exact closure results. |
| [troubleshooting/incident-02-pat-migration.md](troubleshooting/incident-02-pat-migration.md) | Detailed Incident 02 case study covering the wrong PAT interface, one-entry translation limit, targeted cleanup, and stable concurrent TCP/ICMP evidence. |

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

## Skills demonstrated

- Distinguishing configured mappings, active protocol state, and allocated global addresses.
- Diagnosing NAT eligibility, interface roles, object references, capacity, and return paths separately.
- Comparing one-to-one dynamic NAT with interface- and pool-based overload.
- Preserving measured results while explaining what each capture can and cannot establish.
- Applying limited repairs and producing reviewable final configurations.

## Technical references

Cisco describes overload as sharing global addresses through protocol/port state; both interface and pool forms are supported. See the [Cisco NAT FAQ](https://www.cisco.com/c/en/us/support/docs/ip/network-address-translation-nat/26704-nat-faq-00.pdf). The global translation limit is documented in the [IOS IP Addressing Services Command Reference](https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/ipaddr/command/ipaddr-cr-book/ipaddr-i4.html). These references explain mechanisms; the lab captures above establish this project's measured results.
