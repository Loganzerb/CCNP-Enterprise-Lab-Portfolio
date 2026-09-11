# Verification evidence

The `.txt` files preserve user-pasted source messages from **MASTERCLASS CCNP LAB PART 3** (`6a94caeb-6ca4-83ea-93e3-f4eccdd6cbb5`). Each capture identifies its source message UUID. Only relevant NAT material is included.

HTML space entities, Markdown escapes, and line endings are normalized. Prompts, partial commands, original counters, timing variation, and occasional user remarks remain where they were part of a selected message. Separators and introductory provenance text are editorial metadata, not terminal output.

The [guided lab narrative](guided-labs.md) explains the progression. The [main artifact index](../README.md#artifact-index) gives a plain-English summary of every technical file, including both incidents.

## Read captures correctly

- A source message may contain several sequential commands. A translation table and statistics collected afterward may differ because state ages.
- Cumulative counters are not per-test deltas unless paired before/after measurements establish that.
- NAT's top-level Misses and a pool's allocation misses are different reported fields; both are preserved.
- Protocol entries can appear alongside base mappings. Entry counts are not automatically client or allocated-address counts.
- ICMP rows contain identifiers; TCP rows contain port information. An extended row alone does not establish that overload is configured.
- Configuration snapshots, reported symptoms, interpretation, and measured results are labelled separately in the incident write-ups.

Original fault configurations are provided under `configs/`; no missing initial CLI output has been reconstructed as evidence. The portfolio build performed file/content checks only and did not run new network tests.
