# BIDIR troubleshooting and controlled change

| Case | Finding | Validation |
|---|---|---|
| [01 — Links up, RPA unreachable](01-swapped-addresses.md) | R1's addresses did not match its cabling | Corrected addresses, FULL OSPF, metric 12 and 5/5 RPA replies |
| [02 — Tree points toward the wrong receiver](02-wrong-receiver.md) | IGMP join was on SRC-HOST | Reporter 10.30.30.100 and Gi0/3 appear at R3 |
| [03 — Change the Designated Forwarder](03-df-transition.md) | Higher R1 cost makes R2 the better path to the RPA | Both tables select R2; post-change test returns 29/30 replies |

The first two cases are repairs. The third is an intentional metric experiment demonstrating role selection and subsequent delivery.

[Evidence index](../verification/README.md) · [Overview](../README.md)
