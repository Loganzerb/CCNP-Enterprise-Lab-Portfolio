# Lab 20B verification guide

The historical lab compared individual and concurrent flows, applied a temporary ingress policer, and tested a DSCP mismatch that pushed functional TCP traffic out of the intended queue. The verification pages distinguish the supplied captures from reported observations and saved configuration.

## Task-to-evidence matrix

| Task | Evidence type | Result or check |
|---|---|---|
| Confirm the final policy attachments and classifier definitions | Saved configuration and selected policy CLI | R2 applies `MARK-IN` on `Gi0/0` ingress and `WAN-SHAPE` on `Gi0/1` egress. The captured final policy lists the saved class actions. [Implementation excerpts](../configs/README.md#saved-r2-policy) · [Captured policy](../troubleshooting/README.md#captured-correction-and-recovery) |
| Verify marking for both test flows | Captured CLI and reported default-class count | The ACL and policy outputs show 895 EF and 2,041 AF21 markings. The original lab record reports 15 cumulative CS0 markings. [Marking evidence](marking.md) |
| Compare traffic behavior across five phases | Reported performance comparison and selected HQoS iPerf output | [Throughput, loss, and jitter](traffic-performance.md) by workload, with the final concurrent run’s captured reports below the comparison table. |
| Test below and above the temporary CIR | Captured policy counters and iPerf summaries | Below CIR, the receiver got 263 kbps without loss. Above CIR, captured router drops and missing UDP datagrams both totaled 932. [Policing evidence](policing.md) |
| Check the final hierarchy | Captured parent policy and associated counter summary | A 2-Mbps parent invokes `WAN-OUT`. Interface drops increased in the associated record. The exact output-drop mechanism remains unresolved. [HQoS evidence](traffic-performance.md#final-hqos-counters) |
| Verify queue selection after the AF21 correction | Captured classification values and supplied before/fault/recovery comparison | Ingress `BUSINESS` and egress `BUSINESS-AF21` both increased by 2,391 packets after marking was restored. [Fault and recovery](../troubleshooting/README.md#fault-and-recovery-counter-comparison) |

## Checks for a fresh run

Use these commands after building the documented topology or importing an authorized private checkpoint. Confirm the active path and each intended interface's administrative state before generating traffic. A fresh import, boot, and traffic run remain pending.

| Where | Command or check | What to record |
|---|---|---|
| IOSv routers | `show ip interface brief` | Expected router ports are administratively up. Activate the required ports if a reconstructed or imported configuration left them disabled. |
| PC-CLIENT and PC-SERVER | `ip -4 addr show dev eth0`, `ip route`, `iperf --version` | IPv4 endpoint setup and installed tool version |
| R1-CORE and R2-EDGE-A | `show ip route 10.20.40.10`, `show ip cef 10.20.40.10` | Route and forwarding next hop toward the server |
| R4-ISP-A | `show ip route 10.20.10.10` | Return route toward the client |
| R2-EDGE-A | `show access-lists` | Exact selector and relevant match counts |
| R2-EDGE-A | `show policy-map interface GigabitEthernet0/0` | Input policy, per-class matches, and mark or policer counters when present |
| R2-EDGE-A | `show policy-map interface GigabitEthernet0/1` | Parent target, child class matches, queue output, and policy-reported drops |
| R2-EDGE-A | `show interfaces GigabitEthernet0/1` | Interface output drops at both snapshots |
| PC-SERVER | UDP receiver on port 5001, TCP receiver on port 5002 | Receiver throughput and UDP lost datagrams and jitter |

Take snapshots before and after each isolated run and subtract the baseline from the cumulative counters. Separate single-flow tests from concurrent tests, holding the offered rate, run duration, and packet sizing constant when comparing policies. For a marking test, capture packet headers separately if direct field-level evidence is needed. For the AF21 fault and recovery, use the same TCP-only workload and compare the inbound class with the outbound business and default classes.

## Evidence labels

The **captured CLI and iPerf excerpts** are selected historical outputs. **Reported observations** cover contextual details and associated summaries. **Saved configuration** comes from the privately retained CML checkpoint and is represented by the implementation guide. A fresh replay and packet capture would add new observations. [Evidence scope](../scope.md)

[Overview](../README.md) · [Policy architecture](../operation.md) · [Configuration guide](../configs/README.md)
