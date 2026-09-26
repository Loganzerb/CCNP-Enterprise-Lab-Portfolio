# Static RP — Establish forwarding and isolate the fault

A static Rendezvous Point gives every multicast router the same configured meeting point for sources and receivers. I used this baseline to trace the delivery path, change its routing, and compare RP faults at opposite ends of the network.

The diamond topology made the shared tree and source tree visibly different. It also allowed a useful diagnostic contrast: receiver membership could remain healthy while missing RP information prevented the upstream path or source registration from working.

**Phase 01 of 03 · 6 IOSv nodes · 3 cases · 39 evidence blocks**

## Review this phase

| Material | Start here |
|---|---|
| Topology | [Original diagram, addresses and wiring](topology.md) |
| Configuration | [Static device templates](configs/README.md#static-rp) and [exercise changes](configs/exercise-commands.md) |
| Verification | [Static-RP evidence pages](verification/README.md#static-rp) |
| Troubleshooting | [Three static-RP cases](troubleshooting/README.md#static-rp) |

## Results at a glance

| Exercise | Recorded result | Evidence |
|---|---|---|
| Establish the baseline | Receiver replies; R4's shared and source entries use different incoming interfaces | [Membership and forwarding](verification/01-baseline.md) |
| Change the route toward the source | The source tree moves from R3 to R2, then returns after rollback | [RPF path change](troubleshooting/01-rpf-path-change.md) |
| Remove R4's RP mapping | Local membership remains; restoring the mapping rebuilds the upstream tree | [Receiver-side fault](troubleshooting/02-receiver-rp-failure.md) |
| Remove R1's RP mapping | Twenty probes time out; restoration brings back registration and source state | [Source-side fault](troubleshooting/03-source-rp-failure.md) |

## Topology and roles

![Original six-node static-RP topology](topology.png)

R1 is the first-hop router for source 10.1.1.10. R2 is the RP at Loopback0 2.2.2.2. R3 carries the baseline source-tree branch, and R4 serves receiver 10.4.4.10. R1–R4 all have the static RP address configured.

R4 reaches the RP through R2 and the source through R3. The [addressing guide](topology.md) explains the OSPF setting that separates these paths and identifies the temporary groups used in the fault exercises.

## Lessons and evidence scope

- Check membership, RP information, reverse-path selection and forwarding state separately.
- A unicast route change can move the multicast source tree.
- A ready receiver does not prove the source can register with its RP.

The receiver-side repair establishes tree recovery. The source-side repair has recovered state and a reported reply, without a complete recovery ping transcript. The baseline includes an initial timeout marker and duplicate replies; their cause was not established by packet capture. The six configuration files reconstruct the static baseline rather than representing exported running-configs.

## Continue the lab

[Phase 02 — Auto-RP](auto-rp.md) replaces the static setting with dynamic discovery. [Phase 03 — BSR](bsr.md) later adds an election and RP-set distribution.

[All PIM-SM phases](README.md) · [Back to Multicast](../README.md)
