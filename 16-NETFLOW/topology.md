# Flexible NetFlow topology and addressing

![Four-node Flexible NetFlow topology with a separate metadata collector](topology.svg)

[PNG rendition](topology.png)

The [sanitized CML export](CML-LAB.yaml) defines four nodes and three physical links. Software versions below follow the supplied handoff and image definitions.

| Node | Platform | Lab role |
|---|---|---|
| R1-FNF | CSR1000v, IOS XE 17.3.2 | Monitors ingress traffic and exports flow measurements |
| R2-SOURCE | IOSv, IOS 15.9 | Generates test traffic from Loopback0 |
| R3-DEST | IOSv, IOS 15.9 | Hosts the destination Loopback0 |
| FNF-COLLECTOR | Alpine Linux 3.13 | Receives exported NetFlow datagrams on eth0 |

## Addressing and source

| Node / interface | Address | Role | Source |
|---|---|---|---|
| R1-FNF Gi1 | `10.12.12.1/30` | R2-facing ingress; `ENCOR-IPV4-MONITOR input` | Saved YAML |
| R1-FNF Gi2 | `10.13.13.1/30` | R3-facing interface | Saved YAML |
| R1-FNF Gi3 | `10.30.30.1/30` | Collector-facing interface and exporter source | Saved YAML |
| R1-FNF Loopback0 | `10.100.1.1/32` | Loopback with description `NETFLOW-EXPORT-SOURCE` | Saved YAML |
| R2-SOURCE Gi0/0 | `10.12.12.2/30` | Link to R1 Gi1 | Saved YAML |
| R2-SOURCE Loopback0 | `10.10.10.10/32` | Test request source | Saved YAML |
| R3-DEST Gi0/0 | `10.13.13.2/30` | Link to R1 Gi2 | Saved YAML |
| R3-DEST Loopback0 | `10.20.20.20/32` | Test request destination | Saved YAML |
| FNF-COLLECTOR eth0 | `10.30.30.2/30` | Export destination | Handoff-reported interactive address; absent from saved startup script |

## Exact physical connections

| First endpoint | Second endpoint | Link network |
|---|---|---|
| R2-SOURCE GigabitEthernet0/0 | R1-FNF GigabitEthernet1 | `10.12.12.0/30` |
| R1-FNF GigabitEthernet2 | R3-DEST GigabitEthernet0/0 | `10.13.13.0/30` |
| R1-FNF GigabitEthernet3 | FNF-COLLECTOR eth0 | `10.30.30.0/30` |

The diagram uses solid lines for these three physical links. Arrows in the notes describe the request and export relationships.

## Request and export paths

The tested ICMP request uses source `10.10.10.10` and destination `10.20.20.20`. It travels from R2 to R1 Gi1, where the input monitor observes it, then through R1 Gi2 toward R3. Alpine receives the exported measurements of that traffic; the test request continues toward R3.

The separate exporter datagrams use source **`10.30.30.1` on R1 GigabitEthernet3**, destination **`10.30.30.2`**, and destination **UDP port 2055**. NetFlow v9 is established by the supplied operational output and packet evidence; the saved exporter block omits an explicit protocol command.

R1 Loopback0 retains the description `NETFLOW-EXPORT-SOURCE`. The exporter configuration explicitly selects **GigabitEthernet3**, so that loopback description does not select the export source.

## Collector portability

The handoff reports that `10.30.30.2/30` was assigned to Alpine eth0 interactively. The saved Alpine startup script does not assign this address. It may need to be reapplied after a restart or reimport; the diagram labels this as reported interactive state.

The illustration combines saved wiring and Cisco configuration with that reported collector state. Observed connectivity and export results are documented in the verification material.

[Module overview](README.md) · [Configuration guide](configs/README.md) · [Verification guide](verification/README.md)
