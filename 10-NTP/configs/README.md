# NTP configurations and reproduction guide

Start with the supplied [CML export](../CCNP_MASTERCLASS_LAB_September_18th.yaml). It contains the five devices, four physical links and the two-source NTP configuration from the end of the September 18 session.

## Configuration files

These files are extracted from that export, with YAML indentation removed. They represent the exported device configurations, not the final state of the later loopback and ACL exercises.

| Device configuration | Important settings |
|---|---|
| [R1-NTP-SOURCE-A.cfg](R1-NTP-SOURCE-A.cfg) | ntp master 1; route to 10.20.0.0/24 through R2 |
| [R2-NTP-CORE.cfg](R2-NTP-CORE.cfg) | Servers 10.12.0.1 and 10.20.0.4 |
| [R3-NTP-CLIENT.cfg](R3-NTP-CLIENT.cfg) | Server 10.20.0.1; default route through R2 |
| [R4-NTP-SOURCE-B.cfg](R4-NTP-SOURCE-B.cfg) | ntp master 3; default route through R2 |
| [SW1-NTP-ACCESS.cfg](SW1-NTP-ACCESS.cfg) | VLAN 1 access links; unused Gi0/3 shut down |

## Choose the experiment stage

| Stage | Configuration state | Where to check the result |
|---|---|---|
| Exported baseline | Two local sources; R3 uses its connected interface address | [Hierarchy evidence](../verification/01-hierarchy.md) |
| Source failover | Temporarily shut R1 Gi0/0; restore it afterward | [Failover evidence](../verification/02-failover.md) |
| Loopback routing fault | Add R3 Loopback0 and source NTP from it before adding R2's return route | [Routing evidence](../verification/03-loopback-route.md) |
| ACL fault | Keep the loopback and return route; apply the source-specific deny | [ACL evidence](../verification/04-acl-udp123.md) |
| Cleaned-up later state | Keep loopback sourcing and /32 return route; remove the temporary ACL | [Cleanup blocks](../verification/04-acl-udp123.md#block-09) |

## Reproduce the baseline

1. Import the YAML into CML. Map the IOSv and IOSvL2 images available in your installation and verify the [wiring](../topology.md).
2. Start the five devices and inspect their interface addresses. Confirm R1 can reach 10.20.0.3 and 10.20.0.4, and R3 can reach 10.20.0.1.
3. Inspect `show ntp associations`, `show ntp associations detail` and `show ntp status` on the routers. Establish which source is currently selected before inducing a failure.
4. Compare local stratum and reference across the hierarchy. Wait for an explicit synchronized status when the test is intended to establish clock synchronization.

Both sources use their own local clocks. Their offsets and selection can differ on a fresh run. Do not expect the original counters, exact waiting times or automatic preference for R1 in every run.

## Later changes and controlled faults

[Exercise commands](exercise-commands.md) provide the complete readable commands for failover, loopback sourcing, the ACL fault and cleanup. These are reconstructed instructions aligned with the recorded outputs, not additional device captures.

The reduced poll interval used later on R3 is a lab setting. It did not establish a measured improvement in convergence time.

After each experiment, check the current source, routing and applied policy before moving on. Save a new CML export if you want the later loopback state to become your import baseline.

[Back to NTP](../README.md)
