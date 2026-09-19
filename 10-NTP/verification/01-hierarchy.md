# Hierarchy and synchronization

Read the [verification guide](README.md) for field meanings and capture conventions. Blocks retain selected device outputs in test order; each introduction states what that capture establishes.

## Block 01

**R1 local source.** R1 reports synchronized at stratum 1, referencing its own local clock.

```text
R1-NTP-SOURCE-A#show ntp status 
Clock is synchronized, stratum 1, reference is .LOCL.
nominal freq is 1000.0003 Hz, actual freq is 1000.0003 Hz, precision is 2**16
ntp uptime is 103600 (1/100 of seconds), resolution is 1000
reference time is EE5842A6.8E3E5ABD (23:07:18.555 UTC Fri Sep 18 2026)
clock offset is 0.0000 msec, root delay is 0.00 msec
root dispersion is 0.42 msec, peer dispersion is 0.24 msec
loopfilter state is 'CTRL' (Normal Controlled Loop), drift is 0.000000000 s/s
system poll interval is 16, last update was 12 sec ago.
R1-NTP-SOURCE-A#
```

## Block 02

**R2 synchronized.** R2 reports synchronized at stratum 2 with R1 as its reference.

```text
R2-NTP-CORE#sh ntp status 
Clock is synchronized, stratum 2, reference is 10.12.0.1      
nominal freq is 1000.0003 Hz, actual freq is 999.8811 Hz, precision is 2**16
ntp uptime is 147600 (1/100 of seconds), resolution is 1001
reference time is EE58461D.4D7BAF48 (23:22:05.302 UTC Fri Sep 18 2026)
clock offset is 102.0184 msec, root delay is 2.25 msec
root dispersion is 162.10 msec, peer dispersion is 6.16 msec
loopfilter state is 'CTRL' (Normal Controlled Loop), drift is 0.000119136 s/s
system poll interval is 64, last update was 247 sec ago.
R2-NTP-CORE#
```

## Block 03

**R3 selects R2.** The association selects R2 and shows the server's stratum as 2.

```text
R3-NTP-CLIENT#sh ntp associations

address         ref clock       st   when   poll reach  delay  offset   disp
*~10.20.0.1       10.12.0.1        2      6     64     3  3.150   2.068 62.957

* sys.peer, # selected, + candidate, - outlyer, x falseticker, ~ configured
  R3-NTP-CLIENT#
```

## Block 04

**Selection before synchronization.** R3 still reports unsynchronized and FREQ despite the preceding selected association.

```text
R3-NTP-CLIENT#sh ntp status 
Clock is unsynchronized, stratum 3, reference is 10.20.0.1      
nominal freq is 1000.0003 Hz, actual freq is 1000.0003 Hz, precision is 2**16
ntp uptime is 13300 (1/100 of seconds), resolution is 1000
reference time is EE5847D3.31DC6BD3 (23:29:23.194 UTC Fri Sep 18 2026)
clock offset is 2.0685 msec, root delay is 5.39 msec
root dispersion is 233.30 msec, peer dispersion is 62.95 msec
loopfilter state is 'FREQ' (Drift being measured), drift is 0.000000000 s/s
system poll interval is 64, last update was 64 sec ago.
R3-NTP-CLIENT#
```

## Block 05

**R3 synchronized.** A later status confirms synchronization at stratum 3 and CTRL.

```text
R3-NTP-CLIENT#sh ntp status               
Clock is synchronized, stratum 3, reference is 10.20.0.1      
nominal freq is 1000.0003 Hz, actual freq is 999.8678 Hz, precision is 2**16
ntp uptime is 113000 (1/100 of seconds), resolution is 1001
reference time is EE584B42.31A8B47C (23:44:02.193 UTC Fri Sep 18 2026)
clock offset is 95.9743 msec, root delay is 5.07 msec
root dispersion is 234.95 msec, peer dispersion is 3.39 msec
loopfilter state is 'CTRL' (Normal Controlled Loop), drift is 0.000132440 s/s
system poll interval is 64, last update was 182 sec ago.
R3-NTP-CLIENT#
```

## Block 06

**R4 local source.** The backup source reports synchronized at stratum 3 using its local reference.

```text
R4-NTP-SOURCE-B#sh ntp status 
Clock is synchronized, stratum 3, reference is 127.127.1.1    
nominal freq is 1000.0003 Hz, actual freq is 1000.0003 Hz, precision is 2**16
ntp uptime is 111100 (1/100 of seconds), resolution is 1000
reference time is EE5851C4.4655D31A (00:11:48.274 UTC Sat Sep 19 2026)
clock offset is 0.0000 msec, root delay is 0.00 msec
root dispersion is 0.36 msec, peer dispersion is 0.24 msec
loopfilter state is 'CTRL' (Normal Controlled Loop), drift is 0.000000000 s/s
system poll interval is 16, last update was 7 sec ago.
R4-NTP-SOURCE-B#
R4-NTP-SOURCE-B#
```

## Block 07

**Switch neighbors.** CDP confirms the three switch links and their router interfaces. This wiring capture predates the timing checks.

```text
SW1-NTP-ACCESS#show cdp neighbors
Capability Codes: R - Router, T - Trans Bridge, B - Source Route Bridge
                  S - Switch, H - Host, I - IGMP, r - Repeater, P - Phone, 
                  D - Remote, C - CVTA, M - Two-port Mac Relay 

Device ID        Local Intrfce     Holdtme    Capability  Platform  Port ID
R2-NTP-CORE      Gig 0/0           148              R B             Gig 0/1
R3-NTP-CLIENT    Gig 0/1           142              R B             Gig 0/0
R4-NTP-SOURCE-B  Gig 0/2           160              R B             Gig 0/0

Total cdp entries displayed : 3
SW1-NTP-ACCESS#
```

## Block 08

**Switch port state.** Ports Gi0/0 through Gi0/2 are connected in VLAN 1; unused Gi0/3 is disabled.

```text
Port      Name               Status       Vlan       Duplex  Speed Type 
Gi0/0     LINK-TO-R2-NTP-COR connected    1          a-full   auto RJ45
Gi0/1     LINK-TO-R3-NTP-CLI connected    1          a-full   auto RJ45
Gi0/2     LINK-TO-R4-NTP-SOU connected    1          a-full   auto RJ45
Gi0/3     UNUSED             disabled     1            auto   auto RJ45
SW1-NTP-ACCESS#
```

[Back to verification](README.md) · [Back to NTP](../README.md)
