# Case 03 — One additional byte crosses the GRE boundary

**Outcome:** 1476-byte probes with DF succeeded; 1477-byte probes with DF failed; the same 1477-byte probes succeeded with fragmentation permitted.

## Test design and results

The basic encapsulation adds **20 bytes of outer IPv4 header and 4 bytes of GRE header**, giving 24 bytes of overhead. Optional GRE key, sequence and checksum fields are disabled in the captured interface output.

| Probe to 172.16.13.2 | Unfragmented encapsulated size | Recorded result |
|---|---|---|
| `size 1476 df-bit repeat 5` | 1476 + 24 = 1500 bytes | 100% — 5/5 |
| `size 1477 df-bit repeat 5` | 1477 + 24 = 1501 bytes | 0% — 0/5 |
| `size 1477 repeat 5` | Would exceed 1500 without fragmentation | 100% — 5/5 |

[Block 12 — all three actual tests](../verification/04-mtu.md)

## Diagnosis

The first probe fits the basic GRE transport budget. The second exceeds it by one byte; DF prohibits fragmenting the original datagram, so delivery fails. Clearing DF permits fragmentation and the same size succeeds. This comparison is consistent with the standard IPv4/GRE fragmentation mechanism and establishes the observed DF-dependent delivery boundary.

The 1476-byte transport MTU is captured in `show interfaces Tunnel0`. The 1500-byte underlay budget is derived from 1476 plus the basic 24-byte overhead and the tests. A retained physical-interface MTU output is not available. No packet capture or counters show the individual fragments or their exact sizes.

## Operational lesson

Successful small pings do not establish that larger packets will cross a tunnel. Keep the destination fixed and compare size and DF behavior to isolate an MTU constraint. Extra encapsulation or optional GRE fields can change the budget; these results apply to the captured basic IPv4 GRE setup.

[GRE interface fields](../operation.md) · [Case index](README.md) · [Overview](../README.md)
