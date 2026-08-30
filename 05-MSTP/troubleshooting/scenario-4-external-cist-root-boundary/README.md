# Scenario 4 — External CIST root and boundary failure

## Fault injected

MST5-BOUNDARY remained in the separate `BOUNDARY_MST` region and was given a lower MST0 priority, making it the overall CIST root.

## Observation and diagnosis

MST4 became `Regional Root this switch`. Its MST5-facing `Gi0/2` was `Root FWD ... Bound(RSTP)` in MST0 and `Mstr FWD ... Bound(RSTP)` in MSTI 1 and 2. This is the canonical signature of the region's best path to an external CIST root.

When the boundary link was shut, that external path disappeared and the remaining component elected a new CIST root. Restoration re-established the Root/Master roles.

## Fix and validation

Bring the link back up and verify MST0 Root plus MSTI Master on the boundary. The fail/recovery experiment changed reachability, not the region configuration.

Evidence: [external CIST root output](../../verification/boundary-master/external-cist-root.txt).
