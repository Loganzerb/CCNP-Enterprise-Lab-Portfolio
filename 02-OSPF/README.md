# OSPF Verification

This directory contains healthy-state verification evidence collected after the OSPF topology converged. The outputs establish a known-good baseline for comparison during troubleshooting.

Verification evidence will be organized into the following categories:

- **Neighbors** — adjacency state, neighbor roles, and dead timers
- **Interfaces** — area membership, cost, network type, and DR/BDR status
- **Database** — expected LSA types and area-specific link-state information
- **Routing** — intra-area, inter-area, external, NSSA, and equal-cost paths
- **Protocols** — router IDs, passive interfaces, area settings, and redistribution

Representative commands include `show ip ospf neighbor`, `show ip ospf interface`, `show ip ospf database`, `show ip route ospf`, and `show ip protocols`.
