# PIM-SM — Build the tree, trace the path, isolate the fault

Protocol Independent Multicast Sparse Mode (PIM-SM) builds delivery paths for receivers that request a multicast group. A Rendezvous Point (RP) gives sources and receivers a common meeting point; the network can then use a source-specific path.

I used a diamond-shaped topology to make those paths visibly different. The lab follows receiver membership through to actual replies, then changes routing and removes RP information at each edge to compare the resulting symptoms.

**6 IOSv nodes · 3 case studies · 39 evidence blocks**

**Status:** Static-RP checkpoint documented. Auto-RP and BSR remain in progress within the wider study.

## Results at a glance

| Exercise | Recorded result | What it demonstrates |
|---|---|---|
| Receiver joins, then source sends | Receiver replies; R4's shared and source entries use different incoming interfaces | Membership, tree state and delivery are separate checks |
| Change R4's route toward the source | Source tree moves from R3 to R2 and returns after rollback | A unicast routing change can move the multicast path |
| Remove R4's RP mapping | Local membership remains, but the RP has no group state; restoring the mapping rebuilds the tree | Receiver interest alone does not establish an upstream path |
| Remove R1's RP mapping | Twenty probes time out; restoration brings back the PIM tunnel and source-tree state | A healthy receiver tree can coexist with a source-side fault |

The source-side repair includes a reported receiver reply, but no complete post-repair ping capture. The receiver-side repair is verified by tree state, without an end-to-end traffic capture for that group.

## Start with a case

- [A ready receiver with no replies](troubleshooting/03-source-rp-failure.md) — use the failure location and source address to interpret apparently healthy multicast state.
- [Receiver membership without an upstream tree](troubleshooting/02-receiver-rp-failure.md) — compare the same missing RP setting at the other edge.
- [A unicast route moves the multicast tree](troubleshooting/01-rpf-path-change.md) — follow the path change across three routers and verify restoration.

## Lab design

![PIM-SM static-RP topology: R1 and R4 form a diamond through R2-RP and R3-TRANSIT](topology.png)

| Device | Role |
|---|---|
| MCAST-SOURCE | Sends multicast ICMP probes from 10.1.1.10 |
| R1-FHR | First-hop router beside the source |
| R2-RP | Rendezvous Point at Loopback0, 2.2.2.2 |
| R3-TRANSIT | Carries the baseline source-specific branch |
| R4-LHR | Last-hop router beside the receiver |
| MCAST-RECEIVER | Joins the group and replies from 10.4.4.10 |

OSPF area 0 supplies unicast reachability. R4's route toward the RP uses R2; its route toward the source uses R3. The baseline group is `239.1.1.1`. Temporary groups `239.2.2.2` and `239.3.3.3` isolate the two RP fault exercises.

[Addressing and wiring](topology.md) · [Configuration guide](configs/README.md)

## Explore the files

| Location | What it contains |
|---|---|
| [Troubleshooting](troubleshooting/README.md) | Three cases with direct links to failure and recovery evidence |
| [Verification](verification/README.md) | Four pages of numbered CLI blocks and brief interpretations |
| [Configurations](configs/README.md) | Six reconstructed baseline files and the controlled exercise changes |
| [Multicast progress](../progress.md) | Completed checkpoint, planned phases and remaining evidence |

## Evidence scope

The captures come from the September 20–21, 2026 lab. They establish membership, routing state, observed path changes and the traffic results described above. They do not measure application performance, convergence time or loss-free transition.

No complete running-config set or multicast CML export was available in the retrieved record. The configuration files reconstruct the relevant baseline from the setup commands and subsequent verification. The source and receiver are IOSv nodes with routing disabled, not application servers.

[Back to Multicast](../README.md) · [Back to portfolio](../../README.md)

