# ACL scope and evidence provenance

This October 18, 2026 CML lab used one CSR1000v IOS XE 17.3.2 router and three Alpine Desktop endpoints. Four nodes and three links connect the two client networks to a separate application-server subnet.

**Quick navigation:** [Sources](#sources) · [Exercised scope](#exercised-scope) · [Measurement limits](#measurement-limits) · [Saved state and reproduction](#saved-state-and-reproduction)

## Sources

| Material | Source and interpretation |
|---|---|
| Original CML export | Actual saved addressing, ACL entries, and Gi3 OUT attachment; held privately and sanitized for the public module |
| Runtime outcomes and final counters | Engineer-supplied narrative lab results, labeled reported throughout [verification](verification/README.md) and [cases](troubleshooting/README.md) |
| Mechanism explanations and diagrams | Interpretations of first-match order, interface direction, protocol/port fields, and TCP flags; not reconstructed terminal output or packet captures |

No raw CLI, ping, SSH, Netcat, counter display, or packet captures were supplied. The saved configuration does not supply historical runtime counters. No numbered capture blocks or synthetic logs have been created.

## Exercised scope

The reported experiments cover the USERS-TO-SERVER outbound policy, temporary earlier-permit shadowing, a Gi3 direction change, UDP versus TCP destination 5300, source/destination-port matching errors, and a separate temporary inbound return-path ACL using established matching. The final policy retains the specific SSH/UDP denies followed by a broad IP permit.

The exact temporary sequence-5 ACE, experimental return-ACL names and sequence numbers, full port-error ACEs, and ephemeral client ports were not supplied. They are not presented as actual configuration. The TCP established keyword checks ACK or RST flags; it does not establish stateful session tracking.

## Measurement limits

Nine repeated baseline ICMP tests were reported with zero loss; nine tests is not a packet count. TCP 443 was tested using Netcat, without HTTPS/TLS service validation. The final regression specifically reports both SSH denies, both ICMP permits, and both TCP 5300 permits.

Final counts of 5, 4, 1, 1, and 167 belong to sequences 10, 20, 21, 22, and 30 respectively. They are reported totals, not raw captured output or final-regression deltas. No retained counter-clear timing, per-test packet trace, throughput, or long-duration reliability measurement supports stronger conclusions.

## Saved state and reproduction

The supplied export retains the final ACL and its Gi3 outbound attachment. Experimental return-path ACLs are not part of that final saved design. Saving and startup verification were reported; no startup transcript or router reload test was supplied.

A fresh import, boot, and traffic retest of the sanitized public export has not been performed during documentation preparation. [Configuration provenance](configs/README.md) distinguishes the exported configuration from reproduction instructions and reported behavior.

[Overview](README.md) · [Verification](verification/README.md) · [Troubleshooting](troubleshooting/README.md) · [Configurations](configs/README.md) · [Operation](operation.md) · [Topology](topology.md) · [Lessons learned](lessons-learned.md)
