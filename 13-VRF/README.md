# 13 — VRF: Isolated networks and selective shared access

Virtual Routing and Forwarding (VRF) keeps separate routing and forwarding environments on one router. This lab explores overlapping addresses, isolation and selected access to a shared service.

I built BLUE and RED with identical addresses, verified their separate next hops, and diagnosed faults in route installation and forwarding. I then added a shared service and corrected the return routes needed for successful exchanges.

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

BLUE and RED use separate R1 interfaces with identical 10.10.10.0/24 addressing. SHARED-SVC is added later in the global table on Gi0/2.

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

- Select the routing context before interpreting interface, ARP and CEF state.
- Check configuration, route installation, next-hop resolution and forwarding separately.
- Validate both directions of selective shared-service access.
- VRF separates routing contexts; encryption requires additional protection.

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

CLI captures cover the September 27–28, 2026 lab. The CML export is the earlier three-router checkpoint; later additions are documented in the configuration guide. The explicit-egress return routes reflect observed IOSv behavior. Detailed test limits and platform boundaries are recorded in the [scope guide](scope.md).

[Back to portfolio](../README.md)
