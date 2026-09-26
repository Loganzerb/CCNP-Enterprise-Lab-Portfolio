# Case 01 — the receiver branch disappears without a captured Leave

**Result:** R4 removed the receiver-facing branch after membership expired. New reports from `10.4.4.10` restored the branch. The investigation identified the actual removal mechanism instead of assuming a Leave exchange had occurred.

## Symptom and evidence

After the receiver membership was withdrawn, the group remained temporarily in `show ip igmp groups`. Its timer decreased from `00:01:10` to `00:00:08`. The matching multicast route showed Gi0/0 close to expiry as well.

[Block 02 — countdown and removal](../verification/01-v2-membership.md#block-02--membership-expires-without-a-captured-leave)

## Investigation and cause

The debug contained general queries and unrelated `224.0.1.40` reports, but no captured Leave for the test group. At `21:21:16.510`, IOS switched the test-group membership state and deleted Gi0/0 from the multicast route. The evidence supports expiration of unrefreshed membership.

## Remediation and validation

The receiver membership was re-added. At `21:23:48.034`, R4 received a report from `10.4.4.10` for `239.1.1.1`. Subsequent checks listed that reporter on Gi0/0 and restored Gi0/0 to the outgoing interface list.

[Block 03 — reports and restored state](../verification/01-v2-membership.md#block-03--receiver-reports-restore-the-outgoing-branch)

## Lesson

Membership removal can be explained only by following the evidence actually captured. Timer expiry and Leave-driven querying are different mechanisms. A group entry can persist briefly after the receiver stops reporting, so a single table snapshot can be misleading.

[Configuration](../configs/README.md) · [All investigations](README.md) · [Overview](../README.md)
