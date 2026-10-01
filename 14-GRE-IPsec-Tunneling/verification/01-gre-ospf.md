# GRE and OSPF — establish the overlay before protecting it

## Recorded build milestones

These observations come from the completed-lab handoff. The supplied CLI compilation begins at the IPsec stage, so no earlier interface, ping, or route output is reconstructed here.

| Stage | Recorded observation | Meaning |
|---|---|---|
| R1 configured before R3 | Tunnel0 up/up; ping to 172.16.13.2 failed | Local GRE interface state did not prove a usable remote endpoint |
| Both GRE endpoints configured | Overlay ping succeeded 100% | The two overlay addresses could exchange traffic |
| OSPF process 10 over Tunnel0 | Router IDs 1.1.1.1 and 3.3.3.3 reached FULL | Dynamic routing used the logical link |
| R1 remote route | 10.30.30.1/32 via 172.16.13.2 | The remote loopback resolved through the overlay |
| R3 remote route | 10.10.10.1/32 via 172.16.13.1 | The reciprocal private route used the overlay |
| Sourced private test | 10.10.10.1 to 10.30.30.1 succeeded | Private endpoint reachability worked before IPsec was added |

The loopbacks are configured as /24 interfaces. OSPF's default loopback advertisement is a host route, which explains the recorded /32 routes without implying a mask error.

## Correlate with retained protected-state output

The [final OSPF capture](03-final-validation.md#block-03--ospf-remains-full-over-tunnel0) shows RID 3.3.3.3 at 172.16.13.2 on Tunnel0. The [20/20 sourced test](03-final-validation.md#block-02--test-the-private-endpoints) verifies private reachability after IPsec protection and all three repairs.

R2 supplied the outer endpoint path throughout. It did not participate in GRE, OSPF overlay routing, or IPsec.

[Topology](../topology.md) · [Verification index](README.md) · [GRE/IPsec overview](../README.md)
