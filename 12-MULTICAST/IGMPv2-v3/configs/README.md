# IGMP configuration — selected lab changes

These command extracts describe the changes used in the lab. They are reconstructed from the lab instructions and checked against the retained output, not complete running-config exports. The existing routed PIM topology supplies reachability; see [topology](../topology.md).

## IGMPv2 membership experiment

R4 Gi0/0 initially reports IGMPv2. MCAST-RECEIVER simulates a host using its Gi0/0 membership:

```text
interface GigabitEthernet0/0
 ip igmp join-group 239.1.1.1
```

Removing and later re-adding that membership brackets the expiry/rejoin experiment:

```text
interface GigabitEthernet0/0
 no ip igmp join-group 239.1.1.1
!
interface GigabitEthernet0/0
 ip igmp join-group 239.1.1.1
```

These are separate experiment states. The captured R4 debug establishes timer expiry and report-driven recovery, rather than a captured host Leave exchange.

## IGMPv3 and SSM

R4-LHR, receiver-facing interface:

```text
interface GigabitEthernet0/0
 ip igmp version 3
```

The lab instructions enable the default SSM range on R1–R4. The retained running-config check explicitly confirms it on R4:

```text
ip pim ssm default
```

MCAST-RECEIVER, source-specific subscription alongside the ASM membership:

```text
interface GigabitEthernet0/0
 ip igmp version 3
 ip igmp join-group 232.1.1.1 source 10.1.1.10
```

## Checks used in the investigation

| Command | Purpose |
|---|---|
| `show ip igmp interface GigabitEthernet0/0` | Version, querier and timers |
| `show ip igmp groups` | Group, receiver-facing interface and reporter |
| `debug ip igmp` | Report/query sequence and membership expiry |
| `undebug all` | Stop the diagnostic output |
| `show running-config \| include ip pim ssm` | Confirm the configured SSM range setting |
| `show ip igmp groups detail` | Filter mode and SSM membership |
| `show ip mroute 232.1.1.1` | Source/group, flags and forwarding interfaces |

[Evidence index](../verification/README.md) · [IGMP overview](../README.md) · [Multicast](../../README.md)
