# EIGRP Troubleshooting Scenarios

This directory documents intentional failure scenarios performed within the EIGRP AS 100 lab environment.

The purpose of these exercises is to demonstrate EIGRP troubleshooting methodology beyond basic configuration validation.

Each scenario follows a structured troubleshooting process:

1. Identify the reported issue
2. Establish expected network behavior
3. Analyze symptoms using Cisco IOS verification commands
4. Determine the root cause
5. Apply corrective action
6. Validate network recovery

---

# Troubleshooting Methodology

The troubleshooting approach used throughout these scenarios follows a layered methodology.

## 1. Verify Physical and Logical Connectivity

Initial validation includes confirming:

- Interface status
- IP addressing
- Layer 3 reachability
- Neighbor connectivity

Common commands:
show ip interface brief
show interfaces
ping

---

## 2. Verify EIGRP Neighbor Relationships

EIGRP relies on stable neighbor adjacencies to exchange routing information.

Verification commands:
show ip eigrp neighbors

Items reviewed:

- Neighbor state
- Hold timers
- Interface relationships
- Uptime stability

---

## 3. Analyze the EIGRP Topology Table

The EIGRP topology table provides information used by the Diffusing Update Algorithm (DUAL) to select paths.

Verification commands:
show ip eigrp topology

show ip eigrp topology all-links

Items reviewed:

- Successor routes
- Feasible successors
- Feasible Distance (FD)
- Reported Distance (RD)
- Route state

---

## 4. Verify Routing Table Installation

The routing table confirms which EIGRP routes were installed into the forwarding table.

Verification command:
show ip route eigrp

Items reviewed:

- Installed paths
- Administrative Distance
- Metric values
- Next-hop selection

---

# Lab Troubleshooting Scenarios

The following CCNP Enterprise level scenarios are documented:

---

## Scenario 1 — Feasible Successor Failure and DUAL Convergence

Focus areas:

- Successor selection
- Feasible successor operation
- Feasibility Condition
- DUAL route recalculation
- Active/passive route states

---

## Scenario 2 — EIGRP Stuck-In-Active (SIA)

Focus areas:

- EIGRP query propagation
- Reply processing
- Active route states
- Query boundaries
- Stub router behavior

---

## Scenario 3 — EIGRP Route Summarization Failure

Focus areas:

- Manual summarization
- Summary route advertisement
- Null0 behavior
- Route advertisement troubleshooting

---

# Verification Philosophy

The goal of these scenarios is not only to restore connectivity, but to understand why EIGRP behaves the way it does.

Each troubleshooting exercise documents:

- The failure introduced
- The commands used to isolate the problem
- The evidence collected
- The final resolution
- The EIGRP concept demonstrated
