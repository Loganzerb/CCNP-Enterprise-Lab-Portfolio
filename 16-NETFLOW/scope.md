# Scope and evidence provenance

This completed October 12, 2026 CML lab addresses ENCOR v1.2 **4.2 — Configure and verify Flexible NetFlow**. It covers custom records, monitor attachment, local cache interpretation, NetFlow v9 export, and collector-side packet inspection.

## Sources

| Material | Source and interpretation |
|---|---|
| Router settings, platform/image references, and three physical links | Original `CCNP NETFLOW Oct12th.yaml`; operational settings preserved in the sanitized public export and router configuration files |
| Ping, cache, exporter properties/statistics, and short UDP capture excerpts | Selected command/output excerpts supplied in the completed-lab handoff; not complete console sessions |
| Template field definitions, hexadecimal values, and decoded data | Handoff's packet interpretation; full hexadecimal frames and PCAP files were not supplied |
| Approximate template recurrence and collector UP/LOWER_UP state | Reported observations without timestamps or full interface output |
| Collector address and capture commands | Commands used during the lab; the IPv4 address was interactive and is absent from the export |
| Topology and process diagrams | Explanations derived from saved wiring/configuration and the supplied lab results; not screenshots or new captures |

## Interpretation limits

The local cache and supplied data decoding agree on **100 packets / 10,000 bytes**, source `10.10.10.10`, destination `10.20.20.20`, and ICMP protocol 1. The final exporter statistics are cumulative: they report 25 export packets and two client records. The record does not identify both exported records with that single ping run or establish the complete captured packet sequence.

The 25-byte field length excludes transport/export headers and padding. The exporter-reported 708 bytes are preserved as reported; they are not treated as total Ethernet wire volume. Active aging is configured, while the supplied expiration evidence demonstrates inactive aging. Approximate template recurrence is retained without fabricated timestamps.

This was a controlled CML configuration and verification exercise. Deliberate faults, additional routing protocols, production deployment, and monitoring dashboards were outside its completed scope.

## Public export and portability

The original is preserved privately outside this repository. Public sanitization removes router console headers, generated PKI/certificates, licensing/device identifiers, call-home configuration, and collector login variables. Interfaces, static routes, flow definitions, image references, and links remain unchanged. The exporter typo is preserved, and no explicit protocol/default-timeout commands or persistent collector address have been added.

YAML parsing, saved topology relationships, and router configuration consistency were checked. The sanitized export has not been imported or rerun during documentation work. Alpine's address may need to be reapplied, and local login settings must be handled for the importing environment. No Cisco software images are included.

## Technical cross-checks

Source titles: *Implementing Cisco Enterprise Network Core Technologies v1.2 (350-401) Exam Topics*; *Network Services Configuration Guide, Cisco IOS XE 17.x — Flexible Netflow Overview*; *Cisco IOS Flexible NetFlow Command Reference — cache through match flow*; *Configuring Data Export for Flexible NetFlow with Flow Exporters*; and *RFC 3954 — Cisco Systems NetFlow Services Export Version 9*. These support the objective mapping, component/timer semantics, and template/data format.

[Verification guide](verification/README.md) · [Configurations](configs/README.md) · [Collector setup](configs/collector.md) · [Overview](README.md)
