# Controlled routing faults and repairs

The commands below follow the completed lab sequence. The recursive fault command was captured directly; the underlay change and both repair commands are reconstructed from the recorded instructions and corroborated by the resulting output. Apply configuration commands in global configuration mode.

## Remove and restore underlay reachability

On R1-GRE:

```ios
! Fault
no ip route 198.51.100.0 255.255.255.252 192.0.2.2
! Repair
ip route 198.51.100.0 255.255.255.252 192.0.2.2
```

[Underlay case](../troubleshooting/01-underlay-route-loss.md) · [Recorded states and recovery](../verification/02-underlay-failure.md)

## Introduce and remove a recursive host route

Keep the healthy /30 transport route configured. On R1-GRE:

```ios
! Fault: point the outer endpoint at the overlay peer
ip route 198.51.100.2 255.255.255.255 172.16.13.2
! Repair: remove only that host route
no ip route 198.51.100.2 255.255.255.255 172.16.13.2
```

[Recursive-routing case](../troubleshooting/02-recursive-routing.md) · [Captured command, syslogs and recovery](../verification/03-recursion.md)

## Final MTU probes

These EXEC commands were captured after routing recovery:

```text
ping 172.16.13.2 size 1476 df-bit repeat 5
ping 172.16.13.2 size 1477 df-bit repeat 5
ping 172.16.13.2 size 1477 repeat 5
```

[Actual results](../verification/04-mtu.md) · [Configuration index](README.md) · [GRE overview](../README.md)
