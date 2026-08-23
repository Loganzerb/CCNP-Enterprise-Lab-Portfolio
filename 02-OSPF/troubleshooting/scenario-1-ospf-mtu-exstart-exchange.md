# Scenario 1: OSPF Adjacency Stuck in EXSTART Because of an IP MTU Mismatch

## Objective

Diagnose and remediate an Open Shortest Path First (OSPF) neighbor adjacency that stopped progressing beyond `EXSTART`, while preserving evidence of the failure and validating that the protocol recovered without restarting the OSPF process.

This case demonstrates a key troubleshooting principle: successful OSPF Hellos and basic Layer 3 connectivity do not prove that two neighbors can synchronize their link-state databases.

## Lab Context

| Device | Interface | IPv4 address | OSPF area | Healthy role |
|---|---|---:|---:|---|
| `O2-ABR` | `GigabitEthernet0/2` | `10.100.24.1/30` | Area 10 | Backup Designated Router (BDR) |
| `O4-EDGE` | `GigabitEthernet0/0` | `10.100.24.2/30` | Area 10 | Designated Router (DR) |

Router IDs used in the neighbor relationship were `10.100.2.2` for O2-ABR and `10.100.4.4` for O4-EDGE.

## Healthy Baseline

Before fault injection, the OSPF adjacency was `FULL`. O4-EDGE was the Designated Router (DR), and O2-ABR was the Backup Designated Router (BDR). Both physical interfaces reported a Maximum Transmission Unit (MTU) of 1500 bytes.

The healthy state established that addressing, Area 10 membership, OSPF neighbor formation, and DR/BDR election were functioning before the controlled change.

## Fault Injection

The fault was introduced on O2-ABR by lowering only the Layer 3 IP MTU on `GigabitEthernet0/2` and then bouncing the interface:

```cisco
configure terminal
interface GigabitEthernet0/2
 ip mtu 1400
 shutdown
 no shutdown
end
```

The command did not change the physical interface MTU. It changed the IP MTU used by Layer 3 protocols on O2-ABR's link to O4-EDGE.

## Observed Symptoms

After the interface returned, the OSPF adjacency stalled in `EXSTART` on both routers instead of returning to `FULL`.

O4-EDGE reported:

```text
Neighbor 10.100.2.2, interface address 10.100.24.1
   In the area 10 via interface GigabitEthernet0/0
   Neighbor priority is 1, State is EXSTART, 9 state changes
   DR is 10.100.24.2 BDR is 10.100.24.1
   Number of retransmissions for last database description packet 20
```

Despite the failed adjacency, O2-ABR could still reach O4-EDGE at `10.100.24.2`:

```text
O2-ABR#ping 10.100.24.2
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 10.100.24.2, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 1/1/2 ms
```

This separated basic IP reachability from OSPF database synchronization. OSPF Hellos were exchanged successfully enough to discover and maintain the neighbor, but Database Description (DBD) negotiation could not complete.

## Troubleshooting Process

### 1. Confirm the adjacency state

Detailed neighbor output showed that both routers were stuck in `EXSTART`. On O4-EDGE, the repeated DBD count provided an early indication that the failure occurred during database exchange rather than neighbor discovery.

### 2. Verify Layer 3 reachability

A five-packet ping from O2-ABR to O4-EDGE succeeded at 100 percent. This ruled out a complete link failure, but it did not prove that OSPF could complete database synchronization.

### 3. Compare the physical interface MTU

The standard interface command still showed 1500 bytes on both ends:

```text
O2-ABR#show interfaces GigabitEthernet0/2 | include MTU
  MTU 1500 bytes, BW 1000000 Kbit/sec, DLY 10 usec,

O4-EDGE#show interfaces GigabitEthernet0/0 | include MTU
  MTU 1500 bytes, BW 1000000 Kbit/sec, DLY 10 usec,
```

This output reflected the physical interface MTU. It did not reveal the lower IP MTU configured on O2-ABR.

### 4. Inspect the Layer 3 IP MTU and interface configuration

The IP-specific command exposed the mismatch:

```text
O2-ABR#show ip interface GigabitEthernet0/2 | include MTU
  MTU is 1400 bytes
```

The running configuration confirmed the source of that value:

```text
O2-ABR#show running-config interface GigabitEthernet0/2
interface GigabitEthernet0/2
 description LINK-TO-O4-EDGE
 ip address 10.100.24.1 255.255.255.252
 ip mtu 1400
 duplex auto
 speed auto
 media-type rj45
```

