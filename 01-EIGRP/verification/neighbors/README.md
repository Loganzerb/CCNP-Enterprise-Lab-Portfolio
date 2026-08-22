# EIGRP Neighbor Verification

This directory contains EIGRP neighbor adjacency verification outputs collected from the EIGRP AS 100 lab environment.

The purpose of these outputs is to validate successful EIGRP neighbor formation and ensure proper communication between participating routers.

## Verification Command

```text
show ip eigrp neighbors



Validation Performed
The outputs verify:
- EIGRP neighbor relationships
- Neighbor adjacency status
- Connected interfaces participating in EIGRP
- Neighbor uptime
- Reliable Transport Protocol (RTP) neighbor communication
Expected Behavior
A healthy EIGRP adjacency should show:
- Neighbor routers in the neighbor table
- Stable uptime values
- Correct interface participation
- No adjacency resets
Lab Devices Verified
- R1-CORE
- R2-DIST-A
- R3-DIST-B
- R4-BRANCH
- R5-REMOTE
