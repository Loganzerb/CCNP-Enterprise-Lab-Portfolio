# 08 — NAT/PAT: Restore connectivity through translation faults

A correct route or matching access list does not guarantee successful address translation. This Cisco Modeling Labs project follows traffic from source eligibility through translation state, pool capacity, and return routing.

Guided exercises compare static NAT, dynamic NAT, and shared-address PAT. Two integrated incidents then combine those dependencies and verify recovery from both clients.

**Two clients · Four translation modes · Two integrated incidents · 14 evidence captures**

**Start here:** [Restore outside access through multiple faults](troubleshooting/incident-01-external-connectivity-outage.md). Four starting faults prevented the intended dynamic-NAT service. A temporary pool-name typo added another diagnostic checkpoint. Final evidence shows both clients receiving 5/5 replies and holding different translated addresses concurrently.

## Lab design

![NAT/PAT lab showing two clients, NAT-EDGE, ISP, and an outside server](topology.png)

CLIENT-A and CLIENT-B reach NAT-EDGE through NAT-SW. Gi0/1 is the inside boundary; Gi0/0 connects to ISP. The outside test server is `203.0.113.10`.

Dynamic NAT uses the two-address pool `192.0.2.10–192.0.2.11`. Final interface PAT lets both clients share NAT-EDGE's outside address, `198.51.100.2`.

[Topology and addressing](topology.md)

## Troubleshooting results

| Incident | Faults investigated | Captured recovery |
|---|---|---|
| [01 — External connectivity outage](troubleshooting/incident-01-external-connectivity-outage.md) | Missing inside role, narrow source ACL, missing return route, insufficient pool capacity, and a temporary repair typo | Both clients received 5/5 replies; one table showed two separate global allocations |
| [02 — PAT migration](troubleshooting/incident-02-pat-migration.md) | PAT selected the inside interface address; a one-entry translation limit constrained concurrent state | Both clients completed 20/20 and 50/50 probe runs; simultaneous TCP mappings shared the outside address |

The PAT case uses persistent TCP sessions to make concurrent translation state easier to inspect. The client pings and translation tables answer complementary questions about reachability and address sharing.

## Guided exercises

The [guided lab narrative](verification/guided-labs.md) connects the shorter experiments: routed baseline, static mapping, dynamic allocation, pool exhaustion, interface PAT, pool PAT, translation aging, and isolated ACL/interface/return-route failures.

## What this work demonstrates

- **Dependency analysis:** inspect classification, source selection, mapping references, capacity, and routing separately.
- **Targeted repair:** change the settings responsible for the recorded failure.
- **Recovery verification:** combine endpoint replies with translation-state inspection.
- **Configuration review:** compare original fault exports with reconstructed repaired settings and exact diffs.

## Explore the files

| Guide | Contents |
|---|---|
| [Configurations](configs/README.md) | Two original CML fault labs, reconstructed final configurations, diffs, and guided snippets |
| [Verification](verification/README.md) | Direct links to all 14 captures, their purpose, and key commands |
| [Troubleshooting](troubleshooting/README.md) | Two detailed incident studies and their recovery evidence |

## Evidence scope

Original YAMLs establish the starting faults. Final configuration files are labeled reconstructions from those exports and documented repairs. Incident 02's unused pool is removed in the clean configuration; the captured successful device state still includes it.

The cases distinguish simultaneous translation state from the timing of separate ping runs. Incident 02 does not retain both ping start orders, a complete intervening command history, or a save confirmation. Those limits are documented alongside its closure results.

[Back to portfolio](../README.md)
