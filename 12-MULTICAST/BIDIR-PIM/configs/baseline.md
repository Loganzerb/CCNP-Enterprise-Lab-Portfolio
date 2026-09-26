# Corrected BIDIR baseline — selected settings

## Underlay and interface roles

OSPF process 1, area 0 advertises the router loopbacks and connected lab subnets. The endpoint LAN interfaces are passive in OSPF; PIM still operates on them. Source and receiver hosts use `no ip routing` and their local default gateways.

| Device | Interface | Address | Routing detail |
|---|---|---|---|
| SRC-HOST | Gi0/0 | 10.10.10.100/24 | Gateway 10.10.10.1 |
| R1-DF-A | Gi0/1 | 10.10.10.1/24 | Passive in OSPF; shared source LAN |
| R1-DF-A | Gi0/0 | 10.13.0.1/30 | OSPF cost 10 before the experiment |
| R2-DF-B | Gi0/0 | 10.10.10.2/24 | Passive in OSPF; shared source LAN |
| R2-DF-B | Gi0/1 | 10.23.0.1/30 | OSPF cost 30 |
| R3-BRANCH | Gi0/0 | 10.13.0.2/30 | To R1 |
| R3-BRANCH | Gi0/1 | 10.23.0.2/30 | To R2 |
| R3-BRANCH | Gi0/2 | 10.34.0.1/30 | To R4 |
| R3-BRANCH | Gi0/3 | 10.30.30.1/24 | Passive in OSPF; receiver LAN |
| R4-RPA | Gi0/0 | 10.34.0.2/30 | To R3 |
| RCV-HOST | Gi0/0 | 10.30.30.100/24 | Gateway 10.30.30.1 |

R1–R4 use Loopback0 addresses `1.1.1.1/32`, `2.2.2.2/32`, `3.3.3.3/32` and `4.4.4.4/32` respectively. R4's address is the RPA.

## Multicast settings on R1–R4

```text
ip multicast-routing
ip pim bidir-enable
access-list 45 permit 239.100.100.0 0.0.0.255
ip pim rp-address 4.4.4.4 45 bidir
```

The ACL selects the multicast group range for the mapping; it is not applied here as an interface packet filter. The initial experiment used `permit host 239.100.100.100`, then widened that selector to the /24 while retaining the same RP command.

The connected routed lab interfaces listed above on R1–R4 use:

```text
ip pim sparse-mode
```

The group-to-RPA mapping marks the selected range as BIDIR despite that interface command's sparse-mode wording. The `B` neighbor flag confirms capability; `Static, Bidir Mode` confirms the mapping.

## Receiver membership

Only RCV-HOST is intended to join the test group:

```text
interface GigabitEthernet0/0
 ip igmp join-group 239.100.100.100
```

The source does not need receiver membership to send multicast. Its accidental join is covered in the [receiver-placement case](../troubleshooting/02-wrong-receiver.md).

[Experiment changes](experiments.md) · [Configuration index](README.md) · [Overview](../README.md)
