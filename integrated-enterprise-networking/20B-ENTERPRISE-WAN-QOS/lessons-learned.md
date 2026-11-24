# Lab 20B engineering lessons and ENCOR study notes

## Follow the flow through both policy directions

The ingress ACL answers which flow arrived. The marking action writes the DSCP. The egress classifier reads it and selects a scheduling class. Troubleshooting an end-to-end policy means checking all three steps. In this lab an AF31 fault left TCP traffic functional while bypassing the AF21 queue. Matching counter increases after the fix established what the throughput test alone could not show. [DSCP mismatch case](troubleshooting/README.md)

## Read each rate in its own scope

- `priority 1200` requests strict priority for EF traffic with a configured priority allocation under congestion. The scheduler can protect other queues by limiting priority traffic during congestion on supported implementations.
- `bandwidth 300` reserves a minimum share for AF21 traffic during congestion. It can use additional capacity when available.
- The 2-Mbps parent shaper regulates the aggregate by buffering and scheduling traffic for later transmission when possible. Child queuing allocates service within that parent.
- The temporary ingress policer chose transmit or drop immediately based on the traffic profile and configured actions. The captured 932 drops match the receiver’s recorded loss count. [Policing evidence](verification/policing.md)

These are device-policy rates. Application throughput depends on the traffic source, protocol overhead, contention, the forwarding path, and the receiver. [QoS policy architecture](operation.md) · [Cisco IOS priority versus bandwidth](https://www.cisco.com/c/en/us/support/docs/quality-of-service-qos/qos-packet-marking/10100-priorityvsbw.html)

## Use deltas and comparable workloads

Record the test interval and subtract each before snapshot from its after snapshot. An unchanged cumulative class counter shows no observed additions during that interval. Congestion-sensitive results need comparable offered loads and run conditions. In the HQoS run, the rise in interface drops and the gap between voice classifications and queue output do not identify the drop point by themselves. [Reported comparisons](verification/traffic-performance.md)

## Keep platform conclusions within the lab

IOSv is useful here for reading ACL matches, policy hierarchy, and counter relationships. Its forwarding limits constrain performance analysis, and Cisco lists QoS among features without official support. Production rate and latency targets require a supported platform and repeated, controlled measurements. [Cisco CML IOSv documentation](https://developer.cisco.com/docs/modeling-labs/iosv/)

[Overview](README.md) · [Verification](verification/README.md) · [Evidence scope](scope.md)
