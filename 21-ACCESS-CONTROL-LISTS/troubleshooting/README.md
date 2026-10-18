# ACL troubleshooting cases

Three controlled experiments separated first-match order, interface direction, and transport/return-path matching. The source is a narrative lab record, so symptoms, repairs, and validations below remain reported results rather than reconstructed CLI captures.

**Quick navigation:** [Case index](#case-index) · [Read the mechanisms](#read-the-mechanisms)

## Case index

| Case | Reported symptom | Reported correction and result |
|---|---|---|
| [01 — ACE shadowing](01-ace-shadowing.md) | An earlier broad permit let CLIENT-A reach SSH while CLIENT-B stayed denied | Removing sequence 5 restored CLIENT-A denial |
| [02 — Interface direction](02-interface-direction.md) | Moving the ACL to Gi3 IN let both clients connect to TCP 22 | Restoring Gi3 OUT reinstated both SSH restrictions |
| [03 — Ports and return path](03-ports-and-return-path.md) | A port-matching error blocked permitted traffic; a separate return-path error blocked a handshake | Correcting the matching restored the reported behavior; experimental return policy was removed |

## Read the mechanisms

The case explanations connect the supplied saved policy with the reported experiments. Exact temporary sequence-5 text, port-error ACEs, return-ACL names and sequence numbers, and client ephemeral ports were not supplied. The guides therefore do not invent exact remediation commands or replay logs.

The final deployment retains the outbound policy. TCP established flag matching in the temporary experiment is distinct from stateful session tracking. [Final state](../verification/final-state.md) · [Evidence scope](../scope.md)

[Verification](../verification/README.md) · [Configurations](../configs/README.md) · [Operation](../operation.md) · [Topology](../topology.md) · [Lessons learned](../lessons-learned.md) · [Overview](../README.md)
