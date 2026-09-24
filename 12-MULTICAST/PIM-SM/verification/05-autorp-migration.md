# Auto-RP migration — prove discovery before removing static RP

Retrieved CLI from MASTERCLASS CCNP LAB PART 4, September 22–23, 2026. Formatting cleanup decodes escaped spaces and Markdown characters and normalizes line endings. Snapshots are sequential, not simultaneous.

## Block 01

**Candidate RP configuration.** R2 accepts the announcement command using Loopback0. Scope 16 sets the advertisement TTL; it does not define a group range.

```text
R2-RP(config)#ip pim send-rp-announce loopback 0 scope 16 ?
  group-list  Group access-list
  interval    RP announcement interval
  <cr>        <cr>

R2-RP(config)#ip pim send-rp-announce loopback 0 scope 16
```

## Block 02

**Candidate announcements start.** R2 has the listener status line and Sent/Received counters of Announce 3/0 and Discovery 0/0. Candidate advertisement is distinct from mapping distribution.

```text
R2-RP#conf t             
*Sep 22 23:00:25.853: %SYS-5-CONFIG_I: Configured from console by cshow ip pim autorp 
AutoRP Information: 
  AutoRP is enabled.
  RP Discovery packet MTU is 0.
  224.0.1.40 is joined on Loopback0.
  AutoRP groups over sparse mode interface is enabled

PIM AutoRP Statistics: Sent/Received
  RP Announce: 3/0, RP Discovery: 0/0
R2-RP#
```

## Block 03

**Mapping Agent configuration.** R3 accepts send-rp-discovery scope 16.

```text
R3-TRANSIT(config)#ip pim send-rp-discovery scope 16 ?
  interval  RP discovery interval
  <cr>      <cr>

R3-TRANSIT(config)#ip pim send-rp-discovery scope 16
```

## Block 04

**The Mapping Agent receives and distributes.** The first snapshot has zero counters; the next has Announce 0/1 and Discovery 2/0. A first zero snapshot alone is not proof of failure.

```text
R3-TRANSIT#show ip p
*Sep 22 23:06:20.066: %SYS-5-CONFIG_I: Configured from console by consoleim au
R3-TRANSIT#show ip pim autorp 
AutoRP Information: 
  AutoRP is enabled.
  RP Discovery packet MTU is 1500.
  224.0.1.40 is joined on GigabitEthernet0/0.
  AutoRP groups over sparse mode interface is enabled

PIM AutoRP Statistics: Sent/Received
  RP Announce: 0/0, RP Discovery: 0/0
R3-TRANSIT#
R3-TRANSIT#show ip pim autorp 
AutoRP Information: 
  AutoRP is enabled.
  RP Discovery packet MTU is 1500.
  224.0.1.40 is joined on GigabitEthernet0/0.
  AutoRP groups over sparse mode interface is enabled

PIM AutoRP Statistics: Sent/Received
  RP Announce: 0/1, RP Discovery: 2/0
R3-TRANSIT#
```

## Block 05

**Downstream reception.** R4 records seven received Discovery messages and the listener status line.

```text
R4-LHR#sh ip pim autorp 
AutoRP Information: 
  AutoRP is enabled.
  RP Discovery packet MTU is 0.
  224.0.1.40 is joined on GigabitEthernet0/0.
  AutoRP groups over sparse mode interface is enabled

PIM AutoRP Statistics: Sent/Received
  RP Announce: 0/0, RP Discovery: 0/7
R4-LHR#
```

## Block 06

**Intentional coexistence.** R4 has both a dynamic mapping elected via Auto-RP and the static entry for the same RP. This is a migration checkpoint, not yet the Auto-RP-only state.

```text
R4-LHR#sh ip pim rp mapping 
PIM Group-to-RP Mappings

Group(s) 224.0.0.0/4
  RP 2.2.2.2 (?), v2v1
    Info source: 10.34.0.1 (?), elected via Auto-RP
         Uptime: 00:07:48, expires: 00:02:07
Group(s): 224.0.0.0/4, Static
    RP: 2.2.2.2 (?)
R4-LHR#
```

## Block 07

