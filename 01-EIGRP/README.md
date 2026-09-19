# 01 — EIGRP: Backup paths and route policy

A second path is useful only if the routing protocol can use it when the preferred path fails. In this five-router lab, I compared a qualified EIGRP backup with an alternate that failed the protocol's loop-free eligibility check, then verified the replacement route after each controlled failure.

A third case examines inconsistent summarization: removing one setting on a branch uplink introduced more-specific routes and changed the path the routing table would select.

**Five routers · EIGRP AS 100 · Three troubleshooting cases**

**Start here:** [A qualified backup takes over](troubleshooting/scenario-1-feasible-successor-promotion.md). The case connects the eligibility calculation to the installed replacement route and the restored baseline.

## Lab design

![EIGRP topology showing core, two distribution routers, branch, and remote stub](topology.png)

R1 reaches the branch through two distribution routers, which also connect to each other. R4 summarizes four branch networks and filters advertisements toward R5. R5 uses named EIGRP, advertises its remote summary, and operates as a stub.

[Topology, addressing, and device roles](topology.md)

## Troubleshooting results

| Case | Question investigated | Captured result |
|---|---|---|
| [01 — Feasible successor promotion](troubleshooting/scenario-1-feasible-successor-promotion.md) | Does the alternate satisfy EIGRP's backup-path condition? | The qualified R3 path replaced R2 in R1's routing table; restoring the test settings returned two equal-cost successors |
| [02 — No feasible successor](troubleshooting/scenario-2-no-feasible-successor-dual-recalculation.md) | What changes when the alternate fails that condition? | R3 was installed after the R2 path failed; the transient Active/Query/Reply sequence was not captured |
| [03 — Inconsistent summaries](troubleshooting/scenario-3-inconsistent-eigrp-summarization.md) | Can two uplinks advertise the same networks differently? | Summary and component routes coexisted; restoring the missing summary returned the distribution tables to the documented summary-only view |

## What this work demonstrates

- **Backup-path analysis:** compare advertised and local metrics before relying on an alternate.
- **Failure verification:** check the replacement route and restore the original topology.
- **Route-policy diagnosis:** follow exact prefixes and next hops across redundant uplinks.
- **Operational context:** interpret classic and named EIGRP, summaries, a remote stub, and default-only filtering.

## Explore the files

| Guide | Contents |
|---|---|
| [Configuration guide](configs/README.md) | Five device extracts, active policy, authentication, and wider-lab connections |
| [Verification guide](verification/README.md) | Twenty original text captures with a README for each evidence group |
| [Troubleshooting index](troubleshooting/README.md) | Three cases, a direct comparison of the two failover experiments, and original excerpts |

## Evidence scope

These are controlled Cisco Modeling Labs exercises. The sanitized configurations have redacted authentication values and no accompanying EIGRP CML export.

The cases establish metric eligibility, route changes, and restoration. They do not retain endpoint ping/traceroute results or measured failover times. Case 02 is a route-recalculation exercise, not a captured Stuck-in-Active incident. Authentication and timer settings are present, but dedicated mismatch cases are not included.

[Back to portfolio](../README.md)
