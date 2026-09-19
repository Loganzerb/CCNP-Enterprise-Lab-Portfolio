# MSTP verification guide

The nine original evidence files answer different questions about the design and its failure modes. Each folder guide points to the relevant fields and states what the capture can establish.

| Question | Guide and retained evidence | Main finding |
|---|---|---|
| What identifies the main region? | [Region identity](region/README.md) · [Capture](region/main-region-configuration-and-digest.txt) | Name, revision, mapping and digest for CCNP_MST |
| Do the VLAN groups use different paths? | [Instance paths](instances/README.md) · [Capture](instances/mst2-access-a-instance-paths.txt) | Gi0/0 is root for MSTI 1; Gi0/1 is root for MSTI 2 on MST2 |
| Are the intended distribution roots elected? | [Root placement](root-engineering/README.md) · [Capture](root-engineering/engineered-roots.txt) | MST1 is root for instance 1; MST4 for instance 2 |
| How does the region reach an external root? | [Boundary and Master roles](boundary-master/README.md) · [Capture](boundary-master/external-cist-root.txt) | MST4 Gi0/2 is Root in MST0 and Master in MSTIs |
| Can revision alone split a region? | [Region mismatches](region-mismatch/README.md) · [Revision capture](region-mismatch/revision-mismatch.txt) | Revision 2 produces boundaries while the digest stays unchanged |
| What do mapping and name changes reveal? | [Region mismatches](region-mismatch/README.md) · [Combined capture](region-mismatch/mapping-and-name-mismatch.txt) | Mapping changes the digest; name mismatch need not |
| What blocks a designated PVST boundary? | [PVST Simulation](pvst-simulation/README.md) · [Superior-VLAN capture](pvst-simulation/superior-vlan-failure.txt) | Gi0/2 becomes Desg/BKN with PVST inconsistency |
| Is there captured failure and recovery? | [PVST Simulation](pvst-simulation/README.md) · [Inferior-VLAN capture](pvst-simulation/inferior-vlan-failure-and-recovery.txt) | Root-port failure, clear log and zero inconsistent entries |
| What operational details were observed? | [Costs, hops and Dispute](operational/README.md) · [Capture](operational/max-hops-long-cost-and-dispute.txt) | Long operational costs, hop values and a transient Dispute state |

## Terms used in the output

| Field | Meaning in these captures |
|---|---|
| Root / Desg / Altn | Selected path toward a root, designated port, or alternate path |
| FWD / BLK | Forwarding or blocking state |
| Mstr | Master port: the instance's connection toward the external CIST root through the region boundary |
| Bound(RSTP) / Bound(PVST) | A boundary classification; interpret it with the neighboring device's mode and region |
| BKN* / PVST_Inc | PVST Simulation inconsistency is preventing normal forwarding |
| Regional Root | The region's selected bridge toward the overall CIST root |

A boundary is expected on MST4's external link during these tests. A boundary between MST3 and its intended main-region neighbors is the diagnostic clue in the identity-mismatch cases.

## How much recovery evidence is available?

[Case 06](../troubleshooting/scenario-6-pvst-sim-inferior-vlan/README.md) includes failure and clear logs plus an inconsistent-entry count returning to zero. [Case 07](../troubleshooting/scenario-7-transient-dispute/README.md) includes two port-state snapshots. Other cases retain failure or role evidence with a documented correction or replay target, rather than a complete post-fix transcript.

The nine files remain unchanged, including their excerpt labels and observed-state summaries. Port roles establish control-plane state; no endpoint ping tests or throughput measurements are retained here.

[Section overview](../README.md) · [Case index](../troubleshooting/README.md)
