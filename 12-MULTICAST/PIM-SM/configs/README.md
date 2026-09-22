# PIM-SM configuration guide

The six files reconstruct the **static-RP baseline after cleanup** from the lab's setup commands and verification. They are relevant configuration templates, not exported running-configs. No multicast CML YAML was available in the retrieved record.

## Device files

| File | Purpose |
|---|---|
| [MCAST-SOURCE.cfg](MCAST-SOURCE.cfg) | IOSv endpoint at 10.1.1.10 with routing disabled |
| [R1-FHR.cfg](R1-FHR.cfg) | Source LAN gateway, OSPF and PIM on the two upstream branches |
| [R2-RP.cfg](R2-RP.cfg) | RP loopback 2.2.2.2 and both upper transit links |
| [R3-TRANSIT.cfg](R3-TRANSIT.cfg) | Lower transit branch used by the baseline source tree |
| [R4-LHR.cfg](R4-LHR.cfg) | Receiver gateway, static RP and OSPF cost 2 toward R2 |
| [MCAST-RECEIVER.cfg](MCAST-RECEIVER.cfg) | IOSv endpoint with the baseline 239.1.1.1 join |

## Settings that shape the result

| Setting | Role in this lab |
|---|---|
| `ip multicast-routing` on R1–R4 | Enables multicast routing |
| `ip pim sparse-mode` on participating interfaces | Enables PIM-SM on the source LAN, transit links and receiver LAN |
| `ip pim rp-address 2.2.2.2` on all four routers | Supplies the common static RP, including on R2 itself |
| OSPF area 0 | Supplies reachability used by the reverse-path lookups |
| `ip ospf cost 2` on R4 Gi0/1 | Separates R4's preferred source path from its RP path |
| `ip igmp join-group 239.1.1.1` on the receiver | Establishes local interest in the baseline group |
| `no ip routing` and a default gateway on each endpoint | Makes the two IOSv nodes operate as hosts for these tests |

The RP uses Loopback0; R2's unused Gi0/2 is not part of PIM. During setup, PIM was briefly placed on Gi0/2, then removed and applied to Loopback0. These files reflect the corrected state.

## Rebuild and verify

1. Create six IOSv nodes and follow the [wiring table](../topology.md#wiring).
2. Apply the appropriate template to each fresh node, using its configuration mode.
3. Verify interfaces, OSPF neighbors and receiver-to-source unicast reachability.
4. Check static RP mappings and PIM neighbors. On R4, verify the source RPF via R3 and RP RPF via R2.
5. Inspect receiver membership and shared-tree state before sending multicast probes from MCAST-SOURCE.
6. Compare the resulting source entries and replies with the [baseline evidence](../verification/01-baseline.md).

To reproduce the recorded sequence before receiver interest, temporarily remove the baseline join on MCAST-RECEIVER, check the group state after old entries expire, then add the join again. The templates intentionally represent the later clean baseline.

These templates have been checked against the retained addressing, commands and output. They have not been imported and rerun in CML as part of this documentation work. IOS image defaults can affect the initial state; establish a fresh baseline before reproducing the exercises.

## Exercise changes

[Exercise commands](exercise-commands.md) contains the temporary static route, the two RP faults, recovery commands and receiver cleanup. Those changes are excluded from the baseline files.

[Back to PIM-SM](../README.md)

