# PBR case studies

These controlled changes test policy behavior and recovery. Each case links to the recorded output rather than relying on the intended configuration alone.

| Case | Question | Outcome |
|---|---|---|
| [01 — ACL classification](01-acl-classification.md) | Does deny mean drop when the ACL classifies traffic for PBR? | The excluded source used normal routing; permit any selected the other source |
| [02 — Next-hop failure](02-next-hop-failure.md) | Is an indirect route enough to preserve the policy path? | Traffic used R4 during the fault and returned to R3 after restoration |
| [03 — Route-map deny](03-route-map-deny.md) | Does a matching deny continue to the next sequence? | Source A used normal routing; only source B reached the catch-all permit |

Start with [baseline verification](../verification/01-baseline.md#block-06) to see the normal route, policy attachment and selective path change.

[Configuration guide](../configs/README.md) · [Back to PBR](../README.md)
