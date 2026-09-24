# Case 01 — A connected client cannot obtain an address

The clients were connected to functioning interfaces, but the DHCP server was on another network. Enabling relay on each client network allowed requests to reach the server and restored address assignment.

## Symptom and diagnosis

CLIENT-A's interface was **up/up** and configured for DHCP, yet its address remained **unassigned**. DHCP-SRV showed zero Discover, Offer, Request and ACK messages in the [initial capture](../verification/01-relay-client-a.txt).

An operational interface proved the link was available. It did not prove that the address request could cross the network boundary. In the documented starting configuration, DIST-SW had no helper on Vlan10.

## Controlled correction

Relay was added to Vlan10 first, leaving Vlan20 unchanged. This is the configuration change described in the lab sequence:

```cisco
configure terminal
interface Vlan10
 ip helper-address 10.99.99.50
end
```

CLIENT-A then received `10.10.10.21`, and the server recorded its binding. CLIENT-B, once DHCP was enabled, remained unassigned while the server still showed only CLIENT-A's exchange.

The same helper was then added under Vlan20. [The second capture](../verification/02-relay-client-b.txt) shows CLIENT-B receiving `10.10.20.21`, two automatic bindings, and cumulative Discover/Offer/Request/ACK counters of two each.

## Why the correction fits the evidence

A new client's DHCP broadcast is local to its network. The relay forwards it to the remote server and identifies the client subnet. Cisco documents that role for ip helper-address and the giaddr field.

A [later server debug](../verification/08-relayed-dora-and-new-binding.txt) directly records CLIENT-B's Discover through relay `10.10.20.1`, followed by Offer, Request and ACK.

## Outcome and scope

Both subnets obtained addresses from their respective pools. The before/after client and server output supports the relay explanation; no pasted switch running-config was retained to independently capture the helper change.

**Takeaway:** when an interface is up but the client has no address, establish whether the server is receiving the request before investigating the pool.

[All cases](README.md) · [Configuration guide](../configs/README.md)

