# Case 04 — Identify the region's path to an external root

This experiment explains expected boundary operation. An external switch became the overall CIST root, while the main region retained its own instance-root choices.

## Establish the stage

MST5 was operating in the separate `BOUNDARY_MST` region with a temporary MST0 priority of **16384**. This predates its saved Rapid PVST+ configuration.

The [MST4 capture](../../verification/boundary-master/external-cist-root.txt) reports:

| Scope | Gi0/2 role | Meaning |
|---|---|---|
| MST0 | Root FWD, Bound(RSTP) | Path toward the external CIST root |
| MSTI 1 | Mstr FWD, Bound(RSTP) | External connection for instance 1 |
| MSTI 2 | Mstr FWD, Bound(RSTP) | External connection for instance 2 |

MST4 also reports `Regional Root this switch`, while its instance 1 root remains MST1. The external CIST path and internal instance election are distinct.

## Link-failure experiment and evidence limit

The original case notes describe shutting the boundary link, allowing the remaining component to elect a new CIST root, and restoring the link to re-establish the roles.

Only the external-root role snapshot is retained. There is no separate link-down or post-restoration transcript, and no endpoint reachability measurement. The case therefore demonstrates the role relationship directly; the fail/restore sequence remains documented narrative.

For a replay, compare MST0 and both instances before shutdown, during isolation and after restoration. Record the changed root IDs and roles at each stage.

**Takeaway:** a boundary and a Master port can be normal design behavior; they are not inherently faults.

[All cases](../README.md) · [Saved versus experimental topology](../../topology.md)
