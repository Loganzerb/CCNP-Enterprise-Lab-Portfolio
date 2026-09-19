# MSTP troubleshooting

The cases cover configuration mismatches, external-root behavior and protection at a protocol boundary. Start with Case 06 for the most complete failure-and-clear record, then use the identity cases to examine diagnostic reasoning.

| Case | Question or symptom | Evidence retained |
|---|---|---|
| [01 — Revision mismatch](scenario-1-revision-mismatch/README.md) | Why is MST3 outside the region when its digest matches? | Revision 2, boundary roles and local instance roots |
| [02 — Mapping mismatch](scenario-2-mapping-digest-mismatch/README.md) | What changed when VLAN 20 moved instances? | New digest and an observed mapping/boundary summary |
| [03 — Name mismatch](scenario-3-region-name-mismatch/README.md) | Why does the region split with matching revision and digest? | WRONG_REGION and explicit boundary roles |
| [04 — External CIST root](scenario-4-external-cist-root-boundary/README.md) | How do Regional Root, Root and Master differ? | Normal external-root roles; link-failure sequence described in notes |
| [05 — Superior PVST VLAN](scenario-5-pvst-sim-superior-vlan/README.md) | Why is a designated boundary blocked? | Failure and inconsistent entries; no retained recovery transcript |
| [06 — Inferior PVST VLAN](scenario-6-pvst-sim-inferior-vlan/README.md) | Why is the external root path blocked? | Failure, clear log and inconsistent count returning to zero |
| [07 — Transient Dispute](scenario-7-transient-dispute/README.md) | Does one blocked snapshot prove a persistent fault? | Two observations: Dispute, then normal forwarding |

These are documented controlled exercises and observations. The cases distinguish **captured output**, **original lab narrative**, **saved configuration**, and **checks for a future replay**. A saved baseline does not replace a missing post-change capture.

[Section overview](../README.md) · [Full evidence index](../verification/README.md)
