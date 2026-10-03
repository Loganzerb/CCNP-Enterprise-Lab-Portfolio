# Scope — two completed designs with distinct evidence sources

Section 14 covers classic GRE/IKEv1 policy-based transport protection and route-based IKEv2 IPsec VTI. The designs were tested sequentially on the same three-router topology. Three controlled failures belong to the classic stage; the VTI stage stopped after successful configuration, direct OSPF, and private traffic validation.

## Evidence provenance

| Material | Source and use |
|---|---|
| Classic CLI, Blocks 01–29 | Supplied GRE-IPsec-CLI-Evidence.md compilation; original supplied lines retained |
| Classic configuration and build milestones | October 1 handoff; configuration extracts explicitly identified as reconstructions |
| VTI configuration, Blocks 30–31, and CML checkpoint | Saved GRE with IPsec_Oct_1st.yaml; actual selected node settings, with the PSK sanitized |
| VTI runtime states, SPIs, tests, and counters | Completed VTI handoff and October 2 user-provided results; reported as recorded values rather than reconstructed console text |
| Diagrams | Explanations of topology, configuration references, and packet behavior; not packet captures |

The published VTI runtime record is the completed-lab handoff, rather than a verbatim console transcript. It records both matching SPI pairs, READY, ACTIVE(ACTIVE), 5/5 tunnel replies, FULL OSPF, remote /32 routes, and final 10/10 private replies. The selected saved configuration supports the interface mode, object references, addresses, and OSPF settings.

Classic partial captures remain partial. Counter totals include traffic over each sample interval and are separate from individual ping counts. Reported plaintext MTUs of 1458 for classic IPsec and 1438 for VTI are SA fields, not measured inner-packet ceilings. No throughput, precise convergence-time, or VTI fault testing is claimed.

The VTI export retains node settings and wiring, with the shared key replaced by a placeholder. It has not been re-imported or executed during documentation work. A later retention rebuild remains planned work.

## Blueprint and technical references

**CCNP ENCOR 350-401 v1.2, 2.2.b — GRE and IPsec tunneling**, under configuring and verifying data path virtualization technologies.

The masterclass uses *CCNP and CCIE Enterprise Core ENCOR 350-401 Official Cert Guide, Second Edition*. Technical cross-checks used Cisco's *ENCOR v1.2 Exam Topics*, *Configuring IPSec with EIGRP and IPX Using GRE Tunneling*, *Cisco IPsec VPN Command Reference*, *IPsec Virtual Tunnel Interfaces*, *Configuring Internet Key Exchange Version 2 and FlexVPN Site-to-Site*, and *Resolve IPv4 Fragmentation, MTU, MSS, and PMTUD Issues with GRE and IPsec*. Source titles are supplied without external links.

[Verification index](verification/README.md) · [Configuration provenance](configs/README.md) · [Overview](README.md)
