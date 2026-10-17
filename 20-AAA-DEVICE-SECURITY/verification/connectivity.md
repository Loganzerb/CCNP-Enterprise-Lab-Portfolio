# Connectivity before AAA testing

The selected excerpts establish R1 interface state, Ubuntu addressing, internal reachability, and NAT access used for server setup. Exported Ubuntu interface labels differ from the guest names: the export uses ens3/ens4, while the guest observed NAT on ens2 and the internal network on ens3. Preserve the exported graph and verify guest mapping separately.

**Quick navigation:** [Block 01](#block-01) · [Block 02](#block-02)

<a id="block-01"></a>

## Block 01 — Router and Ubuntu Layer 3

**Captured on R1-SEC after addressing:**

```text
R1-SEC#show ip interface brief
Interface              IP-Address      OK? Method Status                Protocol
GigabitEthernet1       192.0.2.10      YES manual up                    up
GigabitEthernet2       unassigned      YES unset  administratively down down
GigabitEthernet3       unassigned      YES unset  administratively down down
GigabitEthernet4       unassigned      YES unset  administratively down down
```

**Captured on Ubuntu after persistent Netplan settings were applied (selected interface lines):**

```text
ens2    UP    192.168.255.110/24
ens3    UP    192.0.2.20/24
```

The full terminal output contained IPv6 link-local addresses and some accidentally pasted text on the `ens3` line; this excerpt retains the verified IPv4 interface settings. **Captured ping summary:**

```text
--- 192.0.2.10 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3006ms
rtt min/avg/max/mdev = 0.791/0.993/1.418/0.255 ms
```

The source package reports an initial router-to-Ubuntu result of **3/5 (60%)**; that initial ping transcript is not retained here. The supplied Ubuntu-to-router summary then shows 4/4. The reason for the two initial missed replies was not isolated.

<a id="block-02"></a>

## Block 02 — Ubuntu NAT and package availability

**Captured network route:**

```text
default via 192.168.255.1 dev ens2 proto dhcp src 192.168.255.110 metric 100
192.0.2.0/24 dev ens3 proto kernel scope link src 192.0.2.20
192.168.255.0/24 dev ens2 proto kernel scope link src 192.168.255.110
```

**Captured external ping and Ubuntu repository test summaries:**

```text
--- 1.1.1.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3005ms
rtt min/avg/max/mdev = 32.127/38.100/48.154/6.203 ms

Fetched 35.4 MB in 8s (4365 kB/s)
Reading package lists... Done
```

DNS lookup for `archive.ubuntu.com` also returned addresses; the recorded output displayed IPv6 results. These records support the successful package installation performed later. [Build and daemon status](setup-observations.md).

[Verification matrix](README.md) · [Overview](../README.md) · [Configurations](../configs/README.md) · [Operation](../operation.md) · [Topology](../topology.md) · [Lessons learned](../lessons-learned.md) · [Evidence scope](../scope.md)
