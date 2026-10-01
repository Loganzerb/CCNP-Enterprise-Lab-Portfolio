# Selector mismatch — correct peer, wrong protected destination

The IKE peer remained 192.0.2.1, but R3’s selected GRE destination changed to 192.0.2.5. These are separate settings, visible directly in the crypto output.

## Block 20 — The original reciprocal selector

R3 originally selected GRE from its WAN endpoint to R1’s WAN endpoint.

```text
permit gre host 198.51.100.2 host 192.0.2.1
```

[Full supplied capture](block-20.txt)

## Block 21 — The deliberate destination error

The source and protocol remain correct; only the remote selected address changes to 192.0.2.5.

```text
permit gre host 198.51.100.2 host 192.0.2.5
```

[Full supplied capture](block-21.txt)

## Block 22 — R3 keeps its IKE SA

QM_IDLE/ACTIVE persists despite the selector error.

[Full supplied capture](block-22.txt)

## Block 23 — The protected identity disagrees with the actual peer

Remote identity is 192.0.2.5, while current_peer and the remote crypto endpoint remain 192.0.2.1. Counters and outbound SPI are zero. Zero send errors on this side do not establish a usable SA.

Selected lines from the supplied capture; omitted lines remain in the full text.

```text
   local  ident (addr/mask/prot/port): (198.51.100.2/255.255.255.255/47/0)
   remote ident (addr/mask/prot/port): (192.0.2.5/255.255.255.255/47/0)
   current_peer 192.0.2.1 port 500
    #pkts encaps: 0, #pkts encrypt: 0, #pkts digest: 0
    #pkts decaps: 0, #pkts decrypt: 0, #pkts verify: 0
    #send errors 0, #recv errors 0
     local crypto endpt.: 198.51.100.2, remote crypto endpt.: 192.0.2.1
     current outbound spi: 0x0(0)
```

[Full supplied capture](block-23.txt)

## Block 24 — Private traffic fails

Five probes sourced from 10.30.30.1 to 10.10.10.1 return 0/5.

```text
R3-VPN#ping 10.10.10.1 source Loopback0 repeat 5
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 10.10.10.1, timeout is 2 seconds:
Packet sent with a source address of 10.30.30.1 
.....
Success rate is 0 percent (0/5)
```

[Full supplied capture](block-24.txt)

## Block 25 — R1 also retains IKE

R1 still shows QM_IDLE/ACTIVE. This is insufficient evidence of working encrypted forwarding.

[Full supplied capture](block-25.txt)

## Block 26 — Historical counters outlive the current ESP state

R1 retains 102 encapsulated/encrypted and 102 decapsulated/decrypted packets, but current outbound SPI is zero. It also reports 24 send errors and no OSPF neighbor. The old counters cannot establish present service health.

Selected lines from the supplied capture; omitted lines remain in the full text.

```text
R1-VPN#show crypto ipsec sa
    #pkts encaps: 102, #pkts encrypt: 102, #pkts digest: 102
    #pkts decaps: 102, #pkts decrypt: 102, #pkts verify: 102
    #send errors 24, #recv errors 0
     current outbound spi: 0x0(0)
     inbound esp sas:
R1-VPN#show ip ospf neighbor
R1-VPN#
```

[Full supplied capture](block-26.txt)

## Block 27 — IKE remains established after selector correction

The repair does not require establishing a different peer identity; the IKE snapshot still shows connection ID 1010 and QM_IDLE.

[Full supplied capture](block-27.txt)

## Block 28 — The correct identity restores ESP

R3’s remote selected address is again 192.0.2.1. Outbound SPI is 0xCD2CA569, counters are 7 outbound and 9 inbound, and errors are zero. This SPI matches R1’s inbound SA in the final complete capture.

Selected lines from the supplied capture; omitted lines remain in the full text.

```text
   remote ident (addr/mask/prot/port): (192.0.2.1/255.255.255.255/47/0)
   current_peer 192.0.2.1 port 500
    #pkts encaps: 7, #pkts encrypt: 7, #pkts digest: 7
    #pkts decaps: 9, #pkts decrypt: 9, #pkts verify: 9
    #send errors 0, #recv errors 0
     current outbound spi: 0xCD2CA569(3442255209)
```

[Full supplied capture](block-28.txt)

## Block 29 — R3 regains FULL adjacency

RID 1.1.1.1 returns to FULL at 172.16.13.1 on Tunnel0.

```text
R3-VPN#show ip ospf neighbor

Neighbor ID     Pri   State           Dead Time   Address         Interface
1.1.1.1           0   FULL/  -        00:00:38    172.16.13.1     Tunnel0
```

[Full supplied capture](block-29.txt)

[Read the troubleshooting narrative](../troubleshooting/03-selector-mismatch.md) · [Final 20/20 validation](03-final-validation.md)

[Verification index](README.md) · [Troubleshooting](../troubleshooting/README.md) · [GRE/IPsec overview](../README.md)
