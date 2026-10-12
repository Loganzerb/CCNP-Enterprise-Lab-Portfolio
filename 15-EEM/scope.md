# Scope and evidence provenance

This completed October 9, 2026 CML exercise covers EEM syslog diagnostics, manual execution, recurring timers, and asynchronous/synchronous CLI event handling. It aligns with ENCOR v1.2 objective 6.6 through applet construction, troubleshooting, and data collection.

## Evidence sources

The **lab record** is the October 9 completed-lab handoff: selected excerpts, commands, and reported observations.

| Material | Source and interpretation |
|---|---|
| Topology, interfaces, platforms, final applet configuration | Original `ENCOR-6.6-EEM-MASTERCLASS_Oct-9th.yaml`; selected configuration is preserved in the sanitized public export and device files |
| Automatic diagnostic sequence, watchdog timestamps, syslog fault sequence, and CLI zero-match debug | Selected excerpts supplied in the completed-lab handoff; formatting and values are retained, but these are not complete terminal transcripts |
| Manual display/completion, successful asynchronous and synchronous tests, successful CLI event history, connectivity and startup saves | Reported observations in the handoff; missing console lines have not been reconstructed |
| Temporary applet and detector configuration | Commands supplied in the handoff; only complete supplied applets are presented as complete examples |
| Topology and process diagrams | Portfolio explanations of the saved design and observed sequence; not lab screenshots or packet captures |

The handoff gives UTC explicitly for the manual, asynchronous, and synchronous completion times. Other excerpt timestamps are retained as supplied. No timezone conversion or new event timestamps have been added.

## Final-state and measurement boundaries

GI1-DOWN-ALERT and MANUAL-DIAG are the only retained EEM applets in the YAML. Temporary timer, fault-test, and CLI-audit policies were removed after successful tests.

The failure trigger was a controlled administrative shutdown. A 3 ms gap between the repaired syslog event and the custom alert is one recorded timestamp interval, not a guaranteed detection latency. The timer timestamps support approximately 60-second recurrence, rather than a timing-precision guarantee.

The CLI debug establishes zero matches for the original expression; the revised expression worked. The record does not prove an IOS defect, hidden whitespace, or a universal restriction on end anchors. Synchronous command blocking, automatic interface remediation, throughput, and production reliability were not demonstrated.

## Public export checks

The original YAML is preserved privately outside this repository. The public YAML and `.cfg` files remove PKI trustpoints/certificate chains, licensing/device identifiers, and call-home settings. Console display headers were removed from configuration fields. All EEM detector/action lines, interface settings, node definitions, image-definition references, and link endpoints remain unchanged. The export parses, its node/link/configuration relationships have been checked, and its configuration fields match the public `.cfg` files. It has not been imported or rerun during documentation work. Image references identify the CML platforms; no Cisco software image is included.

## Technical cross-checks

Source titles: *Implementing Cisco Enterprise Network Core Technologies v1.2 (350-401) Exam Topics*; *Cisco IOS Embedded Event Manager Command Reference — E through event manager Commands*, *event mat through R Commands*, and *A through action snmp Commands*. These establish the objective, manual/timer behavior, CLI publication modes, command permission, and CLI-result variable semantics.

[Verification guide](verification/README.md) · [Configuration source](configs/README.md) · [Overview](README.md)
