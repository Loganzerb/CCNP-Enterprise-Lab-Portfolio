# Next-hop adjacency loss and recovery

Read the [verification guide](README.md) for capture conventions. Each numbered block contains retained device output and a short explanation.

## Block 01

**Indirect route remains.** After the R2 Gi0/1 shutdown step, the next-hop subnet is learned through OSPF via R4; it has not disappeared from the RIB.

```text
R2-PBR-POLICY#show ip route 10.23.1.3
Routing entry for 10.23.1.0/24
Known via "ospf 1", distance 110, metric 3, type intra area
Last update from 10.24.1.4 on GigabitEthernet0/2, 00:00:02 ago
Routing Descriptor Blocks:

- 10.24.1.4, from 3.3.3.3, 00:00:02 ago, via GigabitEthernet0/2
  Route metric is 3, traffic share count is 1
  R2-PBR-POLICY#
```

## Block 02

**Observed path after shutdown.** Source A now traverses R4 directly to R5. The trace records the resulting path, not the internal PBR decision.

```text
R1-PBR-SOURCE#traceroute 10.5.5.5 source 10.1.1.1
Type escape sequence to abort.
Tracing the route to 10.5.5.5
VRF info: (vrf in name/id, vrf out name/id)
  1 10.12.1.2 2 msec 2 msec 1 msec
  2 10.24.1.4 2 msec 2 msec 2 msec
  3 10.45.1.5 3 msec 3 msec * 
R1-PBR-SOURCE#
```

## Block 03

**Direct connection restored.** After the no shutdown step, R2 again lists the next-hop subnet as connected on Gi0/1.

```text
R2-PBR-POLICY#show ip route 10.23.1.3
Routing entry for 10.23.1.0/24
Known via "connected", distance 0, metric 0 (connected, via interface)
Routing Descriptor Blocks:

- directly connected, via GigabitEthernet0/1
  Route metric is 0, traffic share count is 1
  R2-PBR-POLICY#
```

## Block 04

**Policy path returns.** The same explicit source-A trace once again traverses R3, R4 and R5.

```text
R1-PBR-SOURCE#traceroute 10.5.5.5 source 10.1.1.1
Type escape sequence to abort.
Tracing the route to 10.5.5.5
VRF info: (vrf in name/id, vrf out name/id)
  1 10.12.1.2 2 msec 2 msec 1 msec
  2 10.23.1.3 2 msec 2 msec 2 msec
  3 10.34.1.4 2 msec 2 msec 2 msec
  4 10.45.1.5 3 msec 4 msec * 
R1-PBR-SOURCE#
```

[Back to verification](README.md) · [Back to PBR](../README.md)
