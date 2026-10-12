# ERSPAN verification guide

The October 12, 2026 lab record reports successful endpoint traffic, RX-only mirroring, decoded original payloads, and a Both-direction request/reply pair. Alpine received and inspected the GRE traffic directly; an ERSPAN destination session was not built.

**Quick navigation:** [Verification guides](#verification-guides) · [Evidence block index](#evidence-block-index) · [Read the evidence](#read-the-evidence)

## Verification guides

| Guide | Evidence | Recorded result |
|---|---|---|
| [Connectivity](connectivity.md) | Reported test results | R1-to-collector 10/10; endpoint loopback test 100/100; subsequent ping 10/10 |
| [RX capture and original payload](rx-payload.md) | Blocks 01–02; reported observations and decoding | 101 GRE packets, including a separate packet; decoded Echo Request and CDP payload observations |
| [Bidirectional mirroring](bidirectional.md) | Block 03; reported packet observations | Runtime Both : Gi1; 12 GRE packets with a request/reply pair at sequences 122/123; R2 ping 10/10 |

## Evidence block index

| Block | Supplied snippet | Location |
|---|---|---|
| 01 | RX-only GRE capture command | [RX capture](rx-payload.md#block-01) |
| 02 | Hexadecimal payload-inspection command | [Payload inspection](rx-payload.md#block-02) |
| 03 | Selected `show monitor session 1` output | [Runtime direction](bidirectional.md#block-03) |
| Collector Block 01 | Interactive address command | [Collector setup](../configs/collector.md#block-01) |

## Read the evidence

Numbered blocks preserve actual snippets supplied in the completed-lab handoff. The monitor-session block is the single selected device-output excerpt. Ping counts, packet counts, capture-drop counts, sequence observations, and decoded fields are reported results, presented as prose or labeled tables.

Full ping transcripts, raw hexadecimal output, and a PCAP file were not supplied. The pages do not reconstruct those artifacts or turn the selected Both-direction capture into a complete record of every probe. [Evidence scope](../scope.md) defines the module's source boundaries; [platform investigations](../investigations/README.md) separately document the unverified local SPAN and RSPAN work.

[ERSPAN overview](../README.md) · [Topology](../topology.md) · [Configurations](../configs/README.md) · [Collector setup](../configs/collector.md) · [Packet flow](../operation.md) · [Evidence scope](../scope.md)
