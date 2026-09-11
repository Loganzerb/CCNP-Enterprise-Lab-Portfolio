# Configuration artifacts

The original incident YAMLs are unchanged fault labs. The `*-final.cfg` files are portfolio reconstructions: each starts with that incident's exported configuration and applies only repairs supported by the lab record. They are not newly captured running configurations, and this portfolio build did not boot or change any devices.

## Choose the right state

| State | Files | Meaning |
|---|---|---|
| Incident 01, repaired dynamic NAT | `incident-01-NAT-EDGE-final.cfg` and `incident-01-ISP-final.cfg` | Two-address pool without overload; subnet ACL; inside role restored; ISP pool return route restored. |
| Incident 02, final clean interface PAT | `incident-02-NAT-EDGE-final.cfg` and `incident-02-ISP-final.cfg` | Both clients share Gi0/0; one-entry limit removed; unreferenced DYNAMIC-NAT pool removed from the deliverable. |
| Guided alternatives | `guided-mode-snippets.cfg` | Separate reference modes and their routing requirements, not a file to paste in full. |

The two final NAT modes are separate snapshots; they should not be combined. Clients, switch, and server remain available in each original YAML. Incident 02's ISP configuration is preserved unchanged, including the existing route to `192.0.2.0/24`. That route was not a PAT root cause and was outside the requested NAT-EDGE cleanup.

## Exact change scope

Incident 01: add `ip nat inside` on Gi0/1; expand the pool's ending address from `.10` to `.11`; replace the host-only ACL permit with the subnet permit; add the ISP return route. The temporary misspelled pool appeared during repair, not in the original export or corrected final file.

Incident 02: replace Gi0/1 with Gi0/0 in the overload statement; remove `ip nat translation max-entries 1`; remove the now-unreferenced `DYNAMIC-NAT` pool. All other exported configuration lines remain intact. The captured final CLI still includes that pool; its removal is editorial cleanup in the delivered configuration, not an additional observed device change.

The `.diff` files make these boundaries reviewable. Introductory provenance comments in the final `.cfg` files are not device changes and are excluded from the diffs.

For lab reuse, import the appropriate original fault YAML into a separate CML lab and apply the relevant documented repairs. Capture fresh verification after applying changes and save on the devices. No save confirmation or new CML execution is claimed by these files.
