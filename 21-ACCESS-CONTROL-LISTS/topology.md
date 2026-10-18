# ACL topology

![Two client subnets reach APP-SERVER through R1-ACL; USERS-TO-SERVER checks traffic leaving Gi3](topology.svg)

[PNG rendition](topology.png) · [Sanitized CML export](CML-LAB.yaml)

The diagram represents the wiring and final policy in the supplied export. It is an explanatory diagram, not a captured CML runtime screenshot. The lab uses one CSR1000v router running IOS XE 17.3.2 and three Alpine Desktop endpoints.

## Nodes and addressing

| Node | CML definition / image | Interface and address | Default gateway |
|---|---|---|---|
| n0 — R1-ACL | `csr1000v` / `csr1000v-170302` | Gi1 `10.10.10.1/24`; Gi2 `10.20.20.1/24`; Gi3 `172.16.40.1/24` | Directly connected lab networks |
| n1 — CLIENT-A | `desktop` / `desktop-3-13-2-xfce` | eth0 `10.10.10.25/24` | `10.10.10.1` |
| n2 — CLIENT-B | `desktop` / `desktop-3-13-2-xfce` | eth0 `10.20.20.25/24` | `10.20.20.1` |
| n3 — APP-SERVER | `desktop` / `desktop-3-13-2-xfce` | eth0 `172.16.40.10/24` | `172.16.40.1` |

## Physical wiring

| Link | First endpoint | Second endpoint |
|---|---|---|
| l0 | n1/i0 — CLIENT-A eth0 | n0/i1 — R1 GigabitEthernet1 |
| l1 | n2/i0 — CLIENT-B eth0 | n0/i2 — R1 GigabitEthernet2 |
| l2 | n0/i3 — R1 GigabitEthernet3 | n3/i0 — APP-SERVER eth0 |

The exported router also retains its original i0 loopback metadata and unused Gi4/i4 interface. Neither is an additional physical lab link. All node IDs, interface IDs, images, coordinates, tags, and link references remain unchanged in the sanitized YAML.

## Where the policy applies

Both client paths converge at R1's server-facing Gi3. `USERS-TO-SERVER` is applied **outbound on Gi3**, so it evaluates routed client packets as they leave toward APP-SERVER.

The final ACL denies TCP destination port 22 and UDP destination port 5300 from the two client networks to `172.16.40.10`. ACE 30 permits other IPv4 traffic. Replies from the server enter Gi3; the temporary inbound return-path ACL used during the experiment was removed.

TCP 443 testing used Netcat to establish transport connectivity. The diagram's APP-SERVER label does not imply that an HTTPS/TLS application was installed or validated.

[Overview](README.md) · [Operation](operation.md) · [Configurations](configs/README.md) · [Verification](verification/README.md) · [Troubleshooting](troubleshooting/README.md) · [Evidence scope](scope.md)
