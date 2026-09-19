# NAT/PAT troubleshooting

| Case | Problem | Engineering focus |
|---|---|---|
| [Incident 01 — External connectivity outage](incident-01-external-connectivity-outage.md) | Two clients could not reach the external server through dynamic NAT | Multiple simultaneous faults across interface roles, ACL coverage, return routing, pool capacity, and a repair typo. |
| [Incident 02 — External access after PAT migration](incident-02-pat-migration.md) | A PAT migration disrupted clients despite a reported successful router-originated check | Wrong address-source interface, a one-entry state limit, and stable proof of concurrent PAT using persistent TCP sessions. |

Both cases separate original configuration evidence, retained repair checkpoints, and final measurements. Suggested reproduction commands are labelled as such; they are not substituted for missing terminal history.

The [guided labs](../verification/guided-labs.md) cover the shorter controlled failures. Use the [capture index](../verification/README.md#capture-index) for original output and the [configuration guide](../configs/README.md) for exports and repairs.
