# Flexible NetFlow verification guide

The October 12, 2026 completed-lab handoff records successful endpoint traffic, local flow collection and inactive expiration, NetFlow v9 delivery to Alpine, and interpretation of template and data fields.

**Quick navigation:** [Verification guides](#verification-guides) · [Evidence block index](#evidence-block-index) · [Read the evidence](#read-the-evidence)

## Verification guides

| Guide | Blocks | Recorded result |
|---|---|---|
| [Traffic and flow cache](traffic-and-cache.md) | 01–06 | 100/100 replies; one ingress ICMP flow with 100 packets and 10,000 bytes; later aged by the observed 15-second inactive timeout |
| [Export and NetFlow v9 templates](export-and-templates.md) | 07–15 | UDP 2055 delivery; supplied decoding of template 256 and its data fields; cumulative exporter statistics |

## Evidence block index

| Block | Evidence | Location |
|---|---|---|
| 01 | Source ping command | [Traffic generation](traffic-and-cache.md#block-01) |
| 02 | Ping success and round-trip values | [Traffic result](traffic-and-cache.md#block-02) |
| 03 | Flow-cache inspection command | [Cache inspection](traffic-and-cache.md#block-03) |
| 04 | Populated cache and flow counters | [Collected flow](traffic-and-cache.md#block-04) |
| 05 | Observed inactive and active timeout values | [Cache timers](traffic-and-cache.md#block-05) |
| 06 | Cache after inactive expiration | [Aged flow](traffic-and-cache.md#block-06) |
| 07 | Operational exporter properties | [Exporter properties](export-and-templates.md#block-07) |
| 08 | Collector UDP capture command | [Capture command](export-and-templates.md#block-08) |
| 09 | Two supplied UDP packet excerpts | [Received datagrams](export-and-templates.md#block-09) |
| 10 | Hexadecimal capture command | [Hex capture command](export-and-templates.md#block-10) |
| 11 | Supplied template decoding summary | [Template summary](export-and-templates.md#block-11) |
| 12 | Supplied data-record decoding summary | [Data summary](export-and-templates.md#block-12) |
| 13 | Configured template refresh interval | [Template refresh](export-and-templates.md#block-13) |
| 14 | Exporter-statistics command | [Statistics command](export-and-templates.md#block-14) |
| 15 | Cumulative exporter statistics | [Statistics output](export-and-templates.md#block-15) |

## Read the evidence

The numbered blocks preserve the supplied command, output, configuration, and decoded-summary contents verbatim. They are selected handoff excerpts, not one continuous console transcript. The field-definition and hexadecimal-value tables also preserve the supplied decoding.

Full raw hexadecimal output and a packet-capture file were not supplied. Approximate 60-second template recurrence and Alpine `eth0` being UP/LOWER_UP are reported observations without timestamped recurrence output or a full interface-status transcript. The configured active timeout was not demonstrated expiring a continuing flow.

Export packets and flow records measure exported telemetry; their counts are separate from the 100 original ICMP Echo Requests. These pages document the completed working exercise without introducing failed configurations or new troubleshooting tests.

[Flexible NetFlow overview](../README.md) · [Configurations](../configs/README.md) · [Collector setup](../configs/collector.md) · [Operation](../operation.md) · [Evidence scope](../scope.md)
