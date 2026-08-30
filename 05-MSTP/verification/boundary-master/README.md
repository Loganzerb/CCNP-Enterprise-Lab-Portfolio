# Boundary, Regional Root, and Master Port

MST5 first used region name `BOUNDARY_MST`. Its link to MST4 therefore appeared as `Bound(RSTP)`. After MST5 received lower MST0 priority, it became the overall CIST root; MST4 became the CIST Regional Root, used `Gi0/2` as `Root FWD` for MST0, and represented that path as `Mstr FWD` in MSTI 1 and 2.

The link-down experiment removed the external path and caused the remaining component to elect a new CIST root. Restoring the link re-established the Root/Master relationship.
