# Case 02 — Diagnose an unusable path behind a healthy session

Both internal BGP sessions remained established, but O2 could no longer use the path advertised by O1. The route pointed to a provider address that O2 could not reach. O2 retained an installed alternate through O4; restoring `next-hop-self` on O1 recovered the original path.

## Expected behavior and fault

B1 originates the test prefix `172.31.251.0/24`. O1 and O4 learn it externally and advertise paths to O2, the enterprise route reflector.

Normally, O1's `next-hop-self` setting replaces the provider next hop with O1's reachable loopback, `10.100.1.1`. I removed that setting toward O2 and refreshed outbound advertisements. O1 then passed along B1's address, `10.250.1.2`, which O2 could not resolve.

[Originating prefix and fault commands](../verification/incidents/scenario-2-ibgp-next-hop-reachability.md#block-1)

## How I isolated the cause

The peer summaries still showed established sessions. The decisive comparison was between O2's detailed BGP entry and its IP routing table.

| During the fault | Meaning |
|---|---|
| O1 still had its external route through B1 | The destination had not disappeared at its source |
| O2's path learned from O1 showed `10.250.1.2 (inaccessible)` | The advertised forwarding next hop could not be resolved |
| O2's lookup for `10.250.1.2` returned `% Subnet not in table` | The routing table corroborated the next-hop problem |
| O2 installed `172.31.251.0/24` through `10.100.4.4` | The alternate path through O4 remained installed |

The excerpt also labels the inaccessible path `valid, internal`. That wording is preserved; the explicit `inaccessible` annotation and routing-table checks are what explain its failure to become the selected path.

[Peer summaries](../verification/incidents/scenario-2-ibgp-next-hop-reachability.md#block-3) · [Path comparison and route lookups](../verification/incidents/scenario-2-ibgp-next-hop-reachability.md#block-5)

## Repair and verification

On O1, I restored `neighbor 10.100.2.2 next-hop-self` and refreshed advertisements with `clear ip bgp 10.100.2.2 soft out`.

| O2's check | During the fault | After repair |
|---|---|---|
| Next hop in O1's advertisement | `10.250.1.2`, inaccessible | `10.100.1.1`, resolved |
| Candidate through O4 | Selected | Still available |
| Installed route to `172.31.251.0/24` | Via `10.100.4.4` | Via `10.100.1.1` |

[Repair commands](../verification/incidents/scenario-2-ibgp-next-hop-reachability.md#block-8) · [Recovered paths and installed route](../verification/incidents/scenario-2-ibgp-next-hop-reachability.md#block-9)

These captures establish path recovery and a change in the installed next hop. They do not measure uninterrupted traffic delivery or convergence time. The originating prefix is backed by a Null0 discard route, and this case includes no endpoint test.

## Engineering takeaway

A BGP session confirms that routers can exchange routing information; each advertised path still needs a usable next hop. Checking the peer, the individual prefix, and the IP route together exposed a fault that the peer summary alone could not show.

[All original evidence](../verification/incidents/scenario-2-ibgp-next-hop-reachability.md) · [Case index](README.md) · [Topology](../topology.md)
