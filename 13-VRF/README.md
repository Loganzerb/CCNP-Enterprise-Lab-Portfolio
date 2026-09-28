# 13 — VRF: Isolated networks and selective shared access

Virtual Routing and Forwarding (VRF) lets one router maintain separate routing and forwarding environments. Engineers use it to keep networks separate, reuse overlapping IP addresses, and provide selected access to shared services without combining their routing tables.

I built two isolated networks with identical addresses, verified how each selected its own next hop, and introduced faults that separated configuration, route installation, and actual forwarding. I then connected both networks to a shared service and diagnosed the return routes needed to complete the traffic exchange.

**4 routers in the completed lab · 2 VRFs plus the global table · 3 troubleshooting cases · 29 evidence blocks**

## Results at a glance

| Test | What the evidence establishes | Recorded result |
|---|---|---|
| Overlapping addresses | BLUE and RED keep separate connected routes, ARP entries and CEF interfaces | The same 10.10.10.2 resolves to different MAC addresses and links |
| Identical remote prefixes | The same destination and next hop resolve in the correct VRF | 5/5 replies in each VRF to 172.16.100.1 |
| Bad next hop | A route can install while its next-hop adjacency remains unresolved | Real CE: 5/5; remote loopback: 0/5; repaired loopback: 5/5 |
| Wrong routing table | A configured static route can fail to enter the RIB | Global next hop absent; restoring RED’s route returns 5/5 |
| Shared-service access | Forward and return routes must cover the tested endpoints | Final SHARED-SVC tests: 5/5 to each unique CE loopback |

## Start with the evidence

Read [Case 01 — An installed route with an unresolved next hop](troubleshooting/01-bad-next-hop.md) for the clearest diagnostic example. The CE remains reachable while one remote destination fails.

Follow [Selective route leaking](route-leaking/README.md) for the complete shared-service story: initial isolation, forward-route installation, a missing return path, and successful final tests.

## Lab design

![VRF topology: BLUE and RED use overlapping addresses on separate R1 interfaces, with a shared service in the global table](topology.png)

The original topology is **BLUE-CE — R1-VRF — RED-CE**. SHARED-SVC is added later on R1 Gi0/2. BLUE uses Gi0/0; RED uses Gi0/1. Each CE has 10.10.10.2/24, and R1 uses 10.10.10.1/24 independently on both links.

[Addressing and wiring](topology.md) · [Configuration guide and saved checkpoint](configs/README.md)

## Follow the lab

| Stage | Guide | What to inspect |
|---|---|---|
| Establish isolation | [VRF operation](operation.md) | Interface binding, separate RIB/ARP/CEF state and overlapping prefixes |
| Diagnose forwarding failures | [Troubleshooting cases](troubleshooting/README.md) | Bad adjacency versus unresolved recursion in the wrong table |
| Add shared access | [Route leaking](route-leaking/README.md) | Host routes, global next-hop resolution and explicit return paths |
| Inspect the source evidence | [Verification index](verification/README.md) | Numbered blocks with interpretation and full CLI transcripts |
| Review implementation | [Configurations](configs/README.md) | Original checkpoint, later additions and fault/repair commands |

## Engineering lessons

- **Identify the routing context first.** An address alone is insufficient when networks overlap; interface membership, ARP and CEF must agree with the selected VRF.
- **Check configuration, installation and forwarding separately.** A configured route may not install; an installed route may still have an unresolved next-hop adjacency.
- **Global and VRF routes are not automatically shared.** The `global` keyword changes next-hop resolution for a VRF static route; it does not move that route into the global table.
- **Account for both directions.** Selective shared-service access needs routes for requests and replies. This IOSv lab uses explicit egress interfaces to disambiguate overlapping return next hops.
- **Distinguish segmentation from protection.** VLANs separate Layer 2 broadcast domains; VRFs separate Layer 3 routing contexts. VRF does not encrypt traffic. IPsec can provide confidentiality and integrity when those protections are required.

## Validation & Post-Assessment

After the hands-on work, synthesis questions and a post-assessment tested whether I could reason through routing context, recursive lookup, forwarding state and selective connectivity independently.

| Assessment | Recorded result |
|---|---|
| VRF theory synthesis | 8/8 |
| Post-lab synthesis | 8/8 |
| VRF post-assessment — original attempt | **9/10 (90%)** |
| Follow-up remediation | 1/1 |

The only initial post-assessment miss was confusing VRF segmentation with encryption. Follow-up remediation addressed that distinction; the original **9/10** remains unchanged. These results complement the lab evidence and do not represent an official certification exam.

## Evidence scope

The CLI comes from the completed September 27–28, 2026 lab record. The saved CML export is the earlier three-router overlapping-address checkpoint; it does not contain the later loopbacks, static-route exercises or shared-service node. Those additions are documented separately and tied to captured results.

The first RED neighbor test recorded 4/5 replies; later remote-prefix and final shared-service tests recorded 5/5. No loss-free convergence, encryption, throughput or exhaustive isolation test is claimed. The explicit-egress return-route technique is documented as observed IOSv behavior, not a portable configuration guarantee.

[Conceptual sources and platform boundaries](scope.md) · [Back to portfolio](../README.md)
