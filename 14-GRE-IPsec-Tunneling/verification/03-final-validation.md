# Final validation — private traffic, routing, and ESP agree

These captures follow the fault repairs. The test explicitly uses R1’s Loopback0 source, so a successful WAN ping cannot substitute for the result.

## Block 02 — Test the private endpoints

All twenty 100-byte probes from 10.10.10.1 to 10.30.30.1 receive replies. This validates the complete sourced request/reply exchange.

```text
R1-VPN#ping 10.30.30.1 source Loopback0 repeat 20
Type escape sequence to abort.
Sending 20, 100-byte ICMP Echos to 10.30.30.1, timeout is 2 seconds:
Packet sent with a source address of 10.10.10.1 
!!!!!!!!!!!!!!!!!!!!
Success rate is 100 percent (20/20), round-trip min/avg/max = 4/4/7 ms
```

[Full supplied capture](block-02.txt)

## Block 03 — OSPF remains FULL over Tunnel0

RID 3.3.3.3 is FULL at overlay address 172.16.13.2 on Tunnel0. This is a routing check alongside the traffic test, not a substitute for it.

```text
R1-VPN#show ip ospf neighbor

Neighbor ID     Pri   State           Dead Time   Address         Interface
3.3.3.3           0   FULL/  -        00:00:35    172.16.13.2     Tunnel0
```

[Full supplied capture](block-03.txt)

## Compare crypto counters around the test

| R1 counter | Before: Block 01 | After: Block 04 | Change |
|---|---:|---:|---:|
| Encapsulated / encrypted | 117 / 117 | 146 / 146 | +29 / +29 |
| Decapsulated / decrypted | 115 / 115 | 144 / 144 | +29 / +29 |
| Send / receive errors | 0 / 0 | 0 / 0 | 0 / 0 |
| Outbound SPI | 0xDA3E187A | 0xDA3E187A | Same SA across both samples |

[Before-test capture](block-01.txt) · [Complete after-test capture](block-04.txt)

Both directions show new protected traffic while the sourced test succeeds and ESP remains active. The change is 29, rather than 20. These aggregate counters cover all selected traffic between samples, including any routing traffic; the record does not assign every counted packet to an individual ping.

## What this validates

The final result combines **20/20 private replies**, **FULL OSPF**, **active inbound/outbound transport-mode ESP**, **counter growth**, and **zero recorded crypto errors**. It establishes functioning protected forwarding for the tested traffic. It does not measure throughput, long-term reliability, or a maximum inner packet size.

[Active ESP details and SPI correlation](02-ipsec.md) · [The three fault investigations](../troubleshooting/README.md)

[Verification index](README.md) · [Troubleshooting](../troubleshooting/README.md) · [GRE/IPsec overview](../README.md)
