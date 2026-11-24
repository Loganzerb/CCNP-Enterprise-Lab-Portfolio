# Lab 20B — Enterprise WAN QoS

I built a five-router Cisco Modeling Labs network to study how a WAN edge classifies flows, marks packets, and schedules traffic on a shaped link. Two Alpine Desktop endpoints generated UDP and TCP traffic. R2-EDGE-A enforced the policy on the primary client-to-server path. A controlled DSCP fault showed how application traffic can reach the server while missing its intended queue.

The November 23, 2026 lab covers CCNP ENCOR v1.2 objective 1.4, interpreting QoS configurations. [Cisco exam topics](https://learningcontent.cisco.com/documents/marketing/exam-topics/350-401-ENCORE-v1.2.pdf)

**Quick navigation** · [Results](#lab-results) · [Topology and addressing](topology.md) · [Policy architecture](operation.md) · [Implementation](configs/README.md) · [Verification](verification/README.md) · [Troubleshooting](troubleshooting/README.md) · [Evidence scope](scope.md)

## Lab results

| Engineering question | Historical evidence and result |
|---|---|
| Did the ingress policy identify the test flows? | Captured ACL and policy counters show 895 EF markings and 2,041 AF21 markings for the two test flows. [Classification capture](verification/marking.md) |
| Was the temporary policer enforcing its rate? | At about 1.05 Mbps offered load, the receiver got 500 kbps. The captured **932 policer drops matched 932 missing iPerf datagrams**. The lab record reports no increase in interface output drops during this experiment. [Policing comparison](verification/policing.md) |
| What did the final hierarchical policy show? | The captured parent policy lists a 2-Mbps target. The accompanying record reports an increase in interface output drops from 155 to 575 and no drops in individual queues. The precise drop mechanism remains unresolved. [HQoS counters and traffic report](verification/traffic-performance.md#final-hqos-counters) |
| Could business traffic pass through the wrong queue? | Captures show that ingress set AF31 while the egress business class matched AF21. After restoring AF21, both class counters increased by **2,391 packets**. TCP throughput was reported at 1.25 Mbps during the fault and 1.21 Mbps after correction. [Fault and recovery](troubleshooting/README.md) |

The linked pages distinguish selected terminal excerpts from the associated lab record and the inspected saved configuration. [Evidence scope](scope.md)

## Lab design

`PC-CLIENT → R1-CORE → R2-EDGE-A → R4-ISP-A → PC-SERVER` is the preferred forward path. A floating static route points R1 toward R3-EDGE-B and R5-ISP-B, which reach the server via R4. R2's policy covers the primary forward path. [Labeled topology and interface tables](topology.md)

| Policy stage | Final saved setting on R2-EDGE-A |
|---|---|
| `Gi0/0` input `MARK-IN` | For PC-CLIENT to PC-SERVER, the UDP/5001 selector sets EF (46) and the TCP/5002 selector sets AF21 (18). The default class sets CS0. |
| `Gi0/1` output `WAN-SHAPE` | The parent configures a 2,000,000-bps aggregate shaping target and invokes `WAN-OUT`. |
| Child `WAN-OUT` | EF uses `priority 1200`, AF21 uses `bandwidth 300`, and other traffic falls into `class-default`. The `priority` and `bandwidth` values are in kbps. |

The completed configuration retains the hierarchical policy and AF21 marking. The temporary ingress policer and AF31 fault belong to earlier test phases. [Policy walkthrough](operation.md) · [Static routes and implementation excerpts](configs/README.md)

## Study and reproduction

The [traffic comparison](verification/traffic-performance.md) separates individual runs from concurrent runs. The [study notes](lessons-learned.md) explain rate controls, counter baselines, and IOSv's limitations. Cisco documents IOSv forwarding constraints and lists QoS among features without official support. [Cisco CML IOSv documentation](https://developer.cisco.com/docs/modeling-labs/iosv/)

The complete CML checkpoint and IOS configurations remain private pending redistribution clearance. The [configuration guide](configs/README.md) provides selected implementation excerpts and the Alpine endpoint startup scripts for independent reproduction. Fresh CML import, boot, and runtime replay remain pending.

[Integrated enterprise projects](../README.md) · [Back to portfolio](../../README.md)
