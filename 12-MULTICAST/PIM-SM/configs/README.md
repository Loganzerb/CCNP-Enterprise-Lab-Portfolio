# PIM-SM configurations — Choose the lab phase

The files here describe different checkpoints. The six device templates belong to Static RP; the Auto-RP and BSR guides describe their later phase changes.

| Phase | Material | Configuration status |
|---|---|---|
| [Static RP](#static-rp) | Six device templates and an exercise-command guide | Reconstructed static baseline |
| [Auto-RP](#auto-rp) | Migration, listener recovery and rollback commands | Documented changes to the original six-node lab |
| [BSR](#bsr) | Seven-node CML export and separate completion/experiment commands | Intermediate saved checkpoint; completion changes documented separately |

## Static RP

The six files reconstruct the **static-RP baseline after cleanup** from setup commands and verification. They are configuration templates, not exported running-configs. [Static-RP overview](../static-rp.md).

### Device files

| File | Purpose |
|---|---|
| [MCAST-SOURCE.cfg](MCAST-SOURCE.cfg) | IOSv endpoint at 10.1.1.10 with routing disabled |
| [R1-FHR.cfg](R1-FHR.cfg) | Source LAN gateway, OSPF and PIM on the two upstream branches |
| [R2-RP.cfg](R2-RP.cfg) | RP loopback 2.2.2.2 and both upper transit links |
| [R3-TRANSIT.cfg](R3-TRANSIT.cfg) | Lower transit branch used by the baseline source tree |
| [R4-LHR.cfg](R4-LHR.cfg) | Receiver gateway, static RP and OSPF cost 2 toward R2 |
| [MCAST-RECEIVER.cfg](MCAST-RECEIVER.cfg) | IOSv endpoint with the baseline 239.1.1.1 join |

### Settings that shape the result

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

### Exercise changes

[Exercise commands](exercise-commands.md) contains the temporary static route, the two RP faults, recovery commands and receiver cleanup. Those changes are excluded from the baseline files.

## Auto-RP

[Auto-RP configuration guide](auto-rp.md) covers the Candidate RP on R2, Mapping Agent on R3, listener behavior, removal of static fallback and recovery commands. These changes belong to the six-node Auto-RP phase.

[Phase overview](../auto-rp.md) · [Auto-RP evidence](../verification/README.md#auto-rp)

## BSR

[BSR configuration guide](bsr.md) covers the added R5 router, candidate roles, election tests, PIM repair and temporary second-RP experiment.

The [September 24 CML export](PIM-SM_BSR_September_24th.yaml) is an **intermediate checkpoint**: it retains missing PIM on R3 Gi0/0 and Gi0/1 and predates R2's Candidate RP configuration. The guide identifies the later changes; the export alone is not the final completed state.

[Phase overview](../bsr.md) · [BSR evidence](../verification/README.md#bsr)

[All PIM-SM phases](../README.md) · [Back to Multicast](../../README.md)
