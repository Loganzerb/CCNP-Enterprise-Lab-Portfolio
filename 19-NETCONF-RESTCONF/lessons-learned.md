# NETCONF and RESTCONF lessons learned

| Engineering distinction | What this lab established |
|---|---|
| Service enabled versus usable exchange | Service status accompanies successful protocol replies and configuration readback |
| Advertised capability versus exercised feature | The server advertises both base versions and several capabilities; the client uses base 1.0, running reads, and a merge edit |
| Running versus candidate | Candidate is explicitly disabled; the demonstrated edit targets running, without a candidate/commit workflow |
| Accepted edit versus verified state | NETCONF `<ok/>` and RESTCONF HTTP 204 are followed by readback and independent CLI |
| Model key versus interface display name | The keyed Gi1 resources target interface key `1`; CLI confirms GigabitEthernet1 and its retained management address |
| Description change versus other interface state | Both edits change the description; captured readback/CLI retain `192.0.2.10/24` and up/up state |
| Prescribed content versus captured request | Message 104's request and the PATCH BODY assignment remain prescribed; their resulting replies and readbacks are captured |
| Encrypted transport versus certificate trust | TLS 1.2 negotiates, while certificate verification retains the self-signed error |
| One-direction success versus broader connectivity | Linux receives 5/5 replies; no reverse-direction ping summary supports a captured bidirectional claim |
| Running state versus persistence | The final description is confirmed in running state, without an executed save or reboot result |

The description progresses through `NETCONF-RESTCONF-LAB`, `NETCONF-EDIT-VERIFIED`, and `RESTCONF-EDIT-VERIFIED`. The [NETCONF readback](verification/netconf.md#block-08), [RESTCONF readback](verification/restconf.md#block-13), and [final CLI](verification/restconf.md#block-16) connect accepted requests to the observed result.

The [earlier setup observations](verification/setup-observations.md) retain initial ping loss and authentication failure without inventing a precise diagnosis. [Evidence scope](scope.md) defines the untested capabilities, request-capture boundaries, certificate limits, and persistence status.

[Overview](README.md) · [Verification](verification/README.md) · [Configurations](configs/README.md) · [Operation](operation.md) · [Topology](topology.md) · [Evidence scope](scope.md)
