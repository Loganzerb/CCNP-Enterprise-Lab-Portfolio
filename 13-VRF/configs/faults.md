# Controlled fault and repair commands

These command extracts reconstruct the changes used in the two RED routing exercises. The linked evidence establishes the resulting failure and recovery. They are separate from the preserved checkpoint.

## Bad next hop

Fault on R1:

```ios
no ip route vrf RED 172.16.100.1 255.255.255.255 10.10.10.2
ip route vrf RED 172.16.100.1 255.255.255.255 10.10.10.99
```

Repair:

```ios
no ip route vrf RED 172.16.100.1 255.255.255.255 10.10.10.99
ip route vrf RED 172.16.100.1 255.255.255.255 10.10.10.2
```

[Case 01 and supporting evidence](../troubleshooting/01-bad-next-hop.md)

## Wrong routing table

Fault on R1 after restoring the first exercise:

```ios
no ip route vrf RED 172.16.100.1 255.255.255.255 10.10.10.2
ip route 172.16.100.1 255.255.255.255 10.10.10.2
```

Repair:

```ios
no ip route 172.16.100.1 255.255.255.255 10.10.10.2
ip route vrf RED 172.16.100.1 255.255.255.255 10.10.10.2
```

[Case 02 and supporting evidence](../troubleshooting/02-wrong-table.md)

The shared-service exercise adds routes in stages rather than removing an already complete path. Its [configuration sequence](later-additions.md) and [return-path case](../troubleshooting/03-return-path.md) document the separate dependency.

[Configuration index](README.md) · [VRF overview](../README.md)
