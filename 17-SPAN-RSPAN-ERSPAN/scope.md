# Scope and evidence provenance

This October 12, 2026 lab addresses **ENCOR v1.2 4.3 — Configure SPAN/RSPAN/ERSPAN**. ERSPAN was configured and validated through collector-side packet inspection. Local SPAN and RSPAN remain capability investigations, with their recorded limits preserved.

## Sources

The **lab record** is the completed-lab handoff: selected configuration/output excerpts, capture commands, reported test results, and decoded packet observations.

| Material | Source and interpretation |
|---|---|
| Router configuration, device/image definitions, interfaces, and three links | Original `CCNP SPAN RSPAN ERSPAN Oct12th.yaml`; preserved in the sanitized public export and router extracts |
| Working source-session command sequence and selected `show monitor session 1` output | Supplied excerpts from the completed lab; configuration commands and output are labeled separately |
| Ping success, capture counts/drops, GRE sequences, and inner/outer packet fields | Reported observations and packet decoding from the handoff; full ping/capture transcripts were not supplied |
| Collector address and tcpdump commands | Commands used in the lab; the collector address is interactive and absent from the saved startup script |
| Local SPAN and RSPAN commands/help and results | Separate capability investigations described in the handoff; not successful mirroring implementations |
| Topology and process diagrams | Illustrations derived from the saved topology and lab record; not screenshots or packet captures |

## Interpretation limits

No PCAP file or complete hexadecimal packet dump was supplied or created. Decoded fields and GRE sequence numbers retain the lab record's observations; missing packet bytes, timestamps, and console lines have not been reconstructed. Type II is the supplied packet-format identification, not a fresh independent decode of raw frames.

The RX-only capture included 101 GRE packets and a separate non-ICMP observation. The subsequent bidirectional capture contained 12 GRE packets, including a matching request/reply pair. Neither capture count is equated with a complete set of mirrored ICMP packets from its ping test. Zero capture-kernel drops does not establish loss-free delivery across every stage of the mirroring path.

The representative outer IPv4 length of 150 bytes describes one decoded packet carrying a 100-byte original IPv4 ICMP packet. It is not total Ethernet wire size, a fixed length for every ERSPAN packet, or a throughput measurement.

Local SPAN's accepted state did not establish packet replication. The cause of its unobserved delivery was not isolated. RSPAN transport and source-to-destination forwarding were not tested. These results do not establish a universal capability or defect for other platforms, images, or deployments.

## Public export and portability

The original YAML is preserved privately outside the public portfolio. Sanitization removes console display headers, generated PKI trustpoints/certificate chains, the device licensing identifier, call-home configuration, and Alpine login variables. Router interfaces, static routes, the ERSPAN session, node/image definitions, and physical links remain unchanged. The router `.cfg` files match the public YAML's configuration fields.

No Cisco software images are included. Use compatible images and access settings in the local CML environment. Alpine addressing remains interactive; no persistent startup change was added. YAML parsing, saved relationships, configuration extraction, and documentation links were checked. The sanitized export has not been freshly imported or rerun during this documentation work.

## Technical cross-checks

Source titles: *Implementing Cisco Enterprise Network Core Technologies v1.2 (350-401)*; *LAN and WAN Configuration Guide, Cisco IOS XE 17.x — Configuring ERSPAN*; *Command Reference, Cisco IOS XE Amsterdam 17.3.x — Network Management Commands*; *Verify SPAN and ERSPAN on Catalyst 9000 Series Switches*; and *Configure Switched Port Analyzer on ACI*.

These support the objective, mirroring roles, direction controls, and encapsulation concepts. Cross-platform examples explain packet formats; they do not establish a CSR1000v-wide capability guarantee or replace this lab's recorded results.

[Overview](README.md) · [Configurations](configs/README.md) · [Verification](verification/README.md) · [Investigations](investigations/README.md)
