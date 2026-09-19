# Loopback source and return routing

Read the [verification guide](README.md) for field meanings and capture conventions. Blocks retain selected device outputs in test order; each introduction states what that capture establishes.

## Block 01

**Loopback is up.** R3 has Loopback0 3.3.3.3 up/up.

```text
R3-NTP-CLIENT#show ip interface brief | include Loopback0
Loopback0                  3.3.3.3         YES manual up                    up      
R3-NTP-CLIENT#
```

## Block 02

**Missing return route.** R2 has no route entry for 3.3.3.3.

```text
R2-NTP-CORE#show ip route 3.3.3.3
% Network not in table
R2-NTP-CORE#
```

## Block 03

**Source change and failed association.** The horizontally truncated configuration line retains source Loopback0; the subsequent association shows .INIT., stratum 16 and reach 0.

```text
R3-NTP-CLIENT(config)#$10.20.0.1 source Loopback0 minpoll 4 maxpoll 4 iburst
R3-NTP-CLIENT(config)#end
R3-NTP-CLIENT#show ntp associations

address         ref clock       st   when   poll reach  delay  offset   disp
~10.20.0.1       .INIT.          16      -     16     0  0.000   0.000 15937.

* sys.peer, # selected, + candidate, - outlyer, x falseticker, ~ configured
  R3-NTP-CLIENT#
```

## Block 04

**Source-specific ping fails.** All five probes using source 3.3.3.3 fail.

```text
R3-NTP-CLIENT#ping 10.20.0.1 source 3.3.3.3
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 10.20.0.1, timeout is 2 seconds:
Packet sent with a source address of 3.3.3.3 
.....
Success rate is 0 percent (0/5)
R3-NTP-CLIENT#
```

## Block 05

**Return route installed.** R2 now has a static /32 route via 10.20.0.3.

```text
R2-NTP-CORE#show ip route 3.3.3.3
Routing entry for 3.3.3.3/32
Known via "static", distance 1, metric 0
Routing Descriptor Blocks:

- 10.20.0.3
  Route metric is 0, traffic share count is 1
  R2-NTP-CORE#
```

## Block 06

**Source-specific ping recovers.** The same source-specific test now receives five replies.

```text
R3-NTP-CLIENT#ping 10.20.0.1 source 3.3.3.3
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 10.20.0.1, timeout is 2 seconds:
Packet sent with a source address of 3.3.3.3 
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 2/2/3 ms
R3-NTP-CLIENT#
```

## Block 07

**NTP exchanges resume.** Reach rises to octal 17 and upstream information replaces .INIT. There is no selected-peer marker in this capture.

```text
R3-NTP-CLIENT#sh ntp associations

address         ref clock       st   when   poll reach  delay  offset   disp
~10.20.0.1       10.12.0.1        2     16     16    17  3.313 610.071  0.248

* sys.peer, # selected, + candidate, - outlyer, x falseticker, ~ configured
  R3-NTP-CLIENT#
```

[Back to verification](README.md) · [Back to NTP](../README.md)
