# Baseline before ACL filtering

The lab record reports successful connectivity before applying the server-facing policy. CLIENT-A uses `10.10.10.25/24`, CLIENT-B uses `10.20.20.25/24`, and APP-SERVER uses `172.16.40.10/24`, each through R1-ACL's corresponding .1 gateway.

**Quick navigation:** [Reported baseline](#reported-baseline) · [Interpretation](#what-the-baseline-establishes)

## Reported baseline

| Check | Reported lab result |
|---|---|
| Router interfaces and connected routes | Verified during setup |
| ICMP baseline | Nine repeated tests passed with zero packet loss |
| CLIENT-A and CLIENT-B SSH to APP-SERVER | Both established sessions |
| CLIENT-A and CLIENT-B TCP 443 to APP-SERVER | Both Netcat connection tests succeeded |

The nine tests are test runs, not a statement that only nine packets were sent. Individual command transcripts, probe counts, round-trip values, and exact test timing were not supplied.

## What the baseline establishes

The reported baseline provides a comparison for later restrictions: the tested services worked before the policy experiments. TCP 443 was tested with Netcat; no HTTPS service, TLS negotiation, or certificate validation is established by that connection test.

Read the [filtering results](filtering-and-counters.md) alongside the [saved configuration guide](../configs/README.md). The export preserves configured addressing and policy, while interface/route verification and service success remain reported observations.

[Verification index](README.md) · [Final state](final-state.md) · [Overview](../README.md) · [Topology](../topology.md) · [Evidence scope](../scope.md)
