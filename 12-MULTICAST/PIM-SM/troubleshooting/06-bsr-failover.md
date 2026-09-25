# Case 06 — Isolate the preferred BSR, then restore it

I tested whether the connected PIM domain could elect another Bootstrap Router when R5 became unreachable. R3 took over after the old BSR state aged, then accepted R5 again after the link returned.

## Starting point and controlled change

R3 and R5 both had BSR priority 20 and hash-mask length 0. R5 remained elected because `5.5.5.5` is the larger BSR address. R3's [equal-priority capture](../verification/09-bsr-election.md#block-06) shows both its candidacy and its elected peer.

On **R5-BSR2**, the test shut Gi0/0, its only transit link:

```text
configure terminal
interface GigabitEthernet0/0
 shutdown
end
```

This isolates the preferred candidate without removing the R1–R3–R4 source path or the R2 RP branch. R5's local process can remain active in its isolated partition.

## Observe the transition

The [R3 capture](../verification/09-bsr-election.md#block-07) records:

1. R5 still listed as BSR while its retained state ages.
2. OSPF neighbor loss, then PIM neighbor loss on Gi0/2.
3. R3 reporting itself as BSR at `3.3.3.3`, priority 20.

These are separate protocol states with their own timers. The sampled output does not establish that an OSPF event directly triggered election, or provide an exact elapsed takeover time.

## Recovery

Restore **R5-BSR2** Gi0/0:

```text
configure terminal
interface GigabitEthernet0/0
 no shutdown
end
```

PIM and OSPF adjacencies return. R5 reports itself as BSR, and a separate R3 check again lists elected BSR `5.5.5.5`. The election prefers the better candidate after it returns; no separate HSRP-style preemption command was used.

[R5 recovery](../verification/09-bsr-election.md#block-08) · [R3 accepts R5](../verification/09-bsr-election.md#block-09)

## What the test establishes

The captured R3/R5 views demonstrate BSR takeover and recovery across the affected link. This exercise preceded Candidate RP setup, so it does not establish RP failover, uninterrupted multicast delivery or packet-loss performance. The final design still has only one Candidate RP.

## Lesson learned

Verify recovery from another router as well as the candidate itself. A local BSR declaration in an isolated partition does not establish that the connected domain has accepted that router.

[Next: broken RP distribution](07-bsr-propagation.md) · [All cases](README.md) · [BSR overview](../bsr.md)
