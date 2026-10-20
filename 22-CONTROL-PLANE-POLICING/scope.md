# CoPP scope and evidence provenance

This October 20, 2026 CML lab used two CSR1000v IOS XE 17.3.2 routers and two Alpine Desktop endpoints. Four nodes and three links connect CLIENT-A through R1-CoPP and R2-PEER to APP-TEST.

**Quick navigation:** [Sources](#sources) · [Exercised scope](#exercised-scope) · [Measurement limits](#measurement-limits) · [Saved state and publication](#saved-state-and-publication)

## Sources

| Material | Source and interpretation |
|---|---|
| Original CML export | Actual saved addressing, OSPF, CoPP classifiers, policers, and R1 policy attachment; held privately and sanitized for publication |
| Runtime outcomes and packet figures | Engineer-supplied narrative results, labeled reported in [verification](verification/README.md) and [case studies](troubleshooting/README.md) |
| Mechanism explanations and diagrams | Interpretations of classification, policing, management access, and routing dependencies; not reconstructed CLI output or packet captures |

No raw SSH, policy-counter, OSPF, route, ping, or startup-configuration transcripts were supplied. The YAML does not contain the historical counters or fault and recovery messages. No synthetic console output or numbered capture blocks have been created.

## Exercised scope

The saved final R1 policy classifies TCP destination port 22 to **10.10.10.1** and OSPF sourced from **10.1.12.2**. The final CIRs are **80,000 bps** for SSH and **1,000,000 bps** for OSPF; both classes transmit conforming traffic and drop exceeding traffic. CP-PROTECT is attached inbound under R1's control plane.

The reported experiments cover an SSH reduction to **8 kbps with a 1,500-byte burst**, recovery to 80 kbps, and an OSPF conform-drop fault at the unchanged 1-Mbps CIR followed by restoration of conform transmit. Both routers run OSPF 10 in Area 0; endpoint interfaces are passive.

## Measurement limits

The SSH recovery snapshots report **119 to 185 matched**, **109 to 175 conformed**, and **10 to 10 exceeded**: 66 additional matched and conforming packets with no additional exceeded packets. These are cumulative reported snapshots, not raw captures or a timed throughput test. The reported connection-closure message does not identify the exact discarded packet that caused that attempt to fail.

The OSPF record reports normal conforming traffic with zero exceeded packets, the neighbor and route loss after conform drop, and recovery after conform transmit. It supplies no exact OSPF packet totals. Cumulative conform counters do not provide an exact count of packets dropped by the temporary fault.

The final endpoint regression reports **10/10 ICMP replies with zero loss**. It does not establish sustained performance, universal protection of all control protocols, or recommended production policer rates.

## Saved state and publication

Both router startup configurations were inspected according to the handoff. **No router reload verification was performed**, and no startup transcript accompanies that statement.

The published export removes credentials, sensitive cryptographic material, device serials, and unrelated generated metadata. Its retained networking and policy configuration is saved-state evidence. [Import setup](configs/README.md) explains the additional SSH preparation required after sanitization. No working password is published, and the sanitized lab has not been freshly imported, booted, or traffic-tested during documentation preparation.

[Overview](README.md) · [Verification](verification/README.md) · [Troubleshooting](troubleshooting/README.md) · [Configurations](configs/README.md) · [Operation](operation.md) · [Topology](topology.md) · [Lessons learned](lessons-learned.md)
