# Portfolio reading guide

Use either path to explore selected projects without reading every module in sequence. **Project highlights** introduce the work and its results. **Engineering evidence** follows specific questions into the investigation and supporting records.

These are independent labs, each with its own topology and test history. The paths connect engineering ideas across the portfolio; they do not represent one combined deployment or test run.

**Quick navigation:** [Project highlights](#project-highlights) · [Engineering evidence](#engineering-evidence) · [Compare the inspection tools](#compare-the-inspection-tools) · [Read the evidence labels](#read-the-evidence-labels)

## Project highlights

Start with each project's introduction and topology, then use the result link for the outcome. These four stops show troubleshooting, protected connectivity, automation, and packet inspection.

| Stop | What to look for | Result to review |
|---|---|---|
| **1. Restore a service:** [NAT/PAT incident](08-NAT/troubleshooting/incident-01-external-connectivity-outage.md) | How classification, return routing, and address capacity affected two clients | [Final capture](08-NAT/verification/incident-01-final.txt): **5/5 replies from each client**, with two translated addresses in the table |
| **2. Protect site-to-site traffic:** [GRE/IPsec and VTI](14-GRE-IPsec-Tunneling/README.md) | How two designs carry routed traffic through a protected path | [VTI final results](14-GRE-IPsec-Tunneling/verification/07-vti.md#final-results): reported **10/10** private loopback replies and zero final send/receive errors |
| **3. Automate diagnostics:** [EEM overview](15-EEM/README.md) | How a device event triggers an alert and collects relevant interface state | [Selected event sequence](15-EEM/verification/syslog-triggered-diagnostics.md#block-01): line-protocol failure, custom alert, and logged diagnostic result |
| **4. Inspect mirrored traffic:** [ERSPAN overview](17-SPAN-RSPAN-ERSPAN/README.md) | How a separate collector inspects copies while original traffic continues to its destination | [Bidirectional observations](17-SPAN-RSPAN-ERSPAN/verification/bidirectional.md#reported-request-and-reply): reported decoding identifies an Echo Request and its reply |

## Engineering evidence

Choose a question, read the case, and follow the decisive evidence. Compare the conclusion with what was actually captured or reported.

| Question | Investigation | Evidence to inspect |
|---|---|---|
| Can an active gateway still lose its upstream service path? | [HSRP upstream failure](07-FHRP/troubleshooting/scenario-1-hsrp-upstream-black-hole.md) | [Alternate-path capture](07-FHRP/verification/hsrp-tracking/PC-A-ping-and-traceroute-tracking-failover.txt): **10/10** after tracked takeover; the case separately retains loss during recovery tests |
| Why can ping work while a routing adjacency stalls? | [OSPF MTU mismatch](02-OSPF/troubleshooting/scenario-1-ospf-mtu-exstart-exchange.md#how-i-isolated-the-cause) | Compare the physical and IP-specific MTU checks, then the retained **FULL** adjacency evidence after repair |
| Why can RP discovery fail while unicast routing works? | [BSR propagation investigation](12-MULTICAST/PIM-SM/troubleshooting/07-bsr-propagation.md#follow-the-dependency-chain) | Follow the transit-interface PIM checks and [recovered RP mappings](12-MULTICAST/PIM-SM/verification/10-bsr-propagation.md#block-07) across R1–R4 |
| Why can a registered automation policy miss an event? | [EEM syslog-pattern mismatch](15-EEM/troubleshooting/incorrect-syslog-pattern.md) | [Repair excerpt](15-EEM/verification/syslog-triggered-diagnostics.md#block-05): the corrected temporary detector matches the emitted message and produces its alert |

The EEM fault exercise used a temporary LINK detector. It is separate from the retained LINEPROTO applet in the project-highlights path. Likewise, a successful alternate-gateway test does not establish loss-free recovery in the later HSRP runs.

## Compare the inspection tools

These examples answer complementary questions. Follow the process diagram, then check its linked evidence.

| Lab example | Question it answers | Diagram and evidence |
|---|---|---|
| EEM diagnostics | What device event occurred, and what action followed? | [Event-to-action diagram](15-EEM/operation.md) · [Selected diagnostic output](15-EEM/verification/syslog-triggered-diagnostics.md#block-01) |
| Flexible NetFlow | Which configured flow fields and counters describe the monitored traffic? | [Measurement and export diagrams](16-NETFLOW/operation.md) · [Local cache](16-NETFLOW/verification/traffic-and-cache.md#block-04) · [Decoded exported record](16-NETFLOW/verification/export-and-templates.md#block-12) |
| ERSPAN | Which original packet headers appear inside the mirrored copies? | [Traffic and header diagrams](17-SPAN-RSPAN-ERSPAN/operation.md) · [Selected session output](17-SPAN-RSPAN-ERSPAN/verification/bidirectional.md#block-03) · [Reported packet decoding](17-SPAN-RSPAN-ERSPAN/verification/rx-payload.md#original-payload) |

NetFlow's **100 packets / 10,000 bytes** describe the selected ingress flow. ERSPAN's packet observations identify original requests and replies inside mirrored traffic. Their matching endpoint addresses belong to separate lab records, not a shared capture or correlated test run.

## Read the evidence labels

**Selected CLI excerpts** retain supplied device-output lines. **Reported observations and decoded summaries** preserve results from the lab record where complete output or packet files were unavailable. **Saved configuration** establishes configured intent; its runtime checks are identified separately.

Each linked case states its measurement and capture limits. Read those alongside the result, especially when interpreting recovery timing, packet counts, or reported decoding.

[All modules](README.md#explore-the-modules) · [Review method](README.md#how-to-review-the-work) · [Back to portfolio](README.md)
