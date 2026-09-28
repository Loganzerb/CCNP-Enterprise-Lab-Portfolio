# Return path — complete the conversation

Unique CE loopbacks remove ambiguity from the shared service’s destination addresses. The final ping exchanges validate both request and reply forwarding.

These are captured CLI excerpts. Full transcripts retain the original commands and results; only chat formatting is normalized. Omitted route-code legends are marked.

## Block 24 — Each unique loopback works in its own VRF

BLUE installs 192.168.10.10/32; RED installs 192.168.20.20/32. Both VRF-aware tests return 5/5.

```text
R1-VRF#show ip route vrf BLUE 192.168.10.10

Routing Table: BLUE
Routing entry for 192.168.10.10/32
  Known via "static", distance 1, metric 0
  Routing Descriptor Blocks:
  * 10.10.10.2
      Route metric is 0, traffic share count is 1
R1-VRF#show ip route vrf RED 192.168.20.20

Routing Table: RED
Routing entry for 192.168.20.20/32
  Known via "static", distance 1, metric 0
  Routing Descriptor Blocks:
  * 10.10.10.2
      Route metric is 0, traffic share count is 1
R1-VRF#ping vrf BLUE 192.168.10.10
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 192.168.10.10, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 1/1/2 ms
R1-VRF#ping vrf RED 192.168.20.20 
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 192.168.20.20, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 1/1/2 ms
R1-VRF#
```

[Full captured text](block-24.txt)

## Block 25 — The service cannot yet reach either loopback

Both tests return U.U.U and 0/5. The specific-prefix lookups on SHARED-SVC show no matching entry; its installed default route is established separately in Block 23.

```text
SHARED-SVC#ping 192.168.10.10
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 192.168.10.10, timeout is 2 seconds:
U.U.U
Success rate is 0 percent (0/5)
SHARED-SVC#ping 192.168.20.20
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 192.168.20.20, timeout is 2 seconds:
U.U.U
Success rate is 0 percent (0/5)
SHARED-SVC#show ip route 192.168.10.10
% Network not in table
SHARED-SVC#show ip route 192.168.20.20
% Network not in table
SHARED-SVC#
```

[Full captured text](block-25.txt)

## Block 26 — R1’s global context lacks both destinations

These are the decisive lookups at R1: neither unique loopback exists globally before the return routes are added.

```text
R1-VRF#show ip route 192.168.10.10
% Network not in table
R1-VRF#show ip route 192.168.20.20
% Network not in table
R1-VRF#
```

[Full captured text](block-26.txt)

## Block 27 — Explicit egress resolves the overlapping next hop

Both global host routes now install through 10.10.10.2. The explicit interface selects BLUE on Gi0/0 or RED on Gi0/1, as shown in both RIB and CEF. This is observed behavior on this IOSv image.

```text
R1-VRF#show ip route 192.168.10.10
Routing entry for 192.168.10.10/32
  Known via "static", distance 1, metric 0
  Routing Descriptor Blocks:
  * 10.10.10.2, via GigabitEthernet0/0
      Route metric is 0, traffic share count is 1
R1-VRF#show ip route 192.168.20.20
Routing entry for 192.168.20.20/32
  Known via "static", distance 1, metric 0
  Routing Descriptor Blocks:
  * 10.10.10.2, via GigabitEthernet0/1
      Route metric is 0, traffic share count is 1
R1-VRF#show ip cef 192.168.10.10 detail
192.168.10.10/32, epoch 0
  nexthop 10.10.10.2 GigabitEthernet0/0
R1-VRF#show ip cef 192.168.20.20 detail
192.168.20.20/32, epoch 0
  nexthop 10.10.10.2 GigabitEthernet0/1
R1-VRF#
```

[Full captured text](block-27.txt)

## Block 28 — Both CEs have a path back to the service

Each CE installs 172.16.50.10/32 through 10.10.10.1. The identical next-hop IP belongs to a different physical link on each CE.

```text
BLUE-CE#show ip route 172.16.50.10
Routing entry for 172.16.50.10/32
  Known via "static", distance 1, metric 0
  Routing Descriptor Blocks:
  * 10.10.10.1
      Route metric is 0, traffic share count is 1
BLUE-CE#
RED-CE#show ip route 172.16.50.10
Routing entry for 172.16.50.10/32
  Known via "static", distance 1, metric 0
  Routing Descriptor Blocks:
  * 10.10.10.1
      Route metric is 0, traffic share count is 1
RED-CE#
```

[Full captured text](block-28.txt)

## Block 29 — Final shared-service tests succeed

SHARED-SVC receives 5/5 replies from each unique CE loopback. These exchanges establish working bidirectional ICMP forwarding for the two tested paths; independently initiated CE-to-service probes are not retained.

```text
SHARED-SVC#ping 192.168.10.10         
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 192.168.10.10, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 2/2/3 ms
SHARED-SVC#ping 192.168.20.20         
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 192.168.20.20, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 2/2/2 ms
SHARED-SVC#
```

[Full captured text](block-29.txt)

[Evidence index](README.md) · [VRF overview](../README.md)
