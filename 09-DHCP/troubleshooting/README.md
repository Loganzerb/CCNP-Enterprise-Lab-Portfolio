# DHCP troubleshooting

These cases show how a network can fail at different stages: before an address is assigned, after incorrect settings are delivered, or when client and server records disagree.

| Case | Starting symptom | Decisive evidence | Closure |
|---|---|---|---|
| [01 — Missing relay](01-missing-relay.md) | Client interface is up but has no address | DHCP-enabled client remains unassigned while server counters do not increase | Appropriate leases appear after relay is enabled |
| [02 — Incorrect default gateway](02-incorrect-default-gateway.md) | Local ping succeeds; remote ping fails | Client ARPs for `10.10.20.254`, matching the incorrect pool setting | Correct gateway, Bound state and 5/5 remote replies |
| [03 — Lease-state mismatch](03-lease-state-mismatch.md) | Client retains `.22` after its server binding is cleared | Side-by-side lease state, renewal debug and server-generated NAK | Fresh `.23` lease, matching binding and 5/5 replies |

Start with Case 02 for the clearest service-impact story. Case 03 adds a deeper discussion of independent state and evidence limits.

The exercises were guided and intentionally introduced; they are not presented as blind incidents or production outages. Each case links to the original console excerpts and explains what they establish.

[Section overview](../README.md) · [Evidence index](../verification/README.md)

