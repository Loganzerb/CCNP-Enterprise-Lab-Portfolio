# Scenario 7 — Transient Dispute during reconvergence

During a region-change reconvergence, MST3 briefly displayed `P2p Dispute` and blocked a designated port. A repeat of `show spanning-tree mst 0` showed the same port in normal `Desg FWD` state.

This artifact is intentionally labeled **transient**. It is evidence of rapid-transition protection during unstable information, not proof of a persistent cabling or configuration fault. A persistent Dispute would require checking bidirectional BPDU exchange, unidirectional-link conditions, and the neighbor's state.

Evidence: [operational capture](../../verification/operational/max-hops-long-cost-and-dispute.txt).
