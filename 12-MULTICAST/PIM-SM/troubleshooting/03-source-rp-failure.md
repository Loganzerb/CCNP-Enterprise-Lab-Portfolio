# Case 03 — A ready receiver with no replies

The receiver tree was already established, but all twenty multicast probes timed out after the source-side router lost its RP mapping. Restoring that mapping brought back the registration mechanism and source-tree state. The lab notes report a receiver reply after the repair.

The operational lesson is to verify both ends: receiver interest does not establish that a new source can reach the multicast tree.

## Establish the healthy side first

MCAST-RECEIVER joined fresh group `239.3.3.3`. Both R4-LHR and R2-RP had `(*,G)` state with the expected receiver-facing branches before the fault. [R4 baseline](../verification/04-source-rp-failure.md#block-01) · [RP baseline](../verification/04-source-rp-failure.md#block-02)

## Fault and diagnosis

The static RP mapping was removed only from **R1-FHR**.

| Check | Observation | Meaning in this test |
|---|---|---|
| [RP mapping](../verification/04-source-rp-failure.md#block-03) | Empty after the removal command | R1 no longer knows the configured RP |
| [PIM tunnel](../verification/04-source-rp-failure.md#block-04) | No entry | The previously observed registration mechanism is absent |
| [Source ping](../verification/04-source-rp-failure.md#block-05) | Twenty timeouts | The established receiver tree is insufficient for delivery under this fault |
| [Diagnostic source entries](../verification/04-source-rp-failure.md#block-06) | Sources are R1's 10.12.0.1 and 10.13.0.1 | These entries cannot verify forwarding for the intended source 10.1.1.10 |

The missing mapping and tunnel, together with the controlled fault and traffic result, localize the problem to the source-side RP relationship. No packet capture of PIM Register messages was retained.

## Targeted repair

R1's mapping was restored:

```cisco
ip pim rp-address 2.2.2.2
```

The lab note then reported that the source received a reply. Subsequent CLI captures show:

- [An UP PIM Encap tunnel to 2.2.2.2](../verification/04-source-rp-failure.md#block-07).
- [The intended source on R1](../verification/04-source-rp-failure.md#block-08), entering Gi0/0 and forwarding toward R3 on Gi0/2.
- [The source tree on R4](../verification/04-source-rp-failure.md#block-09), entering through R3 on Gi0/2 and forwarding toward the receiver.
- [The pruned source branch at R2](../verification/04-source-rp-failure.md#block-10), consistent with the restored source path through R3.

## Outcome and limits

The fault has a complete twenty-probe failure capture. The repair has a reported reply and captured recovered state, but no complete post-repair ping transcript or measured recovery time.

Temporary joins for `239.2.2.2` and `239.3.3.3` were removed. The [final IGMP check](../verification/04-source-rp-failure.md#block-11) retains the original `239.1.1.1` test group.

[Reproduce the changes](../configs/exercise-commands.md#case-03--remove-the-source-side-rp-mapping) · [Back to cases](README.md)

