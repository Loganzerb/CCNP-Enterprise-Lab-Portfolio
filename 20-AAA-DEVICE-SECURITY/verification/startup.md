# Router platform and saved AAA policies

The startup-configuration excerpts retain the saved method lists and VTY assignments. Platform output identifies IOS XE 17.3.2. These checks do not establish a router reboot test.

**Quick navigation:** [Block 19](#block-19) · [Block 20](#block-20)

<a id="block-19"></a>

## Block 19 — Saved AAA and VTY policies

**Captured R1 startup-configuration excerpt:**

```cisco
R1-SEC#show startup-config | include ^aaa
aaa new-model
aaa group server tacacs+ ADMIN-SERVERS
aaa authentication login default local
aaa authentication login TAC-LOGIN group ADMIN-SERVERS local
aaa authorization exec default local
aaa authorization exec TAC-EXEC group ADMIN-SERVERS local
aaa authorization commands 15 TAC-CMDS group ADMIN-SERVERS local
aaa accounting exec TAC-EXEC-ACCT start-stop group ADMIN-SERVERS
aaa accounting commands 15 TAC-CMD-ACCT start-stop group ADMIN-SERVERS
aaa session-id common
```

**Captured saved VTY assignments:**

```cisco
R1-SEC#show startup-config | section line vty
line vty 0 4
 authorization commands 15 TAC-CMDS
 authorization exec TAC-EXEC
 accounting commands 15 TAC-CMD-ACCT
 accounting exec TAC-EXEC-ACCT
 login authentication TAC-LOGIN
 transport input ssh
line vty 5 156
 transport input ssh
```

These outputs independently establish the policy entries in the **startup** configuration. No router reboot was shown. In this lab, VTY 5–156 uses the global default local login and EXEC authorization lists; that arrangement was maintained as a recovery path.

<a id="block-20"></a>

## Block 20 — Router version

**Captured platform output:**

```text
R1-SEC#show version | include IOS XE|Version|uptime
Cisco IOS XE Software, Version 17.03.02
Cisco IOS Software [Amsterdam], Virtual XE Software (X86_64_LINUX_IOSD-UNIVERSALK9-M), Version 17.3.2, RELEASE SOFTWARE (fc3)
R1-SEC uptime is 2 hours, 2 minutes
```

The original filtered output also included several GNU GPL text lines because they contained the word `Version`. Only platform/version/uptime lines are retained here.

[Verification matrix](README.md) · [Overview](../README.md) · [Configurations](../configs/README.md) · [Operation](../operation.md) · [Topology](../topology.md) · [Lessons learned](../lessons-learned.md) · [Evidence scope](../scope.md)
