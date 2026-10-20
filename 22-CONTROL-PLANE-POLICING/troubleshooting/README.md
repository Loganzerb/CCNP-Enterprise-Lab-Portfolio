# CoPP troubleshooting cases

Two controlled faults show how a control-plane policy can affect administrative access and routed connectivity. Each case connects the symptom to the class, policing action, correction, and reported recovery.

| Case | What changed | Reported impact | Confirmed recovery in the lab record |
|---|---|---|---|
| [01 — SSH policer exhaustion](01-ssh-policer-exhaustion.md) | CP-SSH reduced from 80 kbps to 8 kbps with a 1,500-byte burst | Exceeded counter rose to 7, then 10; a later SSH attempt closed | Restored 80 kbps; privilege-15 authentication; +66 conforming packets and no additional exceeded packets |
| [02 — Incorrect OSPF conform action](02-ospf-conform-action.md) | CP-OSPF conform action changed to drop at the same 1-Mbps CIR | Dead-timer expiration, FULL to DOWN, and remote route loss | Restored conform transmit; LOADING to FULL, route reinstallation, and 10/10 endpoint ICMP replies |

The first case investigates the rate allowance. The second investigates the action applied to traffic within its allowance. Reviewing both prevents a counter labeled conform from being mistaken for proof that the policy transmitted the traffic.

These are **reported lab results**, not reconstructed CLI transcripts. The exported configuration retains the final corrected policy, while the [verification guides](../verification/README.md) organize the reported observations and counter comparison. [Evidence scope](../scope.md) records what was and was not supplied.

[Overview](../README.md) · [Verification](../verification/README.md) · [Configurations](../configs/README.md) · [Operation](../operation.md) · [Topology](../topology.md) · [Lessons learned](../lessons-learned.md) · [Evidence scope](../scope.md)
