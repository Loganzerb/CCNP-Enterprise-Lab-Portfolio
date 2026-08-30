# Verification evidence

This directory organizes retained CLI captures by operational theme. Files are raw-style transcripts from the completed lab, with prompts and command output preserved where available.

| Theme | What it proves |
|---|---|
| `root-election/` | VLAN-specific root identity and port roles |
| `convergence/` | Classic timer observations and Rapid PVST+ state summary |
| `protection/` | Feature/status baselines used during protection tests |
| `path-engineering/` | Long path-cost scale and deterministic Root Port selection |
| `etherchannel/` | Parallel-link baseline, LACP formation, degradation, and failure |
| `bridge-assurance/` | Point-to-point detail and network-port context |

Not every observed failure had a complete transcript retained. Those cases remain documented in `../troubleshooting/` without invented CLI output.
