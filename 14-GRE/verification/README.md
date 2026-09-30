# Verification — transport first, then overlay and service

Each guide explains what its output establishes and links to complete text transcripts. Selected priority blocks carry the requested **📁 GitHub Evidence** marker.

| Guide | Blocks | Question answered |
|---|---|---|
| [Healthy baseline](01-baseline.md) | 01–05 | Can the transport endpoints, overlay peers and private loopbacks communicate? |
| [Underlay loss and restoration](02-underlay-failure.md) | 06–09 | What fails first when the transport route disappears? |
| [Recursive routing and recovery](03-recursion.md) | 10–11 | Can the tunnel destination be reached independently of the tunnel? |
| [MTU boundary](04-mtu.md) | 12 | How do one additional byte and the DF bit affect delivery? |

The transcripts are captured evidence, not commands to paste into devices. Current-state output and buffered syslogs are distinguished in the recursive-routing case.

[Troubleshooting](../troubleshooting/README.md) · [Configurations](../configs/README.md) · [GRE overview](../README.md)
