# ACL classification changes the selected source

Read the [verification guide](README.md) for capture conventions. Each numbered block contains retained device output and a short explanation.

## Block 01

**Reversed classifier.** The ACL denies source A and permits other sources; it is used as a route-map match, not an interface traffic filter.

```text
R2-PBR-POLICY#show access-lists PBR-SOURCE-A
Standard IP access list PBR-SOURCE-A
    10 deny   10.1.1.0, wildcard bits 0.0.0.255
    20 permit any
R2-PBR-POLICY#
```

## Block 02

**Source A uses R4.** The source excluded by the classifier follows the normal route.

```text
R1-PBR-SOURCE#traceroute 10.5.5.5 source 10.1.1.1
Type escape sequence to abort.
Tracing the route to 10.5.5.5
VRF info: (vrf in name/id, vrf out name/id)
  1 10.12.1.2 2 msec 2 msec 2 msec
  2 10.24.1.4 3 msec 2 msec 2 msec
  3 10.45.1.5 3 msec 3 msec * 
R1-PBR-SOURCE#
```

## Block 03

**Source B now uses R3.** The broad permit any classifies source B for the policy action.

```text
R1-PBR-SOURCE#traceroute 10.5.5.5 source 10.11.11.11
Type escape sequence to abort.
Tracing the route to 10.5.5.5
VRF info: (vrf in name/id, vrf out name/id)
  1 10.12.1.2 2 msec 3 msec 1 msec
  2 10.23.1.3 2 msec 2 msec 2 msec
  3 10.34.1.4 2 msec 3 msec 2 msec
  4 10.45.1.5 3 msec 4 msec * 
R1-PBR-SOURCE#
```

## Block 04

**Classifier restored.** The ACL returns to its original source-A permit before the next-hop exercise.

```text
R2-PBR-POLICY#show access-lists PBR-SOURCE-A
Standard IP access list PBR-SOURCE-A
    10 permit 10.1.1.0, wildcard bits 0.0.0.255
R2-PBR-POLICY#
```

[Back to verification](README.md) · [Back to PBR](../README.md)
