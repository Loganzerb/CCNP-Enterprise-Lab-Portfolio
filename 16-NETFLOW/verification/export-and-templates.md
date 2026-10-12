# Export delivery and NetFlow v9 templates

R1-FNF exported flow telemetry to the Alpine collector over UDP 2055. The handoff supplies packet excerpts, decoded template and data values, and exporter statistics; it does not supply a full raw hexadecimal capture or a packet-capture file.

**Quick navigation:** [Exporter properties](#exporter-properties) · [Remote delivery](#remote-delivery) · [Template and data decoding](#template-and-data-decoding) · [Template refresh](#template-refresh) · [Exporter statistics](#exporter-statistics) · [Evidence scope](#evidence-scope)

## Exporter properties

### Block 07

**Supplied operational exporter properties.**

```text
Export protocol:          NetFlow Version 9
Destination IP address:   10.30.30.2
Source IP address:        10.30.30.1
Source Interface:         GigabitEthernet3
Transport Protocol:       UDP
Destination Port:         2055
Export template timeout:  60
```

The destination is the collector address `10.30.30.2`. GigabitEthernet3 supplies the export source address `10.30.30.1`, and UDP destination port `2055` selects the collector transport port. NetFlow v9 identifies the telemetry format. The 60-second template timeout controls template refresh, separately from flow-cache aging.

NetFlow v9 is explicitly recorded in this output and in the supplied packet decoding. The final exported configuration omits an explicit export-protocol command; the operational result does not justify adding that command to the preserved configuration.

## Remote delivery

### Block 08

**Supplied command — FNF-COLLECTOR.**

```bash
sudo tcpdump -ni eth0 -vv 'udp port 2055'
```

### Block 09

**Supplied received-packet excerpts.**

```text
10.30.30.1.53971 > 10.30.30.2.2055:
UDP, length 48

10.30.30.1.53971 > 10.30.30.2.2055:
UDP, length 52
```

The two UDP payload lengths are 48 and 52 bytes. Both excerpts show source `10.30.30.1`, destination `10.30.30.2`, and destination port `2055`, matching the exporter properties. They demonstrate delivery of export datagrams to Alpine, independently of the router's local flow cache.

Alpine's `eth0` being UP/LOWER_UP is reported in the handoff without a full interface-status transcript. Its address was configured interactively and is not preserved by the supplied CML export; [collector setup](../configs/collector.md) documents that portability limit.

## Template and data decoding

### Block 10

**Supplied hexadecimal-capture command — FNF-COLLECTOR.**

```bash
sudo tcpdump -ni eth0 -s 0 -XX 'udp dst port 2055'
```

### Block 11

**Supplied decoded template summary.** This is the handoff's decoding, not a reconstructed raw header.

```text
NetFlow version:     9
Template FlowSet ID: 0
Template ID:         256
Number of fields:    5
```

**Supplied decoded field definitions.**

| Field ID | Meaning | Length |
|---|---|---|
| 8 | IPv4 source address | 4 bytes |
| 12 | IPv4 destination address | 4 bytes |
| 4 | IP protocol | 1 byte |
| 1 | Byte counter | 8 bytes |
| 2 | Packet counter | 8 bytes |

Template FlowSet ID `0` carries the definition for template `256`. Its five fields total `4 + 4 + 1 + 8 + 8 = 25` bytes per data record. That total counts field values only; it excludes NetFlow packet headers, FlowSet headers, and padding.

### Block 12

**Supplied decoded data-record summary.** The corresponding data FlowSet uses ID `256` to identify that template's field layout.

```text
Source IPv4:       10.10.10.10
Destination IPv4:  10.20.20.20
IP protocol:       1 (ICMP)
Byte counter:      10000
Packet counter:    100
```

**Supplied decoded hexadecimal values.**

| Hexadecimal | Value |
|---|---|
| `0A 0A 0A 0A` | 10.10.10.10 |
| `0A 14 14 14` | 10.20.20.20 |
| `01` | ICMP |
| `00 00 00 00 00 00 27 10` | 10,000 bytes |
| `00 00 00 00 00 00 00 64` | 100 packets |

The template describes how to interpret the values; the data record contains the measurements. Its addresses, ICMP protocol, 10,000-byte counter, and 100-packet counter match the [populated local cache](traffic-and-cache.md#block-04). The handoff supplies these decoded values and selected hexadecimal field values, without the full raw hexadecimal output or a packet-capture file.

## Template refresh

### Block 13

**Supplied exporter configuration line.**

```cisco
template data timeout 60
```

The handoff reports repeated 48-byte template datagrams approximately 60 seconds apart. No recurrence timestamps were supplied, so this remains a reported observation rather than a calculated timing interval.

Refreshing the template resends the record layout. It is separate from the monitor's configured 60-second active timeout and observed 15-second inactive timeout, which govern cache entries.

## Exporter statistics

### Block 14

**Supplied command — R1-FNF.**

```cisco
show flow exporter statistics
```

### Block 15

**Supplied final exporter-statistics output.**

```text
Flow Exporter ENCOR-IPV4-EXPORTER:
  Packet send statistics (last cleared 00:27:50 ago):
    Successfully sent:         25 (708 bytes)

  Client send statistics:
    Client: Flow Monitor ENCOR-IPV4-MONITOR
      Records added:           2
        - sent:                2
      Bytes added:             50
        - sent:                50
```

These cumulative statistics report 25 successfully sent export packets and 708 bytes in the router's packet-send counter, plus two client flow records and 50 bytes of record fields sent. Two records at 25 field bytes each account for the client byte total. The 708-byte value is preserved as reported; it is not a calculation of complete wire volume.

The 25 export packets are telemetry datagrams, not the 100 original ICMP packets. The two received-packet excerpts are a selection and do not establish the composition of all 25 exports. The two exported records also do not establish two identical repetitions of the ping test.

## Evidence scope

The output, command, and decoded-summary blocks preserve the handoff's supplied contents. Decoded tables are supplied interpretations; no missing header bytes, capture timestamps, packet sequence, or raw capture has been reconstructed. The packet excerpts and exporter statistics support remote delivery and export activity without proving a continuous capture of every exported datagram.

[Traffic and cache](traffic-and-cache.md) · [Verification index](README.md) · [Flexible NetFlow overview](../README.md) · [Configurations](../configs/README.md) · [Collector setup](../configs/collector.md) · [Operation](../operation.md) · [Evidence scope](../scope.md)
