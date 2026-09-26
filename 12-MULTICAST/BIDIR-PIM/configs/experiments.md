# BIDIR experiment changes

Selected commands are reconstructed from the lab sequence. The linked captures establish the before/after results; these blocks are not presented as console transcripts.

## Correct R1's interface addressing

```text
interface GigabitEthernet0/0
 no ip address
 ip address 10.13.0.1 255.255.255.252
 ip ospf cost 10
!
interface GigabitEthernet0/1
 no ip address
 ip address 10.10.10.1 255.255.255.0
!
router ospf 1
 no passive-interface GigabitEthernet0/0
 passive-interface GigabitEthernet0/1
```

The corrected R1 transit link forms a FULL adjacency with R3 and learns the RPA route at metric 12. See [foundation evidence](../verification/01-foundation.md).

## Widen the group selector

R1–R4, after the single-group mapping experiment:

```text
no access-list 45
access-list 45 permit 239.100.100.0 0.0.0.255
```

The existing `ip pim rp-address 4.4.4.4 45 bidir` remains. The subsequent IOSv lookups for the range base and actual group both returned Group not found before a receiver joined; the evidence is retained as observed.

## Move membership to the intended receiver

SRC-HOST:

```text
interface GigabitEthernet0/0
 no ip igmp join-group 239.100.100.100
```

RCV-HOST, after verifying its address is `10.30.30.100`:

```text
interface GigabitEthernet0/0
 ip igmp join-group 239.100.100.100
```

R3 then identifies the receiver on Gi0/3. See [receiver evidence](../verification/03-receiver-forwarding.md).

## Move the DF role through routing cost

R1-DF-A:

```text
interface GigabitEthernet0/0
 ip ospf cost 50
```

The total route metric toward `4.4.4.4` rises from 12 to 52. R2 stays at 32 and becomes DF. The [post-change evidence](../verification/04-df-transition.md) includes both DF tables, R3's receiver state and 29/30 replies.

Returning this interface to `ip ospf cost 10` was proposed after the final test. No retained output confirms that rollback or a return of the DF role to R1.

[Baseline settings](baseline.md) · [Configuration index](README.md) · [Overview](../README.md)
