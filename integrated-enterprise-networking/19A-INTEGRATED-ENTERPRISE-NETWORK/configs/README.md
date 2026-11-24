# Lab 19A configuration guide

The complete CML checkpoint and full device configurations are retained privately pending redistribution clearance. These selected implementation examples were written for the portfolio and checked against the original export. Use them with the [interface and addressing tables](../topology.md) when building a separate lab. [Evidence scope](../scope.md)

## Device configuration responsibilities

| Node | Settings to implement |
|---|---|
| R1-CLIENT | 802.1Q subinterfaces for the two simulated client addresses. The global default route uses the VLAN 10 VIP. |
| SW1-ACCESS | Client trunk, two active LACP members, and Rapid PVST+ priority 8192 for both VLANs. |
| SW2-DIST | Gateway and bundle trunks, two active LACP members, and Rapid PVST+ priority 4096 for both VLANs. |
| R2-GW-A | HSRPv2 priority 110, preemption, OSPF router ID `2.2.2.2`, PAT, and VLAN 10 ingress filter. |
| R3-GW-B | HSRPv2 default priority 100, preemption, OSPF router ID `3.3.3.3`, PAT, and matching VLAN 10 ingress filter. |
| R4-ISP | OSPF router ID `4.4.4.4`, Area 0 links, and advertisement of the `203.0.113.100/32` loopback. |

## Selected implementation examples

Configure matching VLAN allow lists on both sides of Port-channel1. On each switch, apply `channel-group 1 mode active` to Gi0/2 and Gi0/3. Use the following settings on SW2 to prefer it for the per-VLAN spanning trees.

```ios
spanning-tree mode rapid-pvst
spanning-tree vlan 10,20 priority 4096
interface Port-channel1
 switchport trunk allowed vlan 10,20
 switchport trunk encapsulation dot1q
 switchport mode trunk
```

Configure this policy and PAT selection on both gateways. The interface in the overload command uses each router’s local WAN address. Attach `USERS-FILTER` inbound on Gi0/0.10.

```ios
access-list 10 permit 10.10.10.0 0.0.0.255
access-list 10 permit 10.10.20.0 0.0.0.255
ip nat inside source list 10 interface GigabitEthernet0/1 overload
ip access-list extended USERS-FILTER
 deny icmp 10.10.10.0 0.0.0.255 host 203.0.113.100 echo
 permit ip any any
```

R2's VLAN 10 subinterface terminates the tag, applies the ingress filter, and participates in HSRPv2. R3 uses `10.10.10.3/24` and the default HSRP priority of 100. Apply the matching subinterface pattern for VLAN 20 with group 20, VIP `10.10.20.1`, and no `USERS-FILTER` attachment. Both gateway WAN ports use `ip nat outside` and `ip ospf 10 area 0`.

```ios
interface GigabitEthernet0/0.10
 encapsulation dot1Q 10
 ip address 10.10.10.2 255.255.255.0
 ip access-group USERS-FILTER in
 ip nat inside
 standby version 2
 standby 10 ip 10.10.10.1
 standby 10 priority 110
 standby 10 preempt
```

## Build and replay checks

1. Use a licensed CML environment with the IOSv and IOSvL2 definitions listed in the [topology inventory](../topology.md). Rebuild from the diagrams, addressing tables, and selected examples. An authorized holder of the private checkpoint can import a disposable copy in their own environment.
2. Check boot state, the interface mapping, and administrative status before testing. Use `show ip interface brief` on IOSv routers and `show interfaces status` on the switches. An extracted IOSv configuration can omit `no shutdown`. Enable only intended links that are administratively down, then recheck interface state. [Cisco CML configuration extraction](https://developer.cisco.com/docs/modeling-labs/extracting-configurations/)
3. Use `show vlan brief` on both switches. The saved configuration lists VLANs 10 and 20 on the trunks. Explicit VLAN creation and the VLAN database were unavailable in the export. Create the missing VLANs as `USERS` and `SERVERS` if needed, then verify both trunks and Port-channel1.
4. Verify spanning tree, HSRP, and OSPF before sending traffic. The saved filter denies the VLAN 10 echo requests used for the separate permitted PAT test. Use a disposable lab for the temporary filter and failover changes. [Verification sequence](../verification/README.md#failover-and-policy-sequence)
5. Revert temporary routes, interface shutdowns, and policy changes at the end of the exercise. The expected saved static route on R1 is `ip route 0.0.0.0 0.0.0.0 10.10.10.1`. Fresh CML import, boot, and runtime replay remain pending.

[Overview](../README.md) · [Topology](../topology.md) · [Operation](../operation.md) · [Troubleshooting](../troubleshooting/README.md)
