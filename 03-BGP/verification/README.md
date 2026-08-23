# BGP Verification

This section captures healthy-state verification for the completed BGP lab. The evidence demonstrates stable peerings, correct route propagation and policy behavior, and successful forwarding decisions across the topology.

## Verification Evidence

| Category | What the Evidence Proves |
| --- | --- |
| [Neighbors](neighbors/) | All expected BGP sessions reached the **Established** state after the managed switch was restored. |
| [BGP Table](bgp-table/) | Full BGP tables were captured on **O1, O2, O4, B1, B2, and X1**, confirming route visibility across the lab. |
| [Policy](policy/) | Targeted checks confirm local origination, iBGP propagation, external path diversity, community-driven path selection, and aggregate suppression. |
| [Forwarding](forwarding/) | Data-plane lookups confirm the selected routes resolve through the intended BGP and physical next hops. |

## Policy Highlights

- **O2** locally originates `172.31.250.0/24`.
- **O4** learns `172.31.250.0/24` through iBGP via O2.
- **X1** sees multiple external paths.
- **B1** applies community-based Local Preference behavior to `198.51.100.0/24`; the observed route includes community `65300:100` and `no-export`.
- **X1** suppresses the more-specific `192.0.2.0/25` under its aggregate policy.

## Forwarding Highlights

- **O4** forwards toward **B2** for `203.0.113.0/24`.
- **X1** forwards toward **B1** for `172.31.250.0/24`.
- **B1** recursively resolves BGP next hop `10.255.3.3` through physical next hop `10.250.3.2` for `198.51.100.0/24`.

## Validation Note

Traceroute timeout and `!H` responses were expected for some advertised prefixes. Those prefixes are backed by `Null0` routes rather than reachable end hosts, so this behavior does not contradict the verified BGP control-plane or forwarding decisions.
