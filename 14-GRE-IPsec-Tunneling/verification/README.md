# Verification — prove the overlay and its protection

Each numbered block links to the complete text supplied for that capture. Selected excerpts keep the original lines; partial outputs remain partial. The numbering follows the source compilation, which presents final validation before the three fault cases.

| Guide | Blocks | Question answered |
|---|---|---|
| [GRE and OSPF milestones](01-gre-ospf.md) | Recorded build observations | Did both tunnel endpoints work, and did the private routes use the overlay? |
| [IPsec state and SPI correlation](02-ipsec.md) | 01, 04 | Is the GRE traffic identity protected by active transport-mode ESP? |
| [Final validation](03-final-validation.md) | 02–03; compares 01 and 04 | Do private traffic, OSPF, and crypto counters agree? |
| [PSK failure and repair](04-psk.md) | 05–11 | Can fresh IKE authentication complete? |
| [Transform failure and repair](05-transform.md) | 12–19 | Can ESP negotiate while IKE remains established? |
| [Selector failure and repair](06-selector.md) | 20–29 | Do the protected identities match the actual GRE endpoints? |

The source compilation contains the IPsec-stage CLI. Initial GRE ping results and OSPF route entries are handoff observations, explicitly identified in their guide. Configuration extracts are reconstructions, not additional output evidence.

[Evidence boundaries](../scope.md) · [Troubleshooting](../troubleshooting/README.md) · [Configurations](../configs/README.md) · [GRE/IPsec overview](../README.md)
