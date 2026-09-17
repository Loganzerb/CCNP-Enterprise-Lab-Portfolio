# Protocol settings — which policies were active?

Read the EIGRP section of each `show ip protocols` capture. Other process sections are retained because R1 and R3 also connect to the wider OSPF lab.

| Capture | Details to inspect |
|---|---|
| [R1-CORE](R1-show-ip-protocols.txt) | AS 100, router ID `10.1.1.1`, static and OSPF redistribution |
| [R2-DIST-A](R2-show-ip-protocols.txt) | AS 100 and four participating network ranges |
| [R3-DIST-B](R3-show-ip-protocols.txt) | OSPF redistribution into AS 100 |
| [R4-BRANCH](R4-show-ip-protocols.txt) | `172.16.40.0/22` on both uplinks, four components, and the Gi0/2 default-only prefix filter |
| [R5-REMOTE](R5-show-ip-protocols.txt) | Named instance `CCNP-LAB`; connected/summary stub; remote summary; 64-bit metrics and RIB scale 128 |

The captures show internal/external administrative distances 90/170, maximum paths 4, and variance 1. Those settings permit equal-cost multipath; the [routing files](../routing/README.md) show where multiple paths were installed.

Automatic summarization is disabled, but R4 and R5 have explicit manual summaries. These are separate settings.

R4's heading says an outgoing filter for all interfaces is not set, followed by the specific Gi0/2 filter. Read the interface-specific line before concluding that no filter is applied.

R5's stub declaration is captured. It documents the configured role, not an observed query-boundary experiment. Likewise, redistribution configuration and tagged routes do not establish that a feedback-loop fault was tested.

Authentication and Hello/Hold settings are explained in the [configuration guide](../../configs/README.md); this command is not a complete view of those interface settings.

[Verification guide](../README.md)
