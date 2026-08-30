# Device configurations

These files were extracted verbatim from the `configuration` field of each switch node in the uploaded CML YAML.

| File | Role |
|---|---|
| `SW1-DIST-A.cfg` | Distribution switch; primary root for VLANs 10/20 and secondary for 30/40 |
| `SW2-ACCESS-A.cfg` | Access switch with protected edge port toward PC1 |
| `SW3-ACCESS-B.cfg` | Access switch with protected edge port toward PC2 and Bridge Assurance network port toward SW4 |
| `SW4-DIST-B.cfg` | Distribution switch; primary root for VLANs 30/40 and secondary for 10/20 |
| `SW5-ROGUE.cfg` | Lab switch used for rogue-root, parallel-link, and EtherChannel tests |

The snapshots preserve real configuration history, including any harmless remnants created during failure injection. They have not been normalized or “cleaned up.”
