# Verification — follow intent through to forwarding

Read the interpretation above each block, then inspect the exact commands and output. Each block also links to its full captured text.

| Evidence guide | Blocks | Question answered |
|---|---|---|
| [Isolation](01-isolation.md) | 01–07 | Are routing, ARP and forwarding separated? |
| [Identical remote prefixes](02-identical-prefixes.md) | 08–11 | Does the same next hop resolve through the correct VRF? |
| [Controlled faults and repairs](03-faults.md) | 12–17 | Is the failure configuration, recursion or adjacency? |
| [Shared-service forward path](04-forward-leak.md) | 18–23 | Are selective routes present and resolving globally? |
| [Return paths and final tests](05-return-path.md) | 24–29 | Can the full request/reply exchange complete? |

The first neighbor test includes a RED timeout; later repairs and final service tests retain their separate outcomes. Raw transcripts are source evidence, not commands to paste into a device.

[Troubleshooting](../troubleshooting/README.md) · [Configurations](../configs/README.md) · [VRF overview](../README.md)
