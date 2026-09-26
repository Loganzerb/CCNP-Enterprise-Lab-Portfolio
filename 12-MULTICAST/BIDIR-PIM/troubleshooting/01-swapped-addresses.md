# Case 01 — links are up, but R1 cannot reach the RPA

**Result:** correcting R1's interface addressing restored its OSPF adjacency with R3 and route to `4.4.4.4`. R1 then received 5/5 replies from that address.

## Symptom

R1's interfaces were up/up, but `show ip route 4.4.4.4` returned Network not in table and the ping failed 0/5. R3's OSPF table listed R2 and R4, with R1 missing. R2 could already reach the RPA, narrowing the fault to R1's side.

## Investigation and root cause

The physical connections put R1 Gi0/0 toward R3 and Gi0/1 on the shared source LAN. The initial configuration assigned `10.10.10.1/24` to Gi0/0 and `10.13.0.1/30` to Gi0/1. The interfaces were operational but addressed for each other's segments.

[Blocks 01–02 — failed checks and interface addresses](../verification/01-foundation.md)

## Remediation

Assign `10.13.0.1/30` and OSPF cost 10 to Gi0/0; assign `10.10.10.1/24` to Gi0/1. Make the source-LAN interface passive in OSPF and allow the transit interface to form an adjacency.

## Post-fix validation

R1's corrected output showed R3 FULL on Gi0/0 and an OSPF route to the RPA with metric 12. Its RPA ping succeeded 5/5. The source-to-receiver unicast test returned 4/5, with the first miss preserved rather than attributed to an unobserved cause.

[Blocks 03–04 — corrected state and reachability](../verification/01-foundation.md#block-03--corrected-addressing-restores-ospf-and-the-rpa-route)

## Lesson

Validate the unicast foundation before multicast. Link status proves an operational interface, not that its address and routing settings match the connected neighbor.

[Correction commands](../configs/experiments.md) · [All cases](README.md) · [Overview](../README.md)
