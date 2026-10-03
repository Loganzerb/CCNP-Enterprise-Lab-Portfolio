# IKEv2 VTI validation — direct routing across the protected interface

The saved CML export supplies the configuration excerpts below. Runtime states, SPIs, counts, and ping results are recorded in the completed-lab handoff; they are reported as values rather than reconstructed console output. The [source guide](../scope.md) distinguishes these from the classic stage's verbatim CLI captures.

## Establish the VTI

| Build checkpoint | Recorded observation | What it establishes |
|---|---|---|
| R1 configured before R3 | Tunnel0 up/down | The local configuration alone did not establish the remote VTI |
| R3 configuration complete | Tunnel0 up/up | Both ends established the protected interface |
| Tunnel fields | IPSEC/IP; profile VTI-IPSEC-PROFILE | Native IPsec VTI rather than GRE |
| IKEv2 on R3 | READY | IKEv2 negotiation completed |
| Negotiated settings | AES-CBC-256; integrity SHA256; PRF SHA256; DH14; PSK | The recorded negotiated parameters agreed with the intended protection |

The initial up/down state belongs to normal configuration staging. It is not presented as a deliberate VTI troubleshooting failure.

## Block 30 — Saved R1 VTI protection

This is selected configuration from the saved node, not a live interface-status capture.

```ios
interface Tunnel0
 ip address 172.16.13.1 255.255.255.252
 tunnel source GigabitEthernet0/0
 tunnel mode ipsec ipv4
 tunnel destination 198.51.100.2
 tunnel protection ipsec profile VTI-IPSEC-PROFILE
```

[Full saved-configuration excerpt](block-30.txt) · [Complete relevant R1 settings](../configs/R1-VTI.cfg)

## ESP and the first traffic test

The handoff records Tunnel-mode ESP, inbound/outbound SAs ACTIVE(ACTIVE), and selectors 0.0.0.0/0 on both sides. Broad selectors do not redirect all traffic into the tunnel; routing determines which packets use Tunnel0.

| Counter checkpoint | Encapsulated / encrypted | Decapsulated / decrypted |
|---|---:|---:|
| Before the initial tunnel-address test | 0 / 0 | 0 / 0 |
| After the successful 5/5 Tunnel0-to-Tunnel0 test | 5 / 5 | 5 / 5 |

The recorded counter change agrees with that first five-packet request/reply test. The reported plaintext MTU was 1438 over a 1500-byte path; it is an SA field, not a measured maximum inner-ping size.

## Correlate unidirectional SAs

| Traffic direction | Sender's outbound SPI | Receiver's matching inbound SPI |
|---|---|---|
| R3 to R1 | R3: 0x2DCA0919 | R1: 0x2DCA0919 |
| R1 to R3 | R1: 0xA508C73A | R3: 0xA508C73A |

These values are preserved from the VTI handoff and belong to that stage. They are separate from the classic GRE/IPsec SPIs in Blocks 01–29.

## Block 31 — Saved OSPF directly over the VTI

R3's saved configuration enables process 10 and area 0 across the tunnel subnet, and advertises its loopback. GRE is not involved.

```ios
router ospf 10
 router-id 3.3.3.3
 network 10.30.30.1 0.0.0.0 area 0
 network 172.16.13.0 0.0.0.3 area 0
```

[Full saved-configuration excerpt](block-31.txt) · [Reciprocal R1 OSPF configuration](../configs/vti.md#run-ospf-directly-over-the-vti)

## OSPF adjacency and learned routes

| Check | Recorded result |
|---|---|
| Router IDs | R1 1.1.1.1; R3 3.3.3.3 |
| Process and area | OSPF 10, area 0 across 172.16.13.0/30 |
| R3 neighbor | R1 reached FULL/- over Tunnel0 |
| Route learned by R1 | 10.30.30.1/32 via 172.16.13.2, Tunnel0 |
| Route learned by R3 | 10.10.10.1/32 via 172.16.13.1, Tunnel0 |

R2 does not participate in this OSPF relationship. Its job remains forwarding the outer WAN packet.

## Final results

| Final check | Verified result reported for the VTI stage |
|---|---|
| Private test | 10.30.30.1 to 10.10.10.1: 10/10 replies |
| R3 encaps / encrypt | 44 / 44 |
| R3 decaps / decrypt | 51 / 51 |
| R3 send / receive errors | 0 / 0 |
| Inbound and outbound ESP | ACTIVE(ACTIVE) |

The final totals include selected traffic across the measurement interval, including routing traffic. They are not the packet count of the final ten-probe test alone; unequal directional totals do not establish ping loss.

The lab stopped after successful configuration and verification. No forced VTI faults, throughput measurement, or retention rebuild is represented as completed work.

[Verification commands](commands.md) · [Packet-flow comparison](../operation.md) · [Verification index](README.md) · [Overview](../README.md)
