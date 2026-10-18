# Final ACL state and reported regression

The supplied export retains the final USERS-TO-SERVER policy and its outbound Gi3 attachment. The engineer separately reported final traffic checks, cleanup, saving the configuration, and startup inspection.

**Quick navigation:** [Saved configuration](#saved-configuration) · [Reported final checks](#reported-final-checks) · [Evidence boundary](#evidence-boundary)

## Saved configuration

| Exported setting | What the supplied configuration establishes |
|---|---|
| Gi3 `USERS-TO-SERVER out` | The named policy is assigned toward APP-SERVER |
| Sequences 10 and 20 | TCP destination 22 denied from the two client networks to APP-SERVER |
| Sequences 21 and 22 | UDP destination 5300 denied from the same networks to APP-SERVER |
| Sequence 30 | Broad IP permit follows the specific denies |

The [configuration guide](../configs/README.md) links the sanitized export and device extracts. These settings establish saved intent; they are not a runtime counter display or a replay of the tests.

## Reported final checks

| Check | Reported lab result |
|---|---|
| CLIENT-A and CLIENT-B SSH | Both denied |
| CLIENT-A and CLIENT-B ICMP | Both permitted |
| CLIENT-A and CLIENT-B TCP 5300 | Both permitted |
| Experimental policies | Unused experimental ACLs removed; the inbound return-path experiment is not part of the final policy |
| Save and startup inspection | Final configuration saved; ACL and Gi3 OUT attachment verified in startup-config |

TCP 443 success belongs to the earlier outbound-policy test; the supplied final regression list specifically names SSH, ICMP, and TCP 5300. [Reported counters](filtering-and-counters.md#reported-counter-snapshot) are reported snapshot totals rather than final-test deltas.

## Evidence boundary

No final show-command output, startup transcript, or traffic log was supplied. The configuration export independently retains the final policy, while save/startup verification and runtime outcomes remain reported results. No router reload verification or fresh sanitized import/run is represented as completed work.

[Verification index](README.md) · [Filtering and counters](filtering-and-counters.md) · [Troubleshooting](../troubleshooting/README.md) · [Overview](../README.md) · [Evidence scope](../scope.md)
