# Shared service — build and inspect the forward path

SHARED-SVC is added to R1’s global table. The tests distinguish ordinary global reachability from selective access inside each VRF.

These are captured CLI excerpts. Full transcripts retain the original commands and results; only chat formatting is normalized. Omitted route-code legends are marked.

## Block 18 — The global service network works

R1 installs 172.16.50.0/24 on Gi0/2 and receives 5/5 replies from 172.16.50.10.

```text
R1-VRF#show ip route connected
[Route-code legend omitted]

Gateway of last resort is not set

      172.16.0.0/16 is variably subnetted, 2 subnets, 2 masks
C        172.16.50.0/24 is directly connected, GigabitEthernet0/2
L        172.16.50.1/32 is directly connected, GigabitEthernet0/2
R1-VRF#ping 172.16.50.10
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 172.16.50.10, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 1/1/2 ms
R1-VRF#
```

[Full captured text](block-18.txt)

## Block 19 — VRFs do not inherit global routes

Neither VRF has the service route. Both VRF-aware ping tests return 0/5.

```text
R1-VRF#show ip route vrf BLUE 172.16.50.10

Routing Table: BLUE
% Subnet not in table
R1-VRF#show ip route vrf RED 172.16.50.10

Routing Table: RED
% Subnet not in table
R1-VRF#ping vrf BLUE 172.16.50.10
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 172.16.50.10, timeout is 2 seconds:
.....
Success rate is 0 percent (0/5)
R1-VRF#ping vrf RED 172.16.50.10 
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 172.16.50.10, timeout is 2 seconds:
.....
Success rate is 0 percent (0/5)
R1-VRF#
```

[Full captured text](block-19.txt)

## Block 20 — Check the parser instead of assuming support

The IOSv command help explicitly offers `global`: “Next hop address is global.” This is capability evidence; the incomplete command line is not proof that a leak was installed.

```text
R1-VRF(config)#ip route vrf BLUE 172.16.50.10 255.255.255.255 172.16.50.10 ?
  <1-255>    Distance metric for this route
  global     Next hop address is global
  multicast  multicast route
  name       Specify name of the next hop
  permanent  permanent route
  tag        Set tag for this route
  track      Install route depending on tracked item
  <cr>       <cr>

R1-VRF(config)#ip route vrf BLUE 172.16.50.10 255.255.255.255 172.16.50.10
```

[Full captured text](block-20.txt)

## Block 21 — The forward leaks are configured and installed

Running-config includes `global` on both VRF host routes. Both RIB entries show next-hop context `(default)` and both CEF entries resolve to global Gi0/2. The routes themselves remain in BLUE and RED.

```text
R1-VRF#show running-config | include 172.16.50.10
ip route vrf BLUE 172.16.50.10 255.255.255.255 172.16.50.10 global
ip route vrf RED 172.16.50.10 255.255.255.255 172.16.50.10 global
R1-VRF#show ip route vrf BLUE 172.16.50.10

Routing Table: BLUE
Routing entry for 172.16.50.10/32
  Known via "static", distance 1, metric 0
  Routing Descriptor Blocks:
  * 172.16.50.10 (default)
      Route metric is 0, traffic share count is 1
R1-VRF#show ip route vrf RED 172.16.50.10

Routing Table: RED
Routing entry for 172.16.50.10/32
  Known via "static", distance 1, metric 0
  Routing Descriptor Blocks:
  * 172.16.50.10 (default)
      Route metric is 0, traffic share count is 1
R1-VRF#show ip cef vrf BLUE 172.16.50.10 detail
172.16.50.10/32, epoch 0
  recursive via 172.16.50.10
    attached to GigabitEthernet0/2
R1-VRF#show ip cef vrf RED 172.16.50.10 detail
172.16.50.10/32, epoch 0
  recursive via 172.16.50.10
    attached to GigabitEthernet0/2
R1-VRF#
```

[Full captured text](block-21.txt)

## Block 22 — Forward routes alone do not complete the test

Both VRF-aware service pings still return 0/5 after forward routes install. The capture does not show the chosen source address, so it alone cannot establish the precise return lookup.

```text
R1-VRF#ping vrf BLUE 172.16.50.10
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 172.16.50.10, timeout is 2 seconds:
.....
Success rate is 0 percent (0/5)
R1-VRF#ping vrf RED 172.16.50.10 
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 172.16.50.10, timeout is 2 seconds:
.....
Success rate is 0 percent (0/5)
R1-VRF#
```

[Full captured text](block-22.txt)

## Block 23 — The service has an installed default route

SHARED-SVC’s default route points to 172.16.50.1 and Gi0/0 is up/up. Subsequent tests use unique CE loopbacks to make the missing global return destinations explicit.

```text
SHARED-SVC#show running-config | include ^ip route
ip route 0.0.0.0 0.0.0.0 172.16.50.1
SHARED-SVC#show ip route 0.0.0.0
Routing entry for 0.0.0.0/0, supernet
  Known via "static", distance 1, metric 0, candidate default path
  Routing Descriptor Blocks:
  * 172.16.50.1
      Route metric is 0, traffic share count is 1
SHARED-SVC#show ip interface brief
Interface                  IP-Address      OK? Method Status                Protocol
GigabitEthernet0/0         172.16.50.10    YES manual up                    up      
GigabitEthernet0/1         unassigned      YES unset  administratively down down    
GigabitEthernet0/2         unassigned      YES unset  administratively down down    
GigabitEthernet0/3         unassigned      YES unset  administratively down down    
SHARED-SVC#
```

[Full captured text](block-23.txt)

[Evidence index](README.md) · [VRF overview](../README.md)
