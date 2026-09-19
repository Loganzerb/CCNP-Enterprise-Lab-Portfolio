# 02 — OSPF: Neighbor recovery and routing across areas

A successful ping does not guarantee that routers can exchange routing information. A healthy routing relationship does not guarantee that every expected route is being advertised.

In this five-router lab, I investigated both problems: an IP MTU mismatch that stalled database synchronization and an area-border policy that removed a branch route. A third case documents how an inconsistent NSSA area setting disrupted external-route exchange.

**Five routers · Two OSPF areas · Three troubleshooting cases**

**Start here:** [Repair an OSPF adjacency while ping still works](troubleshooting/scenario-1-ospf-mtu-exstart-exchange.md). O2 received replies to all five probes sent to O4, but OSPF remained in `EXSTART`. Comparing interface and IP MTU values exposed the mismatch; removing it restored `FULL` adjacency on both devices.

## Lab design

![Five-router OSPF topology with O2 connecting Area 0 to Area 10](topology.png)

O2 connects the backbone to the branch and edge area. The branch supplies four networks that O2 summarizes into one advertisement. O4 introduces two external test prefixes, while O5 provides another internal path.

[Topology, addressing, and device roles](topology.md)

## Troubleshooting results

| Case | Problem | Result and retained evidence |
|---|---|---|
| [01 — IP MTU mismatch](troubleshooting/scenario-1-ospf-mtu-exstart-exchange.md) | Ping succeeded, but O2 and O4 could not complete their routing adjacency | Captured IP MTU returned to 1500 and both neighbors returned to `FULL` |
| [02 — NSSA capability mismatch](troubleshooting/scenario-2-nssa-capability-and-lsa-translation.md) | O4's area type no longer matched its neighbors | The lab record reports recovery after restoring NSSA; retained recovery excerpts show Type 7 advertisements on O4 and external routes on O2 |
| [03 — Area-border filtering](troubleshooting/scenario-3-abr-route-filtering-control-plane.md) | The branch summary disappeared from the backbone while all three O2 neighbors remained `FULL` | Removing the filter attachment restored the summary advertisement and O1's inter-area route |

The case studies explain the diagnosis and link directly to the original excerpts. Where an observation was described without its command output being retained, it is labeled accordingly.

## What this work demonstrates

- **Fault isolation:** distinguish basic connectivity, neighbor synchronization, and selective route-policy failures.
- **Area design:** summarize branch routes and trace external information across the NSSA boundary.
- **Verification:** compare interfaces, neighbors, routing databases, and installed routes.
- **Targeted repair:** correct the relevant setting and verify the affected behavior.

## Explore the files

| Guide | What you will find |
|---|---|
| [Configuration guide](configs/README.md) | Five device extracts, active policies, and reconstruction notes |
| [Verification guide](verification/README.md) | Twenty-five original captures, with a README for each evidence group |
| [Troubleshooting index](troubleshooting/README.md) | Three cases and their preserved command blocks |

## Evidence scope

These are controlled Cisco Modeling Labs experiments using OSPFv2 process 1. The saved configurations are sanitized extracts; no OSPF CML export is included. Some interfaces belong to the larger masterclass topology and have no captured neighbor in this module.

The MTU case includes a successful directly connected ping during the fault. Route and database recovery in the other cases does not establish application delivery or measured convergence time. The external test prefixes are backed by Null0 discard routes.

[Back to portfolio](../README.md)
