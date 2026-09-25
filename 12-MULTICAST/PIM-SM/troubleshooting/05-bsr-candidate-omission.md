# Case 05 — R5 does not enter the BSR election

R5 was expected to replace R3 as the Bootstrap Router, but repeated checks kept showing R3. The issue was a missing candidate command on R5. Once the role was configured, R5 became BSR and R3 recognized it.

## Expected behavior and symptom

R3 was already elected at BSR priority 10. The planned R5 priority was 20, which should make R5 the preferred candidate. Instead, R5 continued learning BSR `3.3.3.3`; its expiry timer refreshed across checks rather than counting steadily toward zero.

[Initial R3 election](../verification/09-bsr-election.md#block-01) · [Repeated R5 checks](../verification/09-bsr-election.md#block-02)

## Diagnosis

The new link already had [OSPF reachability and PIM participation](../verification/08-bsr-transition.md#block-10). That established connectivity, not the Candidate BSR role. R5's output contained no local candidate line.

The operator then [identified the omitted command](../verification/09-bsr-election.md#block-03). This corrected the working assumption that R5 was already participating. The earlier decision to wait for election convergence did not address the missing configuration.

## Correction

On **R5-BSR2**, configure the intended candidacy:

```text
configure terminal
ip pim bsr-candidate Loopback0 0 20
end
```

This command is reconstructed from the lab sequence and saved configuration. The operator's diagnosis and resulting election are captured; the original command-entry transcript is not.

## Validation

R5 reported `This system is the Bootstrap Router (BSR)` with address `5.5.5.5` and priority 20. R3 separately showed that elected BSR while remaining a candidate at priority 10.

[R5 becomes BSR](../verification/09-bsr-election.md#block-04) · [R3 confirms the winner](../verification/09-bsr-election.md#block-05)

## Lesson learned

Confirm that a device is a candidate before investigating why it has not won. A working neighbor relationship and a refreshing learned-BSR timer prove participation in the PIM domain, but do not prove local candidacy.

[Next: BSR failover](06-bsr-failover.md) · [All cases](README.md) · [BSR overview](../bsr.md)
