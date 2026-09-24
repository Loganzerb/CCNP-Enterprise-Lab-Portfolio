# Case 04 — Auto-RP roles exist, but discovery cannot recover

R2 still advertised itself as a Candidate RP, but R3 received no announcements after its Mapping Agent role was restored. The completed investigation found missing Auto-RP listener configuration across the sparse-mode domain. Restoring it allowed R3 to receive announcements again, distribute the mapping and restore the RP information used by the receiver-side router.

The case demonstrates how to separate configured roles from the control-message transport those roles depend on.

## Context: two stages of the incident

The lab first intentionally removed R3's Mapping Agent role. A static RP had also reappeared on R4, masking the loss of dynamic discovery; that fallback was removed before evaluating the outage.

R4 then had no RP mapping, retained local receiver membership and showed RP `0.0.0.0` with incoming interface Null. A source test recorded twenty timeouts.

The **persistent recovery fault** came next: restoring R3's Mapping Agent and local listener did not restore announcement reception. This is where the domain-wide listener problem became the key finding. The earlier traffic failure is not presented as an isolated listener-only test.

[Static fallback](../verification/06-autorp-recovery.md#block-01) · [Empty mapping](../verification/06-autorp-recovery.md#block-02) · [Missing upstream tree](../verification/06-autorp-recovery.md#block-03) · [Receiver membership](../verification/06-autorp-recovery.md#block-04) · [Twenty timeouts](../verification/06-autorp-recovery.md#block-05)

## Troubleshooting methodology

| Question | Evidence | Decision |
|---|---|---|
| Is the receiver still asking for the group? | IGMP lists 10.4.4.10 on R4 Gi0/0 | Continue upstream; local membership is present |
| Is R3 configured to distribute mappings? | [Mapping Agent and listener commands are present](../verification/06-autorp-recovery.md#block-06) | Avoid repeatedly changing the role |
| Is R3 receiving candidate information? | [Announce 0/0, Discovery 0/0](../verification/06-autorp-recovery.md#block-07) | Check candidate generation and the path carrying announcements |
| Did R2 lose its candidate role? | [Candidate command remains; Announce is 3/0](../verification/06-autorp-recovery.md#block-08) | Generation exists; it does not prove remote reception |
| Is discovery transport configured? | [R2's listener filter is empty](../verification/06-autorp-recovery.md#block-09); the completed lab check found omissions across R1–R4 | Restore listener behavior throughout the domain |

Counter values are Sent/Received. They are cumulative snapshots, not a packet-by-packet ledger. A zero on the first check just after configuration can be normal; the stalled recovery must be interpreted with the role, listener and upstream checks.

## Root cause and remediation

The completed lab record identifies missing `ip pim autorp listener` configuration across the four-router domain. R3 had already been restored locally by an intermediate checkpoint, so its enabled status line did not establish that the rest of the path was ready.

The corrective setting on **R1, R2, R3 and R4** was:

```cisco
configure terminal
ip pim autorp listener
end
```

R2 retained the Candidate RP role and R3 retained the restored Mapping Agent role. The listener supplies the forwarding treatment needed by the two Auto-RP control groups in this sparse-mode design; it does not assign either role. [Cisco listener behavior](https://www.cisco.com/c/en/us/support/docs/ip/multicast/118405-config-rp-00.html)

The available record does not establish why commands disappeared or why R4's static command reappeared. No IOS defect or unsaved-configuration cause is asserted.

## Post-fix validation

**R3 recovery:** [Block 10](../verification/06-autorp-recovery.md#block-10) contains:

```text
AutoRP groups over sparse mode interface is enabled
RP Announce: 0/5, RP Discovery: 10/0
```

R3 now receives Candidate-RP announcements and sends Mapping-Agent discoveries.

**R4 recovery:** [Block 11](../verification/06-autorp-recovery.md#block-11) identifies RP `2.2.2.2` for `224.0.0.0/4`, information source `10.34.0.1` and `elected via Auto-RP`. That range includes the test group `239.1.1.1`.

The [final forwarding sequence](../verification/07-autorp-forwarding.md) then shows R4's source entry using Gi0/2 toward R3, R2 retaining group state while pruning this source, and R1 settling on Gi0/2 toward the receiver path.

The earlier Auto-RP-only migration test captured **19/20 replies**. The supplied post-fix record verifies counters, RP mapping and final source/receiver forwarding state; it does not include a separate complete post-fix ping transcript.

## Lessons learned

- Correct Candidate RP and Mapping Agent commands do not prove the discovery messages can cross the network.
- Work through generation, reception and distribution in order; use the counters to choose the next check.
- A listener enabled on one router is insufficient evidence of a consistent domain configuration.
- Remove unintended static fallback before claiming a test depends entirely on dynamic RP learning.
- Validate the repaired control plane and the source-specific forwarding path separately.
- Keep the cause of the outage distinct from problems discovered during recovery.

[Configuration and repair steps](../configs/auto-rp.md) · [Back to cases](README.md) · [Back to Auto-RP](../auto-rp.md)

