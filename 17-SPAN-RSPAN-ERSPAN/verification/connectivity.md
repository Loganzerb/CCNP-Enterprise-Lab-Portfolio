# Connectivity before ERSPAN verification

The recorded reachability tests checked the endpoint path through R1 and the separate collector link. Their results establish connectivity before interpreting mirrored traffic.

**Quick navigation:** [Recorded tests](#recorded-tests) · [What the tests establish](#what-the-tests-establish) · [Evidence scope](#evidence-scope)

## Recorded tests

**Reported observations from the lab record.** No ping command/output transcript accompanies these counts.

| Test | Reported result |
|---|---|
| R1 to Alpine at `10.30.30.2` | 10/10 successful |
| R2 Loopback0 `10.10.10.10` to R3 Loopback0 `10.20.20.20` | 100/100 successful |
| Subsequent 10-packet ping | 10/10 successful |

## What the tests establish

R2's endpoint traffic crosses R1 from Gi1 toward Gi2. The collector is attached separately through R1 Gi3 and receives the mirrored copies. Its reachability test checks a different path from the original endpoint traffic.

Successful ping alone does not establish packet replication. The [RX observations](rx-payload.md) identify GRE delivery and original payloads, while the [Both-direction evidence](bidirectional.md) connects the runtime source setting to reported Echo Request and Echo Reply copies.

## Evidence scope

These are reported results, not reconstructed console output. The record supplies no round-trip values or continuous connectivity trace for these tests. The 10/10 result associated with the Both-direction verification remains separate from the completeness of its selected GRE capture.

[Verification index](README.md) · [ERSPAN overview](../README.md) · [Topology and addressing](../topology.md) · [Collector setup](../configs/collector.md) · [Evidence scope](../scope.md)
