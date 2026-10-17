# AAA and device security lessons learned

| Engineering distinction | What the lab established |
|---|---|
| Login versus EXEC authorization | A reported initial local login reached the user prompt; the retained correction and fresh SSH excerpts show local EXEC privilege 15 |
| Privilege versus command permission | netadmin and nocuser both reached privilege 15, while configure terminal succeeded for one and failed for the other |
| Configured policy versus policy scope | Named centralized lists were applied on VTY 0–4; other VTY lines retained default-local login/EXEC policies |
| Command authorization versus accounting | The NOC denial is an authorization result; server command `stop` records describe completed accounting events |
| Rejection versus unavailability | Online rescue SSH was rejected; local SSH privilege 15 succeeded when the TACACS+ process/listener was absent |
| Local access versus a proven method path | The outage session supports useful recovery access, but its unrecorded VTY slot cannot identify named-list fallback versus default-local policy |
| Daemon launch versus persistent service | Supplied setup diagnostics precede enabled/active systemd state and post-Ubuntu-reboot network/listener checks |
| Ubuntu persistence versus router reboot | Ubuntu reboot was checked; R1 startup policy was inspected without a router reboot test |
| Export labels versus guest names | Exported ens3/ens4 labels differ from observed NAT ens2/internal ens3; preserve relationships and verify mapping |
| Saved topology versus a complete server build | The YAML does not preserve installed TACACS+ software or its full runtime files; public templates are reconstructed setup material |

The strongest role comparison is the [captured command test](verification/authorization.md#block-08), supported by [server accounting records](verification/accounting.md#block-10). The configured NOC exception does not establish a complete read-only policy.

The [outage sequence](verification/failure-recovery.md#block-12) retains actual process/listener checks and successful local access. It does not capture a server FAIL/ERROR exchange or command fallback. The [Ubuntu reboot evidence](verification/persistence.md#block-17) and [router startup evidence](verification/startup.md#block-19) establish different persistence checks.

[Overview](README.md) · [Verification](verification/README.md) · [Configurations](configs/README.md) · [Operation](operation.md) · [Topology](topology.md) · [Evidence scope](scope.md)
