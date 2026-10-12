# ERSPAN topology and addressing

![Four-node ERSPAN topology with a separate GRE collector](topology.svg)

[PNG rendition](topology.png)

The [sanitized CML export](CML-LAB.yaml) contains four nodes and three physical links. Platform versions follow the image definitions and completed-lab record.

| Device | Platform | Role |
|---|---|---|
| R1-ERSPAN | CSR1000v / IOS XE 17.3.2 | Transit router and ERSPAN source |
| R2-SOURCE | IOSv / IOS 15.9 | Generates ICMP from Loopback0 |
| R3-DEST | IOSv / IOS 15.9 | Destination Loopback0 |
| ERSPAN-CAPTURE | Alpine Linux 3.13 | Receives and inspects GRE on eth0 |

## Addressing

| Device / interface | Address | Purpose | Source |
|---|---|---|---|
| R1 Gi1 | `10.12.12.1/30` | R2-facing monitored interface | Saved YAML |
| R1 Gi2 | `10.13.13.1/30` | R3-facing routed interface | Saved YAML |
| R1 Gi3 | `10.30.30.1/30` | Collector link and outer ERSPAN origin | Saved YAML |
| R2 Gi0/0 | `10.12.12.2/30` | Link to R1 | Saved YAML |
| R2 Loopback0 | `10.10.10.10/32` | Original ICMP source | Saved YAML |
| R3 Gi0/0 | `10.13.13.2/30` | Link to R1 | Saved YAML |
| R3 Loopback0 | `10.20.20.20/32` | Original ICMP destination | Saved YAML |
| Alpine eth0 | `10.30.30.2/30` | Outer ERSPAN destination | Interactive lab state; absent from saved startup script |

## Physical wiring

| First endpoint | Second endpoint | Subnet |
|---|---|---|
| R2 GigabitEthernet0/0 | R1 GigabitEthernet1 | `10.12.12.0/30` |
| R1 GigabitEthernet2 | R3 GigabitEthernet0/0 | `10.13.13.0/30` |
| R1 GigabitEthernet3 | ERSPAN-CAPTURE eth0 | `10.30.30.0/30` |

R1 Gi4 exists in the device definition but is shutdown and unconnected in this export. The separate Local SPAN investigation used Gi4 in a test copy; that wiring is not implied by this diagram.

## Two traffic paths

The original request follows **R2 → R1 Gi1 → R1 Gi2 → R3**. A reply enters R1 Gi2 and leaves Gi1. RX-only monitoring on Gi1 sees incoming requests; the final bidirectional state monitors ingress and egress on that port.

The mirrored copy follows **R1 Gi3 → Alpine eth0**. Its outer addresses are `10.30.30.1 → 10.30.30.2`, with GRE IP protocol 47. The original loopback addresses remain inside the encapsulated packet. Alpine is a packet-inspection endpoint, not a router forwarding the original ICMP exchange or a configured Cisco ERSPAN destination session.

[Process diagrams](operation.md) explain the paths and header layers. [Collector setup](configs/collector.md) documents the interactive address and restart/import requirements.

[Overview](README.md) · [Configurations](configs/README.md) · [Verification](verification/README.md) · [Evidence scope](scope.md)
