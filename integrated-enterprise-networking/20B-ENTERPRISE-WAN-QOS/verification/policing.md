# Lab 20B temporary ingress policing

The test added a temporary policer to the `VOICE` class on R2-EDGE-A's ingress. The policy used a 512,000-bps CIR and a 16,000-byte committed burst, with conforming traffic transmitted and exceeding traffic dropped. The saved final `MARK-IN` policy retains the EF marking and omits this experimental policer.

## Below-CIR test

**Original traffic test command — PC-CLIENT.**

```text
iperf -c 10.20.40.10 -u -p 5001 -b 256K -t 20 -i 2
```

**Captured iPerf excerpt — original traffic test, client and server report.**

```text
[  1] 0.00-20.05 sec   645 KBytes   263 Kbits/sec
[  1] Sent 450 datagrams
[  1] Server Report:
[ ID] Interval       Transfer     Bandwidth        Jitter   Lost/Total Datagrams
[  1] 0.00-20.05 sec   645 KBytes   263 Kbits/sec   0.407 ms 0/449 (0%)
```

At 263 kbps, the server report lists zero lost datagrams out of 449 and 0.407 ms jitter. The client and server lines report different datagram denominators. The loss result uses the server's displayed denominator.

## Above-CIR test

**Original traffic test command — PC-CLIENT.**

```text
iperf -c 10.20.40.10 -u -p 5001 -b 1M -t 20 -i 2
```

**Captured iPerf excerpt — original traffic test, client and server report.**

```text
[  1] 0.00-20.02 sec  2.51 MBytes  1.05 Mbits/sec
[  1] Sent 1788 datagrams
[  1] Server Report:
[ ID] Interval       Transfer     Bandwidth        Jitter   Lost/Total Datagrams
[  1] 0.00-20.13 sec  1.20 MBytes   500 Kbits/sec   7.533 ms 932/1788 (52%)
```

The client measured about 1.05 Mbps, and the server received 500 kbps. Its report counted 932 of 1,788 datagrams lost and 7.533 ms jitter.

## Policer and interface counters

**Captured CLI excerpt — original CML lab session, R2-EDGE-A, `show policy-map interface GigabitEthernet0/0` after both tests.**

```text
Class-map: VOICE (match-all)
  6357 packets, 9611784 bytes
  5 minute offered rate 61000 bps, drop rate 23000 bps
  Match: access-group name VOICE-TRAFFIC
  QoS Set
    dscp ef
      Packets marked 6357
  police:
      cir 512000 bps, bc 16000 bytes
    conformed 1305 packets, 1973160 bytes; actions:
      transmit
    exceeded 932 packets, 1409184 bytes; actions:
      drop
    conformed 29000 bps, exceeded 23000 bps
```

**Captured CLI excerpt — original CML lab session, R2-EDGE-A output-drop snapshot.**

```text
R2-EDGE-A#show interfaces GigabitEthernet0/1 | include Total output drops
  Input queue: 0/75/0/0 (size/max/drops/flushes); Total output drops: 155
```

The `VOICE` class's 6,357 packets are cumulative class matches. The policer counted 1,305 conforming packets and 932 exceeding packets across both policing tests, for 2,237 packets in that experiment. The 932 exceed drops equal the loss count in the above-CIR receiver report. The matching device and endpoint counts provide direct evidence of functional ingress policing in this run.

The original lab record reports that interface output drops stayed at 155 across the experiment and that outbound LLQ transmissions increased by 1,305. The selected interface excerpt shows one cumulative snapshot. The CIR defines the policer's traffic profile, and iPerf measures receiver application throughput.

[Verification matrix](README.md) · [Traffic performance](traffic-performance.md) · [Final policy](../configs/README.md#saved-r2-policy)
