# Case 01 — Restore a rejected BGP session

B2 stopped exchanging routes with the enterprise edge because it expected the wrong autonomous system number. Comparing the configured peer identity with the rejection message isolated the fault. Correcting that one setting restored the session and an external route on O4.

## Expected behavior and fault

O4-EDGE belongs to AS `65000`; B2-ISP-B belongs to AS `65200`. Their peering addresses are `10.250.2.1` and `10.250.2.2`.

The controlled change made B2 expect O4 in AS `65001`. Both devices then reported the affected session as `Idle`, while their other captured sessions remained established.

[Original setup and fault](../verification/incidents/scenario-1-wrong-remote-as.md#block-1) · [Both peer summaries](../verification/incidents/scenario-1-wrong-remote-as.md#block-3)

## How I isolated the cause

| Observation | Diagnostic value |
|---|---|
| B2 listed the neighbor's remote AS as `65001` | Its configured expectation disagreed with O4's actual AS |
| B2 received an OPEN and sent a NOTIFICATION, with no UPDATE exchange | The attempt reached BGP session negotiation |
| O4 logged `2/2 (peer in wrong AS)` | The peer explicitly rejected the AS identity |
| B2 reported a route to the peer address | A route was available; this alone was not an endpoint reachability test |

The wrong-AS notification and configuration mismatch establish the cause more precisely than the `Idle` state alone.

[Neighbor details and route tracking](../verification/incidents/scenario-1-wrong-remote-as.md#block-5) · [Rejection messages](../verification/incidents/scenario-1-wrong-remote-as.md#block-7)

## Repair and verification

On B2, I removed the incorrect neighbor statement and restored `neighbor 10.250.2.1 remote-as 65000` under `router bgp 65200`.

| Check after correction | Recorded result |
|---|---|
| B2's session to O4 | Established, with five received prefixes |
| O4's session to B2 | Established, with six received prefixes |
| O4's IP route for `203.0.113.0/24` | Installed through `10.250.2.2`, external BGP, administrative distance 20 |

[Repair commands](../verification/incidents/scenario-1-wrong-remote-as.md#block-9) · [Recovery summaries and installed route](../verification/incidents/scenario-1-wrong-remote-as.md#block-10)

The recovery establishes restored route exchange and installation. This incident does not include a successful endpoint traffic test.

## Engineering takeaway

A failed routing session needs a specific explanation. Correlating both peers' configuration, message counters, and notification logs identified the rejection without treating every `Idle` session as a physical or IP connectivity fault.

[All original evidence](../verification/incidents/scenario-1-wrong-remote-as.md) · [Case index](README.md) · [Topology](../topology.md)
