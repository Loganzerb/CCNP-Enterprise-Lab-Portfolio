# EIGRP configuration guide

These five sanitized extracts describe the lab's interfaces, routing policy, and authentication structure. R1–R4 use classic EIGRP; R5 uses the named instance `CCNP-LAB`. All participate in IPv4 AS 100.

| Configuration | Role | Settings to inspect |
|---|---|---|
| [R1-CORE](R1-CORE.cfg) | Core and wider-lab routing boundary | Two distribution peers; static default redistribution; tagged OSPF/EIGRP redistribution |
| [R2-DIST-A](R2-DIST-A.cfg) | Distribution A | Neighbors R1, R3, and R4; authentication toward R1 |
| [R3-DIST-B](R3-DIST-B.cfg) | Distribution B and wider-lab boundary | Neighbors R1, R2, and R4; tagged OSPF/EIGRP redistribution |
| [R4-BRANCH](R4-BRANCH.cfg) | Branch summaries and remote policy | Same `/22` summary on both uplinks; default-only filter toward R5 |
| [R5-REMOTE](R5-REMOTE.cfg) | Named EIGRP stub | Connected/summary stub advertisement; remote `/22`; authentication toward R4 |

## Summaries and default-only policy

R4's four branch loopbacks cover `172.16.40.0/24` through `172.16.43.0/24`. Both Gi0/0 and Gi0/1 summarize them as `172.16.40.0/22`.

R5 summarizes its four remote loopbacks as `172.16.48.0/22` under the named EIGRP interface configuration. Its `eigrp stub connected summary` setting is also present in the [protocol capture](../verification/protocols/R5-show-ip-protocols.txt).

R4's `R5-DEFAULT-ONLY` prefix list is attached outbound on Gi0/2 and permits only `0.0.0.0/0`. This policy explains why R5's [EIGRP route listing](../verification/routing/R5-show-ip-route-eigrp.txt) contains a learned default and its own local summary, rather than the upstream route set. Stub configuration and the outbound filter serve different purposes; the filter is what restricts advertisements sent to R5.

## Wider-lab redistribution

R1 has a static default through `10.200.1.2`. Its `STATIC-TO-EIGRP` map permits that exact prefix for redistribution.

R1 and R3 also configure mutual OSPF/EIGRP redistribution. The maps reject tag 200 on the EIGRP-to-OSPF direction and set tag 100 on permitted routes; in the reverse direction they reject tag 100 and set tag 200. This records the intended feedback-prevention policy. The retained EIGRP tables show tagged/external routes, but no dedicated feedback-loop failure test is included.

The OSPF peer configurations are outside this module. These connections are documented in [topology.md](../topology.md#connections-to-the-wider-lab).

## Authentication and timers

| Link or setting | Saved configuration |
|---|---|
| R1–R2 | MD5 authentication, key ID 1 |
| R4–R5 | MD5 authentication, key ID 2; configured under the address family on R5 |
| R4 Gi0/0 toward R2 | Hello interval 2 seconds; advertised hold time 6 seconds |
| EIGRP participation | Passive by default; router-facing interfaces explicitly enabled |

Secrets are replaced with nonfunctional placeholders. The module retains neighbor baselines, not authentication- or timer-mismatch incident captures.

The temporary delay and shutdown changes used by Cases 01 and 02 are absent from these extracts. The R4 summary removed in Case 03 is present on both interfaces. Use the [incident blocks](../verification/incidents/README.md) for experiment stages.

## Reconstruction scope

No CML export is included. Rebuilding requires suitable router images, the [interface wiring](../topology.md), matching replacement authentication values, and any wider-lab OSPF setup needed for redistribution. These extracts are not complete synchronized device backups.

[Module overview](../README.md) · [Verification guide](../verification/README.md)
