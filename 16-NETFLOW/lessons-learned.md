# Flexible NetFlow lessons learned

| Engineering distinction | What the lab established |
|---|---|
| Forwarding versus measurement | A successful ping and an accurate flow cache are separate checks; both matched the controlled test |
| Match versus collect | Source, destination, and protocol identify the flow; counters accumulate measurements |
| Direction matters | Gi1 input captures source-to-destination requests; return traffic takes a different input interface |
| Empty cache versus failed monitoring | The recorded cache emptied because one flow aged through its inactive timeout |
| Three independent timers | Active aging, inactive aging, and template refresh have different functions |
| Template versus data | FlowSet 0 contains the template definition; data FlowSet 256 uses template 256's five fields |
| Record bytes versus packet bytes | The fields total 25 bytes; export datagrams also contain headers and padding |
| Original packets versus export packets | The 100 ICMP requests, cumulative 25 export packets, and two client records describe different things |
| Description versus effective configuration | Gi3 is the actual export source, despite Loopback0's description |
| Saved state versus interactive state | The YAML preserves router settings and wiring, but Alpine's tested IPv4 address must be checked after import |

The practical skill demonstrated is verifying a measurement path from interface attachment through local cache, remote delivery, and template-based interpretation. Troubleshooting challenges were deferred; this entry documents the completed configuration and verification work.

[Verification](verification/README.md) · [Process diagrams](operation.md) · [Overview](README.md)
