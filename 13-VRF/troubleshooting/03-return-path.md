# Case 03 — The forward route is only half the path

**Outcome:** SHARED-SVC received 5/5 replies from BLUE’s 192.168.10.10 and 5/5 from RED’s 192.168.20.20 after the missing routes were added.

## Symptom and investigation

R1 could reach the service globally, and both VRFs gained installed host routes resolving through global Gi0/2. The VRF-aware service pings still failed. Rather than infer the source selected by those probes, the next stage introduced unique CE loopbacks and tested from SHARED-SVC.

1. R1 reached each unique loopback from its own VRF: 5/5 in both cases.
2. SHARED-SVC had an installed default route toward R1, but its loopback tests returned `U.U.U` and 0/5.
3. R1’s global table had no route to either unique loopback.

[Forward routes and failed probes](../verification/04-forward-leak.md) · [Blocks 24–26 — isolate the missing destinations](../verification/05-return-path.md)

## Root cause and remediation

The selected service route supplied the VRF-to-global direction. It did not automatically supply global reachability into each CE network. The design also needed a route from each CE back to the service.

R1 gained global host routes that explicitly selected Gi0/0 for BLUE and Gi0/1 for RED, with 10.10.10.2 as the next hop on both. Both CEs gained a service host route through 10.10.10.1. The [route-leaking guide](../route-leaking/README.md) shows the exact configuration and the two directional lookups.

## Post-fix validation and lesson

R1’s RIB and CEF selected the correct interface for each unique loopback. Both CE service routes installed, and SHARED-SVC’s final ping exchanges returned all ten replies across the two five-probe tests.

The observed explicit-egress return routes disambiguated the overlapping next-hop addresses on this IOSv image. Selective routes added reachability while the VRF and global tables remained distinct. The final tests prove working request/reply paths for these endpoints; they are not an exhaustive test of all traffic between BLUE and RED.

[Blocks 27–29 — installed routes and final replies](../verification/05-return-path.md#block-27--explicit-egress-resolves-the-overlapping-next-hop) · [Case index](README.md) · [Overview](../README.md)
