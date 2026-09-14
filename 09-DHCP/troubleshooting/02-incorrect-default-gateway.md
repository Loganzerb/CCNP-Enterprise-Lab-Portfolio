# Case 02 — A valid address without remote access

CLIENT-B could communicate locally but could not reach the DHCP server on another subnet. The address assignment had succeeded; the gateway supplied with it was wrong. Correcting that setting and refreshing the client's lease restored the tested remote path.

## Establish the impact

| CLIENT-B test | Captured result |
|---|---|
| Ping real gateway `10.10.20.1` | **5/5 replies** |
| Ping remote server `10.99.99.50` | **0/5 replies** |
| Inspect learned gateway | **10.10.20.254** |

[Read the original connectivity and gateway output](../verification/04-local-success-remote-failure.txt).

## Follow the evidence

1. **Check when the setting changed.** After the pool was deliberately altered, CLIENT-B initially retained its correct gateway. A forced renewal delivered `.254` while preserving client address `10.10.20.21`. [Renewal evidence](../verification/03-bad-gateway-renewal.txt).
2. **Inspect the failed next hop.** During a remote ping, ARP debugging repeatedly tried to resolve `10.10.20.254`. The existing ARP table contained the real gateway, `.1`. [ARP evidence](../verification/05-arp-to-wrong-gateway.txt).
3. **Trace the setting to its source.** The server's USERS-B pool contained `default-router 10.10.20.254`. [Pool and repair evidence](../verification/06-gateway-repair-and-recovery.txt).

The client could reach `.1` directly because it was in the same subnet. Reaching `10.99.99.50` required a gateway, and the client could not resolve the one DHCP had supplied. This explains why the local and remote tests differed.

## Correct the source, then refresh the client

The following commands express the correction shown by the captured before/after pool settings; they are a reconstruction of the repair, not a pasted change transcript.

On DHCP-SRV:

```cisco
configure terminal
ip dhcp pool USERS-B
 no default-router 10.10.20.254
 default-router 10.10.20.1
end
```

On CLIENT-B:

```cisco
renew dhcp GigabitEthernet0/0
```

Changing the server alone did not update the client immediately: the intermediate client check still showed `.254`.

## Verify recovery

The [recovery capture](../verification/06-gateway-repair-and-recovery.txt) shows gateway `10.10.20.1`, **5/5 replies** from `10.99.99.50`, and a subsequent **Bound** lease for the original `10.10.20.21` address with **zero retries**.

The earlier renewal output still displayed Renewing despite the changed gateway and increased server counters. The closure therefore relies on the later client state and functional test, not the counters alone.

**Takeaway:** successful address assignment is only one check. Validate the delivered settings and the communication the client needs.

[All cases](README.md) · [Technical references](../references.md)

