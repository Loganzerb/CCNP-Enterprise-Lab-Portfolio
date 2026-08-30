# Spanning Tree Protocol: Design, Protection, and Troubleshooting

This section documents a multilayer campus switching lab built to validate classic STP, Rapid STP, PVST+, and Rapid PVST+ behavior. The work moves beyond basic root-bridge election into deterministic path engineering, Layer 2 protection, EtherChannel interaction, inconsistency states, and evidence-driven fault isolation.

## Portfolio summary

| Area | Demonstrated capability |
|---|---|
| Design | Selected primary and secondary roots per VLAN and predicted port roles from the complete STP tie-break process |
| Convergence | Compared 802.1D timers with RSTP proposal/agreement and edge-port behavior |
| Protection | Validated PortFast, BPDU Guard, Root Guard, Loop Guard, UDLD, BPDU Filter, and Bridge Assurance |
| Path engineering | Manipulated bridge priority, path cost, and port priority; compared short and long path-cost methods |
| Aggregation | Verified that STP treats a correctly formed EtherChannel as one logical port and diagnosed member inconsistencies |
| Troubleshooting | Isolated native-VLAN, PVID, port-type, channel, and BPDU-related failures from CLI evidence |

## Lab scope

```text
                 +----------------+
                 |     DSW1       |
                 | primary root   |
                 +---+--------+---+
                    /          \
             Po11  /            \  Po12
                  /              \
          +------+----+      +----+------+
          |   ASW1    |------|   ASW2    |
          +-----------+ Po20 +-----------+

VLANs 10,20: DSW1 primary / DSW2 secondary
VLANs 30,40: DSW2 primary / DSW1 secondary
Host-facing access ports: PortFast + BPDU Guard
Switch-facing links: point-to-point trunks
```

The examples use representative interface names and intentionally concise output. Platform syntax and available safeguards should be confirmed against the target IOS/IOS XE release before production use.

## Contents

1. [STP, RSTP, PVST+, and Rapid PVST+ lab](01-STP-RSTP-PVST-Lab.md)
2. [Layer 2 protection features](02-STP-Protection-Features.md)
3. [Path engineering and legacy convergence](03-STP-Path-Engineering.md)
4. [EtherChannel and Bridge Assurance](04-STP-EtherChannel-Bridge-Assurance.md)
5. [Troubleshooting cases](05-STP-Troubleshooting.md)

## Core verification workflow

```cisco
show spanning-tree summary
show spanning-tree root
show spanning-tree vlan 10
show spanning-tree interface gigabitEthernet1/0/1 detail
show interfaces trunk
show etherchannel summary
show errdisable recovery
show logging | include SPANTREE|UDLD|EC
```

The workflow begins with the control-plane mode and elected roots, narrows to the affected VLAN and interface, then correlates STP state with trunking, EtherChannel, and logs. This prevents a visible blocking state from being mistaken for the underlying fault.

## Skills demonstrated

- Translated Layer 2 design intent into deterministic Cisco STP configuration.
- Predicted root, designated, alternate, and backup roles using BPDU comparison rules.
- Distinguished normal loop prevention from protective inconsistency and err-disabled states.
- Used scoped verification commands to validate cause, correction, and reconvergence.
- Documented operational tradeoffs, including safeguards that should not be combined casually.

