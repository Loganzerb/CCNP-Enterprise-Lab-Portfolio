# Operational details: costs, hop counts and a transient state

These excerpts help interpret what IOS reports during MST operation. They also show why a single unusual snapshot should be checked again before diagnosing a persistent fault.

[Open the original operational capture](max-hops-long-cost-and-dispute.txt).

| Observation | What the retained output establishes |
|---|---|
| Configured cost method is short; operational value is long | MST4's summary distinguishes the setting from the active calculation |
| Gi0/0 port cost 20000; root cost 40000 | The individual link cost and total path cost are different fields |
| Max hops 20; remaining hops 18 | A configured limit and a remaining value appear in the output |
| MST3 Gi0/0 changes from `Desg BLK ... Dispute` to `Desg FWD` | The disputed state is absent in the repeated snapshot |

The [adjacent access-switch capture](../instances/mst2-access-a-instance-paths.txt) separately shows remaining hops 19. These are observations from their respective stages, not a hop-exhaustion failure test.

There is no measured duration for the Dispute interval, packet capture establishing its cause, or evidence of a persistent one-way link. [Case 07](../../troubleshooting/scenario-7-transient-dispute/README.md) keeps the conclusion at that level.

[Evidence index](../README.md)