This was the decisive distinction: `show interfaces` reported a physical MTU of 1500, while `show ip interface` reported the effective Layer 3 IP MTU of 1400.

### 5. Correlate the configuration with OSPF debug output

Adjacency debugging on O4-EDGE explicitly identified the failure during DBD negotiation:

```text
Rcv DBD from 10.100.2.2 ... mtu 1400 state EXSTART
Nbr 10.100.2.2 has smaller interface MTU
Retransmitting DBD to 10.100.2.2
```

The advertised DBD MTU matched O2-ABR's configured IP MTU. Repeated DBD retransmissions explained why the adjacency remained in `EXSTART` even though Hellos and ICMP traffic continued to work.

## Root Cause

O2-ABR advertised an IP MTU of 1400 bytes in its OSPF DBD packets, while O4-EDGE expected 1500 bytes. The Layer 3 MTU mismatch prevented the neighbors from completing the database synchronization phase, leaving both sides in `EXSTART`.

The physical interface MTUs remained 1500 bytes throughout the incident. The fault existed only at the IP MTU layer on O2-ABR.

## Remediation

The injected IP MTU override was removed from O2-ABR:

```cisco
configure terminal
interface GigabitEthernet0/2
 no ip mtu
end
```

The OSPF process was not cleared, and the interface was not bounced during remediation. The protocol was allowed to recover naturally after the actual mismatch was removed.

## Post-Fix Verification

O2-ABR's IP MTU returned to 1500 bytes:

```text
O2-ABR#show ip interface GigabitEthernet0/2 | include MTU
  MTU is 1500 bytes
```

The adjacency then returned to `FULL` on O2-ABR:

```text
O2-ABR#show ip ospf neighbor 10.100.4.4
 Neighbor 10.100.4.4, interface address 10.100.24.2
   In the area 10 via interface GigabitEthernet0/2
   Neighbor priority is 1, State is FULL, 6 state changes
   DR is 10.100.24.2 BDR is 10.100.24.1
   retransmission queue length 0, number of retransmission 0
```

O4-EDGE independently confirmed the same recovery:

```text
O4-EDGE#show ip ospf neighbor 10.100.2.2
 Neighbor 10.100.2.2, interface address 10.100.24.1
   In the area 10 via interface GigabitEthernet0/0
   Neighbor priority is 1, State is FULL, 9 state changes
   DR is 10.100.24.2 BDR is 10.100.24.1
   retransmission queue length 0, number of retransmission 0
```

The original DR/BDR roles were preserved: O4-EDGE remained DR and O2-ABR remained BDR.

## Key Technical Takeaways

- A neighbor in `EXSTART` has progressed beyond Hello-based discovery but has not completed DBD negotiation and link-state database synchronization.
- Successful ICMP reachability does not prove that OSPF adjacency formation will succeed. In this case, O2-to-O4 ping remained 100 percent successful while OSPF was stuck in `EXSTART`.
- `show interfaces` and `show ip interface` answer different MTU questions. The former continued to show the physical interface MTU of 1500; the latter exposed O2-ABR's Layer 3 IP MTU of 1400.
- OSPF DBD packets carry an interface MTU value. O4-EDGE's debug tied the received value of 1400 directly to the failed negotiation and repeated retransmissions.
- Removing the faulty configuration was sufficient. Clearing the OSPF process was unnecessary because the adjacency recovered naturally once both sides used a compatible IP MTU.
- Troubleshooting should correlate protocol state, data-plane tests, interface views, running configuration, and targeted debug output rather than relying on a single command.

## Commands Used

### Baseline and neighbor-state validation

```cisco
show ip ospf neighbor 10.100.4.4
show ip ospf neighbor 10.100.2.2
```

### Reachability testing

```cisco
ping 10.100.24.2
```

### MTU comparison and configuration validation

```cisco
show interfaces GigabitEthernet0/2 | include MTU
show interfaces GigabitEthernet0/0 | include MTU
show ip interface GigabitEthernet0/2 | include MTU
show running-config interface GigabitEthernet0/2
```

### Protocol-level diagnosis

```cisco
debug ip ospf adj
```

### Remediation

```cisco
configure terminal
interface GigabitEthernet0/2
 no ip mtu
end
```

### Post-fix verification

```cisco
show ip interface GigabitEthernet0/2 | include MTU
show ip ospf neighbor 10.100.4.4
show ip ospf neighbor 10.100.2.2
```
