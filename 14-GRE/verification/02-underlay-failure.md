# Underlay failure — forwarding stops before displayed state catches up

R1’s transport static route was deliberately removed. These sequential samples distinguish reachability, tunnel display and OSPF state; they do not establish a precise convergence time.

These excerpts retain actual CLI from the completed lab. The linked full transcripts preserve all supplied lines; selections are identified where used.

## Block 06 — The first display still looks healthy

The initial post-removal sample still shows up/up, OSPF FULL and the learned private route. This sample alone does not prove usable forwarding.

```text
R1-GRE#show interfaces Tunnel0 | include Tunnel0|Tunnel source
Tunnel0 is up, line protocol is up 
  Tunnel source 192.0.2.1, destination 198.51.100.2
R1-GRE#show ip ospf neighbor

Neighbor ID     Pri   State           Dead Time   Address         Interface
3.3.3.3           0   FULL/  -        00:00:36    172.16.13.2     Tunnel0
R1-GRE#show ip route 10.3.3.1
Routing entry for 10.3.3.1/32
  Known via "ospf 10", distance 110, metric 1001, type intra area
  Last update from 172.16.13.2 on Tunnel0, 00:07:06 ago
  Routing Descriptor Blocks:
  * 172.16.13.2, from 3.3.3.3, 00:07:06 ago, via Tunnel0
      Route metric is 1001, traffic share count is 1
R1-GRE#
R1-GRE#
```

[Full captured text](block-06.txt)

## Block 07 — The transport destination has no route

The destination lookup returns `% Network not in table`, and the static-route filter returns no lines. The previous healthy display must be checked against this missing dependency.

```text
R1-GRE#
R1-GRE#show ip route 198.51.100.2
% Network not in table
R1-GRE#show running-config | include ^ip route
R1-GRE#
```

[Full captured text](block-07.txt)

## Block 08 — CEF and traffic reveal the failure

CEF has no route. Both the sourced transport ping and overlay ping return 0/5. The later sample shows Tunnel0 up/down and an empty OSPF neighbor table. The excerpt begins at CEF; the full transcript also retains the earlier up/up and FULL observations.

```text
R1-GRE#show ip cef 198.51.100.2 detail
0.0.0.0/0, epoch 0, flags [default route handler, default route]
  no route
R1-GRE#
R1-GRE#ping 198.51.100.2 source 192.0.2.1
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 198.51.100.2, timeout is 2 seconds:
Packet sent with a source address of 192.0.2.1 
.....
Success rate is 0 percent (0/5)
R1-GRE#ping 172.16.13.2
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 172.16.13.2, timeout is 2 seconds:
.....
Success rate is 0 percent (0/5)
R1-GRE#show interfaces Tunnel0 | include Tunnel0|Tunnel source
Tunnel0 is up, line protocol is down 
  Tunnel source 192.0.2.1, destination 198.51.100.2
R1-GRE#show ip ospf neighbor
R1-GRE#
```

[Full captured text](block-08.txt)

## Block 09 — Restore the underlay route

The covering /30 returns through 192.0.2.2, Tunnel0 is up/up, and OSPF is FULL again. This recovery capture contains route and control-plane checks, not a new private-loopback ping.

```text
R1-GRE#show ip route 198.51.100.2
Routing entry for 198.51.100.0/30
  Known via "static", distance 1, metric 0
  Routing Descriptor Blocks:
  * 192.0.2.2
      Route metric is 0, traffic share count is 1
R1-GRE#show interfaces Tunnel0 | include Tunnel0|Tunnel source
Tunnel0 is up, line protocol is up 
  Tunnel source 192.0.2.1, destination 198.51.100.2
R1-GRE#show ip ospf neighbor

Neighbor ID     Pri   State           Dead Time   Address         Interface
3.3.3.3           0   FULL/  -        00:00:35    172.16.13.2     Tunnel0
R1-GRE#.
```

[Full captured text](block-09.txt)

[Evidence index](README.md) · [GRE overview](../README.md)
