# EtherChannel and STP

The retained captures form a before/after/failure sequence:

1. Two standalone trunks: one Root Forwarding, one Alternate Blocking.
2. Healthy LACP bundle: `Po1(SU)` and both members `(P)`.
3. STP moves to the logical `Po1` interface with cost `3`.
4. One member fails: `Po1` stays up, remaining member stays bundled, cost rises to `4`.
5. Passive/passive negotiation: both members suspend and `Po1` goes down.
