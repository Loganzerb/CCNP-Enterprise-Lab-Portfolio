# Isolation — one router, separate forwarding contexts

The exercise first moved two differently addressed interfaces into VRFs, then deliberately reused the BLUE subnet in RED.

These are captured CLI excerpts. Full transcripts retain the original commands and results; only chat formatting is normalized. Omitted route-code legends are marked.

## Block 01 — Interface binding removes its address

Applying `vrf forwarding BLUE` removes the existing IPv4 address. Gi0/0 remains up/up but has no address or BLUE connected route. This is the captured IOSv transition, before reapplying the address.

```text
R1-VRF(config)#int g0/0
R1-VRF(config-if)#vrf def
R1-VRF(config-if)#vrf fo 
R1-VRF(config-if)#vrf forwarding BLUE
% Interface GigabitEthernet0/0 IPv4 disabled and address(es) removed due to enabling VRF BLUE
R1-VRF(config-if)#ex
R1-VRF(config)#end  
R1-VRF#
*Sep 27 22:12:05.889: %SYS-5-CONFIG_I: Configured from console by console
R1-VRF#show running-config interface GigabitEthernet0/0
Building configuration...

Current configuration : 143 bytes
!
interface GigabitEthernet0/0
 description LINK-TO-BLUE-CE
 vrf forwarding BLUE
 no ip address
 duplex auto
 speed auto
 media-type rj45
end

R1-VRF#show ip interface brief
Interface                  IP-Address      OK? Method Status                Protocol
GigabitEthernet0/0         unassigned      YES manual up                    up      
GigabitEthernet0/1         10.20.20.1      YES manual up                    up      
GigabitEthernet0/2         unassigned      YES unset  administratively down down    
GigabitEthernet0/3         unassigned      YES unset  administratively down down    
R1-VRF#show vrf
  Name                             Default RD            Protocols   Interfaces
  BLUE                             <not set>             ipv4        Gi0/0
  RED                              <not set>             ipv4        
R1-VRF#show ip route connected
[Route-code legend omitted]

Gateway of last resort is not set

      10.0.0.0/8 is variably subnetted, 2 subnets, 2 masks
C        10.20.20.0/24 is directly connected, GigabitEthernet0/1
L        10.20.20.1/32 is directly connected, GigabitEthernet0/1
R1-VRF#show ip route vrf BLUE connected

Routing Table: BLUE
[Route-code legend omitted]

Gateway of last resort is not set

R1-VRF#
```

[Full captured text](block-01.txt)

## Block 02 — Both interfaces belong to their intended VRFs

RED initially uses 10.20.20.0/24. Its address is reapplied after VRF binding. `show vrf` places BLUE on Gi0/0 and RED on Gi0/1; neither connected subnet remains in the global table.

```text
R1-VRF(config)#inter
R1-VRF(config)#interface g0/1
R1-VRF(config-if)#vrf forw 
R1-VRF(config-if)#vrf forwarding RED
% Interface GigabitEthernet0/1 IPv4 disabled and address(es) removed due to enabling VRF RED
R1-VRF(config-if)#ip ad
R1-VRF(config-if)#ip add
R1-VRF(config-if)#ip address 10.20.20.1 255.255.255.0
R1-VRF(config-if)#exit
R1-VRF(config)#end
R1-VRF#
*Sep 27 22:17:02.235: %SYS-5-CONFIG_I: Configured from console by console
R1-VRF#show vrf
  Name                             Default RD            Protocols   Interfaces
  BLUE                             <not set>             ipv4        Gi0/0
  RED                              <not set>             ipv4        Gi0/1
R1-VRF#show ip route connected
[Route-code legend omitted]

Gateway of last resort is not set

R1-VRF#show ip route vrf BLUE connected

Routing Table: BLUE
[Route-code legend omitted]

Gateway of last resort is not set

      10.0.0.0/8 is variably subnetted, 2 subnets, 2 masks
C        10.10.10.0/24 is directly connected, GigabitEthernet0/0
L        10.10.10.1/32 is directly connected, GigabitEthernet0/0
R1-VRF#show ip route vrf RED connected

Routing Table: RED
[Route-code legend omitted]

Gateway of last resort is not set

      10.0.0.0/8 is variably subnetted, 2 subnets, 2 masks
C        10.20.20.0/24 is directly connected, GigabitEthernet0/1
L        10.20.20.1/32 is directly connected, GigabitEthernet0/1
R1-VRF#
```

[Full captured text](block-02.txt)

## Block 03 — The same connected and local prefixes coexist

