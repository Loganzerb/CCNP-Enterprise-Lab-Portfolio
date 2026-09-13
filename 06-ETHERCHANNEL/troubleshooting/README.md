# Troubleshooting Cases and Evidence

Start with the detailed cases, then use the artifact tables to inspect the underlying record. All 27 original text captures remain unchanged.

## Detailed cases

| Case | Diagnostic question | Retained closure |
|---|---|---|
| [01 — VLAN-mask mismatch](case-01-vlan-mask-mismatch.md) | Why did one LACP member suspend while Po20 stayed up? | Correct allowed VLAN list, trunk membership restored, both members P |
| [02 — Max-bundle forwarding anomaly](case-02-max-bundle-forwarding-anomaly.md) | Why was an SU bundle insufficient evidence of working service? | Two P members and 5/5 endpoint replies; internal anomaly cause remains unproven |

These are expanded accounts of the original controlled experiments. The [guided exercises](../verification/guided-labs.md) document direct-trunk failover, single-member resilience, and capability checks.

## VLAN-mask mismatch

| Original artifact | What it records |
|---|---|
| [Change, syslog, and summary](vlan-mask-mismatch-syslog-summary.txt) | The allowed-VLAN change, explicit incompatibility message, and Gi0/0(s) alongside Gi0/1(P) |
| [Suspended member detail](vlan-mask-mismatch-switchport.txt) | Operational suspension and enabled VLAN list 1,10,20,30, with native VLAN still 99 |
| [Recovered member detail](vlan-mask-mismatch-recovery-switchport.txt) | Trunk membership restored and VLAN 99 returned to the enabled list |
| [Recovered bundle](vlan-mask-mismatch-recovery-summary.txt) | Po20(SU) with both Gi0/0 and Gi0/1 bundled |

## Max-bundle anomaly

| Original artifact | What it records |
|---|---|
| [Enable and transition](max-bundle-enable-transition.txt) | Accepted max-bundle 1 command; waiting/hot-standby transition followed by bundled/hot-standby state |
| [Failed client test](max-bundle-broken-ping.txt) | Five probes sent with no replies |
| [Failure STP/BPDU detail](max-bundle-broken-stp-bpdu.txt) | SW1 Po20 designated-forwarding views with zero received BPDUs |
| [Recovery summary](max-bundle-recovery-summary.txt) | SW3 Po20 returns to two bundled members |
| [Recovered client test](max-bundle-recovery-ping.txt) | Five probes receive five replies |
| [Recovery STP/BPDU detail](max-bundle-recovery-stp-bpdu.txt) | SW3 Po20 views include received BPDUs; this is a different device from the failure capture |

## Direct-trunk failover

| Original artifact | What it records |
|---|---|
| [Client interruption and resumed replies](direct-trunk-failure-ping.txt) | 66 probes sent, 20 received; the retained run contains failure and recovery |
| [SW3 alternate-path lookup](direct-trunk-failover-SW3-mac.txt) | Destination MAC learned on Po20 toward SW1 |
| [SW1 alternate-path lookup](direct-trunk-failover-SW1-mac.txt) | Same destination MAC learned on Po10 toward SW2 |
| [SW2 alternate-path lookup](direct-trunk-failover-SW2-mac.txt) | Same destination MAC learned on Po30 toward SW4 |
| [SW3 restored lookup](direct-trunk-restored-SW3-mac.txt) | Destination returns to the direct Gi0/2 trunk |

## LACP member failure and recovery

| Original artifact | What it records |
|---|---|
| [Failure summary](lacp-member-failure-summary.txt) | Gi0/1(D), Gi0/0(P), and Po20 still SU |
| [Failure spanning-tree state](lacp-member-failure-stp-cost.txt) | Po20 remains Designated/Forwarding with cost 4 |
| [Failure-run client probes](lacp-member-failure-ping.txt) | 60/60 replies with 0% observed loss |
| [Recovery summary](lacp-member-recovery-summary.txt) | Both members return to P |
| [Recovery spanning-tree state](lacp-member-recovery-stp-cost.txt) | Po20 remains Designated/Forwarding with cost 3 |
| [Recovery-run client probes](lacp-member-recovery-ping.txt) | 75/75 replies with 0% observed loss |

## Capability and cleanup checks

| Original artifact | What it records |
|---|---|
| [Interface LACP options](platform-lacp-interface-options.txt) | CLI help exposes port-priority in the captured interface context |
| [Load-balancing options](platform-load-balance-options.txt) | CLI help exposes six MAC/IP algorithm choices |
| [Standalone-disable nondefault](standalone-disable-nondefault-config.txt) | The no-form appears in Po20's configuration |
| [Standalone-disable restoration](standalone-disable-restored-config.txt) | Command restoration, IOS advisory, and subsequent omission of the default from the configuration |
| [System-priority restoration](system-priority-restore-flap.txt) | Priority returns to 32768, followed by member and port-channel transitions |
| [Routed Po40 capability](layer3-port-channel-capability.txt) | Temporary no-switchport Po40 with no IP address |
| [Routed Po40 cleanup](layer3-port-channel-cleanup.txt) | A section query returns no Port-channel40 configuration |

## Interpreting the record

Capture filenames group the supplied experiment stages. They do not establish a complete timestamped sequence or prove that every intermediate action was recorded. The case narratives distinguish original output from reported lab history, interpretation, and repair references.

For the healthy baseline, use the [final verification index](../verification/README.md). For device roles and the exported settings, use the [configuration guide](../configs/README.md).

[Module overview](../README.md)
