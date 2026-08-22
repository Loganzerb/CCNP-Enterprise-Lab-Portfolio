# EIGRP Verification

This directory contains verification outputs collected from the EIGRP AS 100 lab environment.

The purpose of these outputs is to validate EIGRP operation beyond configuration by demonstrating:

- Neighbor adjacency formation
- EIGRP topology database operation
- Successor and Feasible Successor selection
- Route installation
- EIGRP process configuration
- Route summarization
- Stub routing behavior

## Verification Commands

The following Cisco IOS commands were used:

- `show ip eigrp neighbors`
- `show ip eigrp topology`
- `show ip route eigrp`
- `show ip protocols`

## Verification Categories

### Neighbor Verification

Located in:

neighbors/

Validates:

- EIGRP neighbor relationships
- Autonomous System (AS) matching
- Adjacency uptime
- Interface relationships

---

### Topology Verification

Located in:

topology/

Validates:

- Successor routes
- Feasible Successor routes
- Feasible Distance (FD)
- Reported Distance (RD)
- DUAL (Diffusing Update Algorithm) behavior

---

### Routing Verification

Located in:

routing/

Validates:

- EIGRP routes installed into the Routing Information Base (RIB)
- Next-hop selection
- Administrative Distance
- Metric calculations

---

### Protocol Verification

Located in:

protocols/

Validates:

- EIGRP Autonomous System (AS) configuration
- Router IDs
- Network statements
- Passive interfaces
- Summarization
- Stub routing
