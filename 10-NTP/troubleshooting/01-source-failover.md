# Case 01 — A backup takes over, but recovery is not immediate

## Summary

A backup time server supplied the core and downstream client after the primary link was taken down. Restoring the link did not immediately make the primary usable again: it responded to requests but remained rejected by NTP.

The exercise demonstrated both a working alternate timing hierarchy and the difference between a reachable source and an accepted source.

## Starting point and failure

R1 supplied local stratum 1 time; R4 supplied independent local stratum 3 time. R2 knew both servers, and R3 used R2.

R1 was initially selected. R4 responded but was subsequently marked `insane, invalid`, so simply configuring a second server did not establish that it was ready to take over. [Blocks 01–02](../verification/02-failover.md#block-01)

I took down the R1–R2 link during the exercise. The shutdown was confirmed in the lab notes; the retained output then showed R1 reach falling from 377 to **376**, while R1 still held the selected marker and R4 was marked `x`. This was an intermediate state, not an instantaneous switchover. [Block 03](../verification/02-failover.md#block-03)

## Backup operation

Later status captures established the changed hierarchy:

| Device | Captured state |
|---|---|
| R2 | Synchronized, stratum 4, reference 10.20.0.4 |
| R3 | Synchronized, stratum 5, reference 10.20.0.1 |

[Core result — Block 04](../verification/02-failover.md#block-04) · [Client result — Block 05](../verification/02-failover.md#block-05)

R2 also reported a `SPIK` loop state and 379.0482 ms offset. I retain that detail because the synchronized flag alone does not establish settled or accurate time.

## Recovery and diagnosis

After I confirmed the link was back up, R1 first appeared as `.STEP.` with reach 0. Later it had reach 7 and populated timing samples, yet still showed `insane, invalid`. R4 remained `our_master, sane, valid`. [Blocks 06–07](../verification/02-failover.md#block-06)

The two local clocks showed substantially different offsets. That is consistent with source disagreement, but the capture does not identify a particular failed validity test or establish which clock was externally correct.

I then confirmed applying `ntp server 10.12.0.1 prefer`. The next capture still marked R1 as a falseticker and selected R4. The configuration action is recorded in the exercise notes; the association output captures the outcome, not the presence of the keyword. [Block 08](../verification/02-failover.md#block-08)

A later session confirmed R2 synchronized through R1 again at stratum 2. [Block 09](../verification/02-failover.md#block-09)

## What this establishes

Failover to R4 was observed on both R2 and R3. Immediate failback, a specific convergence time and uninterrupted synchronization were not measured. Two self-referenced local clocks also cannot establish external time accuracy.

**Takeaway:** verify the source's acceptance and the downstream clock state, rather than treating a second configured address or a restored link as proof of timing resilience.

[Back to cases](README.md) · [Back to NTP](../README.md)
