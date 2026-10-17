# TACACS+ rejection, unavailability, and recovery

The record compares an online rescue rejection, a verified server outage, successful local access during that outage, and restored centralized authentication. The exact VTY slot was not captured, so the named-list path remains bounded.

**Quick navigation:** [Block 11](#block-11) · [Block 12](#block-12) · [Block 13](#block-13) · [Block 14](#block-14)

The test VTY 0–4 method lists were:

```cisco
aaa authentication login TAC-LOGIN group ADMIN-SERVERS local
aaa authorization exec TAC-EXEC group ADMIN-SERVERS local
```

<a id="block-11"></a>

## Block 11 — Online rescue login rejected

Prior to the test, R1 showed only the console in use:

```text
R1-SEC#show users
    Line       User       Host(s)              Idle       Location
*  0 con 0     rescue     idle                 00:00:00
```

While `tac_plus` was online, Ubuntu attempted SSH using the local-only `rescue` account. The relevant captured result was:

```text
cisco@ubuntu:~/src/tacacs-F4.0.4.32$ ssh rescue@192.0.2.10
Password: [entered; not echoed]
Password: [entered; not echoed]
Password: [entered; not echoed]
rescue@192.0.2.10's password: [entered; not echoed]
Connection closed by 192.0.2.10 port 22
```

**Evidence limit:** This is an observed remote authentication rejection and is consistent with an explicit TACACS+ FAIL. The actual TACACS+ server-side `FAIL` transaction and VTY slot used were **not separately captured**, so they are not claimed as proved. The user pasted some prompts into the Linux shell afterward, generating unrelated shell errors; those are omitted.

<a id="block-12"></a>

## Block 12 — TACACS+ service stopped

**Captured Ubuntu test:**

```text
cisco@ubuntu:~/src/tacacs-F4.0.4.32$ sudo kill -TERM "$(pgrep -xo tac_plus)"
cisco@ubuntu:~/src/tacacs-F4.0.4.32$ pgrep -af tac_plus
cisco@ubuntu:~/src/tacacs-F4.0.4.32$ sudo ss -ltnp | grep ':49' || echo "TACACS+ listener stopped"
TACACS+ listener stopped
```

This independently verifies that the TACACS+ daemon was unavailable for the subsequent login.

<a id="block-13"></a>

## Block 13 — Local rescue access during the outage

**Captured Ubuntu SSH test during the outage:**

```text
cisco@ubuntu:~/src/tacacs-F4.0.4.32$ ssh rescue@192.0.2.10
Password: [password not echoed]
R1-SEC#show privilege
Current privilege level is 15
```

The excerpt establishes successful local SSH access and privilege 15 during verified TACACS+ unavailability. It is consistent with the configured login/EXEC fallback, but the exact VTY slot was not recorded. VTY 5–156 also used default-local login/EXEC policies, so this capture does not independently identify the named TAC-LOGIN/TAC-EXEC path. No command-authorization fallback result or TACACS+ ERROR transaction was captured.

<a id="block-14"></a>

## Block 14 — Centralized authentication restored

The daemon was restarted, and R1 again returned:

```text
R1-SEC#test aaa group ADMIN-SERVERS netadmin [REDACTED] legacy
Attempting authentication test to server-group ADMIN-SERVERS using tacacs+
User was successfully authenticated.
```

This successful test preceded the separately captured post-Ubuntu-reboot authentication test in [persistence](persistence.md).

[Verification matrix](README.md) · [Overview](../README.md) · [Configurations](../configs/README.md) · [Operation](../operation.md) · [Topology](../topology.md) · [Lessons learned](../lessons-learned.md) · [Evidence scope](../scope.md)
