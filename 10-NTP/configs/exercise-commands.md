# NTP exercise commands

These readable sequences reconstruct the changes used in the lab. Compare the results with the linked evidence; the commands below are instructions, not captured output. Begin with the [exported baseline](README.md).

## Source failover and recovery

On R1, disable the physical link to R2:

```cisco
configure terminal
interface GigabitEthernet0/0
 shutdown
end
```

Inspect associations and local status on R2 and R3. The recorded results eventually showed R2 at stratum 4 through R4 and R3 at stratum 5 through R2. Restore the link on R1:

```cisco
configure terminal
interface GigabitEthernet0/0
 no shutdown
end
```

In the recorded recovery, R1 answered again but remained rejected. The exercise then applied the following on R2; execution was confirmed in the notes rather than retained as a command capture:

```cisco
configure terminal
ntp server 10.12.0.1 prefer
end
```

Inspect the outcome rather than assuming selection changes. [Recorded preference outcome](../verification/02-failover.md#block-08).

For a clean baseline, remove and recreate that server entry without the keyword, then verify the running configuration. This explicit reset sequence is provided for reproduction; it was not captured in the original exercise and resets the association.

```cisco
configure terminal
no ntp server 10.12.0.1
ntp server 10.12.0.1
end
show running-config | include ntp
```

## Loopback source and missing return route

On R3, create the stable source address and replace the exported server entry:

```cisco
configure terminal
interface Loopback0
 ip address 3.3.3.3 255.255.255.255
exit
no ntp server 10.20.0.1
ntp server 10.20.0.1 source Loopback0 minpoll 4 maxpoll 4 iburst
end
show ntp associations
ping 10.20.0.1 source 3.3.3.3
```

The explicit removal above makes the reproduction stage unambiguous; the original captured entry is horizontally truncated. The recorded lab used a 16-second poll interval at this stage.

On R2, inspect and then repair the return route:

```cisco
show ip route 3.3.3.3
configure terminal
ip route 3.3.3.3 255.255.255.255 10.20.0.3
end
show ip route 3.3.3.3
```

Repeat the sourced ping and association check on R3. [Recorded routing sequence](../verification/03-loopback-route.md).

## ACL failure with working ping

Keep the repaired return route. On R2, confirm Gi0/1 has no existing interface ACL before attaching the test policy:

```cisco
show ip interface GigabitEthernet0/1 | include access list
configure terminal
ip access-list extended NTP-SOURCE-TEST
 10 permit udp host 10.20.0.3 host 10.20.0.1 eq ntp
 20 deny udp host 3.3.3.3 host 10.20.0.1 eq ntp
 30 permit ip any any
exit
interface GigabitEthernet0/1
 ip access-group NTP-SOURCE-TEST in
end
```

On R3, run the same source-specific ping and inspect NTP associations. On R2, inspect `show access-lists NTP-SOURCE-TEST` for matching traffic. [Recorded failure checks](../verification/04-acl-udp123.md#block-03).

Repair only sequence 20 on R2:

```cisco
configure terminal
ip access-list extended NTP-SOURCE-TEST
 no 20
 20 permit udp host 3.3.3.3 host 10.20.0.1 eq ntp
end
show access-lists NTP-SOURCE-TEST
```

Check R3's association again and confirm R2's permit counter increases. To establish final clock synchronization on a new run, additionally capture `show ntp status`; that final check was not retained after this original repair.

## Cleanup

On R2, remove the temporary ACL while preserving the /32 route:

```cisco
configure terminal
interface GigabitEthernet0/1
 no ip access-group NTP-SOURCE-TEST in
exit
no ip access-list extended NTP-SOURCE-TEST
end
show ip interface GigabitEthernet0/1 | include access list
show access-lists NTP-SOURCE-TEST
```

The final lab setup retained R3 Loopback0, its NTP source setting and R2's return route. The [captured cleanup](../verification/04-acl-udp123.md#block-09) verifies removal of the temporary filter.

[Back to configurations](README.md) · [Back to NTP](../README.md)
