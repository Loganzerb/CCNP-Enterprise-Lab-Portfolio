# OSPF configuration guide

These five sanitized extracts describe the routing design behind the lab. They retain relevant interfaces, OSPF settings, and route policy. Authentication values are redacted; the files are not complete CML exports.

| Configuration | Role | Settings worth reviewing |
|---|---|---|
| [O1-CORE](O1-CORE.cfg) | Backbone router | Area 0 interfaces, router ID, passive-interface policy |
| [O2-ABR](O2-ABR.cfg) | Area border router | Area 10 `nssa no-summary`, branch `/22` range, authenticated point-to-point link to O3 |
| [O3-BRANCH](O3-BRANCH.cfg) | Branch prefix origin | Four `/24` loopbacks, NSSA membership, authentication toward O2, `maximum-paths 2` |
| [O4-EDGE](O4-EDGE.cfg) | NSSA external-route origin | Two static test prefixes redistributed through a prefix-list/route-map policy |
| [O5-TRANSIT](O5-TRANSIT.cfg) | Alternate internal path | Point-to-point connections to O3 and O4 in Area 10 |

## Connect the settings to the evidence

| Configuration decision | Result to inspect |
|---|---|
| O2: `area 10 nssa no-summary`; O3/O4/O5: `area 10 nssa` | [Database captures](../verification/database/README.md) show Area 10 external Type 7 LSAs and a default Type 3 LSA from O2 |
| O2: `area 10 range 172.20.32.0 255.255.252.0` | [Routing captures](../verification/routing/README.md) show the local summary and O1's inter-area `/22` |
| O3: point-to-point network type on branch loopbacks | The four branch networks are advertised as `/24` prefixes |
| All five: reference bandwidth 10000 | [Interface captures](../verification/interfaces/README.md) show transit cost 10 and loopback cost 1 |
| O3: `maximum-paths 2` | The configured limit is supported by captured two-next-hop routes; it does not measure traffic distribution |
| O4: static redistribution, metric 20, metric type 1, `STATIC-TO-OSPF` | [External route evidence](../verification/routing/README.md) shows `O N1` inside Area 10 and `O E1` on O1 |

O4's `OSPF-EXTERNALS` prefix list permits only `192.0.2.0/24` and `198.51.100.0/24`. Its attached route map permits those matches and denies the rest. Both source routes point to Null0; they are test advertisements, not live external services.

## Settings that need context

**Default route:** O4 retains `default-information originate`, but the saved Area 10 default is a Type 3 advertisement from O2. O3, O4, and O5 install `O*IA` defaults toward O2. The presence of O4's command alone does not establish default origination by O4.

**Fault settings:** O2's saved extract has neither the injected `ip mtu 1400` override nor the `AREA10-TO-AREA0` filter attachment. O4's saved extract includes `area 10 nssa`. Use the [incident commands](../verification/incidents/README.md) for the fault and repair stages.

**Authentication:** The O2–O3 link uses message-digest authentication with key ID 1. Keys are redacted. An authentication failure experiment is not retained here.

**Wider topology:** O1 Gi0/1 and O4 Gi0/2 have additional OSPF configuration but no neighbors in the saved interface captures. O4 Gi0/3 has an external-link address but does not appear as an OSPF interface. See the [topology scope](../topology.md#connections-outside-the-five-router-view).

## Rebuilding the lab

No OSPF CML YAML is included. A rebuild needs suitable router images, the interface connections in the topology guide, and matching replacement authentication values. Establish a fresh baseline before introducing a documented fault; the extracts and captured output are review material, not a synchronized full-device backup.

[Module overview](../README.md) · [Verification guide](../verification/README.md)
