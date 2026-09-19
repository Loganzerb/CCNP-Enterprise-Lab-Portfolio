# EIGRP verification guide

Verification connects four views: **the neighbors exchanging routes, the paths EIGRP knows, the routes installed, and the policy explaining those results.**

All twenty original text files are retained unchanged.

| Evidence group | Files | Question answered |
|---|---:|---|
| [Neighbors](neighbors/README.md) | 5 | Which routers were peers, on which interfaces? |
| [Topology tables](topology/README.md) | 5 | Which destinations and successor paths appear in the saved excerpts? |
| [Routing tables](routing/README.md) | 5 | Which summaries, defaults, external routes, and equal-cost next hops were installed? |
| [Protocol settings](protocols/README.md) | 5 | Which AS, summary, stub, filter, and metric settings were reported? |
| [Incident excerpts](incidents/README.md) | 3 Markdown pages | What was retained from the three controlled experiments? |

## A useful reading sequence

Start with R1's branch summary: the topology excerpt shows two successors, and the routing table lists both next hops. Then read [Case 01](../troubleshooting/scenario-1-feasible-successor-promotion.md) to see one path become a qualified backup and later the installed replacement.

For route policy, compare R4's summary/filter settings with the route listings on R2, R3, and R5. [Case 03](../troubleshooting/scenario-3-inconsistent-eigrp-summarization.md) traces how removing a summary on one interface changes the other routers' views.

## Evidence boundaries

The general captures are separate from the incident excerpts. Several topology files end mid-entry or contain only part of the known route set. A missing line in those files does not establish that a route was absent from the router.

A passive route is not undergoing a diffusing computation at the time of the check. This differs from a passive interface, which suppresses neighbor formation. Neither state alone proves endpoint delivery.

For Case 02, compare the pre-failure eligibility check with the installed replacement route. Its [case study](../troubleshooting/scenario-2-no-feasible-successor-dual-recalculation.md) explains the uncaptured transition.

[Module overview](../README.md) · [Configuration guide](../configs/README.md) · [Case index](../troubleshooting/README.md)
