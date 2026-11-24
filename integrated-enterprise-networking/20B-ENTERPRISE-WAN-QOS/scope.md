# Lab 20B scope and evidence provenance

## Source records

| Source | What it establishes |
|---|---|
| Saved configuration — inspected CML export | Final topology, node images, addresses, static routes, MQC objects, and service-policy attachments. The complete CML checkpoint and IOS configurations remain private pending redistribution clearance. |
| Captured CLI and iPerf excerpts — original CML sessions | Selected excerpts for initial marking, temporary policing, the operational HQoS parent, and the deliberate marking fault and correction. |
| Reported observations — original lab record and associated counter summaries | The five-stage comparison, selected child-policy and interface counters, and the additional fault and recovery observations. |
| Portfolio diagrams, excerpts, and walkthroughs | A source-based explanation of the saved design and a path for independent reproduction. |

The excerpts preserve the original command and output wording. Full transcripts and original configuration artifacts remain private. The final checkpoint retains AF21 and HQoS. The temporary policer and AF31 fault belong to earlier test phases.

## Platform and measurement limits

Cisco documents forwarding limits for IOSv and lists QoS among features without official support. The lab evidence supports the marking, policer-counter correlation, and correction of queue classification in this virtual topology. Its throughput, jitter, and loss values describe the historical test runs. [Cisco CML IOSv documentation](https://developer.cisco.com/docs/modeling-labs/iosv/)

Baseline and marking-only tests ran individual flows. LLQ, LLQ + CBWFQ, and HQoS ran concurrent flows. The different workloads prevent attribution of the measured changes to QoS alone. The final HQoS voice-count difference matches the captured UDP loss, with the precise drop mechanism, shaping accuracy, and scheduling guarantees still inconclusive. [HQoS evidence](verification/traffic-performance.md#final-hqos-counters)

The floating routes define an alternate path in the saved topology. The supplied results cover traffic through R2. A fresh CML import, boot, route test, and QoS replay remain pending. [Static routing](configs/README.md#static-routing) · [Verification guide](verification/README.md)

[Overview](README.md) · [Topology](topology.md) · [Policy architecture](operation.md) · [Troubleshooting](troubleshooting/README.md)
