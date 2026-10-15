# Connectivity and management services

R1-AUTOMATION and the Alpine client share the management subnet. These excerpts establish the client address, one-direction reachability, management-service state, and the TLS session used for the HTTPS exchanges.

**Quick navigation:** [Client and connectivity](#client-and-connectivity) · [NETCONF service](#netconf-service) · [HTTPS and TLS](#https-and-tls)

## Client and connectivity

<a id="block-01"></a>

### Block 01 — Linux addressing, route, and available clients

**Captured Linux excerpts.** eth0 is up with `192.0.2.20/24` and a connected route. SSH and OpenSSL have executable paths. The empty `command -v curl` and `command -v python3` results establish no matching PATH entry at that time, rather than proving those tools were uninstalled.

```text
inserthostname_here:~$ ip addr show dev eth0
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    inet 192.0.2.20/24 scope global eth0
       valid_lft forever preferred_lft forever
inserthostname_here:~$ ip route show
192.0.2.0/24 dev eth0 scope link  src 192.0.2.20

inserthostname_here:~$ command -v ssh
/usr/bin/ssh
inserthostname_here:~$ command -v curl
inserthostname_here:~$ command -v python3
inserthostname_here:~$

inserthostname_here:~$ command -v apk
/sbin/apk
inserthostname_here:~$ command -v wget
/usr/bin/wget
inserthostname_here:~$ command -v openssl
/usr/bin/openssl
inserthostname_here:~$ apk --version
apk-tools 2.12.1, compiled for x86_64.
inserthostname_here:~$ openssl version
OpenSSL 1.1.1j  16 Feb 2021
```

<a id="block-02"></a>

### Block 02 — Linux-to-router ping, 5/5 and 0% loss

**Captured Linux-to-router ping.** Five probes to `192.0.2.10` receive replies, with minimum/average/maximum RTT 0.796/1.028/1.605 ms. No router-to-Linux ping summary was supplied.

```text
inserthostname_here:~$ ping -c 5 192.0.2.10
PING 192.0.2.10 (192.0.2.10): 56 data bytes
64 bytes from 192.0.2.10: seq=0 ttl=42 time=1.605 ms
64 bytes from 192.0.2.10: seq=1 ttl=42 time=0.796 ms
64 bytes from 192.0.2.10: seq=2 ttl=42 time=0.805 ms
64 bytes from 192.0.2.10: seq=3 ttl=42 time=0.861 ms
64 bytes from 192.0.2.10: seq=4 ttl=42 time=1.075 ms

--- 192.0.2.10 ping statistics ---
5 packets transmitted, 5 packets received, 0% packet loss
round-trip min/avg/max = 0.796/1.028/1.605 ms
```

## NETCONF service

<a id="block-03"></a>

### Block 03 — SSH, NETCONF service, and candidate datastore status

**Captured router status and initialization excerpts.** NETCONF is enabled on SSH port 830 and candidate is explicitly disabled. The synchronization log concerns the running datastore; the demonstrated edits use running.

```text
SSH Enabled - version 2.0

R1-AUTOMATION#show netconf-yang status
netconf-yang: enabled
netconf-yang ssh port: 830
netconf-yang candidate-datastore: disabled
```

```text
*Oct 14 23:06:12.696: %DMI-5-SYNC_COMPLETE: R0/0: dmiauthd: The running configuration has been synchronized to the NETCONF running data store.
```

## HTTPS and TLS

<a id="block-14"></a>

### Block 14 — HTTP/HTTPS status and RESTCONF configuration

**Captured router CLI excerpts.** HTTPS is enabled on 443 with local authentication. Plain HTTP is also enabled on 80; the recorded RESTCONF requests used HTTPS. Listed service TLS versions are distinct from the negotiated version below.

```text
R1-AUTOMATION#show ip http server status
HTTP server status: Enabled
HTTP server port: 80
HTTP server authentication method: local
HTTP secure server capability: Present
HTTP secure server status: Enabled
HTTP secure server port: 443
HTTP secure server TLS version:  TLSv1.2 TLSv1.1
HTTP secure server client authentication: Disabled
HTTP secure server ECDHE curve: secp256r1

R1-AUTOMATION#show running-config | include restconf
restconf
R1-AUTOMATION#show running-config | include ip http
ip http server
ip http authentication local
ip http secure-server
```

<a id="block-15"></a>

### Block 15 — Relevant TLS handshake summary

**Captured OpenSSL command and selected handshake lines.** TLS 1.2 negotiated successfully, while certificate verification reported a self-signed error and return code 18. This is transport evidence, not proof of trusted certificate validation.

```text
inserthostname_here:~$ openssl s_client -connect 192.0.2.10:443 -tls1_2 </dev/null
CONNECTED(00000003)
Can't use SSL_get_servername
verify error:num=18:self signed certificate
No client certificate CA names sent
Peer signing digest: SHA256
Peer signature type: RSA-PSS
Server Temp Key: ECDH, P-256, 256 bits
SSL handshake has read 1494 bytes and written 320 bytes
Verification error: self signed certificate
New, TLSv1.2, Cipher is ECDHE-RSA-AES128-GCM-SHA256
Server public key is 2048 bit
Secure Renegotiation IS supported
No ALPN negotiated
SSL-Session:
    Protocol  : TLSv1.2
    Cipher    : ECDHE-RSA-AES128-GCM-SHA256
    Verify return code: 18 (self signed certificate)
    Extended master secret: yes
DONE
```

[Verification index](README.md) · [Overview](../README.md) · [Configurations](../configs/README.md) · [Operation](../operation.md) · [Topology](../topology.md) · [Evidence scope](../scope.md)
