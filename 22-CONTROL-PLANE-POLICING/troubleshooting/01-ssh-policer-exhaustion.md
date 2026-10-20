# Case 01 — SSH policer exhaustion

An intentionally restrictive CP-SSH policer produced exceeded packets and a later failed SSH attempt. Restoring the original rate recovered authenticated administrative access without additional exceeded packets in the reported recovery comparison.

**Quick navigation:** [Starting state](#starting-state) · [Failure symptoms](#failure-symptoms) · [Investigation and mechanism](#investigation-and-mechanism) · [Correction](#correction) · [Post-fix validation](#post-fix-validation) · [Evidence limit](#evidence-limit)

## Starting state

CLIENT-A uses R1-CoPP's **10.10.10.1** address for SSH. COPP-SSH classifies TCP destination port **22** to that address; CP-SSH applies the policer through CP-PROTECT under the control plane.

At the original **80,000-bps CIR**, the lab reports successful authentication, **46 conforming packets**, and **zero exceeded packets**.

## Failure symptoms

The CIR was reduced to **8,000 bps**, with a **1,500-byte burst allowance**. The exceeded count increased to **7 packets**, then **10 packets**. A subsequent SSH attempt returned the reported message `Connection closed by 10.10.10.1 port 22`.

## Investigation and mechanism

The investigation connects three observations: SSH worked before the change, the restrictive allowance produced exceeded packets, and access recovered after the rate was restored. The configured **exceed drop** action explains how the policer can discard classified management traffic when it exceeds the allowance.

The ACL supplies classification; it does not itself rate-limit the session. Reading only the TCP/22 match would therefore miss the cause of the changed access behavior. The CP-SSH rate, burst allowance, actions, and counters must be considered together.

This supports the policer-exhaustion explanation for the controlled experiment. It does not establish which individual packet caused the subsequent connection closure, its exact timing, or whether every SSH attempt under that rate would behave identically.

## Correction

The SSH policer was restored to **80,000 bps**, with conform transmit and exceed drop. That corrected rate and action pair is retained in the saved final configuration.

## Post-fix validation

SSH authenticated successfully and reported **privilege level 15**. The reported comparison was:

| CP-SSH counter | Before recovery test | After recovery test | Change |
|---|---:|---:|---:|
| Matched packets | 119 | 185 | +66 |
| Conforming packets | 109 | 175 | +66 |
| Exceeded packets | 10 | 10 | 0 |

The new session and counter differences support recovery. The unchanged exceeded total distinguishes historical drops from new exceeded packets during the recovery test.

## Evidence limit

All session outcomes and figures are reported observations supplied in the handoff. No raw SSH transcript, policy output, counter-clear timing, or packet capture was supplied. The saved export supplies the final policy, not its historical counters. These lab rates are not a production capacity recommendation.

[Troubleshooting index](README.md) · [SSH verification](../verification/ssh-policing.md) · [Final state](../verification/final-state.md) · [Overview](../README.md) · [Configurations](../configs/README.md) · [Operation](../operation.md) · [Evidence scope](../scope.md)
