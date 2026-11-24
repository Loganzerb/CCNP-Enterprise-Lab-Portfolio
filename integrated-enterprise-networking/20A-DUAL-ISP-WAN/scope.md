# Lab 20A scope and evidence provenance

| Material | What it establishes |
|---|---|
| Saved configuration · privately retained CML checkpoint | Wiring, image choices, addressing, OSPF, BGP, IP SLA, Track 10, and static routes. These support the topology and selected implementation notes. |
| Captured CLI excerpts · original CML session | ISP return-route lookups before and after correction, sourced loopback retests, R2's outage syslog and route lookup, and R1's track, SLA, route, and CEF snapshots. |
| Reported observations · original lab completion record | Initial ping failures, the fault and restoration actions, continued operation of R2 Gi0/0 during the fault, and recovery of the R2 eBGP session and route to `4.4.4.4`. |
| Replay commands | Procedure to collect new evidence in an isolated CML run. |

The complete CML checkpoint, including its full IOS configurations, is retained privately pending redistribution clearance. The portfolio includes an independently authored topology and implementation guide, selected historical CLI excerpts, and screened Alpine startup scripts. Full unscreened transcripts remain private.

## Configuration and experiment boundaries

The failover sequence focuses on R1 and the R2–R4 primary handoff. The saved topology also includes two desktop nodes, a switch, enterprise iBGP, and inter-provider eBGP. The supplied excerpts cover the R2 eBGP outage and R1 recovery. Collection of R2 recovery, enterprise iBGP and OSPF state, and desktop packet delivery remains open. A replay should preserve the inter-provider link and check both the BGP and installed IP route to the probe target during the outage.

## Remaining validation

Fresh CML import, boot, and runtime replay remain pending. End-to-end delivery through the backup default, Internet connectivity, and convergence duration remain unverified. The original timestamps describe individual CLI snapshots. [Replay and capture procedure](verification/README.md#replay-and-capture)

[Overview](README.md) · [Implementation notes](configs/README.md) · [Topology](topology.md) · [Operational evidence](verification/README.md)
