# Filtering results and reported ACL counters

The saved configuration attaches USERS-TO-SERVER outbound on R1-ACL GigabitEthernet3 toward APP-SERVER. The lab record describes the traffic outcomes and supplies final match totals separately from that configuration.

**Quick navigation:** [Filtering results](#reported-filtering-results) · [Counter snapshot](#reported-counter-snapshot) · [Interpretation](#interpret-the-totals)

## Reported filtering results

| Test stage | Reported lab result | Saved-policy relationship |
|---|---|---|
| Initial outbound policy: SSH | Both clients denied | Sequences 10 and 20 deny TCP destination 22 from the respective client networks to APP-SERVER |
| Initial outbound policy: ICMP and TCP 443 | Both permitted | These tests remain eligible for the broad permit at sequence 30 |
| UDP 5300 comparison | Both client networks denied, with deny hits reported | Sequences 21 and 22 deny UDP destination 5300 to APP-SERVER |
| TCP 5300 comparison | Payloads from both clients reached APP-SERVER | TCP does not match the UDP denies; sequence 30 permits the tested traffic |

The source also reports counters confirming the initial SSH denies, without providing their original display or intermediate values. The [case guides](../troubleshooting/README.md) describe the temporary order, direction, and port-matching changes separately.

## Reported counter snapshot

**Reported lab results — not a captured show-command table.** Sequence meanings below come from the saved export; counts come from the user's narrative record.

| Sequence | Saved ACE meaning | Reported matches |
|---|---|---:|
| 10 | Deny TCP from `10.10.10.0/24` to APP-SERVER destination 22 | 5 |
| 20 | Deny TCP from `10.20.20.0/24` to APP-SERVER destination 22 | 4 |
| 21 | Deny UDP from `10.10.10.0/24` to APP-SERVER destination 5300 | 1 |
| 22 | Deny UDP from `10.20.20.0/24` to APP-SERVER destination 5300 | 1 |
| 30 | Permit other IP traffic | 167 |

## Interpret the totals

The handoff supplies a final reported snapshot, not measured deltas for the final regression. The source does not retain counter-clear times or per-test snapshots. A match count is not an SSH-session count, a payload-delivery count, or the packet count of the nine baseline test runs.

The final saved ACL applies to two client subnets; the reported traffic tests used CLIENT-A and CLIENT-B. The record does not test every host or service covered by the broad permit. [Final-state evidence](final-state.md) separates saved policy from reported runtime checks.

[Verification index](README.md) · [Baseline](baseline.md) · [Final state](final-state.md) · [Configurations](../configs/README.md) · [Operation](../operation.md) · [Overview](../README.md) · [Evidence scope](../scope.md)
