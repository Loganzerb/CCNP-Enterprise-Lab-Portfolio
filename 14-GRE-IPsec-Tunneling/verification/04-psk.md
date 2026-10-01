# PSK mismatch — fresh authentication fails, then recovers

The deliberate key mismatch was exposed after clearing existing IKE/IPsec state. Existing SAs had initially kept the VPN usable; that first interval is a handoff observation, not a separate retained capture.

## Block 05 — R1 has Main Mode attempts without usable ESP

No QM_IDLE entry appears. Deleted MM_NO_STATE attempts coexist with an active MM_KEY_EXCH attempt; they are not usable completed IKE SAs. Crypto counters are zero, outbound SPI is zero, four send errors are recorded, and the OSPF neighbor command returns no entries.

Selected lines from the supplied capture; omitted lines remain in the full text.

```text
R1-VPN#show crypto isakmp sa
192.0.2.1       198.51.100.2    MM_NO_STATE       1003 ACTIVE (deleted)
198.51.100.2    192.0.2.1       MM_KEY_EXCH       1004 ACTIVE
198.51.100.2    192.0.2.1       MM_NO_STATE       1002 ACTIVE (deleted)
198.51.100.2    192.0.2.1       MM_NO_STATE       1001 ACTIVE (deleted)
R1-VPN#show crypto ipsec sa
    #pkts encaps: 0, #pkts encrypt: 0, #pkts digest: 0
    #pkts decaps: 0, #pkts decrypt: 0, #pkts verify: 0
    #send errors 4, #recv errors 0
     current outbound spi: 0x0(0)
     inbound esp sas:
R1-VPN#show ip ospf neighbor
R1-VPN#
```

[Full supplied capture](block-05.txt)

## Block 06 — R3 also lacks completed IKE negotiation

R3 shows deleted MM_NO_STATE attempts and no QM_IDLE entry.

[Full supplied capture](block-06.txt)

## Block 07 — R3 has no usable ESP or OSPF neighbor

The reciprocal crypto view has zero counters, seven send errors, outbound SPI zero, and no OSPF neighbor.

[Full supplied capture](block-07.txt)

## Block 08 — A crypto syslog accompanies the fault

The sanity-check/malformed-message warning accompanies this controlled mismatch. This message alone is not a unique PSK diagnosis; the deliberate change and successful correction establish the cause in this lab.

```text
%CRYPTO-4-IKMP_BAD_MESSAGE: IKE message from 192.0.2.1 failed its sanity check or is malformed
```

[Full supplied capture](block-08.txt)

## Block 09 — IKE returns to QM_IDLE after key correction

An ACTIVE QM_IDLE entry appears alongside older deleted attempts. The completed SA, rather than every buffered attempt, is the relevant recovery evidence.

Selected lines from the supplied capture; omitted lines remain in the full text.

```text
R1-VPN#show crypto isakmp sa
198.51.100.2    192.0.2.1       QM_IDLE           1010 ACTIVE
```

[Full supplied capture](block-09.txt)

## Block 10 — ESP and bidirectional counters return

Outbound SPI is now 0x207CA9F7, counters are 2 outbound and 3 inbound, and errors are zero. The supplied output ends at the inbound-SA heading; it does not include complete transform details.

Selected lines from the supplied capture; omitted lines remain in the full text.

```text
    #pkts encaps: 2, #pkts encrypt: 2, #pkts digest: 2
    #pkts decaps: 3, #pkts decrypt: 3, #pkts verify: 3
    #send errors 0, #recv errors 0
     current outbound spi: 0x207CA9F7(545040887)
```

[Full supplied capture](block-10.txt)

## Block 11 — The overlay adjacency recovers

OSPF returns to FULL on Tunnel0 after the key repair, without a recorded OSPF restart.

```text
R1-VPN#show ip ospf neighbor

Neighbor ID     Pri   State           Dead Time   Address         Interface
3.3.3.3           0   FULL/  -        00:00:39    172.16.13.2     Tunnel0
```

[Full supplied capture](block-11.txt)

[Read the troubleshooting narrative](../troubleshooting/01-psk-mismatch.md)

[Verification index](README.md) · [Troubleshooting](../troubleshooting/README.md) · [GRE/IPsec overview](../README.md)
