# Lab 20A return-path verification

**Captured CLI excerpts from the original CML lab session.** These route lookups and retests show which route each provider needed to reply to R1. The initial ping failures are reported in the lab completion record.

## ISP-A return path

R4 initially had no route covering the source address 10.20.12.1.

```text
R4-ISP-A#show ip route 10.20.12.1
% Subnet not in table
```

After the correction, R4 had a route for that source prefix via R2.

```text
R4-ISP-A#show ip route 10.20.12.1
Routing entry for 10.20.12.0/30
  Known via "static", distance 1, metric 0
  Routing Descriptor Blocks:
  * 198.51.100.1
      Route metric is 0, traffic share count is 1
```

R1 repeated the loopback ping with 10.20.12.1 explicitly selected as the source.

```text
R1-CORE#ping 4.4.4.4 source 10.20.12.1
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 4.4.4.4, timeout is 2 seconds:
Packet sent with a source address of 10.20.12.1
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 2/2/3 ms
```

## ISP-B return path

R5 initially had no route covering the source address 10.20.13.1.

```text
R5-ISP-B#show ip route 10.20.13.1
% Network not in table
```

After the correction, R5 had a route for that source prefix via R3.

```text
R5-ISP-B#show ip route 10.20.13.1
Routing entry for 10.20.13.0/30
  Known via "static", distance 1, metric 0
  Routing Descriptor Blocks:
  * 203.0.113.1
      Route metric is 0, traffic share count is 1
```

R1 repeated the loopback ping with 10.20.13.1 explicitly selected as the source.

```text
R1-CORE#ping 5.5.5.5 source 10.20.13.1
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 5.5.5.5, timeout is 2 seconds:
Packet sent with a source address of 10.20.13.1
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 2/2/3 ms
```

## What the retests establish

Each provider needed a route to the corresponding source address for its Echo Replies. Keeping the source explicit ties the successful retest to the repaired return route. R1 sent the requests through its pinned host routes to the provider loopbacks. The retests establish reachability over those paths. [Return-route design](../configs/README.md#provide-isp-return-routes)

[Verification index](README.md) · [Tracked default captures](tracked-default.md) · [Troubleshooting](../troubleshooting/README.md)
