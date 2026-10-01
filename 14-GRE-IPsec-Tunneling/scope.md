# Scope — completed work and evidence boundaries

This project covers GRE, OSPF across the overlay, and classic policy-based IKEv1/IPsec transport mode. Three deliberate faults test the PSK, ESP transform, and GRE traffic selector. IKEv2 and VTI are not represented as completed work.

## Evidence provenance

| Material | Source and use |
|---|---|
| Topology, GRE build, initial OSPF routes, and fault sequence | Completed-lab handoff supplied October 1, 2026; recorded observations where raw output was not included |
| Numbered CLI blocks | User-supplied GRE-IPsec-CLI-Evidence.md compilation from MASTERCLASS CCNP LAB PART 5; each supplied fence retained in its own text file |
| Configuration extracts and fault commands | Reconstructions from the handoff and captured settings; not running-config exports or executed documentation tests |
| Diagrams | Explanations of topology, dependencies, and packet behavior; not packet captures |

Captures that end at `inbound esp sas:` remain partial. No missing SA details, route output, or ping results have been filled in. The original compilation's lab-key text is omitted from published prose; no CLI output needed key redaction. Text-file line endings are normalized to LF.

The final CLI establishes a 20/20, 100-byte sourced ping, active bidirectional ESP on R1, FULL OSPF adjacency, and increasing counters. It does not measure throughput, an inner-packet DF limit, or precise recovery time. Counter changes include all selected traffic between samples, including routing traffic.

## Blueprint and technical references

**CCNP ENCOR 350-401 v1.2, 2.2.b — GRE and IPsec tunneling**, under configuring and verifying data path virtualization technologies.

The masterclass's conceptual reference is *CCNP and CCIE Enterprise Core ENCOR 350-401 Official Cert Guide, Second Edition*. Technical cross-checks used Cisco's *ENCOR v1.2 Exam Topics*, *Configuring IPSec with EIGRP and IPX Using GRE Tunneling*, *IOS IPSec and IKE debugs — IKEv1 Main Mode Troubleshooting*, *Cisco IPsec VPN Command Reference*, and *Resolve IPv4 Fragmentation, MTU, MSS, and PMTUD Issues with GRE and IPsec*. Source titles are listed without external links.

[Verification index](verification/README.md) · [Configuration provenance](configs/README.md) · [Overview](README.md)