After changing RED to the overlapping subnet, both interfaces use 10.10.10.1/24. Each VRF independently installs its connected /24 and local /32.

```text
R1-VRF#show ip interface brief
Interface                  IP-Address      OK? Method Status                Protocol
GigabitEthernet0/0         10.10.10.1      YES manual up                    up      
GigabitEthernet0/1         10.10.10.1      YES manual up                    up      
GigabitEthernet0/2         unassigned      YES unset  administratively down down    
GigabitEthernet0/3         unassigned      YES unset  administratively down down    
R1-VRF#show ip route vrf BLUE connected

Routing Table: BLUE
[Route-code legend omitted]

Gateway of last resort is not set

      10.0.0.0/8 is variably subnetted, 2 subnets, 2 masks
C        10.10.10.0/24 is directly connected, GigabitEthernet0/0
L        10.10.10.1/32 is directly connected, GigabitEthernet0/0
R1-VRF#show ip route vrf RED connected

Routing Table: RED
[Route-code legend omitted]

Gateway of last resort is not set

      10.0.0.0/8 is variably subnetted, 2 subnets, 2 masks
C        10.10.10.0/24 is directly connected, GigabitEthernet0/1
L        10.10.10.1/32 is directly connected, GigabitEthernet0/1
R1-VRF#
```

[Full captured text](block-03.txt)

## Block 04 — Reach the same neighbor address in both VRFs

BLUE receives 5/5 replies. The first RED test receives 4/5, with one initial timeout; its cause is not established by this capture. Later RED tests receive 5/5.

```text
R1-VRF#ping vrf BLUE 10.10.10.2
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 10.10.10.2, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 1/1/2 ms
R1-VRF#ping vrf RED 10.10.10.2
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 10.10.10.2, timeout is 2 seconds:
.!!!!
Success rate is 80 percent (4/5), round-trip min/avg/max = 1/1/2 ms
R1-VRF#
```

[Full captured text](block-04.txt)

## Block 05 — One IP resolves to two different MAC addresses

BLUE resolves 10.10.10.2 to 5254.0005.97a3 on Gi0/0; RED resolves it to 5254.0013.95df on Gi0/1. ARP resolution follows the routing context.

```text
R1-VRF#show ip arp vrf BLUE
Protocol  Address          Age (min)  Hardware Addr   Type   Interface
Internet  10.10.10.1              -   5254.001d.b3b9  ARPA   GigabitEthernet0/0
Internet  10.10.10.2              9   5254.0005.97a3  ARPA   GigabitEthernet0/0
R1-VRF#show ip arp vrf RED 
Protocol  Address          Age (min)  Hardware Addr   Type   Interface
Internet  10.10.10.1              -   5254.000d.35ee  ARPA   GigabitEthernet0/1
Internet  10.10.10.2              0   5254.0013.95df  ARPA   GigabitEthernet0/1
R1-VRF#
```

[Full captured text](block-05.txt)

## Block 06 — Local CEF receive entries remain separate

The local address 10.10.10.1 has a receive entry associated with the appropriate interface in each VRF. It terminates on R1 rather than being forwarded to a CE.

```text
R1-VRF#show ip cef vrf RED 10.10.10.1
10.10.10.1/32
  receive for GigabitEthernet0/1
R1-VRF#show ip cef vrf BLUE 10.10.10.1
10.10.10.1/32
  receive for GigabitEthernet0/0
R1-VRF#
```

[Full captured text](block-06.txt)

## Block 07 — Neighbor CEF entries select different interfaces

The destination 10.10.10.2 is attached through Gi0/0 in BLUE and Gi0/1 in RED. The separation extends from the RIB into ARP/adjacency and the CEF forwarding information base.

```text
R1-VRF#show ip cef vrf BLUE 10.10.10.2 detail
10.10.10.2/32, epoch 0, flags [attached]
  Adj source: IP adj out of GigabitEthernet0/0, addr 10.10.10.2 0F9DB900
    Dependent covered prefix type adjfib, cover 10.10.10.0/24
  attached to GigabitEthernet0/0
R1-VRF#show ip cef vrf RED 10.10.10.2 detail
10.10.10.2/32, epoch 0, flags [attached]
  Adj source: IP adj out of GigabitEthernet0/1, addr 10.10.10.2 0F9DB7D0
    Dependent covered prefix type adjfib, cover 10.10.10.0/24
  attached to GigabitEthernet0/1
R1-VRF#
```

[Full captured text](block-07.txt)

[Evidence index](README.md) · [VRF overview](../README.md)
