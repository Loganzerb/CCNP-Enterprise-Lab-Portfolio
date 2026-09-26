# BIDIR-PIM — shared-tree forwarding and a change of forwarder

This lab tests how a multicast network chooses one router to carry source traffic from a shared LAN. Two routers compete for that responsibility. Changing the preferred router's routing cost moved the forwarding role to its neighbor, after which the receiver returned **29 replies from 30 multicast probes**.

The work also resolved two practical faults: interface addresses that did not match the cabling, and a receiver join accidentally placed on the source host. Each repair is linked to the device evidence that established the cause and result.

## Start here

| Review path | What it explains |
|---|---|
| [DF transition case](troubleshooting/03-df-transition.md) | Why R1 lost the forwarding role and how delivery was checked afterward |
| [DR, DF and shared-tree behavior](operation.md) | Separate router roles and interpret the source/receiver paths |
| [Topology](topology.md) | Shared source LAN, competing routers, receiver branch and RPA |

## Navigate the files

| Guide | Contents |
|---|---|
| [Configuration](configs/README.md) | Corrected addressing, BIDIR mapping and experiment changes |
| [Verification](verification/README.md) | Eighteen numbered blocks, with full supplied transcripts |
| [Troubleshooting](troubleshooting/README.md) | Two repairs and the controlled DF transition |

## What the evidence establishes

- R1 was initially the Designated Forwarder (DF), while R2 was the PIM Designated Router (DR) on the same LAN.
- R1's RPA route changed from metric 12 to 52; R2 remained at 32 and became DF.
- R3 retained the receiver's `(*,G)` shared-tree state, with Gi0/3 toward the receiver.
- The complete post-change traffic test contains one timeout followed by 29 replies.

This was a routing-metric experiment, not a router shutdown. The traffic test was run after the transition; it does not measure convergence loss. A return to R1's original cost was proposed afterward but has no retained confirmation.

[IGMPv2/v3](../IGMPv2-v3/README.md) · [PIM-SM](../PIM-SM/README.md) · [Back to Multicast](../README.md)
