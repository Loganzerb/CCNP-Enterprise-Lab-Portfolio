# Traffic and Flexible NetFlow cache

R2-SOURCE generated ICMP traffic from its Loopback0 to R3-DEST's Loopback0 through R1-FNF. The supplied results connect successful forwarding to the ingress monitor's local counters and later inactive expiration.

**Quick navigation:** [Traffic result](#traffic-result) · [Flow identity and counters](#flow-identity-and-counters) · [Cache timers and expiration](#cache-timers-and-expiration) · [Evidence scope](#evidence-scope)

## Traffic result

### Block 01

**Supplied command — R2-SOURCE.**

```cisco
ping 10.20.20.20 source 10.10.10.10 repeat 100
```

### Block 02

**Supplied ping output.**

```text
Sending 100, 100-byte ICMP Echos to 10.20.20.20,
timeout is 2 seconds:
Packet sent with a source address of 10.10.10.10

Success rate is 100 percent (100/100),
round-trip min/avg/max = 1/2/4 ms
```

All 100 probes received replies. The recorded round-trip minimum, average, and maximum were 1, 2, and 4 ms for this test.

## Flow identity and counters

### Block 03

**Supplied command — R1-FNF.**

```cisco
show flow monitor ENCOR-IPV4-MONITOR cache
```

### Block 04

**Supplied populated-cache excerpt.**

```text
Current entries:               1
High Watermark:                1

Flows added:                   1
Flows aged:                    0

IPV4 SOURCE ADDRESS:       10.10.10.10
IPV4 DESTINATION ADDRESS:  10.20.20.20
IP PROTOCOL:               1
counter bytes long:        10000
counter packets long:      100
```

The record identifies this flow using source address `10.10.10.10`, destination address `10.20.20.20`, and IP protocol `1` (ICMP). These three match fields determine flow identity; the two collected 64-bit counters accumulate its byte and packet totals. TCP/UDP port fields are not needed to identify this ICMP test flow.

The monitor is applied in the input direction on R1-FNF GigabitEthernet1. It counts the Echo Requests entering from R2-SOURCE. Return Echo Replies enter R1-FNF through GigabitEthernet2 and are not counted by that input attachment. The 100 recorded requests at 100 bytes each account for the 10,000-byte cache value.

## Cache timers and expiration

### Block 05

**Supplied operational timer values.**

```text
Inactive Timeout: 15 secs
Active Timeout:   60 secs
```

The monitor explicitly configures `cache timeout active 60`. The 15-second inactive timeout was observed in operational output and is absent from the final running configuration, consistent with a platform default. Active expiration concerns a flow that continues sending traffic; inactive expiration concerns a flow that stops. Only inactive expiration is demonstrated here.

### Block 06

**Supplied cache excerpt after traffic stopped.** The same cache command was used.

```text
Current entries:                               0
High Watermark:                                1

Flows added:                                   1
Flows aged:                                    1
  - Inactive timeout    (15 secs)              1

There are no cache entries to display.
```

The cache retained its high watermark and one added flow while reporting one flow aged by the inactive timeout. An empty cache at this point is normal expiration behavior; this excerpt does not indicate a monitoring failure.

## Evidence scope

These are selected results from the completed October 12, 2026 lab. The populated and expired cache excerpts describe separate observations. No active-expiration test, timing trace of the inactive interval, or failed monitoring test was supplied.

[Export and templates](export-and-templates.md) · [Verification index](README.md) · [Flexible NetFlow overview](../README.md) · [Configurations](../configs/README.md) · [Operation](../operation.md) · [Evidence scope](../scope.md)
