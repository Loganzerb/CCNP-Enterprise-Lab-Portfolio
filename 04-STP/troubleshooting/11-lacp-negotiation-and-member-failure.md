# Case 11 — LACP negotiation and member failure

## Healthy baseline

Both members bundled as `Gi0/0(P)` and `Gi0/1(P)` under `Po1(SU)`. STP selected `Po1` as the VLAN 10 Root Port with local cost `3`.

## Failure A: one physical member down

Shutting Gi0/1 left Gi0/0 bundled. `Po1` remained Layer 2/in use, and STP kept the same logical Root Port while its cost rose from `3` to `4`.

Evidence: [single-member failure](../verification/etherchannel/SW5-single-member-failure.txt).

## Failure B: passive/passive LACP

With both peers passive, neither initiated LACP. Both members suspended, `Po1` became `SD`, and logs reported `%EC-5-L3DONTBNDL2`.

Evidence: [passive/passive failure](../verification/etherchannel/SW5-passive-passive-failure.txt).

## Recovery

Set at least one peer to LACP active and verify `Po1(SU)` with every intended member in `(P)`.

## Lesson

Member failure and channel negotiation failure are different operational events. A single member failure can preserve the logical STP path; passive/passive prevents the logical bundle from forming.
