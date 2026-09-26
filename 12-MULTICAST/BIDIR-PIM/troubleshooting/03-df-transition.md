# Case 03 — change the Designated Forwarder through routing cost

**Result:** the source-LAN DF changed from R1 to R2 when R1's path to the RPA became more expensive. The receiver then returned 29 of 30 multicast probes. The ordinary PIM DR remained R2.

## Objective and baseline

Determine whether the DF election responds to a routing change, then test delivery with the new forwarder. R1 initially had RPA metric 12 and marked itself DF. R2 had metric 32 and agreed that R1 was the winner. R2 was already the PIM DR on the shared source LAN.

[Baseline role evidence](../verification/02-roles.md#block-08--r1-is-df-while-r2-remains-dr)

## Controlled change

R1's Gi0/0 OSPF cost was increased from 10 to 50. This changed its total route metric to `4.4.4.4` from 12 to 52. R2 remained at 32. No DR priority or interface address was changed.

| Check | Before | After |
|---|---|---|
| R1 metric to RPA | 12 | 52 |
| R2 metric to RPA | 32 | 32 |
| Source-LAN DF | R1, 10.10.10.1 | R2, 10.10.10.2 |
| Source-LAN PIM DR | R2 | R2 |

## Validation

Both DF tables selected R2. R1's PIM neighbor table still marked R2 as DR. R3 retained `(*,239.100.100.100)` with Gi0/2 upstream toward the RPA and Gi0/3 toward the receiver.

The source then sent 30 probes to the group from `10.10.10.100`. One timed out; requests 1–29 received replies from `10.30.30.100`.

[Blocks 16–18 — role change, receiver state and complete traffic result](../verification/04-df-transition.md)

## Interpretation and limits

The new DF is explained by the changed routing metric under the same OSPF preference. DR and DF are separate decisions even when the same router holds both roles. The endpoint result supports delivery after the change; it does not establish lossless failover, a convergence duration or the reason for the first timeout.

Restoring R1's original cost was proposed afterward, but a completed rollback and return of the DF role to R1 were not captured.

## Lesson

Check the route that drives an election, verify agreement at both participants, then test the service. A changed control-plane role is only part of the outcome.

[Change commands](../configs/experiments.md) · [Role explanation](../operation.md) · [All cases](README.md) · [Overview](../README.md)
