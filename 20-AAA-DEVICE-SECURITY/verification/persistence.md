# Ubuntu reboot persistence

Post-reboot excerpts check Ubuntu addresses, routes, service state, TCP 49, router reachability, and subsequent centralized authentication. This reboot test applies to Ubuntu; router startup configuration is assessed separately.

**Quick navigation:** [Block 17](#block-17) · [Block 18](#block-18)

<a id="block-17"></a>

## Block 17 — Post-Ubuntu-reboot state

**Captured after executing `sudo reboot` on the Ubuntu CML node:**

```text
cisco@inserthostnamehere:~$ ip -br addr
lo      UNKNOWN  127.0.0.1/8 ::1/128
ens2    UP       192.168.255.110/24
ens3    UP       192.0.2.20/24

cisco@inserthostnamehere:~$ ip route
default via 192.168.255.1 dev ens2 proto dhcp src 192.168.255.110 metric 100
192.0.2.0/24 dev ens3 proto kernel scope link src 192.0.2.20
192.168.255.0/24 dev ens2 proto kernel scope link src 192.168.255.110

cisco@inserthostnamehere:~$ systemctl is-enabled tac_plus.service
enabled
cisco@inserthostnamehere:~$ systemctl is-active tac_plus.service
active
cisco@inserthostnamehere:~$ sudo ss -ltnp | grep ':49'
LISTEN    0    4096    192.0.2.20:49    0.0.0.0:*    users:(("tac_plus",pid=600,fd=4))
```

The original pasted `ip -br addr` line contained stray terminal-paste characters; this excerpt normalizes its spacing and preserves the verified IPv4 facts corroborated by the route table and pings. The new process ID after reboot is consistent with fresh startup.

**Captured post-reboot router reachability:**

```text
--- 192.0.2.10 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3005ms
rtt min/avg/max/mdev = 0.752/1.182/2.371/0.687 ms
```

<a id="block-18"></a>

## Block 18 — Post-reboot router authentication

**Captured on R1 after Ubuntu restarted:**

```text
R1-SEC#test aaa group ADMIN-SERVERS netadmin [REDACTED] legacy
Attempting authentication test to server-group ADMIN-SERVERS using tacacs+
User was successfully authenticated.
```

The tests establish **Ubuntu** address and daemon persistence plus a subsequent centralized authentication response. The R1 router itself was not rebooted for this validation; R1 startup-configuration evidence is separate in [startup.md](startup.md).

[Verification matrix](README.md) · [Overview](../README.md) · [Configurations](../configs/README.md) · [Operation](../operation.md) · [Topology](../topology.md) · [Lessons learned](../lessons-learned.md) · [Evidence scope](../scope.md)
