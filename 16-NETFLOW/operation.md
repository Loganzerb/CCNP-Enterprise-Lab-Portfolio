# Flexible NetFlow operation

## Forward packets and measure the selected direction

```mermaid
flowchart LR
    A["R2-SOURCE<br/>10.10.10.10"] -->|"ICMP Echo Requests"| B["R1 Gi1 input<br/>Match the flow key"]
    B --> C["Forward through Gi2<br/>R3-DEST: 10.20.20.20"]
    B -.-> D["Monitor cache<br/>100 packets / 10,000 bytes"]
```

The solid path represents endpoint forwarding. The cache records measurements of requests entering Gi1. The successful **100/100** ping validates reachability in both directions; the cache counters measure only the configured input direction.

[Traffic and cache evidence](verification/traffic-and-cache.md)

## Send measurements to the collector

```mermaid
flowchart LR
    A["Record definition<br/>Source / destination / protocol<br/>Bytes / packets"] --> B["NetFlow v9 template<br/>Template ID 256"]
    C["Measured flow values<br/>100 packets / 10,000 bytes"] --> D["Data FlowSet 256"]
    B --> E["R1 Gi3: 10.30.30.1<br/>UDP destination port 2055"]
    D --> E
    E --> F["Alpine eth0: 10.30.30.2<br/>Capture and interpret"]
```

Export sends traffic metadata along the collector link. The template describes the five fields; the data record supplies their values. The handoff's decoded values match the local cache. The diagram explains those relationships and does not reproduce packet timing or imply that a template accompanies every data record.

[Template and data evidence](verification/export-and-templates.md) · [Collector setup](configs/collector.md)

## Keep three timers separate

| Timer | What it controls | Evidence in this lab |
|---|---|---|
| Inactive timeout: 15 seconds | Idle flow aging | One recorded inactive expiration |
| Active timeout: 60 seconds | Aging of an ongoing cached flow | Saved configuration and observed monitor setting |
| Template refresh: 60 seconds | Resending the record definition | Saved exporter setting and reported approximate recurrence |

Identical numerical settings do not give timers the same role. An empty cache after aging is expected; repeated template traffic describes the record structure rather than a new endpoint traffic burst.

[Flow configuration](configs/flow-components.md) · [Verification index](verification/README.md) · [Overview](README.md)
