# Case 07 — OSPF reaches the BSR, but RP discovery stops

R2 was configured to advertise itself as a Rendezvous Point, yet the network did not learn an RP. Ordinary routes to the Bootstrap Router existed. The fault was missing PIM Sparse Mode on two R3 transit interfaces, which interrupted the multicast control-plane path. Restoring those settings allowed RP discovery to recover across R1–R4.

## Symptoms

R2 showed its Candidate RP role and advertisement timer, but no active BSR address. R5 identified itself as the BSR while its RP-set remained empty. Repeated checks showed the condition persisting beyond the first convergence snapshot.

[Candidate role with no mapping](../verification/10-bsr-propagation.md#block-02) · [Persistent empty state](../verification/10-bsr-propagation.md#block-03)

## Follow the dependency chain

The Candidate RP must learn the elected BSR before sending advertisements to it. An empty RP-set can therefore result from missing BSR knowledge upstream of the advertisement stage.

I compared BSR knowledge with the route to `5.5.5.5` on each router:

| Device | Captured BSR knowledge | Captured OSPF path to 5.5.5.5 |
|---|---|---|
| R3 | Knows R5 | Gi0/2 via 10.35.0.2 |
| R1 | Knows R5 in this snapshot | Gi0/2 via 10.13.0.2 |
| R4 | No active BSR shown | Gi0/2 via 10.34.0.1 |
| R2 | Candidate RP only; no active BSR shown | Equal-cost entries through R1 and R4 |

[Router-by-router evidence](../verification/10-bsr-propagation.md#block-04)

These route entries narrowed the investigation; they did not prove PIM was active on the same links. R1's temporary BSR knowledge also matters: the captures are not simultaneous, so the evidence does not support saying R1 never received Bootstrap Messages.

## Root cause

R3 Gi0/0 toward R1 and Gi0/1 toward R4 lacked `ip pim sparse-mode`. The R5-facing Gi0/2 still had it. The [saved configuration excerpt](../verification/10-bsr-propagation.md#block-05) independently corroborates the missing settings reported during the repair.

Earlier filtered PIM output had shown sparse-mode lines without their interface names. Counting those lines could not confirm that each required transit interface participated. The reason the two commands were absent was not established.

## Remediation

Restore PIM on **R3-TRANSIT**:

```text
configure terminal
interface GigabitEthernet0/0
 ip pim sparse-mode
interface GigabitEthernet0/1
 ip pim sparse-mode
end
```

The exact keystrokes are reconstructed. The operator reported the correction, and the following captures retain its results.

## Post-fix validation

First, R5's RP-set included `2.2.2.2` with the Candidate RP itself as the information source. Then R1, R2, R3 and R4 all learned the same RP for `224.0.0.0/4`, with `Info source: 5.5.5.5, via bootstrap`.

[R5 receives the Candidate RP](../verification/10-bsr-propagation.md#block-06) · [R1–R4 recover their mappings](../verification/10-bsr-propagation.md#block-07)

The [subsequent forwarding checks](../verification/11-bsr-forwarding.md) show R4's receiver-driven shared tree, then its source tree through R3 and R2's pruned source branch. This establishes recovered discovery and forwarding state. There is no complete post-repair multicast ping transcript or packet capture in the supplied BSR material.

## Lessons learned

- Separate underlay reachability from multicast protocol participation.
- Check BSR knowledge before blaming Candidate RP advertisement syntax.
- Inspect named interfaces; a filtered list of PIM lines is not a path audit.
- Verify the repaired mapping on every affected router, then inspect forwarding state.

[All cases](README.md) · [BSR overview](../bsr.md) · [Configuration and checkpoint](../configs/bsr.md)
