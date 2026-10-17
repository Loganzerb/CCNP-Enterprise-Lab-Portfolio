# AAA and device security verification guide

The October 17, 2026 CML record connects authentication, EXEC privilege, command authorization, server-side accounting, server-outage access, and Ubuntu persistence. The pages preserve the recovered package's selected excerpts and original Block IDs, with stable short anchors.

**Quick navigation:** [Task-to-evidence matrix](#task-to-evidence-matrix) · [Read the evidence](#read-the-evidence)

## Task-to-evidence matrix

| Task | Supporting blocks | Recorded result |
|---|---|---|
| Verify internal and NAT connectivity | [01](connectivity.md#block-01), [02](connectivity.md#block-02) | R1 Gi1 up/up; guest addressing/routes; Ubuntu internal and external ping summaries 4/4 |
| Separate login from EXEC authorization | [03](authentication.md#block-03), [04](authentication.md#block-04) | SSH 2.0 and local recovery access; corrected local EXEC policy followed by privilege 15 |
| Verify centralized authentication | [05](authentication.md#block-05), [06](authentication.md#block-06) | Successful TACACS+ group test and netadmin SSH privilege 15 |
| Compare command permissions | [07](authorization.md#block-07), [08](authorization.md#block-08) | netadmin enters configuration mode; nocuser is denied configure terminal despite privilege 15 |
| Verify received accounting records | [09](accounting.md#block-09), [10](accounting.md#block-10) | Client actions and selected server EXEC start/stop and command records |
| Compare rejection with unavailability | [11](failure-recovery.md#block-11), [12](failure-recovery.md#block-12), [13](failure-recovery.md#block-13) | Online rescue rejection; verified daemon/listener outage; local SSH privilege 15 during outage, with VTY path unrecorded |
| Verify service restoration | [14](failure-recovery.md#block-14) | Router TACACS+ authentication test succeeds again |
| Check server build and service state | [15](setup-observations.md#block-15), [16](setup-observations.md#block-16) | Supplied source-check, dependency/parser results, and enabled/active systemd service |
| Check Ubuntu reboot persistence | [17](persistence.md#block-17), [18](persistence.md#block-18) | Post-reboot network/listener/service and 4/4 ping; router authentication succeeds afterward |
| Inspect saved router policy and platform | [19](startup.md#block-19), [20](startup.md#block-20) | Startup AAA/VTY settings and IOS XE 17.3.2; no router reboot test |

## Read the evidence

These are selected, redacted excerpts from the recovered review package and the user's lab handoff. Some prompts, spacing, or selected interface lines were normalized in that package; omissions are described locally. The full original terminal transcript and accounting file were not independently retrieved. Blocks can overlap in selected content and are not twenty independent test runs.

The [supplied CML workbench capture](cml-workbench-capture.png) provides node and link context for the recorded environment.

Named centralized policies are configured on VTY 0–4; VTY 5–156 retains default-local login/EXEC policies. The online rejection has no captured server-side FAIL transaction. The outage session proves local access with the server unavailable, but its unrecorded VTY slot prevents assigning the exact named-method path. No command fallback test is claimed.

[Overview](../README.md) · [Configurations](../configs/README.md) · [Operation](../operation.md) · [Topology](../topology.md) · [Lessons learned](../lessons-learned.md) · [Evidence scope](../scope.md)
