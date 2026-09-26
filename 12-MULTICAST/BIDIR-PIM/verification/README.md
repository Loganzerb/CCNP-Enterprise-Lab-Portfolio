# BIDIR evidence

| Sequence | Blocks | What it establishes |
|---|---|---|
| [01 — Unicast foundation](01-foundation.md) | 01–04 | Addressing fault, repair, OSPF and reachability |
| [02 — PIM and BIDIR roles](02-roles.md) | 05–10 | Capability, mapping, DR/DF separation and pre-receiver state |
| [03 — Receiver and forwarding](03-receiver-forwarding.md) | 11–15 | Wrong-host join, corrected receiver branch and initial replies |
| [04 — DF transition](04-df-transition.md) | 16–18 | Metric change, new DF, retained tree and complete post-change traffic test |

Numbering is local to this BIDIR subsection. Each block links to the full supplied text. Chat escaping and HTML spaces are normalized; command errors, incomplete results and unusual displays are retained.

The initial 100-probe capture stops at request 42. The later 30-probe capture is complete and contains 29 replies. Neither is a continuous measurement of traffic during the DF election change. Protocol explanations are distinguished from packet captures, which were not supplied for this exercise.

[Cases](../troubleshooting/README.md) · [Configuration](../configs/README.md) · [Overview](../README.md)
