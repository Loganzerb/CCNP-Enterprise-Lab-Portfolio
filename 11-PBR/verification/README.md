# PBR verification guide

The four pages retain 30 numbered evidence blocks from the completed lab. Follow the block links in each case to inspect the supporting output.

| Evidence page | Blocks | Purpose |
|---|---:|---|
| [01 — Baseline and selective forwarding](01-baseline.md) | 14 | Interfaces, normal route, ACL, route map, attachment, contrasting paths and initial counter |
| [02 — ACL classification](02-acl-classification.md) | 4 | Reversed source selection and restored classifier |
| [03 — Next-hop failure](03-next-hop-failure.md) | 4 | Indirect route during the fault, observed path, connected-route recovery and restored path |
| [04 — Route-map sequencing](04-route-map-sequencing.md) | 8 | Deny/permit sequence behavior, contrasting counters and final baseline checks |

## Read the checks together

| Check | Question it answers |
|---|---|
| show ip route 10.5.5.5 | Which destination route does normal routing use? |
| show ip policy | Which interface receives the policy? |
| show route-map PBR-TO-R3 | Which criteria, actions and sequence counters are present? |
| show access-lists PBR-SOURCE-A | Which source is classified, and does the ACL record matches? |
| Source-specific traceroute | Which responding hops appear for this particular source? |

The [before route](01-baseline.md#block-06) and [after route](01-baseline.md#block-12) both point to R4, although the policy-selected trace includes R3. The [final paired traces](04-route-map-sequencing.md#block-07) explicitly retain both source commands.

## Classification versus policy action

| Result | Meaning in this PBR context |
|---|---|
| ACL permits a packet | The ACL match condition succeeds |
| ACL denies a packet | That ACL match fails; a later route-map sequence may still apply |
| Packet matches route-map deny | Stop PBR evaluation and use normal routing |
| Packet reaches a permit sequence with no match clause | It matches that sequence |
| No policy sequence matches | Use normal routing |

These rules concern an ACL referenced by a PBR route map. They do not describe an interface filtering ACL.

The sequencing exercise recorded **nine ACL matches**, **zero policy-routing packets on deny 10**, and **39 policy-routing packets on permit 20**. Those are separate cumulative counters, not a one-to-one packet ledger.

## Evidence handling and limits

The blocks retain device output from September 19–20, 2026. Formatting cleanup decodes escaped spaces and Markdown escapes and normalizes line endings. Truncated prompts, interleaved logging, route-descriptor list formatting and unanswered traceroute probes remain visible.

One initial policy trace lacks the entered command; its source-A context comes from the preceding exercise step. The later final check contains the complete command. The configuration files reconstruct the relevant setup; they are not running-config exports.

Traceroute responses include R5's transit address 10.45.1.5 while the requested destination is its loopback 10.5.5.5. Final-hop asterisks were not investigated and are not evidence of loss-free service. No application transaction, throughput benchmark or failover timing was measured.

The recorded follow-up knowledge check was **12/12**. That is a study assessment, separate from device verification. Local PBR, TCP-port classification, multiple next hops, recursive PBR and availability tracking were not demonstrated in the captured lab.

[Back to cases](../troubleshooting/README.md) · [Back to PBR](../README.md)
