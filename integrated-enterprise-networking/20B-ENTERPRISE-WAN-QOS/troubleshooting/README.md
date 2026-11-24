# Lab 20B troubleshooting — Business traffic bypasses its queue

The deliberate fault changed ingress `BUSINESS` marking from AF21 (18) to AF31 (26). The dedicated outbound class still matched AF21. The historical captures show the policy mismatch and the restoration of the intended classification after ingress marking was corrected.

## Fault and recovery counter comparison

The table presents cumulative counters at the three checkpoints supplied with the historical captures. Selected input and output values are visible in the CLI excerpts below. The other snapshots come from the associated lab record.

| Counter | Before fault test | After fault test | After recovery test |
|---|---:|---:|---:|
| Inbound BUSINESS | 7,820 | 10,225 | 12,616 |
| Outbound BUSINESS-AF21 | 1,329 | 1,329 | 3,720 |
| Outbound BUSINESS-AF21 output | 1,194 | 1,194 | 3,365 |
| Outbound VOICE-EF | 1,787 | 1,787 | 1,787 |
| Outbound class-default | 38 | 2,463 | 2,489 |

During the fault, ingress `BUSINESS` increased by 2,405 and the output `BUSINESS-AF21` match and transmission counts stayed unchanged. The default class increased by 2,425. This supports a classification mismatch, with other traffic also possible in the default class.

During recovery, ingress `BUSINESS` and outbound `BUSINESS-AF21` both increased by **2,391 packets**. Output from the business queue increased by 2,171, and voice classification stayed unchanged. The default class reached 2,469 immediately before the recovery test after incidental traffic, so the recovery-test increment in that class was 20. The historical record reports 1.25 Mbps TCP throughput in the fault test and 1.21 Mbps after recovery. The matching classification deltas establish the recovery of queue selection. The transmission counters and final cumulative interface drops leave delivery of every classified packet and congestion resolution unverified.

## Captured fault

**Captured CLI excerpt — original CML lab session, R2-EDGE-A ingress marking.**

```text
R2-EDGE-A#show policy-map MARK-IN
  Policy Map MARK-IN
    Class VOICE
      set dscp ef
    Class BUSINESS
      set dscp af31
    Class class-default
      set dscp default
```

**Captured CLI excerpt — original CML lab session, R2-EDGE-A egress class definition.**

```text
R2-EDGE-A#show class-map BUSINESS-AF21
 Class Map match-all BUSINESS-AF21 (id 4)
   Match   dscp af21 (18)
```

**Captured CLI excerpts — original CML lab session, R2-EDGE-A ingress and outbound child-policy excerpts after the fault traffic test.**

```text
Class-map: BUSINESS (match-all)
  10225 packets, 15437520 bytes
  5 minute offered rate 93000 bps, drop rate 0000 bps
  Match: access-group name BUSINESS-TRAFFIC
  QoS Set
    dscp af31
      Packets marked 10225
```

```text
Class-map: BUSINESS-AF21 (match-all)
  1329 packets, 2003474 bytes
  5 minute offered rate 10000 bps, drop rate 0000 bps
  Match:  dscp af21 (18)
  Queueing
  queue limit 64 packets
  (queue depth/total drops/no-buffer drops) 0/0/0
  (pkts output/bytes output) 1194/1800532
  bandwidth 300 kbps
```

## Captured correction and recovery

**Captured CLI excerpt — original CML lab session, R2-EDGE-A corrected ingress marking.**

```text
R2-EDGE-A#show policy-map MARK-IN
  Policy Map MARK-IN
    Class VOICE
      set dscp ef
    Class BUSINESS
      set dscp af21
    Class class-default
      set dscp default
```

**Captured CLI excerpts — original CML lab session, R2-EDGE-A ingress and outbound child-policy excerpts after the recovery test.**

```text
Class-map: BUSINESS (match-all)
  12616 packets, 19048868 bytes
  5 minute offered rate 118000 bps, drop rate 0000 bps
  Match: access-group name BUSINESS-TRAFFIC
  QoS Set
    dscp af21
      Packets marked 12616
```

```text
Class-map: BUSINESS-AF21 (match-all)
  3720 packets, 5614816 bytes
  5 minute offered rate 77000 bps, drop rate 0000 bps
  Match:  dscp af21 (18)
  Queueing
  queue limit 64 packets
  (queue depth/total drops/no-buffer drops) 0/0/0
  (pkts output/bytes output) 3365/5078794
  bandwidth 300 kbps
```

**Captured CLI excerpt — original CML lab session, selected final policy configuration on R2-EDGE-A.**

```text
R2-EDGE-A#show running-config | section ^policy-map
policy-map WAN-OUT
 class VOICE-EF
  priority 1200
 class BUSINESS-AF21
  bandwidth 300
policy-map WAN-SHAPE
 class class-default
  shape average 2000000
   service-policy WAN-OUT
policy-map MARK-IN
 class VOICE
  set dscp ef
 class BUSINESS
  set dscp af21
 class class-default
  set dscp default
```

**Captured CLI excerpt — original CML lab session, final R2-EDGE-A cumulative interface output drops.**

```text
R2-EDGE-A#show interfaces GigabitEthernet0/1 | include Total output drops
  Input queue: 0/75/0/0 (size/max/drops/flushes); Total output drops: 1412
```

[Overview](../README.md) · [Verification matrix](../verification/README.md) · [Saved policy and implementation excerpts](../configs/README.md#saved-r2-policy) · [Study notes](../lessons-learned.md)
