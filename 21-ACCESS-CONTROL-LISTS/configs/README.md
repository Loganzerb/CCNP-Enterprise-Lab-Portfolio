# ACL configuration

The [sanitized CML export](../CML-LAB.yaml) retains the four original nodes, three links, images, interface definitions, addressing, and final ACL. The files below are exact extracts of its decoded configuration strings. They are saved configuration evidence, not newly captured CLI output.

| File | Content |
|---|---|
| [R1-ACL.cfg](R1-ACL.cfg) | Router configuration after removal of generated PKI, device identification, call-home, and display metadata |
| [CLIENT-A.sh](CLIENT-A.sh) | Original Alpine hostname, eth0 activation, `10.10.10.25/24`, and default route |
| [CLIENT-B.sh](CLIENT-B.sh) | Original Alpine hostname, eth0 activation, `10.20.20.25/24`, and default route |
| [APP-SERVER.sh](APP-SERVER.sh) | Original Alpine hostname, eth0 activation, `172.16.40.10/24`, and default route |

The Alpine extracts preserve every original startup command, including their final newlines. They contain network setup only. SSH and Netcat service commands, service state, connection transcripts, and packet counters are not embedded in the export.

## Configuration stages

The lab first established routed connectivity, then attached the extended ACL toward the server. Temporary changes tested ACE order, interface direction, protocol/port matching, and return traffic before the final policy was restored. The [three case studies](../troubleshooting/README.md) describe those changes; their exact temporary configurations were not supplied.

### 1. Connected networks

**Selected saved configuration.** Each endpoint's default gateway is the router address in its subnet.

```cisco
interface GigabitEthernet1
 ip address 10.10.10.1 255.255.255.0
interface GigabitEthernet2
 ip address 10.20.20.1 255.255.255.0
interface GigabitEthernet3
 ip address 172.16.40.1 255.255.255.0
```

### 2. Final extended ACL

**Exact saved ACL stanza.** ACEs 10 and 20 match TCP destination port 22; ACEs 21 and 22 match UDP destination port 5300.

```cisco
ip access-list extended USERS-TO-SERVER
 10 deny   tcp 10.10.10.0 0.0.0.255 host 172.16.40.10 eq 22
 20 deny   tcp 10.20.20.0 0.0.0.255 host 172.16.40.10 eq 22
 21 deny   udp 10.10.10.0 0.0.0.255 host 172.16.40.10 eq 5300
 22 deny   udp 10.20.20.0 0.0.0.255 host 172.16.40.10 eq 5300
 30 permit ip any any
```

The final ACE broadly permits other IPv4 traffic. This lab demonstrates specific exclusions and ordered matching; the policy is not a restrictive server allowlist. TCP and UDP port numbers are independent, so denying UDP 5300 does not deny TCP 5300.

### 3. Server-facing outbound attachment

**Selected saved configuration.**

```cisco
interface GigabitEthernet3
 ip access-group USERS-TO-SERVER out
```

Client traffic enters Gi1 or Gi2 and leaves Gi3 toward APP-SERVER. The outbound attachment therefore checks that traffic before it reaches the server. No experimental inbound return-path ACL remains in the saved router configuration.

## Publication boundaries

The public copy removes complete PKI trustpoint/certificate blocks, the license/device identifier, call-home configuration, and generated display headers/comments. No passwords, hashes, private keys, or replacement credentials were added. All router interface stanzas and the final ACL were retained exactly.

The handoff reports final regression, a configuration save, and startup-config inspection. Those observations are documented in [verification](../verification/README.md); they are not inferred from this export. A fresh import of the sanitized YAML and a router reload test have not been performed during portfolio preparation.

[Overview](../README.md) · [Topology](../topology.md) · [Operation](../operation.md) · [Verification](../verification/README.md) · [Troubleshooting](../troubleshooting/README.md) · [Evidence scope](../scope.md)
