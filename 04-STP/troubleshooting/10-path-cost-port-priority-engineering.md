# Case 10 — Choose a preferred path deliberately

## Why this matters

Redundant cabling creates choices. An engineer needs to explain which path should be preferred and verify that the switch makes that choice.

## Documented exercise

The original notes describe changing interface path cost to alter a root-port decision, then using port priority in equal-cost conditions. The purpose was to distinguish the main path-selection controls from later tie-breaks.

## Read the controls in order

First establish the intended root bridge. When comparing paths toward that same root, compare total root-path cost, including the receiving interface's contribution. Remaining ties depend on the sender bridge ID, sender port ID, and finally the receiving port ID.

| Control | Question it answers |
|---|---|
| Root bridge priority/ID | Which switch provides the spanning-tree reference? |
| Total path cost | Which available route toward that root is preferred? |
| Sender port priority/ID | Which otherwise tied advertisement is preferred? |
| Receiving port ID | Which local port wins if the earlier comparisons still tie? |

A lower port priority is not a substitute for understanding the cost and bridge comparisons that precede it.

## What the files establish

The [SW3 VLAN 10 capture](../verification/root-election/SW3-show-spanning-tree-vlan-10.txt) shows Gi0/0 Root/FWD at long cost 20000 and Gi0/2 Alternate/Blocked. It establishes the selected result at that stage, not a before/after record of the priority exercise.

The [SW5 setting capture](../verification/path-engineering/SW5-pathcost-method-long.txt) confirms long cost at a later check. In contrast, the [temporary LACP sequence](../verification/etherchannel/README.md) shows local cost 3 with two members and 4 with one member, while total root costs are 11 and 12 respectively.

Those distinctions prevent both a local-versus-total cost error and a comparison between incompatible experiment stages.

## Recovery and verification

The original recovery guidance is to remove temporary cost/priority overrides or record them as intentional design, then recheck affected VLANs. Reference checks are `show spanning-tree vlan 10`, interface-level STP detail, and the corresponding interface configuration.

The exact cost/priority changes and dedicated before/after output are not retained. The saved baseline and selected-port capture should not be presented as direct proof that a particular override caused the path change.

## Engineering takeaway

Explain the intended root and route first, then interpret the numerical fields in that context. A selected path is observable evidence; the cause of a change requires a change record and comparable before/after state.

[Case index](README.md) · [Path-engineering guide](../verification/path-engineering/README.md) · [Module overview](../README.md)
