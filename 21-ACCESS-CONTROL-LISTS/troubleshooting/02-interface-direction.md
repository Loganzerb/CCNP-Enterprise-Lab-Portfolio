# Case 02 — Correct rule set, wrong interface direction

The lab reports that both clients could connect to APP-SERVER on TCP/22 after the existing ACL was moved to the inbound direction on Gi3. Restoring the outbound attachment denied both clients again.

**Quick navigation:** [Symptom](#symptom) · [Mechanism](#mechanism) · [Reported repair](#reported-repair) · [Validation](#validation) · [Evidence limit](#evidence-limit)

## Symptom

`USERS-TO-SERVER` contained TCP/22 denies for both client networks, but moving the same policy from **Gi3 outbound** to **Gi3 inbound** allowed both reported SSH connection tests to succeed.

CLIENT-A at **10.10.10.25** reached R1-ACL through Gi1, and CLIENT-B at **10.20.20.25** through Gi2. Both targeted APP-SERVER at **172.16.40.10**, reached through Gi3.

## Mechanism

Interface direction is relative to the router. Requests from either client enter R1-ACL through a client-facing interface and leave through Gi3. An outbound ACL on Gi3 can inspect those requests as they head toward the server.

Moving that ACL inbound on Gi3 places it on traffic arriving from the server segment. The client requests no longer encounter the policy on their way out Gi3. The deny statements can remain correct while the attachment fails to enforce their intended path.

## Reported repair

The lab record reports restoring `USERS-TO-SERVER` to the **outbound** direction on Gi3. No change to the client networks, server address, or intended SSH deny rules was needed for this comparison.

## Validation

| Gi3 attachment | CLIENT-A to TCP/22 | CLIENT-B to TCP/22 |
|---|---|---|
| Outbound, intended baseline | Reported denied | Reported denied |
| Inbound, direction fault | Reported connected | Reported connected |
| Outbound, restored | Reported denied | Reported denied |

Both clients changing together is consistent with a common policy-placement fault on their shared server-facing egress. The final configuration retains the outbound attachment.

## Evidence limit

These are reported lab results. No raw interface ACL output, packet trace, test transcript, timestamps, or direction-specific counters were supplied. The saved configuration establishes the final attachment, while the inbound fault and recovery are described by the lab record.

[Troubleshooting index](README.md) · [Overview](../README.md) · [Verification](../verification/README.md) · [Configurations](../configs/README.md) · [Operation](../operation.md) · [Evidence scope](../scope.md)
