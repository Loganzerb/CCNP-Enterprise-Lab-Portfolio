# BGP verification guide

Verification follows four questions: **Is the peer established? What paths were learned? Which route was installed? What did the traffic probe actually show?**

The twenty original text captures below are unchanged. Incident excerpts are preserved separately so the general snapshots are not mistaken for fault or recovery stages.

| Evidence group | Files | What to inspect |
|---|---:|---|
| [Neighbor sessions](neighbors/README.md) | 6 | Peer identity, session state, and received-prefix counts |
| [BGP tables](bgp-table/README.md) | 6 | Candidate paths, selected paths, suppressed routes, and RIB-failure markers |
| [Detailed policy results](policy/README.md) | 5 | Prefix origin, path attributes, communities, and aggregate suppression |
| [Routes and traceroutes](forwarding/README.md) | 3 | Installed next hop, first responding hop, and where the trace stops |
| [Incident evidence](incidents/README.md) | 3 Markdown pages | All 31 original setup, fault, diagnostic, repair, and recovery blocks |

## Read the checks together

A numeric `State/PfxRcd` value indicates an established session and the number of received prefixes. It does not establish that each path can be used.

The BGP table identifies candidates and the selected BGP path. An IP route lookup checks installation in the routing table. A traffic test then supplies evidence about forwarding; the traces here do not reach successful destination replies.

This distinction is visible in [Case 02](../troubleshooting/scenario-2-ibgp-next-hop-reachability.md): sessions stayed established while one next hop was inaccessible and the alternate remained installed.

## Snapshot boundaries

The general captures were collected at different stages. Uptime, prefix counts, and selected paths need not match across files. Use each incident's own before/after excerpts for its recovery claim.

The extracts include policy exercises that are not attached in the saved configuration. IPv6 and VRF configuration is present, but these dedicated verification files cover global IPv4. RIB-failure entries do not include a dedicated `show ip bgp rib-failure` capture establishing every cause.

[Module overview](../README.md) · [Configuration guide](../configs/README.md) · [Technical references](../references.md)
