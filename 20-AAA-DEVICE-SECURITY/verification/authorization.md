# Command authorization for two administrator roles

Selected sessions compare netadmin entering configuration mode with nocuser receiving a configure-terminal denial. Both reach privilege 15; the difference is the specific server-side command rule.

**Quick navigation:** [Block 07](#block-07) · [Block 08](#block-08)

**Policy described in the handoff:** NETADMINS permits services by default, while NOC-RESTRICTED adds `cmd = configure { deny .* }`. Both groups receive EXEC privilege 15. The public server file is a reconstructed template from those supplied policy details; a comprehensive production read-only policy was not tested.

The IOS XE method list `aaa authorization commands 15 TAC-CMDS group ADMIN-SERVERS local` was defined and applied to VTY 0–4, as confirmed by running/startup configuration excerpts.

<a id="block-07"></a>

## Block 07 — netadmin permitted commands

**Selected captured `netadmin` SSH results:**

```text
cisco@ubuntu:~/src/tacacs-F4.0.4.32$ ssh netadmin@192.0.2.10
Password: [password not echoed]
R1-SEC#show privilege
Current privilege level is 15
R1-SEC#show running-config | include ^hostname
hostname R1-SEC
R1-SEC#conf t
Enter configuration commands, one per line.  End with CNTL/Z.
R1-SEC(config)#end
R1-SEC#
```

These demonstrate privileged commands working with the TACACS+ command authorization method list configured. Server-side accounting later corroborated execution of `show running-config` and `configure terminal` (see [accounting](accounting.md)).

<a id="block-08"></a>

## Block 08 — nocuser restricted command

**Selected captured `nocuser` SSH results:**

```text
cisco@ubuntu:~/src/tacacs-F4.0.4.32$ ssh nocuser@192.0.2.10
Password: [password not echoed]
R1-SEC#show privilege
Current privilege level is 15
R1-SEC#show running-config | include ^hostname
hostname R1-SEC
R1-SEC#configure terminal
Command authorization failed.
R1-SEC#
```

The contrast demonstrates that privilege 15 did **not** override TACACS+ command-level policy. The observed denial applies to `configure terminal`; the test did not prove all other configuration-impacting commands are disallowed.

[Verification matrix](README.md) · [Overview](../README.md) · [Configurations](../configs/README.md) · [Operation](../operation.md) · [Topology](../topology.md) · [Lessons learned](../lessons-learned.md) · [Evidence scope](../scope.md)
