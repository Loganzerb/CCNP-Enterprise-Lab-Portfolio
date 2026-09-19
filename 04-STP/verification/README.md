# STP verification guide

A verification file records what a switch reported at one point in the lab. This guide identifies the question each file answers and the part of the output worth inspecting.

**Nine original captures are retained.** Their coverage is strongest for root/port roles and the temporary LACP experiment. Detailed explanations sit in the topic guides.

## All captured files

| File | Question it answers | What to look for |
|---|---|---|
| [SW3 VLAN 10 roles](root-election/SW3-show-spanning-tree-vlan-10.txt) | Which path does SW3 select, and which is held in reserve? | Gi0/0 Root/FWD, Gi0/2 Alternate/Blocked; root priority 24586 and long path cost 20000 |
| [SW3 STP summary](convergence/SW3-show-spanning-tree-summary.txt) | Which mode and feature defaults are reported? | rapid-pvst, long costs, enabled Bridge Assurance and misconfiguration guard; per-VLAN state counts |
| [SW3 Gi0/1 before network-port change](bridge-assurance/SW3-Gi0-1-detail-before-network-port.txt) | Does one link have different roles for different VLANs? | Designated/Forwarding for VLANs 10/20, Root/Forwarding for 30/40, and per-VLAN BPDU counters |
| [SW5 before bundling](etherchannel/SW5-before-etherchannel.txt) | How are two separate parallel trunks handled? | Gi0/0 forwards, Gi0/1 is Alternate/Blocked; Gi0/1's forwarding-VLAN list is empty |
| [SW5 healthy LACP summary](etherchannel/SW5-healthy-lacp-summary.txt) | Did both physical links join the bundle? | Po1(SU), Gi0/0(P), Gi0/1(P) |
| [SW5 STP after bundling](etherchannel/SW5-STP-after-bundle.txt) | What does spanning tree see after bundling? | A logical Po1 Root/FWD interface with local cost 3 and total root cost 11 |
| [SW5 single-member failure](etherchannel/SW5-single-member-failure.txt) | Can the logical link remain up with one member down? | Gi0/1(D), Po1(SU), Po1 still Root/FWD; local cost 4, total root cost 12 |
| [SW5 negotiation failure](etherchannel/SW5-passive-passive-failure.txt) | What happens when the bundle stops forming? | Suspension messages, both members (s), and Po1(SD) |
| [SW5 long-cost setting](path-engineering/SW5-pathcost-method-long.txt) | Was long cost configured at this later check? | “Configured Pathcost method used is long”; no port-selection or timing result is included |

## Choose a plain-English explanation

| Guide | Reading goal |
|---|---|
| [Root selection](root-election/README.md) | Understand Root, Designated, and Alternate roles |
| [Recovery behavior and timers](convergence/README.md) | Separate configured timers from measured recovery time |
| [Link bundles and failures](etherchannel/README.md) | Follow the strongest before/after/failure sequence |
| [Path engineering](path-engineering/README.md) | Interpret priority and cost without mixing different lab stages |
| [Protection features](protection/README.md) | Understand the difference between configured protection and a recorded activation |
| [Bridge Assurance context](bridge-assurance/README.md) | Read the pre-change capture and later saved configuration correctly |

## How to interpret common fields

- **Root FWD:** this switch is forwarding toward the selected root on that port.
- **Desg FWD:** the port is designated to forward on its segment for that VLAN.
- **Altn BLK:** a redundant path is held out of normal forwarding; this can be a healthy result.
- **Po1(SU):** the port-channel is Layer 2 and in use.
- **Member (P), (D), (s):** bundled, down, and suspended respectively. The cause matters as much as the missing member.

Compare the reported state with the intended design. A forwarding state establishes the switch's view; endpoint probes would be needed to demonstrate measured client delivery. This module's retained capture set does not include those probes.

The files are unchanged. They contain different experiment stages rather than one simultaneous snapshot. The [case index](../troubleshooting/README.md) identifies where only a documented observation or recovery method is available.

[Module overview](../README.md) · [Configuration guide](../configs/README.md)
