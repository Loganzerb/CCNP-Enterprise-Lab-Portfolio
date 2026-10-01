# Transform mismatch — IKE survives while ESP cannot rebuild

R1 retained AES-256; R3 was changed to AES-128. The mismatch surfaced after clearing IPsec SAs while keeping the IKE SA.

## Block 12 — OSPF loses its neighbor when protected traffic stops

The captured transition is FULL to DOWN because the dead timer expires. It establishes routing impact, not the cause by itself.

```text
*Oct  1 20:14:44.996: %OSPF-5-ADJCHG: Process 10, Nbr 3.3.3.3 on Tunnel0 from FULL to DOWN, Neighbor Down: Dead timer expired
```

[Full supplied capture](block-12.txt)

## Block 13 — IKE remains established

QM_IDLE/ACTIVE persists with connection ID 1010. Authentication is still established.

```text
R1-VPN#show crypto isakmp sa
IPv4 Crypto ISAKMP SA
dst             src             state          conn-id status
198.51.100.2    192.0.2.1       QM_IDLE           1010 ACTIVE

IPv6 Crypto ISAKMP SA
```

[Full supplied capture](block-13.txt)

## Block 14 — No usable ESP forms under the mismatched proposal

R1 has zero encrypt/decrypt counters, outbound SPI zero, four send errors, and no OSPF neighbor. Compare this with the healthy IKE entry above.

Selected lines from the supplied capture; omitted lines remain in the full text.

```text
R1-VPN#show crypto ipsec sa
    #pkts encaps: 0, #pkts encrypt: 0, #pkts digest: 0
    #pkts decaps: 0, #pkts decrypt: 0, #pkts verify: 0
    #send errors 4, #recv errors 0
     current outbound spi: 0x0(0)
     inbound esp sas:
R1-VPN#show ip ospf neighbor
R1-VPN#
```

[Full supplied capture](block-14.txt)

## Block 15 — IKE is still present immediately after repair

The first post-correction IKE snapshot still shows QM_IDLE. It is a separate sample from the eventual ESP recovery.

[Full supplied capture](block-15.txt)

## Block 16 — The earliest post-repair ESP check is not yet healthy

The first ESP snapshot still has SPI zero, zero counters, and 13 send errors. Retaining this intermediate result avoids claiming instantaneous recovery.

Selected lines from the supplied capture; omitted lines remain in the full text.

```text
    #pkts encaps: 0, #pkts encrypt: 0, #pkts digest: 0
    #pkts decaps: 0, #pkts decrypt: 0, #pkts verify: 0
    #send errors 13, #recv errors 0
     current outbound spi: 0x0(0)
```

[Full supplied capture](block-16.txt)

## Block 17 — OSPF completes recovery naturally

The later log records LOADING to FULL. The record does not establish a precise repair-to-recovery duration.

```text
*Oct  1 20:16:31.503: %OSPF-5-ADJCHG: Process 10, Nbr 3.3.3.3 on Tunnel0 from LOADING to FULL, Loading Done
```

[Full supplied capture](block-17.txt)

## Block 18 — ESP counters and a nonzero SPI return

R1 now has outbound SPI 0x448ABAA8, 85 encrypted and 85 decrypted packets, and zero errors. This supplied snapshot is partial below the inbound-SA heading.

Selected lines from the supplied capture; omitted lines remain in the full text.

```text
    #pkts encaps: 85, #pkts encrypt: 85, #pkts digest: 85
    #pkts decaps: 85, #pkts decrypt: 85, #pkts verify: 85
    #send errors 0, #recv errors 0
     current outbound spi: 0x448ABAA8(1149942440)
```

[Full supplied capture](block-18.txt)

## Block 19 — Confirm the recovered neighbor table

The current OSPF view shows FULL on Tunnel0, agreeing with the recovery log.

```text
R1-VPN#show ip ospf neighbor

Neighbor ID     Pri   State           Dead Time   Address         Interface
3.3.3.3           0   FULL/  -        00:00:31    172.16.13.2     Tunnel0
```

[Full supplied capture](block-19.txt)

[Read the troubleshooting narrative](../troubleshooting/02-transform-mismatch.md)

[Verification index](README.md) · [Troubleshooting](../troubleshooting/README.md) · [GRE/IPsec overview](../README.md)
