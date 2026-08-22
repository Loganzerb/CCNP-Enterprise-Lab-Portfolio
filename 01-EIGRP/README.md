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

# Troubleshooting Scenarios

This lab included deliberate failure testing to observe EIGRP convergence behavior.

Examples:

- Primary path failure and successor replacement
- Feasible successor validation
- Loss of feasible successor
- Query propagation and Active state behavior
- Neighbor relationship troubleshooting

---

# Repository Structure
configs/
    Sanitized Cisco IOS configurations
verification/
    Show commands and validation outputs
troubleshooting/
    Failure scenarios and analysis

    
---

# Lab Environment

Tools used:

- Cisco Modeling Labs (CML)
- Cisco IOSv routers
- GitHub documentation workflow

---

# Lessons Learned

Key takeaways from this lab:

- EIGRP maintains loop-free backup paths through DUAL
- Understanding FD and RD is critical for troubleshooting convergence
- Verification commands are essential for validating expected behavior
- Network failures should be tested intentionally to understand protocol behavior
