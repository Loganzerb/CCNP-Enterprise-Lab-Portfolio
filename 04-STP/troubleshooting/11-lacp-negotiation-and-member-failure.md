# Case 11 — One Member Fails, Then the Whole Bundle Stops Forming

## Problem in plain English

Two physical links can operate as one logical connection. Losing one member does not necessarily remove that logical path. A separate failure that prevents the bundle from forming can remove it entirely.

This exercise provides the section's strongest retained sequence: separate trunks, a healthy LACP bundle, a one-member failure, and a later negotiation failure.

## Topology and intended behavior

SW5 connects to SW4 over two links. Before bundling, STP selects one of those parallel links for VLAN 10 and blocks the other. During the temporary experiment, LACP combines them into Port-channel1, or Po1, which STP treats as a logical interface.

The saved [SW4/SW5 configurations](../configs/README.md) later return to separate trunks. They are not the active LACP configuration for these captures.

## Stage 1 — Separate links

In [the pre-bundle capture](../verification/etherchannel/SW5-before-etherchannel.txt), both Gi0/0 and Gi0/1 are trunks carrying the intended VLANs. For VLAN 10:

| Port | Role | Interpretation |
|---|---|---|
| Gi0/0 | Root FWD, local cost 4 | Selected path toward the root |
| Gi0/1 | Altn BLK, local cost 4 | Parallel backup excluded from normal forwarding |

The trunk output also shows no forwarding VLANs on Gi0/1. That agrees with the STP state; it is not evidence that the physical link cannot trunk.

## Stage 2 — A healthy logical bundle

The [healthy LACP summary](../verification/etherchannel/SW5-healthy-lacp-summary.txt) shows:

```text
1      Po1(SU)         LACP      Gi0/0(P)    Gi0/1(P)
```

Here SU means Layer 2/in use, and P means bundled. In the separate [STP-after-bundle capture](../verification/etherchannel/SW5-STP-after-bundle.txt), the root port is now Po1 with local cost 3 and total root cost 11.

This establishes both membership and spanning tree's view of the logical interface. It does not measure aggregate bandwidth.

## Stage 3 — One physical member is down

The original notes describe shutting Gi0/1. The [retained failure capture](../verification/etherchannel/SW5-single-member-failure.txt) shows:

```text
1      Po1(SU)         LACP      Gi0/0(P)    Gi0/1(D)
```

Po1 remains Root/FWD for VLAN 10. Its local cost is now 4, and total root cost is 12.

| Check | Two-member state | One-member state |
|---|---|---|
| Logical bundle | SU | SU |
| Gi0/0 | P | P |
| Gi0/1 | P | D |
| VLAN 10 logical root port | Po1 | Po1 |
| Local cost / total root cost | 3 / 11 | 4 / 12 |

The logical forwarding path remains present in the switch output. No endpoint ping run is retained, so this should not be described as measured zero-loss client service.

## Stage 4 — Negotiation fails

The original notes identify the next exercise as LACP passive/passive: neither peer initiates negotiation. The [SW5 failure transcript](../verification/etherchannel/SW5-passive-passive-failure.txt) includes suspension messages saying LACP is currently not enabled on the remote port, followed by:

```text
1      Po1(SD)         LACP      Gi0/0(s)    Gi0/1(s)
```

SD means Layer 2/down, and s means suspended. Both members are unavailable to the bundle.

The captured output establishes suspension and loss of Po1. The passive/passive configuration comes from the exercise notes; a simultaneous running-configuration capture from both peers is not included. The message alone should not be treated as uniquely identifying that one possible configuration.

## Diagnosis and recovery method

Compare physical-member state, protocol negotiation, and the logical interface:

| Observed condition | Diagnostic direction | Documented recovery method |
|---|---|---|
| Gi0/1(D), Po1(SU), remaining member P | Investigate the failed physical member; the bundle still exists | Restore the intentionally shut member and recheck both members |
| Both members (s), Po1(SD) | Investigate peer negotiation and member configuration | For the documented passive/passive trial, set at least one peer to active and verify formation |

Useful replay checks are `show etherchannel summary`, `show lacp neighbor`, the member configurations on both peers, and the relevant VLAN's STP state. Client traffic should also be checked on the intended path.

## Closure boundary

A separate recovery transcript after the passive/passive test was not retained. The earlier healthy summary proves the baseline, not the later repair. The final exported separate-trunk state also does not prove recovery of Po1.

The small costs in these captures belong to the earlier experiment. The later [long-cost setting](../verification/path-engineering/SW5-pathcost-method-long.txt) is a different stage, not a reason to alter the original numbers.

## Engineering takeaway

An engineer should be able to distinguish reduced membership from loss of the whole logical connection. This sequence demonstrates that distinction with actual port-channel and STP output, while keeping client availability and uncaptured recovery outside the proven results.

[Case index](README.md) · [LACP evidence guide](../verification/etherchannel/README.md) · [Module overview](../README.md)
