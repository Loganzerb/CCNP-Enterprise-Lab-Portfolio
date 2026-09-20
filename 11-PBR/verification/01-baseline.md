# Baseline and selective forwarding

Read the [verification guide](README.md) for capture conventions. Each numbered block contains retained device output and a short explanation.

## Block 01

**R1 source interfaces.** R1's two loopbacks and transit link are up. The Router prompt predates the hostname correction.

```text
Router#show ip interface brief
Interface                  IP-Address      OK? Method Status                Protocol
GigabitEthernet0/0         10.12.1.1       YES manual up                    up      
GigabitEthernet0/1         unassigned      YES unset  administratively down down    
GigabitEthernet0/2         unassigned      YES unset  administratively down down    
GigabitEthernet0/3         unassigned      YES unset  administratively down down    
Loopback0                  10.1.1.1        YES manual up                    up      
Loopback1                  10.11.11.11     YES manual up                    up      
Router#
```

## Block 02

**R2 interfaces.** The policy router has separate links to R1, R3 and R4.

```text
R2-PBR-POLICY#show ip interface brief
Interface                  IP-Address      OK? Method Status                Protocol
GigabitEthernet0/0         10.12.1.2       YES manual up                    up      
GigabitEthernet0/1         10.23.1.2       YES manual up                    up      
GigabitEthernet0/2         10.24.1.2       YES manual up                    up      
GigabitEthernet0/3         unassigned      YES unset  administratively down down    
R2-PBR-POLICY#
```

## Block 03

**R3 interfaces.** Both links on the alternate branch are up.

```text
R3-PBR-ALT#show ip interface brief
Interface                  IP-Address      OK? Method Status                Protocol
GigabitEthernet0/0         10.23.1.3       YES manual up                    up      
GigabitEthernet0/1         10.34.1.3       YES manual up                    up      
GigabitEthernet0/2         unassigned      YES unset  administratively down down    
GigabitEthernet0/3         unassigned      YES unset  administratively down down    
R3-PBR-ALT#
```

## Block 04

**R4 interfaces.** The primary router connects to R2, R3 and R5.

```text
*Sep 19 21:54:47.753: %SYS-5-CONFIG_I: Configured from console by consoleshow ip interface brief
Interface                  IP-Address      OK? Method Status                Protocol
GigabitEthernet0/0         10.24.1.4       YES manual up                    up      
GigabitEthernet0/1         10.34.1.4       YES manual up                    up      
GigabitEthernet0/2         10.45.1.4       YES manual up                    up      
GigabitEthernet0/3         unassigned      YES unset  administratively down down    
R4-PBR-PRIMARY#
```

## Block 05

**R5 destination.** R5 has the destination loopback and transit interface up.

```text
R5-PBR-DEST#show ip interface brief
Interface                  IP-Address      OK? Method Status                Protocol
GigabitEthernet0/0         10.45.1.5       YES manual up                    up      
GigabitEthernet0/1         unassigned      YES unset  administratively down down    
GigabitEthernet0/2         unassigned      YES unset  administratively down down    
GigabitEthernet0/3         unassigned      YES unset  administratively down down    
Loopback0                  10.5.5.5        YES manual up                    up      
R5-PBR-DEST#
```

## Block 06

**Normal destination route.** Before PBR, R2 learns 10.5.5.5/32 through OSPF via R4, metric 3.

```text
R2-PBR-POLICY#show ip route 10.5.5.5
Routing entry for 10.5.5.5/32
Known via "ospf 1", distance 110, metric 3, type intra area
Last update from 10.24.1.4 on GigabitEthernet0/2, 00:01:15 ago
Routing Descriptor Blocks:

- 10.24.1.4, from 5.5.5.5, 00:01:15 ago, via GigabitEthernet0/2
  Route metric is 3, traffic share count is 1
  R2-PBR-POLICY#
```

## Block 07

