# Threshold and timeout — a rejected IP SLA schedule

**Outcome:** the initial schedule was rejected because threshold 5000 ms exceeded timeout 2000 ms. The final configuration used threshold 1000 ms and timeout 2000 ms; the lab record reports that scheduling was then accepted.

**Quick navigation:** [Rejection](#recorded-schedule-rejection) · [Correction](#reported-correction) · [Evidence boundary](#evidence-boundary)

## Recorded schedule rejection

R1-BRANCH used CSR1000v IOS XE 17.3.2. The initial operation retained a default threshold of 5000 ms while its timeout was explicitly set to 2000 ms. IOS XE rejected the request to start operation 10.

### Block 01

**Selected CLI excerpt — October 12, 2026.** The supplied scheduling command and rejection are retained verbatim.

```text
R1-BRANCH(config)#ip sla schedule 10 life forever start-time now
%Scheduling a probe with threshold 5000 ms greater than timeout 2000 ms is not allowed.
```

The error identifies a parameter relationship: the threshold exceeded the operation's timeout. It is a scheduling failure, before the reachability experiment could run.

## Reported correction

The final operation used **threshold 1000 ms** and **timeout 2000 ms**. The lab record reports successful scheduling after that change. Its later [baseline statistics](../verification/baseline.md#what-the-baseline-establishes) retain an operational result of `OK` with four successes and zero failures.

## Evidence boundary

The rejection is supported by the selected console excerpt. The correction and scheduling acceptance are reported observations, without a separate acceptance-output capture. This documents behavior observed on the lab's CSR1000v image; the sanitized configuration has not undergone a fresh import-and-boot test.

[Case index](README.md) · [Interface mapping](interface-mapping.md) · [Lessons learned](../lessons-learned.md) · [Verification](../verification/README.md) · [Configurations](../configs/README.md) · [Topology](../topology.md) · [Operation](../operation.md) · [Evidence scope](../scope.md) · [Overview](../README.md)
