# Link Bundles — Follow the Strongest Evidence Sequence

Two parallel links can be treated as separate paths or combined into one logical port-channel. These captures show how spanning tree's view changes, then compare two kinds of failure.

| Stage | Original capture | What happened |
|---|---|---|
| Separate trunks | [Before EtherChannel](SW5-before-etherchannel.txt) | Gi0/0 is Root/FWD and Gi0/1 is Alternate/Blocked for VLAN 10 |
| Healthy bundle | [LACP summary](SW5-healthy-lacp-summary.txt) | Po1 is SU with both Gi0/0(P) and Gi0/1(P) |
| STP over the bundle | [After bundling](SW5-STP-after-bundle.txt) | STP shows one Po1 Root/FWD interface, local cost 3 |
| One physical member down | [Member failure](SW5-single-member-failure.txt) | Gi0/1 is D; Po1 remains SU and Root/FWD, local cost 4 |
| Negotiation failure | [Suspended bundle](SW5-passive-passive-failure.txt) | Both members are s and Po1 is SD; the lab notes identify a passive/passive trial |

**Why this matters:** losing a member and losing the logical bundle have different consequences. The first failure retains a forwarding port-channel; the second removes it.

Read [Case 11](../../troubleshooting/11-lacp-negotiation-and-member-failure.md) for the diagnosis and recovery method. A separate post-repair capture after the passive/passive trial was not retained. The earlier healthy output should not be reused as proof that the later repair completed.

These are temporary experiment states. The [saved SW4/SW5 configurations](../../configs/README.md) contain separate trunks and long-cost settings, without Po1. The captured local costs 3/4 belong to the earlier sequence; they are not long-cost examples. No throughput or client packet-loss measurement is included.

[Verification index](../README.md) · [Module overview](../../README.md)
