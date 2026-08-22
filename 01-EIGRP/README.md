# EIGRP Lab

## Overview

This project documents the Enhanced Interior Gateway Routing Protocol (EIGRP) portion of my CCNP Enterprise lab environment.

The lab was built using Cisco Modeling Labs (CML) to develop practical experience designing, configuring, verifying, and troubleshooting enterprise routing environments.

The focus of this project was understanding EIGRP behavior beyond configuration, including convergence, path selection, failure recovery, and troubleshooting methodology.

---

# Lab Objectives

The goals of this lab were:

- Build an enterprise EIGRP routing domain
- Understand EIGRP neighbor formation
- Analyze Diffusing Update Algorithm (DUAL) behavior
- Validate successor and feasible successor operation
- Test routing convergence during failures
- Implement EIGRP authentication
- Practice summarization and route control techniques

---

# Lab Topology

The EIGRP lab consisted of a multi-router enterprise topology designed to simulate core, distribution, and branch routing relationships.

The topology was used to validate:

- EIGRP neighbor formation
- Route propagation
- Redundant path selection
- Routing convergence during failures
- Dynamic routing troubleshooting

## Topology Diagram

*Topology diagram will be added here.*

---

# Technologies Practiced

## EIGRP Fundamentals

- Classic EIGRP configuration
- Named EIGRP configuration
- Autonomous System (AS) operation
- Neighbor relationships
- Hello and hold timers
- Routing table verification

## DUAL and Path Selection

- Feasible Distance (FD)
- Reported Distance (RD)
- Successor routes
- Feasible Successor routes
- Feasibility Condition
- Passive and Active states

## Design Features

- EIGRP authentication
- Route summarization
- Stub routing
- Route filtering
- Default route propagation

---

# Skills Demonstrated

- Enterprise routing design
- Dynamic routing troubleshooting
- Network convergence analysis
- Cisco IOS verification methodology
- Failure scenario testing
- Routing protocol optimization
- Network behavior analysis

---

# Troubleshooting Scenarios

This lab included deliberate failure testing to observe EIGRP convergence behavior.

The goal was to understand how EIGRP reacts to network changes and how DUAL determines the best available path.

Examples:

- Primary path failure and successor replacement
- Feasible successor validation
- Loss of feasible successor
- Query propagation and Active state behavior
- Neighbor relationship troubleshooting

Detailed troubleshooting scenarios will be documented in the troubleshooting directory.

---

# Verification

The following Cisco IOS commands were used to validate EIGRP operation.

## Neighbor Verification

```text
show ip eigrp neighbors
