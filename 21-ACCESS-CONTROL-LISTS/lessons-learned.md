# ACL lessons learned

| Engineering distinction | What the lab record supports |
|---|---|
| An intended deny versus the first matching ACE | An earlier broad permit let CLIENT-A use SSH; removing it restored the reported restriction |
| Interface identity versus direction | The same named policy had a different effect on Gi3 IN and OUT; the final assignment is OUT toward the server |
| Protocol versus port number | UDP 5300 was denied while TCP 5300 payloads reached the server |
| Source versus destination port | The operator's position selects a different packet field; incorrect matching blocked previously permitted traffic |
| Forward versus return traffic | The temporary inbound return-path experiment required its own matching checks; its exact ACEs and client ports were not supplied |
| TCP flags versus tracked connection state | Established checks ACK/RST flags; it does not maintain a stateful session table |
| Connectivity versus application security | Netcat success on TCP 443 establishes the reported connection test, without validating HTTPS or TLS |
| Saved policy versus runtime evidence | The export retains the ACL/attachment; narrative results and match totals remain reported observations |
| Test runs versus ACL match totals | Nine baseline tests and final ACE totals describe different records; the totals are not final-regression deltas |

The [three case guides](troubleshooting/README.md) connect symptoms to mechanisms and reported corrections without inventing temporary ACE syntax. The [final-state guide](verification/final-state.md) separates the exported policy from the reported cleanup, save, startup inspection, and regression checks.

[Overview](README.md) · [Verification](verification/README.md) · [Filtering and counters](verification/filtering-and-counters.md) · [Troubleshooting](troubleshooting/README.md) · [Configurations](configs/README.md) · [Operation](operation.md) · [Topology](topology.md) · [Evidence scope](scope.md)
