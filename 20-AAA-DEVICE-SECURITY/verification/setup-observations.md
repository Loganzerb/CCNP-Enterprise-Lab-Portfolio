# Server setup and dependency observations

The supplied package retains source-check, shared-library, parser, and systemd observations from the original setup. These are selected historical excerpts, not a fresh installation or reproduction run.

**Quick navigation:** [Block 15](#block-15) · [Block 16](#block-16)

<a id="block-15"></a>

## Block 15 — Software installed and validated

The supplied lab record reports downloading `tacacs-F4.0.4.32.tar.gz` and checking SHA-256 before extraction. Its retained check output is:

```text
tacacs-F4.0.4.32.tar.gz: OK
```

No reference digest is retained with this excerpt. The `archive: OK` outcome does not independently establish the expected digest or upstream authenticity.

Source was compiled after installing `build-essential`, `wget`, `flex`, `bison`, and `libwrap0-dev`. A libtool wrapper of 6.2 KB was distinguished from a real ELF server executable of 456 KB.

**Captured diagnostic and correction:**

```text
/usr/local/sbin/tac_plus: error while loading shared libraries: libtacacs.so.1: cannot open shared object file: No such file or directory

cisco@ubuntu:~$ sudo ldconfig
cisco@ubuntu:~$ ldd /usr/local/sbin/tac_plus | grep -E 'libtacacs|not found'
libtacacs.so.1 => /usr/local/lib/libtacacs.so.1 (0x00007ff434c91000)

cisco@ubuntu:~$ /usr/local/sbin/tac_plus -v
tac_plus version F4.0.4.32
```

(The `cisco@ubuntu:~$` prompt is normalized from a longer build-directory path; addresses/results are copied from the supplied output.)

**Captured TACACS+ config parser result:**

```text
Parser exit code: 0
```

This was checked after creating the initial admin policy and again after adding `NOC-RESTRICTED` and `nocuser`.

<a id="block-16"></a>

## Block 16 — Systemd running

**Captured after `sudo systemctl enable tac_plus.service` and starting the service under systemd:**

```text
cisco@ubuntu:~$ systemctl is-enabled tac_plus.service
enabled
cisco@ubuntu:~$ systemctl is-active tac_plus.service
active

● tac_plus.service - Shrubbery TACACS+ Server - CCNP Lab
     Loaded: loaded (/etc/systemd/system/tac_plus.service; enabled; vendor preset: enabled)
     Active: active (running) since Sat 2026-10-17 18:24:39 UTC; 5s ago
   Main PID: 10940 (tac_plus)
     CGroup: /system.slice/tac_plus.service
             └─10940 /usr/local/sbin/tac_plus -G -C /etc/tacacs/tac_plus.conf -B 192.0.2.20
```

A later `ss` check showed the daemon listening at `192.0.2.20:49`; post-reboot startup is verified in [persistence](persistence.md). The `systemd-analyze verify` run reported an unrelated Ubuntu `dbus.socket` legacy path warning, not a TACACS+ service-definition error.

[Verification matrix](README.md) · [Overview](../README.md) · [Configurations](../configs/README.md) · [Operation](../operation.md) · [Topology](../topology.md) · [Lessons learned](../lessons-learned.md) · [Evidence scope](../scope.md)
