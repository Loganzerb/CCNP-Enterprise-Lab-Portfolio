# Lab 20B traffic classification and marking

The two saved ACLs select flows from PC-CLIENT to PC-SERVER by transport protocol and destination port. The historical ACL matches and inbound marking counters show that both test flows matched and received the configured DSCP treatment.

## Initial classification and marking

**Captured CLI excerpt — original CML lab session, R2-EDGE-A.**

```text
R2-EDGE-A#show access-lists
Extended IP access list BUSINESS-TRAFFIC
    10 permit tcp host 10.20.10.10 host 10.20.40.10 eq 5002 (2041 matches)
Extended IP access list VOICE-TRAFFIC
    10 permit udp host 10.20.10.10 host 10.20.40.10 eq 5001 (895 matches)
```

**Captured CLI excerpt — original CML lab session, R2-EDGE-A, `show policy-map interface GigabitEthernet0/0`.**

```text
Class-map: VOICE (match-all)
  895 packets, 1353240 bytes
  5 minute offered rate 28000 bps, drop rate 0000 bps
  Match: access-group name VOICE-TRAFFIC
  QoS Set
    dscp ef
      Packets marked 895

Class-map: BUSINESS (match-all)
  2041 packets, 3081448 bytes
  5 minute offered rate 69000 bps, drop rate 0000 bps
  Match: access-group name BUSINESS-TRAFFIC
  QoS Set
    dscp af21
      Packets marked 2041
```

The ACL and policy evidence agree: 895 voice-class matches and EF markings, and 2,041 business-class matches and AF21 markings. These are device marking counters. A packet capture would verify the DSCP field on the wire. The original completion record separately reports 15 cumulative CS0 markings for the default class.

[Verification matrix](README.md) · [Policy architecture](../operation.md) · [DSCP fault and recovery](../troubleshooting/README.md)
