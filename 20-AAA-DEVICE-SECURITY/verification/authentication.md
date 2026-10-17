# Authentication and EXEC privilege

The record separates local SSH recovery, local EXEC authorization, a direct TACACS+ test, and a real netadmin SSH session. Successful login and the resulting privilege are checked separately.

**Quick navigation:** [Block 03](#block-03) · [Block 04](#block-04) · [Block 05](#block-05) · [Block 06](#block-06)

<a id="block-03"></a>

## Block 03 — SSH server and local user

**Selected R1 output:**

```text
R1-SEC#show ip ssh
SSH Enabled - version 2.0
Authentication methods:publickey,keyboard-interactive,password
```

**Actual local SSH login test from Ubuntu after the AAA configuration was corrected:**

```text
cisco@ubuntu:~$ ssh rescue@192.0.2.10
Password: [password not echoed]
R1-SEC#show privilege
Current privilege level is 15
```

The saved router configuration contained a local `rescue` user at privilege level 15, but its Type 9 password verifier is **not reproduced** in the public files. `transport input ssh` was verified across the VTY ranges.

<a id="block-04"></a>

## Block 04 — Local EXEC authorization correction

The source package reports that an initial local SSH session reached `R1-SEC>` instead of privileged EXEC. After `aaa authorization exec default local` was applied, the supplied correction and fresh-session excerpts show the local EXEC result.

**Captured configuration after correction:**

```cisco
R1-SEC#show running-config | include ^aaa
aaa new-model
aaa authentication login default local
aaa authorization exec default local
aaa session-id common
```

**Captured result:**

```text
cisco@ubuntu:~$ ssh rescue@192.0.2.10
Password: [password not echoed]
R1-SEC#show privilege
Current privilege level is 15
```

This is a valuable configuration-and-verification example: successful login alone does not prove the resulting EXEC privilege.

<a id="block-05"></a>

## Block 05 — Direct TACACS+ authentication test

After defining TAC1, the `ADMIN-SERVERS` group, and TAC-LOGIN, R1 ran a direct group authentication test. The password argument is redacted below.

```text
R1-SEC#test aaa group ADMIN-SERVERS netadmin [REDACTED] legacy
Attempting authentication test to server-group ADMIN-SERVERS using tacacs+
User was successfully authenticated.
```

The same command later succeeded after service restoration and after Ubuntu reboot (see [failure/recovery](failure-recovery.md) and [persistence](persistence.md)).

<a id="block-06"></a>

## Block 06 — netadmin SSH and privileged EXEC

**Captured SSH session.** Named login and EXEC authorization lists were configured on VTY 0–4; the excerpt does not identify this session's exact VTY slot.

```text
cisco@ubuntu:~/src/tacacs-F4.0.4.32$ ssh netadmin@192.0.2.10
Password: [password not echoed]
R1-SEC#show privilege
Current privilege level is 15
```

The source CML router configuration shows only local `rescue`, not a local `netadmin`. That fact together with the successful TACACS+ test and SSH session provides strong evidence of centrally authenticated login and the intended privilege authorization; independent wire-level transaction evidence was not supplied.

[Verification matrix](README.md) · [Overview](../README.md) · [Configurations](../configs/README.md) · [Operation](../operation.md) · [Topology](../topology.md) · [Lessons learned](../lessons-learned.md) · [Evidence scope](../scope.md)
