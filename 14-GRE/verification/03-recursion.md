# Recursive routing — a tunnel cannot carry its own transport dependency

A more-specific static route deliberately points the remote GRE endpoint through the tunnel’s overlay next hop. The original healthy /30 remains configured.

These excerpts retain actual CLI from the completed lab. The linked full transcripts preserve all supplied lines; selections are identified where used.

## Block 10 — Correlate the bad route with explicit recursion logs

The captured command adds 198.51.100.2/32 through 172.16.13.2. The later RIB lookup displays the safe covering /30, while Tunnel0 is up/down. Syslogs at 22:46:43–22:46:48 UTC show the looped midchain, RECURDOWN, line-protocol loss and OSPF FULL-to-DOWN transition. Earlier buffered logs are excluded from this excerpt to avoid mixing incidents.

```text
R1-GRE#configure terminal
Enter configuration commands, one per line.  End with CNTL/Z.
R1-GRE(config)#ip route 198.51.100.2 255.255.255.255 172.16.13.2
R1-GRE(config)#end
R1-GRE#show ip route 198.51.100.2
Routing entry for 198.51.100.0/30
  Known via "static", distance 1, metric 0
  Routing Descriptor Blocks:
  * 192.0.2.2
      Route metric is 0, traffic share count is 1
R1-GRE#show interfaces Tunnel0 | include Tunnel0|Tunnel source
Tunnel0 is up, line protocol is down 
  Tunnel source 192.0.2.1, destination 198.51.100.2
R1-GRE#show interfaces Tunnel0 | include Tunnel0|Tunnel source
Tunnel0 is up, line protocol is down 
  Tunnel source 192.0.2.1, destination 198.51.100.2
[Earlier buffered syslogs omitted; see full captured text.]
*Sep 30 22:46:43.204: %ADJ-5-PARENT: Midchain parent maintenance for IP midchain out of Tunnel0 - looped chain attempting to stack
*Sep 30 22:46:48.952: %TUN-5-RECURDOWN: Tunnel0 temporarily disabled due to recursive routing
*Sep 30 22:46:48.952: %LINEPROTO-5-UPDOWN: Line protocol on Interface Tunnel0, changed state to down
*Sep 30 22:46:48.954: %OSPF-5-ADJCHG: Process 10, Nbr 3.3.3.3 on Tunnel0 from FULL to DOWN, Neighbor Down: Interface down or detached
```

[Full captured text](block-10.txt)

## Block 11 — Remove the bad /32 and verify recovery

After removing the recursive route, Tunnel0 is up/up, OSPF returns to FULL, and 10.3.3.1/32 is learned again with metric 1001. The repair command is documented separately from this captured recovery output.

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
  Last update from 172.16.13.2 on Tunnel0, 00:00:13 ago
  Routing Descriptor Blocks:
  * 172.16.13.2, from 3.3.3.3, 00:00:13 ago, via Tunnel0
      Route metric is 1001, traffic share count is 1
R1-GRE#
```

[Full captured text](block-11.txt)

[Evidence index](README.md) · [GRE overview](../README.md)
