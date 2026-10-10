# EEM topology and addressing

![EEM-R1 and R2-PEER connected by one routed link](topology.svg)

[PNG rendition](topology.png)

Two routers share one routed link on `10.66.12.0/30`. The [sanitized CML export](CML-LAB.yaml) supplies the node configuration and physical interface mapping; platform versions below are described in the completed-lab handoff.

| Device | Platform described in the handoff | Interface | Address | Lab role |
|---|---|---|---|---|
| EEM-R1 | CSR1000v, IOS XE 17.3.2 | GigabitEthernet1 | `10.66.12.1/30` | Runs the local EEM policies and diagnostic CLI actions |
| R2-PEER | IOSv, IOS 15.9 | GigabitEthernet0/0 | `10.66.12.2/30` | Connected peer for the lab testbed |

The export contains exactly one link: **EEM-R1 Gi1 ↔ R2-PEER Gi0/0**. EEM detectors and actions execute on EEM-R1. The diagram shows the physical topology and local policy roles.

## Retained policy state

`GI1-DOWN-ALERT` responds to a matching Gi1 line-protocol-down syslog, runs a local interface check, and records `$_cli_result` through syslog. `MANUAL-DIAG` uses `event none`; an administrator invokes it to print local interface output and record completion.

These are the two applets retained in the export. The watchdog, syslog-pattern fault, and CLI event exercises used temporary policies that were removed after testing.

## Evidence boundary

The handoff reports verified interface connectivity and ICMP reachability. It does not supply a ping transcript or reply count. The topology illustration derives from the saved configuration and link definitions; it is not an observed packet path or a new device capture.

[Module overview](README.md) · [Configuration guide](configs/README.md)
