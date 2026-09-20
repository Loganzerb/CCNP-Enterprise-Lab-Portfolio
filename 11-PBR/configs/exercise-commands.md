# PBR exercise commands

These sequences reconstruct the lab changes for a clean replica. They are instructions, not additional CLI captures. Use the [baseline configuration guide](README.md) first.

## Case 01 — Reverse the classifier

On R2, starting with the baseline standard ACL:

```cisco
configure terminal
ip access-list standard PBR-SOURCE-A
 no 10
 10 deny 10.1.1.0 0.0.0.255
 20 permit any
end
show access-lists PBR-SOURCE-A
```

Run both source-specific traceroutes on R1. Source A should use normal routing and source B should match the alternate-path policy. [Recorded results](../verification/02-acl-classification.md)

Restore the source-A-only classifier on R2 before continuing:

```cisco
configure terminal
ip access-list standard PBR-SOURCE-A
 no 10
 no 20
 10 permit 10.1.1.0 0.0.0.255
end
show access-lists PBR-SOURCE-A
```

## Case 02 — Remove the direct policy next hop

On R2:

```cisco
configure terminal
interface GigabitEthernet0/1
 shutdown
end
show ip route 10.23.1.3
```

Inspect the route rather than assuming the prefix disappears. In the captured test, OSPF installed an indirect route through R4. From R1:

```cisco
traceroute 10.5.5.5 source 10.1.1.1
```

Restore the direct link on R2:

```cisco
configure terminal
interface GigabitEthernet0/1
 no shutdown
end
show ip route 10.23.1.3
```

Repeat the same source-A trace on R1. [Recorded fault and recovery](../verification/03-next-hop-failure.md)

## Case 03 — Stop at a matching route-map deny

Keep the baseline ACL permitting source A. On R2:

```cisco
configure terminal
no route-map PBR-TO-R3 permit 10
route-map PBR-TO-R3 deny 10
 match ip address PBR-SOURCE-A
exit
route-map PBR-TO-R3 permit 20
 set ip next-hop 10.23.1.3
end
show route-map PBR-TO-R3
```

Run both source-specific traces on R1. Then inspect both counter types on R2:

```cisco
show access-lists PBR-SOURCE-A
show route-map PBR-TO-R3
```

A matching deny uses normal routing; it does not fall through to permit 20. Source B can reach that later sequence because it does not match sequence 10's ACL. [Recorded paths and counters](../verification/04-route-map-sequencing.md#block-02)

## Restore and verify the baseline

On R2:

```cisco
configure terminal
no route-map PBR-TO-R3 deny 10
no route-map PBR-TO-R3 permit 20
route-map PBR-TO-R3 permit 10
 match ip address PBR-SOURCE-A
 set ip next-hop 10.23.1.3
end
show route-map PBR-TO-R3
show access-lists PBR-SOURCE-A
show ip policy
```

Confirm the direct R2–R3 link is up, the ACL permits only source A, and the policy remains on Gi0/0. Run both traces again on R1:

```cisco
traceroute 10.5.5.5 source 10.1.1.1
traceroute 10.5.5.5 source 10.11.11.11
```

Compare with the [final paired captures](../verification/04-route-map-sequencing.md#block-07): source A includes R3, while source B uses R4 directly.

[Back to configurations](README.md) · [Back to PBR](../README.md)
