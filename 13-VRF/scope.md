# Conceptual sources and platform boundaries

The primary conceptual reference used for the masterclass was **CCNP and CCIE Enterprise Core ENCOR 350-401 Official Cert Guide, Second Edition**. This portfolio presents the lab’s own configuration, output and interpretation; it does not reproduce the book or third-party exam material.

| Category | How it is used here |
|---|---|
| ENCOR/OCG concepts | VRF routing and forwarding separation, overlapping address space, and the distinction between Layer 2 segmentation, Layer 3 segmentation and encryption |
| Cisco documentation / platform behavior | Modern VRF CLI, address removal on interface binding, static-route recursion and the `global` next-hop keyword |
| Observed IOSv/CML behavior | Actual MAC addresses, route/CEF entries, initial and final ping counts, parser support, and installation of global routes through explicit VRF egress interfaces |
| Beyond ENCOR — Job Skills | Structured fault isolation, comparison of configuration/RIB/CEF/ARP, selective shared-service design, and proving return-path dependencies |

## Cisco material used for technical cross-checking

- *Configuring VRF-lite*, Cisco IOS XE IP Routing Configuration Guide: independent routing/forwarding contexts and overlapping addressing.
- *Cisco IOS Multiprotocol Label Switching Command Reference*, `ip route vrf` and `ip route static inter-vrf`: next-hop context and restrictions on cross-context static routes.
- *MPLS VPN—VRF CLI for IPv4 and IPv6 VPNs*: modern VRF syntax and address removal when binding an interface.
- *Configure Route Leak Between Global and VRF Routing Table without Next-Hop*: distinctions between point-to-point interfaces, multi-access next hops and platform-specific approaches.

These titles identify the conceptual and command references without external links. Documentation for a different Cisco platform does not establish support on every image. The final explicit-interface return routes are supported here by the captured IOSv RIB, CEF and traffic results.

## Evidence boundaries

The baseline file is a three-node checkpoint recovered from the original attachment preview. Later commands are labeled reconstructions and matched to actual output. The source assessment results are reported separately from packet-forwarding evidence. No device was rerun while preparing these documents.

VRF-Lite and static routing are the completed implementation. MPLS, MP-BGP VPN distribution, route-target policies and IPsec encryption were not implemented in this lab. The final tests show ICMP request/reply success for the named loopbacks; they do not establish application performance or universal isolation between all possible endpoints.

[Verification record](verification/README.md) · [Configuration provenance](configs/README.md) · [VRF overview](README.md)
