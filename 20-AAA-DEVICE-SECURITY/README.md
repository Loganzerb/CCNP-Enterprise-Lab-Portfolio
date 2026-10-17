# 20 — AAA and Device Security: Verify who can log in and what they can do

I configured centralized router administration using Cisco IOS XE and an Ubuntu TACACS+ server. Two accounts received **privilege level 15**, but their command permissions differed: `netadmin` entered configuration mode, while `nocuser` received **Command authorization failed**. Server-side accounting then connected an administrator session to the commands executed.

The lab also tested local recovery access during a TACACS+ outage, restoration of centralized authentication, and Ubuntu service persistence after reboot. This Cisco Modeling Labs exercise covers **CCNP ENCOR 350-401 v1.2, 5.1 — Configure and verify device access control**, with **5.1.a — Lines and local user authentication** and **5.1.b — Authentication and authorization using AAA** at the scope exercised.

**Quick navigation:** [Results](#recorded-results) · [Topology](#lab-design) · [AAA diagrams](operation.md) · [Configurations](configs/README.md) · [Verification matrix](verification/README.md) · [Outage and recovery](verification/failure-recovery.md) · [Evidence scope](scope.md)

## Recorded results

| Verification question | Recorded outcome |
|---|---|
| Did centralized authentication work? | The router's named-server-group test returned **User was successfully authenticated**; an administrator SSH session reached privilege **15** |
| Did roles differ beyond privilege level? | `netadmin` could enter configuration mode; `nocuser` could inspect hostname but was denied `configure terminal`, despite privilege **15** |
| Did accounting reach the server? | Four selected records show an EXEC start, accounting for `show running-config` and `configure terminal`, and an EXEC stop |
| What happened with the local-only recovery account? | SSH was rejected while TACACS+ was online; during the verified daemon/listener outage, local `rescue` SSH reached privilege **15** |
| Did centralized service return? | Named-server-group authentication succeeded after service restoration and again after Ubuntu reboot |
| Did Ubuntu retain its settings? | Internal **192.0.2.20/24**, NAT routing, enabled/active systemd service, and TCP **49** listener were present after reboot; Ubuntu-to-router ping succeeded **4/4** |
| Was the router's configuration saved? | Startup output retained the AAA method lists and VTY assignments; the router itself was **not reboot-tested** |

The [verification guide](verification/README.md) retains the supplied selected excerpts from October 17, 2026, with original numbered Blocks. The exact VTY slot used by the rejection and outage SSH sessions was not recorded. The observations are consistent with the configured fallback design, but do not independently identify the method-list path or a TACACS+ FAIL/ERROR transaction.

## Lab design

![CML NAT connector, Ubuntu TACACS+ server, and CSR1000v management link](topology.svg)

[PNG copy](topology.png) · [Original CML screenshot](verification/cml-workbench-capture.png) · [Addresses and wiring](topology.md) · [Sanitized CML export](CML-LAB.yaml)

R1-SEC uses CSR1000v / IOS XE **17.3.2** and Gi1 **192.0.2.10/24**. AAA-SERVER runs Ubuntu **20.04.2 LTS** with Shrubbery `tac_plus` **F4.0.4.32**, listening at **192.0.2.20:49**. The separate NAT connection supplied Ubuntu package access.

The exported Ubuntu labels are **ens3 / ens4**; the guest observed **ens2 for NAT / ens3 for the internal network**. The public export preserves the original graph, and the [wiring guide](topology.md) documents both naming views.

## Implementation approach

| Component | Engineering purpose |
|---|---|
| Local account and SSH | Establish local administrative access and retain a recovery account |
| Login authentication | Use the named TACACS+ group with a local alternative on the explicitly assigned VTY lines |
| EXEC authorization | Request the administrator's shell privilege separately from login authentication |
| Command authorization | Permit or deny selected privilege-15 commands according to the server policy |
| Accounting | Send EXEC and command records to Ubuntu for independent inspection |
| Netplan and systemd | Retain server addressing and restore the daemon after Ubuntu reboot |

Named centralized login, EXEC, command, and accounting lists are assigned to **VTY 0–4**. **VTY 5–156** retains the default local login/EXEC policies and SSH transport. This difference is part of the saved lab configuration; centralized policy was not assigned uniformly across every VTY.

## Engineering interpretation

Authentication, EXEC authorization, command authorization, and accounting answer different questions. Reaching privilege 15 did not give both server accounts identical command access. The accounting records provide server-side evidence of activity, separate from an enabled accounting configuration.

The NOC policy denies `configure` while permitting other services by default. It demonstrates a targeted command restriction, not a comprehensive read-only policy. Likewise, the observed online recovery-account rejection is consistent with a server denial, but the actual rejection transaction was not captured. [Authorization evidence](verification/authorization.md) · [Recovery boundaries](verification/failure-recovery.md)

## Reuse and remaining testing

The public export removes credentials, hashes, generated PKI, and device-specific identifiers. Ubuntu's installed TACACS+ software and runtime configuration files are not embedded in the CML export; the [configuration guide](configs/README.md) distinguishes saved extracts, supplied server files, and reconstructed templates. Populate private credentials before reuse and verify the guest interface mapping.

A fresh import and execution of the sanitized lab remains pending. Ubuntu reboot evidence and saved router configuration do not establish a router reboot result. [Setup observations](verification/setup-observations.md) · [Persistence evidence](verification/persistence.md) · [Lessons learned](lessons-learned.md)

[Back to portfolio](../README.md)
