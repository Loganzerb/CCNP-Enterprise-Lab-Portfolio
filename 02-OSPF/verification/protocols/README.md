# Protocol settings — what explains the observed behavior?

Each `show ip protocols` file includes an `ospf 1` section. Some also include BGP or an application routing process because the devices were part of a larger masterclass topology.

| Capture | OSPF details to inspect |
|---|---|
| [O1-CORE](O1-show-ip-protocols.txt) | Router ID `10.100.1.1`; one normal area; Gi0/1 enabled explicitly under the interface |
| [O2-ABR](O2-show-ip-protocols.txt) | Two areas: one normal and one NSSA; IOS reports area-border and autonomous-system-boundary roles |
| [O3-BRANCH](O3-show-ip-protocols.txt) | One NSSA; branch network range; maximum paths 2; passive loopbacks |
| [O4-EDGE](O4-show-ip-protocols.txt) | ASBR role; static redistribution with metric 20; one NSSA; Gi0/2 enabled explicitly |
| [O5-TRANSIT](O5-show-ip-protocols.txt) | One NSSA; the two transit networks; maximum paths 4 |

All five OSPF sections report administrative distance 110. O3 permits up to two equal-cost paths; the others permit up to four. The [routing captures](../routing/README.md) establish where multiple next hops were actually installed.

O2's role line includes ASBR, but its saved configuration has no static redistribution statement. In this design O4 originates the external routes, and O2 advertises their translated Type 5 LSAs. Use the configuration and database together to distinguish those roles.

“Routing Information Sources” is not a direct-neighbor inventory: O2's list includes O5 even though they have no direct link. Use [neighbor output](../neighbors/README.md) to identify adjacencies.

Likewise, “update filter list for all interfaces is not set” does not replace inspection of an OSPF area filter. [Case 03](../../troubleshooting/scenario-3-abr-route-filtering-control-plane.md) examines the area-specific attachment directly.

[Verification guide](../README.md) · [Configuration guide](../../configs/README.md)
