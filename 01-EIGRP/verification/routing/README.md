
Paste:

```markdown
# EIGRP Routing Verification

This directory contains EIGRP routing table verification outputs from the EIGRP AS 100 lab environment.

These outputs demonstrate successful route installation and forwarding decisions made by EIGRP.

## Verification Command

```text
show ip route eigrp



Validation Performed
The outputs verify:
- EIGRP learned routes
- Installed routing table entries
- Administrative Distance (AD)
- EIGRP metric selection
- Active forwarding paths
Expected Behavior
A correctly operating EIGRP network should show:
- EIGRP routes installed in the Routing Information Base (RIB)
- Expected next-hop selection
- Correct metric calculations
- Successful route propagation throughout the topology
Lab Devices Verified
- R1-CORE
- R2-DIST-A
- R3-DIST-B
- R4-BRANCH
- R5-REMOTE
