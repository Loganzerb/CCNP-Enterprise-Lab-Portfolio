# 11 — PBR: Selective forwarding and path recovery

Policy-Based Routing (PBR) lets a network send selected traffic along a different path while other traffic follows normal routing. That flexibility adds a troubleshooting challenge: the routing table alone may not describe the path a particular flow takes.

I built a five-router Cisco Modeling Labs environment with two source addresses and two paths to one destination. I verified selective forwarding, compared two different meanings of `deny`, and tested what happened when the policy-selected link failed.

**5 routers · 2 source addresses · 3 case studies · 30 evidence blocks**

## Results at a glance

| Test | What I established | Recorded result |
|---|---|---|
| Select one source for an alternate path | PBR changed forwarding without changing the destination route | Source A traversed R3; source B used R4 directly; R2's OSPF route still pointed to R4 |
| Reverse the classification ACL | An ACL used for matching determines which traffic receives the policy | Source A returned to normal routing; source B moved to the alternate path |
| Remove the direct policy next hop | An indirect route to that address did not preserve the observed policy path | Source A used R4 during the fault and returned to R3 after restoration |
| Match a route-map deny before a later permit | Matching the deny stopped policy evaluation for that traffic | Source A used R4; source B reached permit sequence 20 and used R3 |

## Start with the evidence

Read [Case 02 — The next-hop route remains, but the policy path changes](troubleshooting/02-next-hop-failure.md) for the strongest operational example. It follows a controlled link failure through routing-table evidence, a changed traffic path and restoration.

Read [Case 03 — A deny match with zero policy-routing packets](troubleshooting/03-route-map-deny.md) for a closer look at policy logic. An ACL recorded nine matches while its route-map deny sequence reported zero policy-routing packets.

## Lab design

![PBR topology: R1 feeds R2, which can forward directly through R4 or through R3 and R4 to R5](topology.png)

| Device | Responsibility |
|---|---|
| R1-PBR-SOURCE | Generates test traffic from 10.1.1.1 and 10.11.11.11 |
| R2-PBR-POLICY | Applies the ingress policy and selects the next hop |
| R3-PBR-ALT | Provides the alternate branch |
| R4-PBR-PRIMARY | Carries the normal path and joins both branches |
| R5-PBR-DEST | Hosts destination 10.5.5.5 |

OSPF supplies the underlying routes in area 0. With the baseline policy, **source A follows R1 → R2 → R3 → R4 → R5**, while **source B follows R1 → R2 → R4 → R5**.

[Addressing and wiring](topology.md) · [Configuration and reproduction guide](configs/README.md)

## What this work demonstrates

- **Verification by traffic class:** compare two sources to the same destination.
- **Policy diagnosis:** read ACL classification, route-map sequence order and interface attachment together.
- **Failure analysis:** distinguish an installed route from a usable policy next hop.
- **Controlled restoration:** return the configuration to its baseline and retest both sources.

## Explore the files

| Location | What you will find |
|---|---|
| [Troubleshooting](troubleshooting/README.md) | Three concise cases linked to exact evidence blocks |
| [Verification](verification/README.md) | Baseline, changed states, counters and final traces |
| [Configurations](configs/README.md) | Five reconstructed configurations and the exercise changes |

## Evidence scope

These controlled exercises retain actual CLI output from September 19–20, 2026. The configuration files reconstruct the relevant setup from the lab record; no PBR CML export or complete running-config was available.

The traces establish observed paths and include unanswered probes. They do not measure application performance, loss-free failover or convergence time. Recursive PBR, local PBR, multiple next hops and TCP-port classification were discussed rather than tested.

[Back to portfolio](../README.md)
