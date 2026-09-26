# 12 — Multicast

Multicast delivers a source's traffic to interested receivers. This portfolio follows how routers discover the Rendezvous Point (RP), build delivery paths, and recover when routing or discovery fails. Each lab connects the intended behavior to troubleshooting decisions and recorded device evidence.

## Explore the topics

| Topic | Current work | Start here |
|---|---|---|
| **PIM-SM** | Static RP, Auto-RP and BSR completed; seven cases and 105 evidence blocks | [PIM-SM overview](PIM-SM/README.md) |
| **IGMPv2/v3** | Lab in progress; portfolio section pending | Will be a standalone subsection alongside PIM-SM |
| **RPF** | Routing and path-change work already appears within PIM-SM; dedicated review pending | [RPF path-change case](PIM-SM/troubleshooting/01-rpf-path-change.md) |
| **SSM, Bidir-PIM and MSDP** | Future dedicated subsections | Add after their respective labs are completed |

## Choose a PIM-SM phase

The three phases build on the same multicast scenario. Each has its own overview and links to its configuration, evidence and cases.

| Phase | Engineering focus |
|---|---|
| [01 — Static RP](PIM-SM/static-rp.md) | Establish forwarding, trace the shared/source trees and isolate faults at either edge |
| [02 — Auto-RP](PIM-SM/auto-rp.md) | Migrate to dynamic RP discovery and restore control-message transport |
| [03 — BSR](PIM-SM/bsr.md) | Test election resilience, repair RP-set propagation and explain RP selection |

For a quick technical review, start with [OSPF reaches the BSR, but RP discovery stops](PIM-SM/troubleshooting/07-bsr-propagation.md). Ordinary routes were present; missing PIM settings on two transit interfaces prevented discovery from working throughout the domain.

[All PIM-SM cases](PIM-SM/troubleshooting/README.md) · [Evidence by phase](PIM-SM/verification/README.md) · [Progress and evidence scope](progress.md)

[Back to portfolio](../README.md)
