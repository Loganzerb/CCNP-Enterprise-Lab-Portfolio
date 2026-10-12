# Flexible NetFlow configurations

These router files are sanitized extracts from the completed October 12, 2026 CML export. They retain the original interfaces, static routes, flow definitions, and monitor attachment.

| File or guide | Purpose |
|---|---|
| [R1-FNF.cfg](R1-FNF.cfg) | Monitor/export router: custom record, monitor, exporter, three connected networks, and endpoint routes |
| [R2-SOURCE.cfg](R2-SOURCE.cfg) | Traffic-source loopback and default route through R1 |
| [R3-DEST.cfg](R3-DEST.cfg) | Destination loopback and return route through R1 |
| [CML-LAB.yaml](../CML-LAB.yaml) | Four-node topology with the original interface and link definitions; public configuration sanitized |
| [Flow components](flow-components.md) | Selected saved commands and the reasoning behind record, monitor, direction, and exporter settings |
| [Collector setup](collector.md) | Tested interactive Alpine address and capture commands; the address is not saved in the YAML |

## Saved configuration and observed defaults

The saved monitor explicitly sets its active timeout to 60 seconds. The 15-second inactive timeout was reported in operational output. NetFlow v9 was verified in exporter output and the supplied packet decoding, although the explicit export-protocol command is absent from the saved configuration. No such commands have been added to the public export.

R1's Loopback0 description says `NETFLOW-EXPORT-SOURCE`, but the configured exporter actually uses **GigabitEthernet3**. The supplied operational output confirms source address **10.30.30.1**. The files preserve both the description and the effective setting.

## Public export preparation

The original YAML is preserved outside the public portfolio. Generated PKI trustpoints/certificate chains, device-specific licensing identifiers, call-home settings, and Alpine login variables were removed. Router console display headers were also removed from configuration fields.

Flow, interface, and routing commands remain unchanged, including the exporter description's `ECNOR` typo. Node/image references and all three physical links are preserved. The router `.cfg` files match the public YAML's configuration fields. No software images are included.

The YAML parses and its saved relationships have been checked. It has not been imported or executed again during this documentation work. Alpine login settings must be handled for the user's own lab environment; the public file contains no supplied login credentials.

[Flow components](flow-components.md) · [Collector setup](collector.md) · [Evidence scope](../scope.md) · [Overview](../README.md)
