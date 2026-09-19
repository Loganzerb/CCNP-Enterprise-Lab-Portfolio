# Ping succeeds while NTP is blocked

Read the [verification guide](README.md) for field meanings and capture conventions. Blocks retain selected device outputs in test order; each introduction states what that capture establishes.

## Block 01

**Faulty policy.** The ACL permits the old interface source but denies UDP/123 from 3.3.3.3. Other IP traffic is permitted.

```text
R2-NTP-CORE#show access-lists NTP-SOURCE-TEST
Extended IP access list NTP-SOURCE-TEST
    10 permit udp host 10.20.0.3 host 10.20.0.1 eq ntp
    20 deny udp host 3.3.3.3 host 10.20.0.1 eq ntp
    30 permit ip any any
R2-NTP-CORE#
```

## Block 02

**Policy applied inbound.** The ACL is attached inbound on R2 Gi0/1.

```text
R2-NTP-CORE#configure terminal
Enter configuration commands, one per line.  End with CNTL/Z.
R2-NTP-CORE(config)#interface GigabitEthernet0/1
R2-NTP-CORE(config-if)# ip access-group NTP-SOURCE-TEST in
R2-NTP-CORE(config-if)#end
R2-NTP-CORE#show ip interface GigabitEthernet0/1 | include access list
  Outgoing access list is not set
  Inbound  access list is NTP-SOURCE-TEST
R2-NTP-CORE#
```

## Block 03

**Ping still works.** With the ACL applied, the ping sourced from 3.3.3.3 still receives five replies.

```text
R3-NTP-CLIENT#ping 10.20.0.1 source 3.3.3.3
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 10.20.0.1, timeout is 2 seconds:
Packet sent with a source address of 3.3.3.3 
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 2/2/3 ms
R3-NTP-CLIENT#
```

## Block 04

**Deny counter identifies the traffic.** Sequence 20 records five matches against loopback-sourced NTP.

```text
R2-NTP-CORE#show access-lists NTP-SOURCE-TEST
Extended IP access list NTP-SOURCE-TEST
    10 permit udp host 10.20.0.3 host 10.20.0.1 eq ntp
    20 deny udp host 3.3.3.3 host 10.20.0.1 eq ntp (5 matches)
    30 permit ip any any (6 matches)
R2-NTP-CORE#
```

## Block 05

**NTP reaches failed state.** R3 shows .INIT., stratum 16 and reach 0.

```text
R3-NTP-CLIENT#sh ntp associations

address         ref clock       st   when   poll reach  delay  offset   disp
~10.20.0.1       .INIT.          16    165     16     0  0.000   0.000 15937.

* sys.peer, # selected, + candidate, - outlyer, x falseticker, ~ configured
  R3-NTP-CLIENT#
```

## Block 06

**Policy corrected.** The resulting ACL confirms sequence 20 now permits the loopback source. The entered line is horizontally truncated in the capture.

```text
R2-NTP-CORE#configure terminal
Enter configuration commands, one per line.  End with CNTL/Z.
R2-NTP-CORE(config)#ip access-list extended NTP-SOURCE-TEST
R2-NTP-CORE(config-ext-nacl)# no 20
R2-NTP-CORE(config-ext-nacl)#$udp host 3.3.3.3 host 10.20.0.1 eq ntp         
R2-NTP-CORE(config-ext-nacl)#end
R2-NTP-CORE#show access-lists NTP-SOURCE-TEST
Extended IP access list NTP-SOURCE-TEST
    10 permit udp host 10.20.0.3 host 10.20.0.1 eq ntp
    20 permit udp host 3.3.3.3 host 10.20.0.1 eq ntp
    30 permit ip any any (7 matches)
R2-NTP-CORE#
```

## Block 07

**First successful exchange.** R3 reach becomes 1 with upstream reference information. This establishes renewed exchange, not completed synchronization.

```text
R3-NTP-CLIENT#sh ntp associations

address         ref clock       st   when   poll reach  delay  offset   disp
~10.20.0.1       10.20.0.4        4      6     16     1  3.074 620.352 187.55

* sys.peer, # selected, + candidate, - outlyer, x falseticker, ~ configured
  R3-NTP-CLIENT#
```

## Block 08

**Permit counter verifies repair.** The corrected entry reaches 37 matches.

```text
R2-NTP-CORE#show access-lists NTP-SOURCE-TEST
Extended IP access list NTP-SOURCE-TEST
    10 permit udp host 10.20.0.3 host 10.20.0.1 eq ntp
    20 permit udp host 3.3.3.3 host 10.20.0.1 eq ntp (37 matches)
    30 permit ip any any (20 matches)
R2-NTP-CORE#
```

## Block 09

**ACL detached.** Both interface directions report no access list. The same capture shows R2 selecting R4 at this later checkpoint.

```text
R2-NTP-CORE#sh ntp associations

address         ref clock       st   when   poll reach  delay  offset   disp
+~10.12.0.1       .LOCL.           1     83     64    77  0.925 -142.88  4.300
*~10.20.0.4       127.127.1.1      3     83     64    77  0.756 239.736  4.980

* sys.peer, # selected, + candidate, - outlyer, x falseticker, ~ configured
  R2-NTP-CORE#configure terminal
  Enter configuration commands, one per line.  End with CNTL/Z.
  R2-NTP-CORE(config)#interface GigabitEthernet0/1
  R2-NTP-CORE(config-if)# no ip access-group NTP-SOURCE-TEST in
  R2-NTP-CORE(config-if)#end
  R2-NTP-CORE#show ip interface GigabitEthernet0/1 | include access list
  Outgoing access list is not set
  Inbound  access list is not set
  R2-NTP-CORE#
```

## Block 10

**Temporary policy removed.** The ACL is deleted and the subsequent show command returns no entries.

```text
R2-NTP-CORE(config)#no ip access-list extended NTP-SOURCE-TEST
R2-NTP-CORE(config)#end
R2-NTP-CORE#show access-lists NTP-SOURCE-TEST
R2-NTP-CORE#
```

[Back to verification](README.md) · [Back to NTP](../README.md)
