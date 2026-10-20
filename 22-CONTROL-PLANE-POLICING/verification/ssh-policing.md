# SSH policing verification

The lab tested SSH access to R1-CoPP at **10.10.10.1** while changing the CP-SSH policer. The saved final configuration classifies TCP destination port 22 to that address and applies an **80,000-bps** policer with conform transmit and exceed drop.

**Quick navigation:** [Initial test](#reported-initial-test) · [Restricted-rate test](#reported-restricted-rate-test) · [Recovery comparison](#reported-recovery-comparison) · [Interpretation](#interpretation)

## Reported initial test

| Observation | Reported result |
|---|---|
| CP-SSH CIR | 80,000 bps |
| SSH authentication | Successful |
| Conforming packets | 46 |
| Exceeded packets | 0 |

This test established a working management session under the original policy before the restrictive-rate experiment.

## Reported restricted-rate test

The CIR was temporarily reduced to **8,000 bps**, with a **1,500-byte burst allowance**. The exceeded counter was reported at **7 packets**, then **10 packets**. A subsequent SSH attempt returned the reported message `Connection closed by 10.10.10.1 port 22`.

The class policy drops traffic measured as exceeding its allowance. The counter growth and access failure support the [policer-exhaustion case](../troubleshooting/01-ssh-policer-exhaustion.md). They do not identify the individual packet or exact timing that closed the later connection.

## Reported recovery comparison

The policer was restored to **80,000 bps**. SSH authentication recovered, and the session reported **privilege level 15**.

| CP-SSH packet counter | Before recovery test | After recovery test | Difference |
|---|---:|---:|---:|
| Matched | 119 | 185 | +66 |
| Conformed | 109 | 175 | +66 |
| Exceeded | 10 | 10 | 0 |

These are reported counter snapshots. The comparison shows additional conforming traffic without further exceeded packets during the recovery test. The earlier 10 exceeded packets remain in the cumulative total; their presence does not mean that the repaired test incurred new exceed drops.

## Interpretation

The test distinguishes matching from policing: an ACL identifies the SSH class, while the policy's rate measurement and actions determine whether classified traffic is transmitted or dropped. An ACL permit used by this class map is not a standalone interface access rule.

The final export retains the restored 80-kbps policy. It does not retain the temporary rate or these counters. No raw session or counter transcript, packet trace, sustained-load test, or fresh sanitized-import execution accompanies the record. The rates demonstrate this lab's experiment and are not a general sizing recommendation.

[Verification index](README.md) · [SSH troubleshooting case](../troubleshooting/01-ssh-policer-exhaustion.md) · [Final state](final-state.md) · [Overview](../README.md) · [Configurations](../configs/README.md) · [Operation](../operation.md) · [Evidence scope](../scope.md)
