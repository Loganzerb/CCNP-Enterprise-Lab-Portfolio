# AAA and device security scope and evidence provenance

This October 17, 2026 CML exercise addresses ENCOR 5.1.a and 5.1.b through local device administration and TACACS+ authentication, EXEC authorization, command authorization, and accounting. The supplied record also includes a controlled server outage and Ubuntu reboot validation.

**Quick navigation:** [Sources](#sources) · [Control and test boundaries](#control-and-test-boundaries) · [Topology and reproduction](#topology-and-reproduction) · [Public export](#public-export)

## Sources

| Material | Source and interpretation |
|---|---|
| Verification Blocks 01–20 | Selected supplied excerpts recovered from the earlier review package, checked against the October 17 handoff; timestamps, task IDs, and accounting records are retained |
| Original CML export | User-supplied three-node, two-link topology with embedded router configuration and Ubuntu cloud-init; held privately and sanitized for publication |
| Server policy and persistence files | The TACACS+ policy is a reconstructed template from supplied policy details; Netplan and systemd files reproduce supplied snippets. These are not an export of the installed Ubuntu filesystem |
| Diagrams and reproduction instructions | Explanations of the saved graph and supplied record, not new execution results |

The recovered excerpts were already selected, redacted, and editorially formatted. Some prompts and interface output were normalized; the pages identify those adjustments. The full original terminal transcript, complete accounting file, and TACACS+ packet trace were not independently retrieved. No missing output has been generated.

## Control and test boundaries

Authentication, EXEC authorization, command authorization, and accounting are separate checks. Both administrator roles reached privilege 15; the NOC rule specifically denied configure while permitting other services by default. It was a granular lab policy, not a comprehensive read-only or least-privilege profile.

Named TACACS+ lists apply to VTY 0–4. VTY 5–156 retains default-local login/EXEC policies. Online rescue rejection is consistent with centralized rejection, but no matching server FAIL transaction or exact VTY slot was captured. During verified daemon/listener unavailability, rescue obtained local SSH access and privilege 15. That is consistent with configured fallback; the unrecorded slot does not establish that the named login/EXEC lists handled the session. No TACACS+ ERROR packet or command-authorization fallback result is claimed.

The accounting lines record EXEC start/termination and completed command entries. Command `stop` markers are accounting record types, not authorization denials. The approximately five-second session value describes that record, without establishing a latency or performance benchmark.

Ubuntu was reboot-tested, with subsequent network, service, listener, ping, and router authentication excerpts. The router's startup AAA and VTY settings were inspected; the router itself was not reboot-tested. RADIUS, 802.1X, and a broader hardening or exhaustive command-policy test are outside the exercised scope.

## Topology and reproduction

The graph has a CSR1000v router, Ubuntu server, and NAT connector, with two links. The export labels Ubuntu interfaces ens3/ens4; the guest observed NAT on ens2 and the internal network on ens3. Preserve the exported node/link relationships and verify guest mapping rather than silently equating the two label sets.

The CML export does not contain the installed TACACS+ software or complete runtime configuration files. The public server configuration files and [setup guide](configs/README.md) describe that missing guest setup. A fresh sanitized import, boot, and end-to-end AAA run has not been performed during portfolio preparation. Original Ubuntu reboot evidence does not establish reproduction of the sanitized export.

## Public export

The original credentials, account hashes, shared key values, generated PKI material, and device identifiers must remain outside the public module. Sensitive values in supplied excerpts are redacted. Public configuration placeholders require local replacement before use; they are not working access settings.

[Overview](README.md) · [Configurations](configs/README.md) · [Verification](verification/README.md) · [Operation](operation.md) · [Topology](topology.md) · [Lessons learned](lessons-learned.md)
