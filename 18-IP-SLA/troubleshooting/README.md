# IP SLA troubleshooting cases

These two setup cases connect a rejected schedule and a failed directly connected ping to their corrections. The later outage experiment is documented in the [verification guide](../verification/README.md).

**Quick navigation:** [Cases](#case-index) · [Evidence boundary](#read-the-evidence-boundary)

## Case index

| Case | Diagnostic question | Recorded outcome |
|---|---|---|
| [Threshold and timeout](threshold-timeout.md) | Why did IOS XE reject the probe schedule? | Threshold 5000 ms exceeded timeout 2000 ms; the final threshold was 1000 ms and scheduling acceptance was reported |
| [Interface mapping](interface-mapping.md) | Did the IP addressing match the actual physical connections? | Reported CDP diagnosis identified R2 Gi0/1 → R4 Gi0/1 and R3 Gi0/1 → R4 Gi0/0 |

## Read the evidence boundary

The [scheduling rejection](threshold-timeout.md#block-01) retains the supplied command and complete rejection message. Its later acceptance is a reported result. The interface case has no supplied ping or CDP output, so its diagnosis and correction remain explicitly reported.

The outage, backup forwarding, and recovery pages retain separate device-output excerpts. Read their [capture limits](../scope.md) alongside the results; neither setup case adds a new execution or import test.

[Threshold case](threshold-timeout.md) · [Interface case](interface-mapping.md) · [Lessons learned](../lessons-learned.md) · [Verification](../verification/README.md) · [Configurations](../configs/README.md) · [Topology](../topology.md) · [Operation](../operation.md) · [Evidence scope](../scope.md) · [Overview](../README.md)
