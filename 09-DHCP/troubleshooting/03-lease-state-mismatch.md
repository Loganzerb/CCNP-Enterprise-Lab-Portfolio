# Case 03 — Client and server disagree about a lease

Deleting a DHCP server record did not remove the address already held by CLIENT-B. The experiment exposed that mismatch, compared renewal behavior under two server policies, and restored agreement through a fresh acquisition.

## Create and verify the mismatch

Following a release of `.21`, a [complete relayed exchange](../verification/08-relayed-dora-and-new-binding.txt) assigned CLIENT-B `10.10.20.22`.

The server binding was deliberately cleared:

```cisco
clear ip dhcp binding 10.10.20.22
```

The [paired checks](../verification/09-client-server-state-mismatch.txt) then showed:

| Observation point | State |
|---|---|
| DHCP-SRV binding table | No `10.10.20.22` entry |
| CLIENT-B lease | Still `10.10.20.22`, **Bound**, server `10.99.99.50` |

This isolated the issue to independent lease records rather than assuming the client changed when the server did.

## Compare renewal behavior

| Condition | Server evidence | Client evidence |
|---|---|---|
| Default pool policy | DHCPREQUEST logged; no ACK or NAK in the supplied excerpts | Renewing, retry count 2 |
| `renew deny unknown` enabled | Requested address is not leased; DHCPNAK generated | Still Renewing, retry count 3 |

[Default-policy capture](../verification/10-unknown-renewal.txt) · [Rejection-policy capture](../verification/11-unknown-renewal-nak.txt).

Cisco's [command reference](https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/ipaddr/command/ipaddr-cr-book/ipaddr-l1.html) describes this policy difference: the default ignores the unknown request, while the configured policy sends a rejection.

## Check the client independently

A [later client debug](../verification/12-client-debug-and-cleanup.txt) showed an outgoing request containing `ciaddr: 10.10.20.22`, followed by the socket closing. No incoming ACK or NAK appeared in that excerpt.

**Established:** the server generated a NAK in one attempt; the client remained Renewing afterward; a later client-side attempt showed no incoming response.

**Unresolved:** these were separate debug attempts without a synchronized packet capture. They do not establish where a reply was lost or why the client did not return to normal operation. A repeat with captures on the client and server VLANs would distinguish delivery from client processing.

## Restore normal operation

The temporary policy was removed and the [captured pool configuration](../configs/captured-dhcp-pools.txt) confirmed the baseline.

CLIENT-B's lease was released. [Checks before reacquisition](../verification/13-clean-state-before-acquisition.txt) showed no client lease, zero leases in USERS-B and current index `10.10.20.23`. The subsequent acquisition assigned that address.

[Final verification](../verification/14-final-recovery.txt) closes the case:

- CLIENT-B: `10.10.20.23/24`, gateway `10.10.20.1`, **Bound**, retry count **0**.
- DHCP-SRV: matching automatic binding for `10.10.20.23`.
- CLIENT-B to `10.99.99.50`: **5/5 replies**.

**Takeaway:** compare both ends of a stateful service. A server action or generated response does not by itself establish the client's state or recovery.

[All cases](README.md) · [Lease progression](../verification/README.md)

