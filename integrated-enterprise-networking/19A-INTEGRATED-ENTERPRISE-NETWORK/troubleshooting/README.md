# Lab 19A troubleshooting

## Restore dynamic PAT

The lab handoff records a correction to the NAT statement. The exact original command and CLI response are unavailable. The saved correction was traditional inside-source overload on both gateways.

```ios
ip nat inside source list 10 interface GigabitEthernet0/1 overload
```

The useful isolation order is to verify the active HSRP owner, verify its OSPF `/32` route, and check that the packet can pass the ingress filter before inspecting NAT inside and outside roles, selection ACL 10, and fresh translations. The same probe through a different active gateway should use that gateway’s own outside address. The lab handoff reports `172.16.24.1` through R2 and `172.16.34.1` through R3. [Configuration guide](../configs/README.md) · [PAT checks](../verification/README.md#task-to-evidence-matrix)

## Isolate policy denial from path failure

A failed echo alone could reflect a Layer 2, first-hop, OSPF, PAT, or policy problem. With the active router and upstream route established, compare the `USERS-FILTER` deny counter before and after a known-size probe set. Five deny matches were reported on R2 and five on R3 in separate tests. The policy is attached to Gi0/0.10 on both gateways, so a change in active role does not bypass the configured deny. VLAN 20 provides a permitted control flow through the same upstream destination when its route is selected.

## Select the intended VLAN 20 egress

R1 uses routed subinterfaces to simulate both hosts. Its saved default route sends traffic to the VLAN 10 VIP. Selecting VLAN 20’s source IP alone does not change that route. A temporary static host route for `203.0.113.100/32` takes precedence over the default by longest-prefix match and can direct that destination through the VLAN 20 gateway. The handoff records removing the test route after verifying the permitted flow. That restored the normal destination route selection for the VLAN 10 probe. [Failover and policy sequence](../verification/README.md#failover-and-policy-sequence)

[Overview](../README.md) · [Operation](../operation.md) · [Lessons learned](../lessons-learned.md) · [Evidence scope](../scope.md)
