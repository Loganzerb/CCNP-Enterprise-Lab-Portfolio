# Device configurations

These files were extracted verbatim from the `configuration` blocks in the authoritative CML YAML. They are final saved snapshots, so they represent the restored lab state rather than every temporary fault injected during the masterclass.

| Device | Role |
|---|---|
| `MST1-DIST-A.cfg` | Main-region distribution switch; MSTI 1 root |
| `MST2-ACCESS-A.cfg` | Main-region access switch; three internal trunks |
| `MST3-ACCESS-B.cfg` | Main-region access switch; three internal trunks |
| `MST4-DIST-B.cfg` | Main-region distribution switch; MSTI 2 root and boundary attachment |
| `MST5-BOUNDARY.cfg` | Restored boundary node configuration from the saved topology |

The temporary revision, mapping, name, MST0-priority, and Rapid-PVST+ changes are documented under [troubleshooting](../troubleshooting/) because they are experiments, not part of the final baseline.
