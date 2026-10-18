# Case 03 — Protocol, port fields, and the return path

The lab reports UDP/5300 denied while TCP payloads to the same port reached APP-SERVER. Separate experiments blocked a previously permitted TCP connection and a return-path handshake through incorrect port matching. Correcting the matches restored the reported behavior; the temporary return ACL was removed.

**Quick navigation:** [Symptom](#symptom) · [Mechanism](#mechanism) · [Reported repair](#reported-repair) · [Validation](#validation) · [Evidence limit](#evidence-limit)

## Symptom

Both client networks tested APP-SERVER at **172.16.40.10** on port **5300**. UDP traffic was reported denied with matching ACL counters, while TCP payloads reached the server.

In a separate TCP experiment, an incorrect destination-port deny blocked a previously permitted connection. Correcting source/destination-port matching restored the reported behavior.

An experimental inbound return-path ACL using TCP `established` first allowed return traffic. An intentional source/destination-port error then blocked a handshake; correcting it restored success. These were temporary exercises, not additional rules retained in the final deployment.

## Mechanism

The following explains packet matching; it does not reconstruct the missing experimental ACEs.

| Match detail | Why it matters |
|---|---|
| IP protocol | A UDP/5300 deny does not match TCP/5300. The saved ACL has separate SSH denies and a final permit for remaining IP traffic. |
| Source versus destination port | A client request targets the server's service port. Matching that value as the request's source port selects different traffic. Replies reverse the address and port roles. |
| Return-path policy | A rule applied to replies must match the packet as it appears in that direction, including the reversed endpoint roles. |
| TCP `established` | This qualifier matches TCP ACK or RST flags. It does not maintain a connection table or establish that a packet belongs to a previously permitted session. |

The experiments therefore test distinct questions: which protocol is filtered, which port field is matched, and which direction carries the packet being evaluated.

## Reported repair

The lab record reports correcting source/destination-port matching in the deny experiment and correcting the intentional port error in the return-path experiment. The exact experimental ACEs, return ACL name, and client ephemeral ports were not supplied, so no replacement syntax is reconstructed here.

The experimental return ACL was removed. The final deployment retained `USERS-TO-SERVER` outbound on Gi3, including UDP/5300 denies for **10.10.10.0/24** and **10.20.20.0/24**, followed by the terminal permit for remaining IP traffic.

## Validation

| Check | Reported result |
|---|---|
| CLIENT-A and CLIENT-B UDP/5300 tests | Denied, with matching ACL counters reported |
| TCP/5300 payload tests | Payloads reached APP-SERVER |
| Incorrect TCP destination-port deny | Previously permitted connection blocked; correcting port matching restored behavior |
| Experimental inbound return ACL | Return traffic initially allowed; intentional port error blocked a handshake; correction restored success; policy subsequently removed |
| Final SSH policy | TCP/22 denied from both clients |
| Final allowed traffic | ICMP and TCP/5300 permitted |

The TCP/5300 payload result is application-side receipt as reported by the lab record. The separate TCP/443 connection result establishes a connection test, not an HTTPS or TLS validation.

## Evidence limit

All outcomes and counter observations are reported lab results. No raw client/server output, ACL counters, experimental rules, test transcript, packet capture, or timestamps were supplied. The saved final ACL distinguishes UDP/5300 from other permitted IP traffic; it does not retain the temporary port-matching or return-path experiments.

[Troubleshooting index](README.md) · [Overview](../README.md) · [Verification](../verification/README.md) · [Configurations](../configs/README.md) · [Operation](../operation.md) · [Evidence scope](../scope.md)
