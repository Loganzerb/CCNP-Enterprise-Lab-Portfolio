# Verification — review the classic and VTI stages

Each numbered block links to the complete text supplied for that capture. Selected excerpts keep the original lines; partial outputs remain partial. Blocks 01–29 follow the classic source compilation. Blocks 30–31 are selected saved VTI configuration; VTI runtime checks are recorded handoff results.

| Guide | Blocks | Question answered |
|---|---|---|
| [GRE and OSPF milestones](01-gre-ospf.md) | Recorded build observations | Did both tunnel endpoints work, and did the private routes use the overlay? |
| [IPsec state and SPI correlation](02-ipsec.md) | 01, 04 | Is the GRE traffic identity protected by active transport-mode ESP? |
| [Final validation](03-final-validation.md) | 02–03; compares 01 and 04 | Do private traffic, OSPF, and crypto counters agree? |
| [PSK failure and repair](04-psk.md) | 05–11 | Can fresh IKE authentication complete? |
| [Transform failure and repair](05-transform.md) | 12–19 | Can ESP negotiate while IKE remains established? |
| [Selector failure and repair](06-selector.md) | 20–29 | Do the protected identities match the actual GRE endpoints? |
| [IKEv2 VTI](07-vti.md) | 30–31; recorded validation | Does native IPsec carry direct OSPF and private traffic? |
| [Verification commands](commands.md) | Both stages | Which check establishes each part of the forwarding path? |

The source compilation contains the IPsec-stage CLI. Initial GRE ping results and OSPF route entries are handoff observations, explicitly identified in their guide. Classic configuration extracts are reconstructions. The VTI extracts come from the saved CML node configurations.

[Evidence boundaries](../scope.md) · [Troubleshooting](../troubleshooting/README.md) · [Configurations](../configs/README.md) · [GRE/IPsec overview](../README.md)
