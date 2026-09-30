# Healthy baseline — verify transport, tunnel and traffic

The healthy sequence proves the outer transport endpoints first, then the overlay and private traffic carried through it.

These excerpts retain actual CLI from the completed lab. The linked full transcripts preserve all supplied lines; selections are identified where used.

## Block 01 — Reach the actual GRE transport endpoints

R1 has a static route covering 198.51.100.2 through R2 at 192.0.2.2. The ping explicitly uses the GRE source address, 192.0.2.1, and returns 5/5 replies.

```text
R1-GRE#show ip route 198.51.100.2
Routing entry for 198.51.100.0/30
  Known via "static", distance 1, metric 0
  Routing Descriptor Blocks:
  * 192.0.2.2
      Route metric is 0, traffic share count is 1
R1-GRE#ping 198.51.100.2 source 192.0.2.1
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 198.51.100.2, timeout is 2 seconds:
Packet sent with a source address of 192.0.2.1 
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 1/2/3 ms
R1-GRE#
```

[Full captured text](block-01.txt)

## Block 02 — Inspect the tunnel’s actual parameters

**📁 GitHub Evidence**

Tunnel0 is up/up with overlay address 172.16.13.1/30, source 192.0.2.1 and destination 198.51.100.2. GRE/IP, transport MTU 1476, no keepalive, disabled key/checksum/sequence, and TTL 255 are captured values. The separate interface MTU field is 17916; it is not the measured unfragmented transport limit.

```text
R1-GRE#show interfaces Tunnel0
Tunnel0 is up, line protocol is up 
  Hardware is Tunnel
  Internet address is 172.16.13.1/30
  MTU 17916 bytes, BW 100 Kbit/sec, DLY 50000 usec, 
     reliability 255/255, txload 1/255, rxload 1/255
  Encapsulation TUNNEL, loopback not set
  Keepalive not set
  Tunnel linestate evaluation up
  Tunnel source 192.0.2.1, destination 198.51.100.2
  Tunnel protocol/transport GRE/IP
    Key disabled, sequencing disabled
    Checksumming of packets disabled
  Tunnel TTL 255, Fast tunneling enabled
  Tunnel transport MTU 1476 bytes
  Tunnel transmit bandwidth 8000 (kbps)
  Tunnel receive bandwidth 8000 (kbps)
[Remaining interface counters omitted; see full captured text.]
```

[Full captured text](block-02.txt)

## Block 03 — Test the overlay peer

R1 receives 5/5 replies from R3’s Tunnel0 address, 172.16.13.2. This adds a forwarding test to the up/up display.

```text
R1-GRE#ping 172.16.13.2
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 172.16.13.2, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 2/2/3 ms
R1-GRE#
```

[Full captured text](block-03.txt)

## Block 04 — Run OSPF across Tunnel0

**📁 GitHub Evidence**

Neighbor RID 3.3.3.3 is FULL at overlay address 172.16.13.2. OSPF process 10 installs 10.3.3.1/32 through Tunnel0 with metric 1001. The CE loopback is configured with a /24 mask; its OSPF loopback advertisement is a /32.

```text
R1-GRE#show ip ospf neighbor

Neighbor ID     Pri   State           Dead Time   Address         Interface
3.3.3.3           0   FULL/  -        00:00:38    172.16.13.2     Tunnel0
R1-GRE#show ip route 10.3.3.1
Routing entry for 10.3.3.1/32
  Known via "ospf 10", distance 110, metric 1001, type intra area
  Last update from 172.16.13.2 on Tunnel0, 00:03:54 ago
  Routing Descriptor Blocks:
  * 172.16.13.2, from 3.3.3.3, 00:03:54 ago, via Tunnel0
      Route metric is 1001, traffic share count is 1
R1-GRE#
```

[Full captured text](block-04.txt)

## Block 05 — Carry private-to-private traffic

**📁 GitHub Evidence**

The ping is sourced from R1’s 10.1.1.1 loopback and targets R3’s 10.3.3.1 loopback. All five replies return across the overlay. The saved R2 configuration has only the two connected transport networks and no overlay routing process.

```text
R1-GRE#ping 10.3.3.1 source 10.1.1.1
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 10.3.3.1, timeout is 2 seconds:
Packet sent with a source address of 10.1.1.1 
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 2/2/3 ms
R1-GRE#
```

[Full captured text](block-05.txt)

[Evidence index](README.md) · [GRE overview](../README.md)
