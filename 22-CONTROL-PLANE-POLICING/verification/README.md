# CoPP verification guide

The October 20, 2026 lab record reports successful SSH access, an OSPF FULL adjacency, two controlled policy faults, and recovery of both management access and routed connectivity. The CML export supplies the final saved configuration; it does not contain historical packet counters or failure and recovery transcripts.

**Quick navigation:** [Task-to-evidence matrix](#task-to-evidence-matrix) · [Read the evidence](#read-the-evidence)

## Task-to-evidence matrix

| Task | Guide | Evidence and result |
|---|---|---|
| Classify traffic addressed to R1 | [Configurations](../configs/README.md) | Saved COPP-SSH and COPP-OSPF ACLs, class maps, and input control-plane policy |
| Verify normal SSH policing | [SSH verification](ssh-policing.md#reported-initial-test) | Reported authenticated session at 80 kbps; 46 conforming packets and zero exceeded packets |
| Diagnose an overly restrictive SSH policer | [SSH case](../troubleshooting/01-ssh-policer-exhaustion.md) | Reported exceeded count increased at 8 kbps with a 1,500-byte burst; a later SSH attempt closed |
| Confirm SSH recovery | [Recovery comparison](ssh-policing.md#reported-recovery-comparison) | Reported privilege 15; 66 additional matched and conforming packets, with no additional exceeded packets |
| Protect routing traffic | [OSPF verification](ospf-protection.md) | Reported normal 1-Mbps policer, zero exceeded packets, and FULL adjacency |
| Diagnose a wrong conform action | [OSPF case](../troubleshooting/02-ospf-conform-action.md) | Reported dead-timer expiration and route loss with conform drop; adjacency and route restored with conform transmit |
| Confirm the final configuration and service path | [Final state](final-state.md) | Saved final policy and OSPF configuration; reported inspection of both startup configurations and CLIENT-A to APP-TEST 10/10 ICMP replies |

## Read the evidence

**Saved configuration** establishes the final classifier definitions, policing actions, addresses, OSPF settings, and R1 control-plane attachment. [Configuration extracts](../configs/README.md) are derived from the supplied export and sanitized for publication.

**Reported lab results** are the engineer-supplied observations in the lab handoff. The tables retain those figures without presenting them as captured CLI output. No raw SSH, policy-counter, OSPF, route, ping, or startup-configuration transcripts were supplied.

**Mechanism explanations** connect those observations to classification, policing, and routing behavior. They are not packet captures or proof of a fresh execution of the sanitized export. The [evidence scope](../scope.md) records the remaining limits.

[Overview](../README.md) · [Configurations](../configs/README.md) · [Operation](../operation.md) · [Topology](../topology.md) · [Troubleshooting](../troubleshooting/README.md) · [Lessons learned](../lessons-learned.md) · [Evidence scope](../scope.md)