**Normal source-A path.** The pre-policy trace passes through R2 and R4 to R5.

```text
R1-PBR-SOURCE#traceroute 10.5.5.5 source 10.1.1.1
Type escape sequence to abort.
Tracing the route to 10.5.5.5
VRF info: (vrf in name/id, vrf out name/id)
  1 10.12.1.2 2 msec 2 msec 2 msec
  2 10.24.1.4 2 msec 2 msec 2 msec
  3 10.45.1.5 3 msec 4 msec * 
R1-PBR-SOURCE#
```

## Block 08

**Classification ACL.** The baseline ACL permits source network 10.1.1.0/24.

```text
R2-PBR-POLICY#show access-lists PBR-SOURCE-A
Standard IP access list PBR-SOURCE-A
    10 permit 10.1.1.0, wildcard bits 0.0.0.255
R2-PBR-POLICY#
```

## Block 09

**Baseline route map.** Sequence 10 matches that ACL and sets R3 as next hop.

```text
R2-PBR-POLICY#show route-map PBR-TO-R3
route-map PBR-TO-R3, permit, sequence 10
  Match clauses:
    ip address (access-lists): PBR-SOURCE-A 
  Set clauses:
    ip next-hop 10.23.1.3
  Policy routing matches: 0 packets, 0 bytes
R2-PBR-POLICY#
```

## Block 10

**Ingress attachment.** The policy is attached to R2 Gi0/0, receiving R1's traffic.

```text
R2-PBR-POLICY#show ip policy
Interface      Route map
Gi0/0          PBR-TO-R3
R2-PBR-POLICY#
```

## Block 11

**Selected traffic takes R3.** The trace captured in response to the source-A test passes through R3. The entered command is absent from this capture; the final restoration page retains an explicit source-A command.

```text
Tracing the route to 10.5.5.5
VRF info: (vrf in name/id, vrf out name/id)
  1 10.12.1.2 2 msec 2 msec 2 msec
  2 10.23.1.3 2 msec 2 msec 2 msec
  3 10.34.1.4 3 msec 3 msec 3 msec
  4 10.45.1.5 3 msec 3 msec * 
R1-PBR-SOURCE#
```

## Block 12

**Destination route remains unchanged.** R2 still shows R4 as the OSPF next hop after the policy trace.

```text
R2-PBR-POLICY#show ip route 10.5.5.5
Routing entry for 10.5.5.5/32
Known via "ospf 1", distance 110, metric 3, type intra area
Last update from 10.24.1.4 on GigabitEthernet0/2, 00:33:05 ago
Routing Descriptor Blocks:

- 10.24.1.4, from 5.5.5.5, 00:33:05 ago, via GigabitEthernet0/2
  Route metric is 3, traffic share count is 1
  R2-PBR-POLICY#
```

## Block 13

**Source B follows normal routing.** The explicit 10.11.11.11 source test uses R4 directly.

```text
R1-PBR-SOURCE#traceroute 10.5.5.5 source 10.11.11.11
Type escape sequence to abort.
Tracing the route to 10.5.5.5
VRF info: (vrf in name/id, vrf out name/id)
  1 10.12.1.2 1 msec 2 msec 1 msec
  2 10.24.1.4 2 msec 3 msec 2 msec
  3 10.45.1.5 2 msec 4 msec * 
R1-PBR-SOURCE#
```

## Block 14

**Policy counter.** The permit sequence records 12 packets and 720 bytes. The captured prompt starts with 2 rather than R2.

```text
2-PBR-POLICY#show route-map PBR-TO-R3
route-map PBR-TO-R3, permit, sequence 10
  Match clauses:
    ip address (access-lists): PBR-SOURCE-A 
  Set clauses:
    ip next-hop 10.23.1.3
  Policy routing matches: 12 packets, 720 bytes
R2-PBR-POLICY#
```

[Back to verification](README.md) · [Back to PBR](../README.md)
