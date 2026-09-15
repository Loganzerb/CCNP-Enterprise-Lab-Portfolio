# Case 07 — Check a transient state before declaring a persistent fault

MST3 briefly showed a designated port blocked with a Dispute indication. A repeat of the same command showed that port forwarding normally.

## Captured sequence

[The original operational file](../../verification/operational/max-hops-long-cost-and-dispute.txt) contains two `show spanning-tree mst 0` observations:

| MST3 Gi0/0 | First snapshot | Repeated snapshot |
|---|---|---|
| Role | Desg | Desg |
| State | BLK | FWD |
| Type annotation | P2p Dispute | P2p |

The original notes place the observation during region-change reconvergence. The file does not contain timestamps measuring the duration or a capture establishing the underlying BPDU exchange.

## Conclusion and follow-up

The observed Dispute was transient. No specific corrective command is recorded between the snapshots, and the evidence does not establish a persistent cabling or one-way-link fault.

If the state persisted in a replay, inspect both neighbors' port roles and BPDU exchange, alongside interface errors and link directionality. Those are investigation steps, not faults demonstrated by this artifact.

**Takeaway:** repeat and correlate an unusual state before assigning a cause or claiming a repair.

[All cases](../README.md) · [Operational evidence guide](../../verification/operational/README.md)
