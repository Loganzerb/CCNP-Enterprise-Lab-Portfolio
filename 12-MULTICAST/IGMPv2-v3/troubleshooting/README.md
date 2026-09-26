# IGMP investigations

| Case | Diagnostic decision | Result |
|---|---|---|
| [01 — Membership expires](01-membership-expiry.md) | Follow the group timer and receiver-facing branch | New reports restore membership and Gi0/0 |
| [02 — SSM verification is incomplete in one view](02-ssm-verification.md) | Correlate configuration, membership and multicast route | Source-specific state verified despite an unavailable command and an empty displayed source list |

These are observed lab investigations. The first is a controlled membership withdrawal; the second is a verification issue, not a demonstrated forwarding outage.

[Evidence](../verification/README.md) · [Overview](../README.md)
