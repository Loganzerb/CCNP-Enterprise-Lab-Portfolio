
# EIGRP Topology Verification

This directory contains EIGRP topology database verification outputs collected from the EIGRP AS 100 lab environment.

These outputs demonstrate how EIGRP maintains routing information, selects paths, and stores backup routes.

## Verification Commands

```text
show ip eigrp topology

show ip eigrp topology all-links


Validation Performed
The outputs verify:
- Successor routes
- Feasible Successor routes
- Feasible Distance (FD)
- Reported Distance (RD)
- Feasibility Condition
- Alternate routing paths
Expected Behavior
A correctly operating EIGRP topology database should display:
- The best path selected as the Successor
- Backup paths satisfying the Feasibility Condition
- Accurate metric calculations
- Available alternate paths during failures
Lab Devices Verified
- R1-CORE
- R2-DIST-A
- R3-DIST-B
- R4-BRANCH
- R5-REMOTE
