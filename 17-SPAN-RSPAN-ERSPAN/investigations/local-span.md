# Local SPAN — enabled state without observed packet replication

**Outcome:** the CSR1000v accepted a local SPAN session and reported a monitoring destination interface, but replicated ICMP traffic was not observed at Alpine.

This investigation used **Gi4 in a separate CML test copy**. The saved ERSPAN topology connects the collector through **Gi3**; its Gi4 is unused, shut down, and unconnected.

**Quick navigation:** [Configuration](#recorded-local-session) · [Observations](#compare-state-with-received-traffic) · [Interpretation](#interpret-the-result)

## Recorded local session

**Recorded configuration from the lab record:**

```cisco
monitor session 2 type local
 description ENCOR-LOCAL-SPAN-LAB
 source interface GigabitEthernet1 both
 destination interface GigabitEthernet4
 no shutdown
```

## Compare state with received traffic

**Reported observations:**

| Check | Result |
|---|---|
| `show monitor session 2` | Admin Enabled; source Both : Gi1; destination Gi4 |
| `show interfaces GigabitEthernet4` | Up, line protocol up (monitoring) |
| Original ICMP connectivity | **10/10** successful |
| Alpine's filtered capture | **Zero ICMP packets** received |
| Alpine's unfiltered capture | Only Alpine-generated DHCP Discover traffic observed |

The successful endpoint ping establishes original forwarding. Session status and the monitoring interface establish configured state. Neither supplies the missing evidence of copies arriving at the collector.

## Interpret the result

The selected captures did not demonstrate local SPAN replication. The record does not establish why it was absent, and no root cause or successful repair is claimed. This remains a configuration/capability investigation rather than a verified working local SPAN lab.

[Investigation index](README.md) · [Configurations](../configs/README.md) · [Verification](../verification/README.md) · [Topology](../topology.md) · [Evidence scope](../scope.md) · [Overview](../README.md)
