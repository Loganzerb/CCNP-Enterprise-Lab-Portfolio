# NETCONF and RESTCONF scope and evidence provenance

This October 14, 2026 two-node CML exercise covers NETCONF and RESTCONF reads and description changes on R1-AUTOMATION. Protocol replies/readbacks and independent CLI checks establish the observed running configuration.

**Quick navigation:** [Sources](#sources) · [Exercised scope](#exercised-scope) · [Evidence limits](#evidence-limits) · [Export and persistence](#export-and-persistence)

## Sources

| Material | Source and interpretation |
|---|---|
| Verification Blocks 01–17 | Supplied redacted terminal excerpts and selected uploaded NETCONF transcript, preserved once with their original IDs |
| Block 08 request and Block 12 BODY assignment | Prescribed lab instructions, distinguished from captured replies, request-template fragments, and readbacks |
| CML topology and router configuration | Supplied export, sanitized for the public portfolio; [configuration guide](configs/README.md) identifies saved artifacts |
| Topology image and process diagrams | Context and explanations, separate from terminal evidence |

The source excerpts are already editorially formatted: wrapped command tokens are rejoined, XML may be indented, and HTTP fragments decode shell line-ending escapes. `[REDACTED]` values and marked omissions replace sensitive content. These are selected transcript excerpts, not PCAPs or fresh execution results.

## Exercised scope

The NETCONF client uses base 1.0 delimiter framing over SSH port 830, reads running configuration with subtree filters, and performs a merge description edit. Candidate was explicitly disabled. Server advertisement of base 1.1, rollback, validate, XPath, and notifications does not establish that those features were exercised.

RESTCONF uses manually constructed HTTP/1.1 through OpenSSL to HTTPS port 443. Captured GET, PATCH response, subsequent GET, and CLI agree with the final description. Plain HTTP was also enabled in the router settings; no plaintext RESTCONF test is claimed.

## Evidence limits

Block 08's message-104 request and Block 12's body assignment are prescribed rather than echoed captures. No expanded PATCH body or numeric transmitted Content-Length is available. The captured responses and independent readbacks establish the resulting description without reconstructing missing wire bytes.

Connectivity evidence retains Linux-to-router 5/5 replies; no router-to-Linux ping summary was supplied. Earlier 25% ping loss and HTTP 401 are preserved separately. Their precise causes were not isolated by the excerpts.

TLS 1.2 negotiation succeeded with a self-signed certificate verification error. No trusted-certificate validation result is established. Missing curl/python3 PATH results do not prove those tools were uninstalled. [Verification](verification/README.md) links each result to its supporting block.

## Export and persistence

The public export and extracts represent saved configuration source material. Protocol and CLI checks establish observed running state. Instructions to save or configure Linux boot behavior are not executed save/reboot evidence; no persistence test is supplied.

Sanitized CML import, boot, and protocol retesting have not been performed during portfolio preparation. No new lab run, packet capture, or advanced troubleshooting test is represented as completed work.

[Overview](README.md) · [Configurations](configs/README.md) · [Verification](verification/README.md) · [Operation](operation.md) · [Topology](topology.md) · [Lessons learned](lessons-learned.md)
