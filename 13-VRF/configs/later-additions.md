# Later additions — from overlap to shared-service access

These are selected configuration commands reconstructed from the completed lab sequence and checked against captured routes, interfaces and traffic tests. They are not full running-config exports. The original YAML remains the earlier three-router checkpoint.

## Duplicate remote prefixes

On both BLUE-CE and RED-CE:

```ios
interface Loopback0
 ip address 172.16.100.1 255.255.255.255
```

On R1-VRF:

```ios
ip route vrf BLUE 172.16.100.1 255.255.255.255 10.10.10.2
ip route vrf RED 172.16.100.1 255.255.255.255 10.10.10.2
```

[Recorded loopbacks, routes and CEF](../verification/02-identical-prefixes.md)

## Shared-service attachment

R1-VRF Gi0/2 remains in the global routing table:

```ios
interface GigabitEthernet0/2
 ip address 172.16.50.1 255.255.255.0
 no shutdown
```

The added SHARED-SVC node connects Gi0/0 to R1 Gi0/2:

```ios
hostname SHARED-SVC
interface GigabitEthernet0/0
 ip address 172.16.50.10 255.255.255.0
 no shutdown
ip route 0.0.0.0 0.0.0.0 172.16.50.1
```

R1’s selective forward routes:

```ios
ip route vrf BLUE 172.16.50.10 255.255.255.255 172.16.50.10 global
ip route vrf RED 172.16.50.10 255.255.255.255 172.16.50.10 global
```

[Forward-route configuration and installed state](../verification/04-forward-leak.md#block-21--the-forward-leaks-are-configured-and-installed)

## Unique endpoints and complete return paths

BLUE-CE:

```ios
interface Loopback10
 ip address 192.168.10.10 255.255.255.255
ip route 172.16.50.10 255.255.255.255 10.10.10.1
```

RED-CE:

```ios
interface Loopback20
 ip address 192.168.20.20 255.255.255.255
ip route 172.16.50.10 255.255.255.255 10.10.10.1
```

R1-VRF:

```ios
ip route vrf BLUE 192.168.10.10 255.255.255.255 10.10.10.2
ip route vrf RED 192.168.20.20 255.255.255.255 10.10.10.2
ip route 192.168.10.10 255.255.255.255 GigabitEthernet0/0 10.10.10.2
ip route 192.168.20.20 255.255.255.255 GigabitEthernet0/1 10.10.10.2
```

The last two routes use explicit egress interfaces to select the intended CE despite the overlapping next-hop IP. Installation and forwarding were observed on this IOSv image. They are not a claim of identical support on all Cisco platforms.

[Return-path and final traffic evidence](../verification/05-return-path.md) · [Configuration index](README.md) · [Route-leaking explanation](../route-leaking/README.md)
