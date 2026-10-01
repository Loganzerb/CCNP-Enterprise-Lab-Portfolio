# Multicast — receiver interest, shared trees and forwarding decisions

These labs trace how a network discovers receivers, selects multicast paths and responds when configuration or routing changes. Each subsection connects a plain-English outcome to configuration, device evidence and the decisions used to diagnose it.

## Explore the topics

| Topic | Published lab evidence | Start here |
|---|---|---|
| **PIM-SM** | Static RP, Auto-RP and BSR; seven cases and 105 evidence blocks | [PIM-SM overview](PIM-SM/README.md) |
| **IGMPv2/v3 and SSM** | Membership expiry/rejoin and source-specific control-plane state; seven blocks | [IGMP overview](IGMPv2-v3/README.md) |
| **BIDIR-PIM** | DR/DF separation, two repairs and a routing-driven DF transition; eighteen blocks | [BIDIR overview](BIDIR-PIM/README.md) |
| **RPF** | Path-change work documented within PIM-SM; dedicated review pending | [RPF path-change case](PIM-SM/troubleshooting/01-rpf-path-change.md) |
| **MSDP** | Portfolio evidence not yet integrated | [Progress and scope](progress.md) |

## Choose a case

| Question | Follow the investigation |
|---|---|
| Why does RP discovery stop when OSPF still works? | [Missing PIM on transit interfaces](PIM-SM/troubleshooting/07-bsr-propagation.md) |
| Why did a receiver-facing branch disappear? | [IGMP membership timer expiry](IGMPv2-v3/troubleshooting/01-membership-expiry.md) |
| Why does the tree point toward the wrong host? | [BIDIR receiver join on the source LAN](BIDIR-PIM/troubleshooting/02-wrong-receiver.md) |
| What changes the router carrying source traffic? | [BIDIR Designated Forwarder transition](BIDIR-PIM/troubleshooting/03-df-transition.md) |

## PIM-SM phases

Static RP, Auto-RP and BSR remain together within PIM-SM. IGMP and BIDIR have their own sibling subsections and navigation.

| Phase | Engineering focus |
|---|---|
| [01 — Static RP](PIM-SM/static-rp.md) | Establish forwarding, trace shared/source trees and isolate edge faults |
| [02 — Auto-RP](PIM-SM/auto-rp.md) | Migrate to dynamic RP discovery and repair control-message transport |
| [03 — BSR](PIM-SM/bsr.md) | Test election resilience, repair RP-set propagation and explain selection |

## Validation & Post-Assessment

After the hands-on multicast work, I completed an original **50-question CCNP ENCOR-style cumulative assessment**, scoring **43/50 (86%) on the first attempt**. It tested whether I could independently reason through multicast behavior, interpret device output and diagnose scenarios using the understanding developed during the labs.

The assessment covered Reverse Path Forwarding (RPF), PIM Sparse Mode, Auto-RP, Bootstrap Router (BSR), IGMPv2 and IGMPv3, Source-Specific Multicast (SSM), Bidirectional PIM, Multicast Source Discovery Protocol (MSDP), PIM Dense Mode, and multicast addressing and control-plane behavior. It combined conceptual questions, troubleshooting scenarios, configuration/output interpretation, protocol behavior and multi-select questions.

Assessment coverage extends beyond the lab evidence currently published here, including MSDP and PIM Dense Mode. The score records cumulative reasoning across those topics; the topic table and linked captures identify the documented hands-on results.

### First-attempt findings

The result provided a separate check of the reasoning behind the lab work and identified specific areas for further review:

- BSR Candidate-RP priority direction.
- IPv4 multicast-to-Ethernet MAC mapping.
- PIM protocol number and control addresses.
- RPF behavior on `(*,G)` shared-tree state.
- IGMPv2 General Query behavior.
- IGMPv3 Membership Report destination.
- IGMP querier versus PIM Designated Router election behavior.

The original score and these first-attempt findings remain the assessment baseline, separate from recorded forwarding results.

[Progress and evidence scope](progress.md) · [Back to portfolio](../README.md)
