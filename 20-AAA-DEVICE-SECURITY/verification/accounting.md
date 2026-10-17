# Server-side EXEC and command accounting

The client transcript and four selected Ubuntu accounting lines connect session activity to records received by the TACACS+ server. The accounting records are supplied excerpts, not newly generated logs.

**Quick navigation:** [Block 09](#block-09) · [Block 10](#block-10)

R1-SEC configured:

```cisco
aaa accounting exec TAC-EXEC-ACCT start-stop group ADMIN-SERVERS
aaa accounting commands 15 TAC-CMD-ACCT start-stop group ADMIN-SERVERS
```

Both accounting lists were applied under `line vty 0 4`, confirmed by captured running/startup outputs.

<a id="block-09"></a>

## Block 09 — Client-generated actions

**Selected user-supplied SSH transcript:**

```text
cisco@ubuntu:~/src/tacacs-F4.0.4.32$ ssh netadmin@192.0.2.10
Password: [password not echoed]
R1-SEC#show privilege
Current privilege level is 15
R1-SEC#show running-config | include ^hostname
hostname R1-SEC
R1-SEC#configure terminal
Enter configuration commands, one per line.  End with CNTL/Z.
R1-SEC(config)#end
R1-SEC#exit
Connection to 192.0.2.10 closed by remote host.
Connection to 192.0.2.10 closed.
```

<a id="block-10"></a>

## Block 10 — TACACS+ server accounting file

**Captured on Ubuntu; selected full accounting lines as provided:**

```text
Oct 17 18:09:13 192.0.2.10      netadmin        tty1    192.0.2.20      start   task_id=4009    timezone=UTC    service=shell
Oct 17 18:09:18 192.0.2.10      netadmin        tty1    192.0.2.20      stop    task_id=4009    timezone=UTC    service=shell   priv-lvl=15     cmd=show running-config <cr>
Oct 17 18:09:18 192.0.2.10      netadmin        tty1    192.0.2.20      stop    task_id=4010    timezone=UTC    service=shell   priv-lvl=15     cmd=configure terminal <cr>
Oct 17 18:09:18 192.0.2.10      netadmin        tty1    192.0.2.20      stop    task_id=4009    timezone=UTC    service=shell   disc-cause=1    disc-cause-ext=9        pre-session-time=2      elapsed_time=5  stop_time=1792260558
```

**Interpretation:** `start` and the last `stop` record show the EXEC session's lifecycle. The two intermediate `stop` records identify completed command accounting entries, **not authorization denials**. The log records command names as shown; it does not retain the full `show running-config | include ^hostname` pipeline.

These selected server-side lines establish received accounting records in addition to configured intent. The full original accounting file was not independently retrieved. `elapsed_time=5` describes this session; it is not a performance benchmark.

[Verification matrix](README.md) · [Overview](../README.md) · [Configurations](../configs/README.md) · [Operation](../operation.md) · [Topology](../topology.md) · [Lessons learned](../lessons-learned.md) · [Evidence scope](../scope.md)
