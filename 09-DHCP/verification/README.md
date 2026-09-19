# DHCP verification guide

The evidence follows the lab from failed address assignment to confirmed recovery. Each text file starts with a short explanation, then preserves the console output and source-message identifiers.

## Read the captures by question

| Question | Evidence | What to look for |
|---|---|---|
| Did relay restore the first client? | [01 — CLIENT-A](01-relay-client-a.txt) | Unassigned with zero server counters, then `10.10.10.21` and its binding |
| Did the second subnet receive its own lease? | [02 — CLIENT-B](02-relay-client-b.txt) | `10.10.20.21`, two bindings and one lease per pool |
| Can renewal change settings without changing the address? | [03 — Bad gateway delivered](03-bad-gateway-renewal.txt) | Same `.21` address; gateway changes from `.1` to `.254` |
| What was the service impact? | [04 — Local vs remote tests](04-local-success-remote-failure.txt) | Local 5/5; remote 0/5; incorrect learned gateway |
| Where was forwarding failing? | [05 — ARP trace](05-arp-to-wrong-gateway.txt) | Repeated attempts to resolve `10.10.20.254` |
| Did the gateway correction restore access? | [06 — Repair and recovery](06-gateway-repair-and-recovery.txt) | Corrected pool, refreshed client gateway, 5/5 remote replies and Bound state |
| Was the old address explicitly released? | [07 — Release](07-release-old-lease.txt) | Server logs DHCPRELEASE for `.21` |
| Did a fresh acquisition complete through relay? | [08 — DORA and binding](08-relayed-dora-and-new-binding.txt) | Discover/Offer/Request/ACK, relay `.1`, new address `.22` |
| Did clearing the server binding clear the client? | [09 — State mismatch](09-client-server-state-mismatch.txt) | Server lacks `.22`; client remains Bound |
| What happened during an unknown renewal? | [10 — Default policy](10-unknown-renewal.txt) | Requests without responses in the excerpt; client retry count 2 |
| What changed under the rejection policy? | [11 — DHCPNAK](11-unknown-renewal-nak.txt) | Explicit server rejection; client still Renewing |
| What did the client itself log? | [12 — Client debug](12-client-debug-and-cleanup.txt) | Outgoing request, no incoming response in this later excerpt |
| Was the final acquisition started from a clean state? | [13 — Reset](13-clean-state-before-acquisition.txt) | Empty client lease, zero USERS-B leases, index `.23` |
| Did recovery hold across both devices? | [14 — Final verification](14-final-recovery.txt) | Bound `.23`, matching binding and 5/5 remote replies |

The fifteenth evidence file is the actual [DHCP pool configuration after cleanup](../configs/captured-dhcp-pools.txt).

## Understand the address progression

| Stage | CLIENT-B | Meaning |
|---|---|---|
| Initial assignment | `10.10.20.21` | Correct pool supplies a lease |
| Gateway experiment | Still `.21` | Renewal changes the gateway option without changing the address |
| Explicit release and fresh acquisition | `10.10.20.22` | Full DORA establishes a new lease |
| Server binding manually cleared | Still `.22` | Client and server no longer agree |
| Client release and fresh acquisition | `10.10.20.23` | Client, server and remote reachability agree again |

The pool's current index was `.23` before the last acquisition, and `.23` was subsequently assigned. This is the result under the recorded conditions; a replay may allocate a different valid address.

## DORA and lease timers

DORA means **Discover → Offer → Request → Acknowledgment**. [Capture 08](08-relayed-dora-and-new-binding.txt) contains all four stages in the server debug, including replies sent to relay `10.10.20.1`.

The final client lease reports:

| Field | Captured seconds | Duration |
|---|---:|---|
| Lease | 86400 | 24 hours |
| Renewal / T1 | 43200 | 12 hours |
| Rebind / T2 | 75600 | 21 hours |

These are displayed timer values. Renewals were forced during the lab; natural T1/T2 expiration was not observed. The standard describes renewal with the original server at T1, broadcast rebinding at T2, and stopping use of the address when the lease expires. [RFC 2131, section 4.4.5](https://datatracker.ietf.org/doc/html/rfc2131#section-4.4.5).

## Evidence handling

Captures contain console output recorded during Parts 3 and 4. HTML space entities, Markdown escapes and line endings are normalized; prompts, abbreviated commands, timestamps and device messages are retained. Source conversation and message IDs accompany each block.

Device clocks were not verified as synchronized. Server counters are cumulative, and separate debug attempts are identified as such. A server pinging itself is excluded from the final proof; the retained final ping originates from CLIENT-B.

[Section overview](../README.md) · [Troubleshooting](../troubleshooting/README.md)

