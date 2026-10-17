# AAA configuration and source boundaries

The [sanitized CML export](../CML-LAB.yaml) preserves the original three nodes, images, interfaces, and two links. [R1-SEC.cfg](R1-SEC.cfg) is an exact extract of its sanitized router configuration. Relevant router commands are retained from the full original export; the file is not a newly captured running configuration.

The YAML does **not** contain the installed Ubuntu `tac_plus` binary or its runtime policy, Netplan, systemd unit, logs, or service state. Those materials have separate provenance:

| Artifact | Source and use |
|---|---|
| [R1-SEC.cfg](R1-SEC.cfg) | Full original router configuration after removal of credentials, shared key, PKI, device identifiers, and generated boilerplate |
| [tac_plus.conf](tac_plus.conf) | **Reconstructed template** from the supplied group/user policy summary; not a captured complete server file |
| [ubuntu-netplan.yaml](ubuntu-netplan.yaml) | Supplied internal-address file for the guest-observed `ens3` interface |
| [tac_plus.service](tac_plus.service) | Supplied systemd unit; its original service was verified after Ubuntu reboot |
| [Ubuntu reproduction guide](ubuntu-setup.md) | Instructions for separate server installation and local setup; not a fresh execution record |

## Preserve the two VTY scopes

| Scope | Saved policy |
|---|---|
| Default login / EXEC authorization | Local database |
| VTY 0–4 | Named TACACS+ login, EXEC authorization, privilege-15 command authorization, and EXEC/command accounting lists |
| VTY 5–156 | SSH transport with the local default login and EXEC policies; no named TACACS+ lists applied |
| TACACS+ source and destination | R1 Gi1, `192.0.2.10`, to server `192.0.2.20:49` |

**Selected saved configuration — not terminal output.**

```cisco
aaa authentication login default local
aaa authentication login TAC-LOGIN group ADMIN-SERVERS local
aaa authorization exec default local
aaa authorization exec TAC-EXEC group ADMIN-SERVERS local
aaa authorization commands 15 TAC-CMDS group ADMIN-SERVERS local
aaa accounting exec TAC-EXEC-ACCT start-stop group ADMIN-SERVERS
aaa accounting commands 15 TAC-CMD-ACCT start-stop group ADMIN-SERVERS
```

The named lists apply only where the saved VTY configuration references them. This exercise does not demonstrate centrally enforced AAA on every VTY. The NOC policy also has a specific `configure` denial with a default-permit policy; it is not a comprehensive read-only policy.

## Prepare a private copy before use

These are reproduction steps, not additional observations.

1. Prepare private Ubuntu cloud-init access and a local privilege-15 recovery account on R1. The public files omit the source passwords/hashes and router account commands. Add your own enable secret and matching router/server TACACS+ shared key in the private copies. Keep the CML console available during setup.
2. Generate fresh router SSH key and certificate material appropriate to the image. The source PKI identity has been removed. Retained HTTP/HTTPS, local HTTP authentication, SSH2, AAA, and VTY settings have not been silently hardened or extended.
3. Follow [Ubuntu setup](ubuntu-setup.md), including checking actual guest interface names before applying the supplied Netplan file. Replace and enable the commented credential/user stanzas in the reconstructed TACACS+ template locally; no active placeholder password or shared key is provided.
4. Verify client/server reachability, the TCP 49 listener, authentication, both authorization roles, accounting, and the controlled outage/recovery sequence against the [original evidence](../verification/README.md).

The original Ubuntu reboot results and inspected router startup configuration are documented separately. The sanitized YAML and reconstructed policy template have not been freshly imported, booted, parsed by `tac_plus`, or rerun during this packaging work. No router reboot test is claimed.

## Sanitization

Removed categories include router local credentials, TACACS+ shared key, complete PKI trustpoint/certificate blocks, a license/device identifier, call-home configuration, generated display headers/comments, and Ubuntu cloud-init password/hash fields. No usable replacement credential was inserted. All original node/image/interface/link metadata and retained router commands remain intact.

[Overview](../README.md) · [Topology](../topology.md) · [Operation](../operation.md) · [Verification](../verification/README.md) · [Evidence scope](../scope.md)
