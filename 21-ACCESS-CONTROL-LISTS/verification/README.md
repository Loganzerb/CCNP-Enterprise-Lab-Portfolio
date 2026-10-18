# ACL verification guide

The October 18, 2026 lab record reports a working baseline, selective filtering, three controlled policy experiments, and final regression checks. The supplied CML export provides actual saved configuration evidence; it does not contain runtime test output or ACL match counters.

**Quick navigation:** [Task-to-evidence matrix](#task-to-evidence-matrix) · [Read the evidence](#read-the-evidence)

## Task-to-evidence matrix

| Task | Guide | Evidence and result |
|---|---|---|
| Establish the unfiltered baseline | [Baseline](baseline.md) | Reported results: nine repeated ICMP tests with zero loss; both clients established SSH and Netcat TCP 443 connections |
| Verify the outbound policy | [Filtering](filtering-and-counters.md#reported-filtering-results) | Reported results: SSH denied from both clients; ICMP and TCP 443 permitted |
| Explain an earlier permit overriding a deny | [ACE shadowing](../troubleshooting/01-ace-shadowing.md) | Reported sequence-5 experiment allowed CLIENT-A SSH; removing it restored denial |
| Explain the effect of interface direction | [Direction case](../troubleshooting/02-interface-direction.md) | Reported Gi3 IN test allowed both TCP 22 connections; restoring OUT reinstated restrictions |
| Separate protocols, ports, and return traffic | [Ports and return path](../troubleshooting/03-ports-and-return-path.md) | Reported UDP 5300 denial, TCP 5300 payload delivery, and temporary matching errors/corrections |
| Interpret final match totals | [Reported counters](filtering-and-counters.md#reported-counter-snapshot) | User-supplied values for sequences 10, 20, 21, 22, and 30; no raw counter display or per-test deltas |
| Confirm final policy and cleanup | [Final state](final-state.md) | Saved outbound ACL in the export; reported regression, experimental-policy removal, save, and startup verification |

## Read the evidence

**Reported lab results** are narrative outcomes supplied by the engineer. No raw ping, SSH, Netcat, counter, or packet captures accompany this record, so the guides contain no reconstructed terminal output or numbered capture blocks.

**Saved configuration** establishes the ACL entries and Gi3 outbound attachment in the supplied export. Explanations of first-match processing, direction, port fields, and TCP flags interpret the described tests; they do not recover missing experimental ACEs. [Evidence scope](../scope.md) records the limits.

[Overview](../README.md) · [Configurations](../configs/README.md) · [Operation](../operation.md) · [Topology](../topology.md) · [Troubleshooting](../troubleshooting/README.md) · [Lessons learned](../lessons-learned.md) · [Evidence scope](../scope.md)
