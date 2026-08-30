# MSTP troubleshooting case studies

Each scenario records the injected fault, the observed signature, the diagnosis, the correction, and the proof of recovery. Supporting `.txt` files are links to captured evidence when available.

| Scenario | Fault | Key signature |
|---|---|---|
| 1 | Revision mismatch | Same digest, different revision, `Bound(RSTP)` |
| 2 | Mapping/digest mismatch | VLAN 20 remapped, changed digest, region split |
| 3 | Region-name mismatch | Same digest/revision, different name, region split |
| 4 | External CIST root | MST4 Regional Root; MST0 Root and MSTIs Master |
| 5 | Superior PVST VLAN | Designated boundary `BKN*`, `PVST_Inc` |
| 6 | Inferior PVST VLAN | Root port blocked, FAIL/OK logs |
| 7 | Transient Dispute | Temporary reconvergence state only |
