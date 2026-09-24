# Case 03 — A deny match with zero policy-routing packets

## Summary

A two-sequence policy separated traffic that should bypass PBR from traffic that should take the alternate path. Source A matched route-map deny sequence 10 and used normal routing. Source B did not match that sequence, reached permit sequence 20 and traversed R3.

The counters provided an additional lesson: zero policy-routing packets on a deny sequence did not mean its classification ACL was unused.

## Policy under test

The ACL permitted source A, 10.1.1.0/24. I changed the route map to:

```cisco
route-map PBR-TO-R3 deny 10
 match ip address PBR-SOURCE-A
route-map PBR-TO-R3 permit 20
 set ip next-hop 10.23.1.3
```

The [captured policy — Block 01](../verification/04-route-map-sequencing.md#block-01) confirms deny 10 and a permit 20 with no match clause.

## Path and counter evidence

| Check | Captured result |
|---|---|
| Source-A traceroute | R2 → R4 → R5 |
| Source-B traceroute | R2 → R3 → R4 → R5 |
| ACL permit for source A | 9 matches |
| Route-map deny sequence 10 | 0 policy-routing packets |
| Route-map permit sequence 20 | 39 policy-routing packets, 2928 bytes |

[Paired traces — Blocks 02–03](../verification/04-route-map-sequencing.md#block-02) · [Route-map counters — Block 04](../verification/04-route-map-sequencing.md#block-04) · [ACL counter — Block 05](../verification/04-route-map-sequencing.md#block-05)

Source A matched the ACL, but the route-map action was deny. Its traffic used normal routing rather than continuing to the later permit. Source B did not match sequence 10 and was eligible for the catch-all sequence.

Cisco distinguishes these steps: a matching route-map deny ends PBR evaluation and uses normal forwarding; a sequence without a match clause applies to all packets reaching it.

## Restoration

I removed the experimental deny and catch-all entries, restored the original permit sequence, and tested both sources again. Source A returned to R3; source B returned to the direct R4 path. [Blocks 06–08](../verification/04-route-map-sequencing.md#block-06)

**Takeaway:** read classification counters, policy-action counters and traffic paths together. They answer different questions. A matching route-map deny bypasses PBR without dropping the packet or falling through to the next sequence.

[Back to cases](README.md) · [Back to PBR](../README.md)
