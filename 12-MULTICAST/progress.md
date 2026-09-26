# Multicast progress

**Snapshot: September 26, 2026.** Static RP, Auto-RP and BSR are documented within PIM-SM. The IGMPv2/v3 lab is in progress; its portfolio subsection will sit alongside PIM-SM.

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
| IGMPv2/v3 | Lab in progress; standalone Multicast subsection pending |
| SSM, Bidir-PIM, MSDP | Dedicated subsections to follow their completed labs |
| Final RPF review | Planned; existing RPF work remains linked within PIM-SM |

## Evidence retained

PIM-SM contains **105 numbered blocks** across twelve verification pages: 39 static-RP, 30 Auto-RP and 36 BSR. There are seven cases, two topology diagrams and a saved BSR CML checkpoint. The BSR blocks include a labeled operator report and an excerpt from the original export alongside retrieved CLI.

Auto-RP's migration has a complete 20-probe transcript. Its later recovery and the BSR recovery retain mapping and forwarding state without separate complete recovery ping transcripts. Register-Stop behavior is interpreted from the earlier state transition, not a packet capture.

The BSR failover test precedes Candidate RP setup. It establishes election takeover and recovery, not RP failover or a traffic-loss measurement. The supplied CML export also predates Candidate RP setup and retains the missing R3 PIM settings; [completion steps](PIM-SM/configs/bsr.md#complete-the-saved-checkpoint) are documented separately.

## Next checkpoint

Keep Static RP, Auto-RP and BSR together inside PIM-SM. Add IGMPv2/v3, SSM, Bidir-PIM and MSDP as standalone Multicast subsections once their work is ready. A dedicated RPF subsection can summarize the existing exercises and the final review without duplicating evidence.

For the next lab handoff, retain the starting export, the significant before/after checks and a complete traffic transcript where delivery is being tested. A final BSR running-config export would complement the existing intermediate checkpoint.

[Read BSR](PIM-SM/bsr.md) · [Read Auto-RP](PIM-SM/auto-rp.md) · [Back to Multicast](README.md)
