# Scope — completed GRE work and evidence boundaries

The completed work covers the GRE part of ENCOR objective **2.2.b — GRE and IPsec tunneling**, within data path virtualization. It includes configuration inspection, sourced transport and overlay probes, OSPF across the tunnel, two controlled routing faults with recovery, and DF-dependent MTU tests. IPsec is a separate stage.

The masterclass’s conceptual reference was *CCNP and CCIE Enterprise Core ENCOR 350-401 Official Cert Guide, Second Edition*. Technical cross-checks used Cisco’s ENCOR v1.2 exam topics, *Implementing Tunnels*, *The "%TUN-5-RECURDOWN" Error Message and Flapping EIGRP/OSPF/BGP Neighbors Over a GRE Tunnel*, and *Resolve IPv4 Fragmentation, MTU, MSS, and PMTUD Issues with GRE and IPsec*. Source titles are supplied without external links.

| Evidence type | What it supports |
|---|---|
| Original CML export | Three-node wiring, actual addresses and masks, static transport routes, tunnel settings and OSPF configuration |
| September 30 console output | Healthy forwarding, delayed displayed state, recursion logs, recovery and packet-size results |
| Protocol explanation | IP protocol 47, GRE encapsulation, 24-byte basic overhead and permitted fragmentation |
| Observed IOSv behavior | The sampled interface-state delay and later safe covering-route display during the recursive fault |

Selected CLI excerpts link to their full text. Fault/repair commands without a captured console entry are labeled reconstructions. Buffered syslogs from earlier events are separated from the recursive incident’s timestamps. No device was rerun during documentation work.

The record does not measure tunnel throughput, precise convergence time or individual fragment sizes. TTL, bandwidth and keepalive fields are inspected settings rather than separately completed experiments. GRE encryption, IPsec, key/sequence/checksum experiments and alternate tunnel-source testing are not represented as completed lab work here.

[Evidence index](verification/README.md) · [Original configuration](configs/README.md) · [GRE overview](README.md)
