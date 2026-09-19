# Case 08 — A network link stops exchanging control messages

## Why this matters

An infrastructure link can remain physically operational while one side stops contributing the control information needed for a safe spanning tree. The documented Bridge Assurance exercise examines the protective response to that condition.

## Documented exercise

The original notes identify SW3 Gi0/1 and SW4 Gi0/1 as a pair of point-to-point network ports. BPDU participation was deliberately broken on one side. The notes report a `*BA_Inc` inconsistency rather than normal forwarding.

## What the retained artifacts show

| Artifact | Supported observation |
|---|---|
| [SW3 Gi0/1 before the change](../verification/bridge-assurance/SW3-Gi0-1-detail-before-network-port.txt) | Per-VLAN roles, point-to-point link detail, and BPDU counters before the network-port relationship was enabled |
| [SW3 configuration](../configs/SW3-ACCESS-B.cfg) | Gi0/1 later retains spanning-tree portfast network |
| [SW4 configuration](../configs/SW4-DIST-B.cfg) | Its corresponding Gi0/1 retains the same network-port setting |
| [SW3 summary](../verification/convergence/SW3-show-spanning-tree-summary.txt) | Bridge Assurance is shown as enabled at the summary level |

The pre-change capture has **no `*BA_Inc` failure state**. The exact fault action, affected-instance output, and post-repair clearing were not retained.

## How to investigate

Compare both peers' configuration and interface detail. Determine whether they are intended network ports, whether the physical link is up, and what each side reports about BPDU exchange. Use inconsistent-port output and logs to identify the condition.

Reference checks include `show spanning-tree interface gigabitEthernet 0/1 detail`, `show spanning-tree inconsistentports`, and `show logging`. These are suggested replay checks.

## Recovery and verification

The documented method is to restore the intended network-port relationship and BPDU exchange, then verify that the inconsistency clears and expected per-VLAN roles return.

A full evidence set would include the failure state on the affected port, peer context, the corrective action, and subsequent forwarding/client checks. The retained files provide configuration and starting-state context only for those steps.

## Engineering takeaway

A global feature status and a later saved configuration answer different questions from an observed protection event. Use the right artifact for each claim.

[Case index](README.md) · [Bridge Assurance guide](../verification/bridge-assurance/README.md) · [Module overview](../README.md)
