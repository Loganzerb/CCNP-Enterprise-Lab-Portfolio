# 18 — IP SLA: Detect an upstream outage and change the forwarding path

I configured a branch router to test reachability beyond its directly connected provider and use that result to select a default route. When ISP-A's upstream link was shut down, the branch's own primary interface remained **up/up**. IP SLA detected the loss of reachability, tracking withdrew the primary default, and an application test succeeded **5/5** through ISP-B. Restoring the upstream link returned the default route and the observed forwarding path to ISP-A.

This Cisco Modeling Labs exercise aligns with **CCNP ENCOR 350-401 v1.2, objective 4.4 — Configure and verify IP SLA**. The engineering objective was to distinguish local link status from remote reachability and verify the route change with traffic evidence.

**Quick navigation:** [Results](#recorded-results) · [Topology](#lab-design) · [Process diagrams](operation.md) · [Configurations](configs/README.md) · [Verification](verification/README.md) · [Troubleshooting](troubleshooting/README.md) · [Lessons learned](lessons-learned.md) · [Evidence scope](scope.md)

## Recorded results

| Verification question | Recorded outcome |
|---|---|
| Was the primary path initially reachable? | IP SLA **OK**, RTT **3 ms**, four successes and no failures; Track 10 **Up**, default via ISP-A with administrative distance **1** |
| Did monitoring detect the remote failure? | Track 10 changed **Up → Down** while R1 Gi1 remained **up/up**; the default moved to ISP-B with distance **200** |
| Did application traffic use the backup? | **5/5 replies**, RTT min/avg/max **2/2/3 ms**; traceroute traversed `10.13.13.2` and `10.34.34.2` |
| Did the primary path return after restoration? | Track 10 changed **Down → Up**; the primary default returned, and traceroute traversed `10.12.12.2` and `10.24.24.2` |
| What did the final measurement show? | Latest result **OK**, RTT **5 ms**, **73 successes / 58 failures**, Track 10 **Up** with three changes |

These are supplied, transcribed excerpts from the original October 12, 2026 lab. The final counters cover the interactive session; they do not measure failover duration or application packet loss. [Verification](verification/README.md) preserves the selected output, including unanswered traceroute probes.

## Lab design

![Four-router dual-provider IP SLA lab, with distinct probe and application targets](topology.svg)

[PNG copy](topology.png) · [Addresses and wiring](topology.md) · [Sanitized CML export](CML-LAB.yaml)

R1-BRANCH uses CSR1000v / IOS XE 17.3.2. R2-ISP-A, R3-ISP-B, and R4-TARGET use IOSv 15.9(3)M3. R1's source loopback is `10.100.1.1`; R4 hosts the probe target `10.40.40.40` and the separate application test address `10.40.40.41`.

The failure was introduced on **R2 Gi0/1 toward R4 Gi0/1**. R1's connection to R2 stayed operational, making local interface status insufficient to identify the upstream problem.

## Configuration approach

| Component | Role in this lab |
|---|---|
| IP SLA operation 10 | Sends ICMP Echo probes to `10.40.40.40` from `10.100.1.1`, every ten seconds, with a 1,000 ms threshold and 2,000 ms timeout |
| Track 10 | Uses the operation's reachability result to control the primary static default |
| Tracked and floating defaults | Prefer ISP-A at distance 1; use ISP-B at distance 200 when the primary route is withdrawn |
| Probe-target host route | Keeps the probe directed through ISP-A during the tested remote-link outage, while its next hop remains resolvable |
| R4 return routes | Provide primary and floating backup routes to the branch source loopback |

The application address follows the active default. Keeping it separate from the pinned probe address lets the lab test backup forwarding while continuing to monitor the primary path. [Configuration stages and commands](configs/README.md) explain the saved settings and temporary failure command.

## Troubleshooting and interpretation

Two setup issues sharpened the verification method. A scheduling rejection exposed a threshold larger than the configured timeout; correcting the threshold allowed the operation to run. A reported direct-link problem led to a cabling check and corrected R4 interface assignments. The [case guides](troubleshooting/README.md) distinguish the supplied rejection output from the wiring diagnosis, for which no CDP capture was supplied.

The outage test then connected three observations: failed remote reachability, a changed routing decision, and successful traffic over the backup path. It did not establish an exact switchover time or loss-free service during the transition.

## Reuse and testing status

The supplied sanitized reconstruction preserves four nodes, four links, the probe host route, and R4's floating return routes. Its structure, configuration extracts, and public sanitization have been checked. **A fresh CML import, boot, and failover/failback run remains required** to validate reproduction with the selected images.

TCP Connect, UDP Jitter, an SLA responder, reaction alerts, and tracking delays were not configured in this lab. [Evidence and testing scope](scope.md) separates the completed exercise from remaining reproduction checks.

[Back to portfolio](../README.md) · [Portfolio reading guide](../READING-GUIDE.md)
