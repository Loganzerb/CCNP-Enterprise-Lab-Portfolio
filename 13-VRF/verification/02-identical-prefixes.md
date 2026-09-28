# Identical remote prefixes — verify recursive resolution

Both CEs receive the same Loopback0 address. R1 must resolve the same destination and next-hop IP independently in BLUE and RED.

These are captured CLI excerpts. Full transcripts retain the original commands and results; only chat formatting is normalized. Omitted route-code legends are marked.

## Block 08 — Both CEs host the same loopback

The interface and connected-route captures show 172.16.100.1 on Loopback0 of each CE.

```text
RED-CE#show ip interface brief
Interface                  IP-Address      OK? Method Status                Protocol
GigabitEthernet0/0         10.10.10.2      YES NVRAM  up                    up      
GigabitEthernet0/1         unassigned      YES NVRAM  administratively down down    
GigabitEthernet0/2         unassigned      YES NVRAM  administratively down down    
GigabitEthernet0/3         unassigned      YES NVRAM  administratively down down    
Loopback0                  172.16.100.1    YES manual up                    up      
RED-CE#show ip route connected
[Route-code legend omitted]

Gateway of last resort is not set

      10.0.0.0/8 is variably subnetted, 2 subnets, 2 masks
C        10.10.10.0/24 is directly connected, GigabitEthernet0/0
L        10.10.10.2/32 is directly connected, GigabitEthernet0/0
      172.16.0.0/32 is subnetted, 1 subnets
C        172.16.100.1 is directly connected, Loopback0
RED-CE#
BLUE-CE#show ip interface brief
Interface                  IP-Address      OK? Method Status                Protocol
GigabitEthernet0/0         10.10.10.2      YES NVRAM  up                    up      
GigabitEthernet0/1         unassigned      YES NVRAM  administratively down down    
GigabitEthernet0/2         unassigned      YES NVRAM  administratively down down    
GigabitEthernet0/3         unassigned      YES NVRAM  administratively down down    
Loopback0                  172.16.100.1    YES manual up                    up      
BLUE-CE#show ip route connected
[Route-code legend omitted]

Gateway of last resort is not set

      10.0.0.0/8 is variably subnetted, 2 subnets, 2 masks
C        10.10.10.0/24 is directly connected, GigabitEthernet0/0
L        10.10.10.2/32 is directly connected, GigabitEthernet0/0
      172.16.0.0/32 is subnetted, 1 subnets
C        172.16.100.1 is directly connected, Loopback0
BLUE-CE#
```

[Full captured text](block-08.txt)

## Block 09 — Identical static routes install independently

Each VRF installs 172.16.100.1/32 through 10.10.10.2. The VRF name supplies the context missing from the IP addresses alone.

```text
R1-VRF#show ip route vrf BLUE 172.16.100.1

Routing Table: BLUE
Routing entry for 172.16.100.1/32
  Known via "static", distance 1, metric 0
  Routing Descriptor Blocks:
  * 10.10.10.2
      Route metric is 0, traffic share count is 1
R1-VRF#show ip route vrf RED 172.16.100.1

Routing Table: RED
Routing entry for 172.16.100.1/32
  Known via "static", distance 1, metric 0
  Routing Descriptor Blocks:
  * 10.10.10.2
      Route metric is 0, traffic share count is 1
R1-VRF#
```

[Full captured text](block-09.txt)

## Block 10 — Both remote-loopback tests succeed

R1 receives 5/5 replies to 172.16.100.1 in BLUE and 5/5 in RED.

```text
R1-VRF#ping vrf BLUE 172.16.100.1
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 172.16.100.1, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 1/1/2 ms
R1-VRF#ping vrf RED 172.16.100.1 
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 172.16.100.1, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 1/1/2 ms
R1-VRF#
```

[Full captured text](block-10.txt)

## Block 11 — CEF follows the correct recursive chain

Both entries recurse through 10.10.10.2. BLUE resolves to Gi0/0; RED resolves to Gi0/1.

```text
R1-VRF#sh ip cef vrf BLUE 172.16.100.1 de
R1-VRF#sh ip cef vrf BLUE 172.16.100.1 detail 
172.16.100.1/32, epoch 0
  recursive via 10.10.10.2
    attached to GigabitEthernet0/0
R1-VRF#sh ip cef vrf RED 172.16.100.1 detail  
172.16.100.1/32, epoch 0
  recursive via 10.10.10.2
    attached to GigabitEthernet0/1
R1-VRF#
```

[Full captured text](block-11.txt)

[Evidence index](README.md) · [VRF overview](../README.md)
