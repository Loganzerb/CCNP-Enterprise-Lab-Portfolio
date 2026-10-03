# Packet behavior — GRE transport protection and native IPsec tunneling

## How private traffic crosses the transit network

```mermaid
flowchart LR
    A["Inner IP packet<br/>10.10.10.1 to 10.30.30.1"] --> B["R1: OSPF selects Tunnel0<br/>GRE encapsulates the packet"]
    B --> C["R1: crypto ACL matches GRE<br/>ESP protects the GRE payload"]
    C --> D["R2: routes outer IP packet<br/>192.0.2.1 to 198.51.100.2"]
    D --> E["R3: authenticates and decrypts ESP<br/>then removes GRE encapsulation"]
    E --> F["Deliver to 10.30.30.1<br/>reply follows the reverse path"]
```

The first routing decision selects Tunnel0 for the private destination. A separate underlay lookup reaches the remote WAN endpoint through R2. GRE's outer source and destination match the IPsec peers, allowing transport mode to protect the GRE header and carried packet while retaining the outer addressing.

R2 forwards the protected outer packet without learning either private loopback route. GRE also carries OSPF traffic across the overlay, so the transit router does not become an OSPF neighbor.

## Read the protocol layers

| Layer | Role in this lab |
|---|---|
| Inner IPv4 | Private traffic between 10.10.10.1 and 10.30.30.1, or routing traffic across Tunnel0 |
| GRE | Carries the overlay traffic; selected by IP protocol 47 in the crypto ACL |
| ESP transport mode | Encrypts/authenticates the GRE payload; the outer IPv4 packet uses protocol 50 when carried as native ESP |
| Outer IPv4 | WAN endpoints 192.0.2.1 and 198.51.100.2, routed through R2 |

This describes the configured native-ESP design. No packet capture is retained to inspect individual packets on R2.

## Negotiation state and forwarding state

IKEv1 Phase 1 authenticates the peers and establishes the IKE SA. Quick Mode negotiates the ESP protection and traffic identities. The two ESP directions have separate SAs and SPIs.

The [transform fault](troubleshooting/02-transform-mismatch.md) retained QM_IDLE while a new ESP SA could not form. The [selector fault](troubleshooting/03-selector-mismatch.md) produced the same broad IKE/ESP separation for a different cause. Compare the proposals and selected addresses to distinguish them.

## What the reported MTU establishes

The healthy IPsec output reports **plaintext MTU 1458** and **path/IP MTU 1500**. The plaintext figure is an IPsec SA field for the packet presented to IPsec, which already includes GRE encapsulation. It is not a measured 1458-byte inner-ping limit. GRE and ESP overhead, padding, and fragmentation all affect the usable inner packet size.

This project records the field without claiming a new DF boundary test or importing the old GRE-only size results.

## How the VTI carries private traffic

```mermaid
flowchart LR
    A["R3 private packet<br/>10.30.30.1 to 10.10.10.1"] --> B["OSPF route selects Tunnel0<br/>IPsec profile protects the packet"]
    B --> C["ESP tunnel-mode packet<br/>outer 198.51.100.2 to 192.0.2.1<br/>R2 routes the WAN destination"]
    C --> D["R1 authenticates and decrypts ESP<br/>delivers the inner packet<br/>reply uses the reverse VTI path"]
```

The VTI is a routed IPsec interface. Selecting Tunnel0 sends the packet to its IPsec profile; tunnel-mode ESP protects the inner packet and supplies the outer WAN encapsulation. No GRE header is involved. The route to the remote WAN endpoint still resolves through R2 rather than through the tunnel itself.

OSPF runs directly across the VTI and provides the loopback routes. R2 does not participate in this adjacency or learn the private routes.

## Compare encapsulation and traffic selection

| Layer or decision | Classic GRE/IPsec | IKEv2 VTI |
|---|---|---|
| Private destination lookup | Selects the GRE Tunnel0 | Selects the IPsec Tunnel0 |
| Inner packet | Encapsulated inside GRE | Carried directly inside tunnel-mode ESP |
| Protection selection | Crypto ACL matches GRE between WAN endpoints | Interface routing plus the attached IPsec profile |
| Outer packet | GRE's WAN IPv4 addressing retained by transport-mode ESP | WAN IPv4 header supplied by IPsec tunnel encapsulation |
| Transit forwarding | R2 routes the outer WAN destination | R2 routes the outer WAN destination |

The VTI handoff records selectors of 0.0.0.0/0 in both directions. These broad SA identities do not redirect every destination into the tunnel: the routing table determines which packets enter Tunnel0. No crypto ACL was needed to classify site prefixes in this VTI design.

The VTI handoff reports plaintext MTU 1438 over a 1500-byte path, compared with the classic stage's captured 1458 field. Both are SA fields, not measured inner-ping ceilings. No VTI DF boundary test or packet capture is represented here.

[Classic IPsec CLI](verification/02-ipsec.md) · [Classic final validation](verification/03-final-validation.md) · [VTI validation](verification/07-vti.md) · [Overview](README.md)
