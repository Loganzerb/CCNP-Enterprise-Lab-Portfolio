# Flow record, monitor, and exporter

These selected configuration blocks come from the saved R1-FNF configuration. Read them alongside the [operational evidence](../verification/README.md), which establishes what the lab actually observed.

**Quick navigation:** [Record](#record--identify-and-measure-a-flow) · [Monitor](#monitor--apply-the-record-to-incoming-traffic) · [Exporter](#exporter--deliver-the-measurements)

## Record — identify and measure a flow

```cisco
flow record ENCOR-IPV4-RECORD
 description CCNP ENCOR Flexible Netflow Lab
 match ipv4 source address
 match ipv4 destination address
 match ipv4 protocol
 collect counter bytes long
 collect counter packets long
```

The three `match` fields form the key used to group observed packets. The two `collect` fields accumulate measurements for that key; `long` selects 64-bit counters.

For this controlled test, source `10.10.10.10`, destination `10.20.20.20`, and protocol **1 (ICMP)** identify the monitored traffic. TCP/UDP port fields are unnecessary for this ICMP test. This key groups traffic sharing those three values; it does not identify individual ping sessions or ICMP message types.

The field values occupy **25 bytes**: two 4-byte addresses, one protocol byte, and two 8-byte counters. This is the data-record field length, excluding export headers and padding. [Template field definitions](../verification/export-and-templates.md)

## Monitor — apply the record to incoming traffic

```cisco
flow monitor ENCOR-IPV4-MONITOR
 description CCNP ENCOR Local Flow Monitoring
 exporter ENCOR-IPV4-EXPORTER
 cache timeout active 60
 record ENCOR-IPV4-RECORD
```

Selected interface attachment:

```cisco
interface GigabitEthernet1
 ip flow monitor ENCOR-IPV4-MONITOR input
```

R2's Echo Requests enter R1 on Gi1, making input the relevant monitoring direction. Echo Replies enter Gi2 and leave Gi1, so this attachment does not measure both directions.

| Timer | Saved or observed state | Meaning |
|---|---|---|
| Active | **60 seconds**, explicitly configured | Ages an ongoing cached flow when it reaches the active timeout |
| Inactive | **15 seconds**, observed operational value; absent from saved configuration | Ages a cached flow after inactivity |

The supplied cache output demonstrates inactive expiration. It does not provide an active-timeout expiration test. [Traffic and cache verification](../verification/traffic-and-cache.md)

## Exporter — deliver the measurements

```cisco
flow exporter ENCOR-IPV4-EXPORTER
 description CCNP ECNOR NetFlow v9 Export
 destination 10.30.30.2
 source GigabitEthernet3
 transport udp 2055
 template data timeout 60
```

| Setting | Meaning in this lab |
|---|---|
| Destination `10.30.30.2` | Collector that receives exported measurements |
| Source Gi3 / `10.30.30.1` | Router interface address used as the export datagram's source |
| UDP destination port `2055` | Transport endpoint selected for this collector capture |
| NetFlow v9 | Export format verified operationally; its explicit command is omitted from the saved configuration |
| Template timeout `60` | Template refresh interval, independent of monitor cache aging |

The description typo is retained exactly. Loopback0 is described as an export source in its interface configuration, but the exporter uses Gi3; the operational output and collector excerpt agree with Gi3's address.

A template describes the fields and their lengths. A data record carries measured values using that template. [Export and template verification](../verification/export-and-templates.md)

[Configuration index](README.md) · [Process diagrams](../operation.md) · [Overview](../README.md)
