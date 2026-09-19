# Guided EtherChannel Exercises

These summaries connect the retained captures to the engineering questions behind each exercise. The [final verification guide](README.md) covers the delivered steady state; the [two detailed cases](../troubleshooting/README.md) cover member inconsistency and the max-bundle anomaly.

## Direct-trunk failure

**Question:** What path can carry VLAN 10 traffic if the direct SW3–SW4 trunk is unavailable?

The supplied lab narrative reports shutting the direct Gi0/2 trunk. PC-A's [failure-run ping](../troubleshooting/direct-trunk-failure-ping.txt) contains replies for sequences 0–7, then resumes at sequence 54. Its final statistics are **66 sent, 20 received, 69% loss** as printed, with min/average/max RTT of 2.374/169.838/2107.591 ms.

This is an interrupted run with recovery, not a wholly failed test. The missing sequence numbers and large initial recovery RTTs should remain visible. The capture does not provide a timestamped link-shutdown event or an exact elapsed convergence measurement.

The retained lookups follow destination MAC `5254.0019.800a`:

| Switch | Learned interface | Interpretation |
|---|---|---|
| [SW3](../troubleshooting/direct-trunk-failover-SW3-mac.txt) | Po20 | Send destination traffic toward SW1 over LACP |
| [SW1](../troubleshooting/direct-trunk-failover-SW1-mac.txt) | Po10 | Continue toward SW2 over the static bundle |
| [SW2](../troubleshooting/direct-trunk-failover-SW2-mac.txt) | Po30 | Continue toward SW4 over PAgP |

Together, these observations support the alternate path:

**PC-A → SW3 → Po20 → SW1 → Po10 → SW2 → Po30 → SW4**

After restoration, the [SW3 lookup](../troubleshooting/direct-trunk-restored-SW3-mac.txt) learns the same destination on Gi0/2 again. This establishes the local return to the direct path. The [final 10/10 ping](PC-A-final-ping.txt) is a separate steady-state capture.

The saved switches use classic PVST. This experiment shows why physical redundancy must be assessed together with forwarding state and the actual interruption seen by the client.

## Single-member failure

**Question:** Can the logical LACP path remain available when one physical member is lost?

The earlier lab narrative describes forcing traffic through Po20 and shutting SW3 Gi0/1. The retained observations are:

| Check | Member failure | Recovery |
|---|---|---|
| [Failure summary](../troubleshooting/lacp-member-failure-summary.txt) / [recovery summary](../troubleshooting/lacp-member-recovery-summary.txt) | Po20(SU), Gi0/0(P), Gi0/1(D) | Po20(SU), both members P |
| [Failure STP state](../troubleshooting/lacp-member-failure-stp-cost.txt) / [recovery STP state](../troubleshooting/lacp-member-recovery-stp-cost.txt) | Po20 Designated/Forwarding, cost 4 | Po20 Designated/Forwarding, cost 3 |
| [Failure-run ping](../troubleshooting/lacp-member-failure-ping.txt) / [recovery-run ping](../troubleshooting/lacp-member-recovery-ping.txt) | 60/60 replies, 0% loss | 75/75 replies, 0% loss |

The failure and recovery captures show the logical interface staying in use while its membership and STP cost differ. The pings demonstrate no observed loss in those runs; they are not a throughput test or a guarantee for all traffic patterns. The retained files do not supply a synchronized command-and-packet timeline.

Contrast this with [Case 01](../troubleshooting/case-01-vlan-mask-mismatch.md): its member is suspended `(s)` because of incompatible configuration. Here the affected member is down `(D)`. The same high-level observation—one usable member—can have different causes.

## Capability and cleanup exercises

| Exercise | Captured result | Boundary |
|---|---|---|
| [LACP interface choices](../troubleshooting/platform-lacp-interface-options.txt) | The displayed interface help lists port-priority | It does not offer a fast-rate setting in that captured context |
| [Hashing choices](../troubleshooting/platform-load-balance-options.txt) | MAC- and IP-based choices are listed | No Layer 4 port-based choice appears in the shown help; this is image/context-specific |
| [Final hashing setting](EC-SW3-ACCESS-A-load-balance.txt) | src-dst-ip is selected | No retained member-counter comparison establishes flow distribution |
| [System-priority restoration](../troubleshooting/system-priority-restore-flap.txt) | Removal of priority 1, system ID priority 32768, and link/Po20 down/up messages | Correlates the change with observed transitions; it is not a general disruption benchmark |
| [Nondefault standalone setting](../troubleshooting/standalone-disable-nondefault-config.txt) / [restored setting](../troubleshooting/standalone-disable-restored-config.txt) | The no-form appears before restoration; the restored default is omitted from the later config | The IOS message about already-standalone ports is advisory, not evidence that such a forwarding test occurred |
| [Temporary routed Po40](../troubleshooting/layer3-port-channel-capability.txt) / [cleanup](../troubleshooting/layer3-port-channel-cleanup.txt) | Po40 accepts no switchport and has no IP address; the later section query is empty | This proves a configuration capability and removal, not a working physical Layer 3 EtherChannel |

The earlier summary reported additional negotiation and hashing experiments for which raw captures were not supplied. Their status is retained in the [coverage table](README.md#coverage-and-boundaries), without promoting those reports to measured proof.

[Module overview](../README.md) · [Final evidence index](README.md) · [Troubleshooting index](../troubleshooting/README.md)
