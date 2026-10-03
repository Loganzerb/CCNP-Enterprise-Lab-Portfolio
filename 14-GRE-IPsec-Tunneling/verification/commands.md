# Commands — separate interface, negotiation, routing, and service checks

The classic guides retain exact commands and output in their numbered captures. For VTI, these command families review the saved settings and recorded validation checkpoints; original runtime console text is not included in the current handoff.

| Check | Commands | What to correlate |
|---|---|---|
| Underlay | `show ip route 198.51.100.2` on R1; `show ip route 192.0.2.1` on R3 | The outer endpoint route resolves through R2 |
| Tunnel | `show interfaces Tunnel0`; `show running-config interface Tunnel0` | GRE/IP versus IPSEC/IP, endpoint addresses, and protection attachment |
| Classic IKEv1 | `show crypto isakmp sa` | Completed negotiation versus Main Mode attempts |
| VTI IKEv2 | `show crypto ikev2 sa`; `show crypto ikev2 proposal` | READY and negotiated encryption/integrity/PRF/DH parameters |
| ESP | `show crypto ipsec sa` | Mode, selectors, current inbound/outbound SPIs, active SAs, counters, and errors |
| OSPF | `show ip ospf neighbor` | Router ID, FULL adjacency, neighbor address, and Tunnel0 |
| Private routes | `show ip route 10.30.30.1` on R1; `show ip route 10.10.10.1` on R3 | Remote /32 and overlay next hop |
| Traffic | Sourced loopback-to-loopback ping | A complete private request/reply exchange |

The retained classic traffic command is `ping 10.30.30.1 source Loopback0 repeat 20`. The VTI handoff records the reverse-direction test from 10.30.30.1 to 10.10.10.1 with ten probes; its exact prompt/output has not been reconstructed.

Compare ESP counters before and after a fresh test, alongside current SA state. OSPF traffic also uses the protected tunnel, so counters are broader than a single ping test.

[Classic final CLI](03-final-validation.md) · [VTI validation](07-vti.md) · [Verification index](README.md) · [Overview](../README.md)
