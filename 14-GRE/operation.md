# Packet flow — two routing decisions for one carried packet

## Underlay and overlay

The **underlay** is the physical R1–R2–R3 IP network. R1 reaches the remote transport endpoint 198.51.100.2 through 192.0.2.2; R3 reaches R1’s endpoint 192.0.2.1 through 198.51.100.1.

The **overlay** is Tunnel0 between 172.16.13.1 and 172.16.13.2. OSPF process 10 uses it to exchange routes between the private loopbacks. R1’s captured neighbor is RID 3.3.3.3, FULL on Tunnel0; the route to 10.3.3.1/32 has next hop 172.16.13.2 and metric 1001.

## Follow the sourced private ping

```mermaid
flowchart LR
    A["Inner packet: 10.1.1.1 → 10.3.3.1"] --> B["R1: OSPF selects Tunnel0"]
    B --> C["GRE encapsulation: outer 192.0.2.1 → 198.51.100.2"]
    C --> D["R2: routes outer IP packet"]
    D --> E["R3: removes outer IP and GRE headers"]
    E --> F["Delivers to 10.3.3.1; reply returns through overlay"]
```

R2 only needs reachability for the outer transport packet. Its captured configuration has two connected underlay networks, no tunnel and no OSPF process. The [5/5 sourced private ping](verification/01-baseline.md#block-05--carry-private-to-private-traffic) validates the complete request/reply exchange; the drawing explains that exchange rather than presenting a packet capture.

## Read the interface fields carefully

| Captured field | Meaning in this lab |
|---|---|
| Source 192.0.2.1; destination 198.51.100.2 | Outer IP transport endpoints, distinct from overlay addresses |
| GRE/IP | GRE carried directly over IPv4; IP protocol 47 |
| Keepalive not set | No GRE keepalive configured in the retained baseline |
| Key disabled | No optional GRE key; a GRE key is not encryption |
| TTL 255 | Captured tunnel transport TTL, not a traceroute measurement |
| Transport MTU 1476 | Size limit used in the packet-boundary tests |
| Interface MTU 17916 | Separate tunnel-interface display field; not evidence that a 17916-byte packet fits the physical path unfragmented |
| BW 100 Kbit/sec | Routing metric input, not measured tunnel throughput |

The captured OSPF route metric is 1001. With the default 100 Mbps reference bandwidth and the displayed tunnel bandwidth, the tunnel cost is 1000 plus a loopback cost of 1. This calculation explains the result; no explicit cost override or throughput test is present in the baseline.

[Actual interface and OSPF output](verification/01-baseline.md) · [MTU interpretation](troubleshooting/03-mtu-boundary.md) · [Overview](README.md)