**R1 after static removal.** R1 displays only the Auto-RP mapping, supplied by R3's 10.13.0.2 interface. Interleaved logging remains in the capture.

```text
R1-FHR#show 
*Sep 22 23:20:28.061: %SYS-5-CONFIG_I: Configured from console by consoleip pim rp ma
R1-FHR#show ip pim rp mapping 
PIM Group-to-RP Mappings

Group(s) 224.0.0.0/4
  RP 2.2.2.2 (?), v2v1
    Info source: 10.13.0.2 (?), elected via Auto-RP
         Uptime: 00:14:08, expires: 00:02:45
R1-FHR#
```

## Block 08

**R2 after static removal.** R2 is identified as an Auto-RP RP and displays the dynamic mapping without a Static entry.

```text
R2-RP#show ip pim
*Sep 22 23:24:17.427: %SYS-5-CONFIG_I: Configured from console by console rp map
R2-RP#show ip pim rp mapping 
PIM Group-to-RP Mappings
This system is an RP (Auto-RP)

Group(s) 224.0.0.0/4
  RP 2.2.2.2 (?), v2v1
    Info source: 10.34.0.1 (?), elected via Auto-RP
         Uptime: 00:17:57, expires: 00:02:52
R2-RP#
```

## Block 09

**R3 after static removal.** R3 is identified as an RP-mapping agent and displays only the learned mapping. Its information source is the Candidate RP.

```text
R3-TRANSIT#show ip pi
*Sep 22 23:32:47.986: %SYS-5-CONFIG_I: Configured from console by consolem rp ma
R3-TRANSIT#show ip pim rp mapping 
PIM Group-to-RP Mappings
This system is an RP-mapping agent

Group(s) 224.0.0.0/4
  RP 2.2.2.2 (?), v2v1
    Info source: 2.2.2.2 (?), elected via Auto-RP
         Uptime: 00:26:28, expires: 00:02:28
R3-TRANSIT#
```

## Block 10

**R4 after domain migration.** R4 displays only the Auto-RP mapping from 10.34.0.1. The four snapshots support the recorded removal of the static command across R1–R4.

```text
R4-LHR#show ip pim rp mapping
PIM Group-to-RP Mappings

Group(s) 224.0.0.0/4
  RP 2.2.2.2 (?), v2v1
    Info source: 10.34.0.1 (?), elected via Auto-RP
         Uptime: 00:27:48, expires: 00:01:57
R4-LHR#
```

## Block 11

**Auto-RP-only delivery.** Twenty probes produce one timeout marker and nineteen replies from 10.4.4.10. The count is 19/20; the initial timeout occurred at startup, but its exact timing/cause was not measured. This is the migration test, not a post-repair loss measurement.

```text
MCAST-SOURCE#ping 239.1.1.1 repeat 20
Type escape sequence to abort.
Sending 20, 100-byte ICMP Echos to 239.1.1.1, timeout is 2 seconds:
.
Reply to request 1 from 10.4.4.10, 8 ms
Reply to request 2 from 10.4.4.10, 4 ms
Reply to request 3 from 10.4.4.10, 4 ms
Reply to request 4 from 10.4.4.10, 4 ms
Reply to request 5 from 10.4.4.10, 4 ms
Reply to request 6 from 10.4.4.10, 4 ms
Reply to request 7 from 10.4.4.10, 4 ms
Reply to request 8 from 10.4.4.10, 4 ms
Reply to request 9 from 10.4.4.10, 3 ms
Reply to request 10 from 10.4.4.10, 3 ms
Reply to request 11 from 10.4.4.10, 4 ms
Reply to request 12 from 10.4.4.10, 4 ms
Reply to request 13 from 10.4.4.10, 4 ms
Reply to request 14 from 10.4.4.10, 4 ms
Reply to request 15 from 10.4.4.10, 4 ms
Reply to request 16 from 10.4.4.10, 5 ms
Reply to request 17 from 10.4.4.10, 4 ms
Reply to request 18 from 10.4.4.10, 4 ms
Reply to request 19 from 10.4.4.10, 3 ms
MCAST-SOURCE#
```

[Back to Auto-RP](../auto-rp.md) · [Back to verification](README.md)

