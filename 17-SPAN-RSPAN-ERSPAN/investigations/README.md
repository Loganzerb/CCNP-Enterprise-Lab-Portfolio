# Local SPAN and RSPAN investigations

These investigations separate accepted configuration and command help from observed packet delivery. Neither is presented as a completed working SPAN or RSPAN implementation.

## Investigation index

| Investigation | What was established | Remaining evidence boundary |
|---|---|---|
| [Local SPAN](local-span.md) | A separate Gi4 test accepted the local session; Admin Enabled and monitoring interface state were reported | Alpine did not observe replicated ICMP; no root cause was established |
| [RSPAN](rspan.md) | The CSR1000v recognized an RSPAN source session and exposed remote-VLAN help | VLAN transport and source-to-destination mirroring were not demonstrated |

## Read the findings

Configuration and help snippets retain the lab record's text. Session/interface states and capture observations are reported results, not reconstructed console output. The local Gi4 test is separate from the saved three-link ERSPAN topology.

Successful ERSPAN packet inspection is documented in the [verification guide](../verification/README.md). These investigations explain why enabled session state or visible CLI alone cannot establish delivered mirror traffic.

[Configurations](../configs/README.md) · [Topology](../topology.md) · [Evidence scope](../scope.md) · [Overview](../README.md)
