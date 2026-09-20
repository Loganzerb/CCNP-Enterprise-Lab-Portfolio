# Route-map deny and baseline restoration

Read the [verification guide](README.md) for capture conventions. Each numbered block contains retained device output and a short explanation.

## Block 01

**Two-sequence policy.** Deny sequence 10 references the source-A ACL; permit sequence 20 has no match clause and sets R3 as next hop.

```text
R2-PBR-POLICY#show route-map PBR-TO-R3
route-map PBR-TO-R3, deny, sequence 10
  Match clauses:
    ip address (access-lists): PBR-SOURCE-A 
  Set clauses:
  Policy routing matches: 0 packets, 0 bytes
route-map PBR-TO-R3, permit, sequence 20
  Match clauses:
  Set clauses:
    ip next-hop 10.23.1.3
  Policy routing matches: 0 packets, 0 bytes
R2-PBR-POLICY#
```

## Block 02

**Matching deny uses normal routing.** Source A traverses R4 directly despite the later permit sequence.

```text
R1-PBR-SOURCE#traceroute 10.5.5.5 source 10.1.1.1
Type escape sequence to abort.
Tracing the route to 10.5.5.5
VRF info: (vrf in name/id, vrf out name/id)
  1 10.12.1.2 2 msec 2 msec 2 msec
  2 10.24.1.4 2 msec 3 msec 3 msec
  3 10.45.1.5 3 msec 4 msec * 
R1-PBR-SOURCE#
```

## Block 03

**Unmatched source reaches permit 20.** Source B traverses R3 and R4.

```text
R1-PBR-SOURCE#traceroute 10.5.5.5 source 10.11.11.11
Type escape sequence to abort.
Tracing the route to 10.5.5.5
VRF info: (vrf in name/id, vrf out name/id)
  1 10.12.1.2 2 msec 2 msec 1 msec
  2 10.23.1.3 2 msec 4 msec 3 msec
  3 10.34.1.4 3 msec 3 msec 2 msec
  4 10.45.1.5 4 msec 3 msec * 
R1-PBR-SOURCE#
```

## Block 04

**Different policy counters.** Sequence 10 reports zero policy-routing packets; sequence 20 reports 39 packets and 2928 bytes.

```text
R2-PBR-POLICY#show route-map PBR-TO-R3
route-map PBR-TO-R3, deny, sequence 10
  Match clauses:
    ip address (access-lists): PBR-SOURCE-A 
  Set clauses:
  Policy routing matches: 0 packets, 0 bytes
route-map PBR-TO-R3, permit, sequence 20
  Match clauses:
  Set clauses:
    ip next-hop 10.23.1.3
  Policy routing matches: 39 packets, 2928 bytes
R2-PBR-POLICY#
```

## Block 05

**ACL counter shows classification.** The source-A ACL records nine matches even though the deny sequence's policy-routing counter was zero.

```text
R2-PBR-POLICY#show access-lists PBR-SOURCE-A
Standard IP access list PBR-SOURCE-A
    10 permit 10.1.1.0, wildcard bits 0.0.0.255 (9 matches)
R2-PBR-POLICY#
```

## Block 06

**Original policy restored.** Only permit sequence 10 remains, matching source A and setting R3 as next hop.

```text
R2-PBR-POLICY#
*Sep 20 16:19:56.058: %SYS-5-CONFIG_I: Configured from console by consoleshow route-map PBR-TO-R3
route-map PBR-TO-R3, permit, sequence 10
  Match clauses:
    ip address (access-lists): PBR-SOURCE-A 
  Set clauses:
    ip next-hop 10.23.1.3
  Policy routing matches: 0 packets, 0 bytes
R2-PBR-POLICY#
```

## Block 07

**Final source-A check.** The explicit source-A command again takes the alternate path.

```text
R1-PBR-SOURCE#traceroute 10.5.5.5 source 10.1.1.1
Type escape sequence to abort.
Tracing the route to 10.5.5.5
VRF info: (vrf in name/id, vrf out name/id)
  1 10.12.1.2 2 msec 2 msec 2 msec
  2 10.23.1.3 2 msec 2 msec 2 msec
  3 10.34.1.4 3 msec 3 msec 3 msec
  4 10.45.1.5 3 msec 4 msec * 
R1-PBR-SOURCE#
```

## Block 08

**Final source-B check.** The explicit source-B command again takes the normal path.

```text
R1-PBR-SOURCE#traceroute 10.5.5.5 source 10.11.11.11
Type escape sequence to abort.
Tracing the route to 10.5.5.5
VRF info: (vrf in name/id, vrf out name/id)
  1 10.12.1.2 1 msec 1 msec 1 msec
  2 10.24.1.4 2 msec 3 msec 2 msec
  3 10.45.1.5 3 msec 3 msec * 
R1-PBR-SOURCE#
```

[Back to verification](README.md) · [Back to PBR](../README.md)
