# Multicast progress

**Snapshot: September 26, 2026.** Static RP, Auto-RP and BSR are documented within PIM-SM. IGMPv2/v3 with SSM control-plane validation and BIDIR-PIM are documented as sibling subsections.

| Work | Current position |
|---|---|
| Original six-node topology | Built; distinct source and RP paths verified |
| Static-RP PIM-SM | Membership, registration state, receiver replies and three controlled cases documented |
| RPF path change | Source tree moved with a temporary unicast route and restored |
| Auto-RP migration | Dynamic mapping verified before removing static configuration across R1–R4; 19 replies from 20 probes captured |
| Auto-RP recovery | Listener restored across the domain; counters, mapping and source-tree state documented |
| Seven-node BSR topology | R5 added as a leaf off R3; OSPF reachability and PIM adjacency captured |
| BSR election | Missing candidacy corrected; priority and BSR-address tie-break verified |
| BSR failover/recovery | R3 takes over when R5 is isolated; R3 accepts R5 after reconnection |
| BSR propagation repair | Missing PIM on R3 Gi0/0 and Gi0/1 corrected; R1–R4 recover matching RP information |
| BSR forwarding | R4 shared/source-tree state and R2's pruned source entry captured |
| Candidate RP experiment | Unequal/equal priority and R4's hash selection documented; temporary R3 RP role removed |
| IGMPv2/v3 | Membership expiry/rejoin and version migration documented in its own subsection |
| SSM | INCLUDE membership and source-specific routing state documented with IGMPv3; no retained SSM traffic transcript |
| BIDIR-PIM | Addressing and receiver-placement repairs, DR/DF separation and DF transition documented; post-change test has 29/30 replies |
| MSDP | Next lab; no completed evidence added to the portfolio |
| Final RPF review | Planned; existing RPF work remains linked within PIM-SM |

## Evidence retained

PIM-SM contains **105 numbered blocks** across twelve verification pages: 39 static-RP, 30 Auto-RP and 36 BSR. There are seven cases, two topology diagrams and a saved BSR CML checkpoint. The BSR blocks include a labeled operator report and an excerpt from the original export alongside retrieved CLI.

Auto-RP's migration has a complete 20-probe transcript. Its later recovery and the BSR recovery retain mapping and forwarding state without separate complete recovery ping transcripts. Register-Stop behavior is interpreted from the earlier state transition, not a packet capture.

The BSR failover test precedes Candidate RP setup. It establishes election takeover and recovery, not RP failover or a traffic-loss measurement. The supplied CML export also predates Candidate RP setup and retains the missing R3 PIM settings; [completion steps](PIM-SM/configs/bsr.md#complete-the-saved-checkpoint) are documented separately.

IGMP adds seven numbered blocks and two investigations. BIDIR adds eighteen blocks, two repairs and one controlled change case, plus six captured device configuration blocks from the September 25 checkpoint. Numbering restarts within each protocol subsection. Across Multicast there are **130 numbered evidence blocks**.

IGMPv2 removal was observed through expiry, without a captured Leave exchange. IGMPv3/SSM has a source-specific route but no retained delivery test. BIDIR's original 100-probe excerpt stops at request 42; its later 30-probe transcript is complete. That later test occurred after the DF change and does not measure transition loss. The proposed cost rollback was not captured.

## Next checkpoint

Keep Static RP, Auto-RP and BSR together inside PIM-SM. Keep IGMPv2/v3 (including its completed SSM state exercise) and BIDIR as sibling subsections. Add MSDP when its evidence is ready. A dedicated RPF subsection can summarize the existing exercises and the final review without duplicating evidence.

For the next lab handoff, retain the starting export, the significant before/after checks and a complete traffic transcript where delivery is being tested. A final BSR running-config export would complement the existing intermediate checkpoint.

[Read IGMP](IGMPv2-v3/README.md) · [Read BIDIR](BIDIR-PIM/README.md) · [Read BSR](PIM-SM/bsr.md) · [Read Auto-RP](PIM-SM/auto-rp.md) · [Back to Multicast](README.md)
