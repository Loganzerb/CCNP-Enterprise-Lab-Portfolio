# SPAN, RSPAN, and ERSPAN lessons learned

| Engineering distinction | What the lab established |
|---|---|
| Session state versus delivered copies | Local SPAN displayed Admin Enabled and an interface in monitoring state, but replicated ICMP was not observed at Alpine |
| Original traffic versus mirror traffic | Endpoint pings continued through R1; ERSPAN copies used the separate GRE path to Alpine |
| RX versus both directions | RX-only inspection identified incoming traffic; the later Both session supplied decoded requests and replies |
| Inner versus outer addresses | `10.10.10.10` and `10.20.20.20` identify the original endpoints; `10.30.30.1` and `10.30.30.2` identify the mirrored delivery path |
| Packet inspection versus configuration acceptance | Decoded original headers correlated the mirrored traffic with the endpoint test; session configuration alone could not establish delivery |
| Capture counts versus a complete exchange | The 101-packet RX capture was not identified as all ICMP; 12 later GRE packets do not establish a complete capture of the ten-ping exchange |
| CLI capability versus validated transport | RSPAN source CLI and remote-VLAN help were inspected, without demonstrated VLAN transport or successful mirroring |
| Test copy versus saved topology | Local SPAN used Gi4 in a separate test copy; the retained ERSPAN collector link uses Gi3 |
| Interactive state versus saved state | Alpine's tested address was applied interactively; check it after an import or restart |

The practical result was packet-level ERSPAN validation and bounded SPAN/RSPAN investigations. The local SPAN record does not establish a root cause, and the RSPAN investigation does not establish a working implementation.

[Process diagrams](operation.md) · [Investigations](investigations/README.md) · [Configurations](configs/README.md) · [Verification](verification/README.md) · [Topology](topology.md) · [Evidence scope](scope.md) · [Overview](README.md)
