# Case 01 — An earlier permit shadows the SSH deny

The lab reports that CLIENT-A could connect to APP-SERVER on TCP/22 after a broader permit was inserted ahead of its deny entry. CLIENT-B remained denied. Removing the earlier permit restored the intended result.

**Quick navigation:** [Symptom](#symptom) · [Mechanism](#mechanism) · [Reported repair](#reported-repair) · [Validation](#validation) · [Evidence limit](#evidence-limit)

## Symptom

At the start of this test, the policy denied SSH from both client networks to APP-SERVER at **172.16.40.10**, while permitting ICMP and TCP/443. `USERS-TO-SERVER` was applied outbound on R1-ACL Gi3 toward the server.

The fault was a broader permit inserted at **sequence 5**. CLIENT-A at **10.10.10.25** could then connect to TCP/22, even though its intended deny remained at sequence 10. CLIENT-B at **10.20.20.25** still could not connect.

## Mechanism

An ACL evaluates entries in order and uses the first match. The sequence 5 permit matched CLIENT-A's test before the TCP/22 deny at sequence 10 could be reached. The later deny's presence therefore did not establish that it controlled this traffic.

CLIENT-B's continued denial provided a useful comparison: the changed result affected the tested CLIENT-A path rather than opening TCP/22 for both clients. The temporary permit's full match criteria were not supplied.

## Reported repair

The lab record reports removing sequence 5. The intended TCP/22 denies at sequences 10 and 20 and the outbound Gi3 attachment remained the final policy.

## Validation

| Test to APP-SERVER TCP/22 | Before insertion | With sequence 5 | After removal |
|---|---|---|---|
| CLIENT-A, 10.10.10.25 | Reported denied | Reported connected | Reported denied |
| CLIENT-B, 10.20.20.25 | Reported denied | Reported denied | Not separately reported at this step |

The later final regression reports both SSH denies, as well as ICMP and TCP/5300 permitted. The sequence 5 comparison demonstrates the effect of entry order for the tested traffic; it does not enumerate everything the temporary permit would have allowed.

## Evidence limit

These are reported lab results. No raw ACL output, test transcript, timestamps, or before-and-after counters were supplied. The saved final configuration supports the intended deny entries and outbound attachment, but does not retain the temporary sequence 5 entry or independently prove its runtime behavior.

[Troubleshooting index](README.md) · [Overview](../README.md) · [Verification](../verification/README.md) · [Configurations](../configs/README.md) · [Operation](../operation.md) · [Evidence scope](../scope.md)
