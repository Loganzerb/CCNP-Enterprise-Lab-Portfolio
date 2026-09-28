# Fault evidence — installed, resolved and reachable are separate checks

Two controlled faults target the RED route to 172.16.100.1. Each is repaired before the next exercise.

These are captured CLI excerpts. Full transcripts retain the original commands and results; only chat formatting is normalized. Omitted route-code legends are marked.

## Block 12 — A nonexistent next hop still installs

The RED static route points to 10.10.10.99. RED’s connected /24 covers that address, so route recursion reaches Gi0/1. This does not prove Layer 2 resolution.

```text
R1-VRF#show ip route vrf RED 172.16.100.1

Routing Table: RED
Routing entry for 172.16.100.1/32
  Known via "static", distance 1, metric 0
  Routing Descriptor Blocks:
  * 10.10.10.99
      Route metric is 0, traffic share count is 1
R1-VRF#show ip cef vrf RED 172.16.100.1 detail
172.16.100.1/32, epoch 0
  recursive via 10.10.10.99
    recursive via 10.10.10.0/24
      attached to GigabitEthernet0/1
R1-VRF#
```

[Full captured text](block-12.txt)

## Block 13 — The real CE works while the remote prefix fails

The real CE returns 5/5 replies, the loopback returns 0/5, and ARP for the configured next hop 10.10.10.99 is Incomplete. This isolates the fault to the next-hop adjacency rather than a failed CE link.

```text
R1-VRF#ping vrf RED 10.10.10.2
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 10.10.10.2, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 1/1/2 ms
R1-VRF#ping vrf RED 172.16.100.1
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 172.16.100.1, timeout is 2 seconds:
.....
Success rate is 0 percent (0/5)
R1-VRF#show ip arp vrf RED
Protocol  Address          Age (min)  Hardware Addr   Type   Interface
Internet  10.10.10.1              -   5254.000d.35ee  ARPA   GigabitEthernet0/1
Internet  10.10.10.2             30   5254.0013.95df  ARPA   GigabitEthernet0/1
Internet  10.10.10.99             0   Incomplete      ARPA   
R1-VRF#
```

[Full captured text](block-13.txt)

## Block 14 — Repair the next hop and retest

RED’s route points to 10.10.10.2 again, followed by 5/5 replies to the loopback.

```text
R1-VRF#show ip route vrf RED 172.16.100.1

Routing Table: RED
Routing entry for 172.16.100.1/32
  Known via "static", distance 1, metric 0
  Routing Descriptor Blocks:
  * 10.10.10.2
      Route metric is 0, traffic share count is 1
R1-VRF#ping vrf RED 172.16.100.1
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 172.16.100.1, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 1/1/2 ms
R1-VRF#
```

[Full captured text](block-14.txt)

## Block 15 — A global route exists in configuration only

After removing RED’s route, a static route without `vrf RED` appears in running-config. Neither the global nor RED RIB contains the destination.

```text
R1-VRF#show running-config | include 172.16.100.1
ip route 172.16.100.1 255.255.255.255 10.10.10.2
ip route vrf BLUE 172.16.100.1 255.255.255.255 10.10.10.2
R1-VRF#show ip route 172.16.100.1
% Network not in table
R1-VRF#show ip route vrf RED 172.16.100.1

Routing Table: RED
% Network not in table
R1-VRF#
```

[Full captured text](block-15.txt)

## Block 16 — The next hop exists only in RED

The global lookup for 10.10.10.2 fails; RED resolves it through its connected Gi0/1 network. Reachability in RED does not satisfy a global recursive lookup.

```text
R1-VRF#show ip route 10.10.10.2
% Network not in table
R1-VRF#show ip route vrf RED 10.10.10.2

Routing Table: RED
Routing entry for 10.10.10.0/24
  Known via "connected", distance 0, metric 0 (connected, via interface)
  Routing Descriptor Blocks:
  * directly connected, via GigabitEthernet0/1
      Route metric is 0, traffic share count is 1
R1-VRF#
```

[Full captured text](block-16.txt)

## Block 17 — Restore the route in the right context

The repaired RED route again uses 10.10.10.2 and the destination responds to all five probes.

```text
R1-VRF#show ip route vrf RED 172.16.100.1

Routing Table: RED
Routing entry for 172.16.100.1/32
  Known via "static", distance 1, metric 0
  Routing Descriptor Blocks:
  * 10.10.10.2
      Route metric is 0, traffic share count is 1
R1-VRF#ping vrf RED 172.16.100.1
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 172.16.100.1, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 1/1/2 ms
R1-VRF#
```

[Full captured text](block-17.txt)

[Evidence index](README.md) · [VRF overview](../README.md)
