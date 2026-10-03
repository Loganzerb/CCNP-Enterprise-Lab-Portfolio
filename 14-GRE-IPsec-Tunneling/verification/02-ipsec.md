# Classic GRE/IKEv1 IPsec verification — current SAs and protected identities

Inspect IKE and ESP separately. A configured peer or a QM_IDLE entry does not establish a currently usable ESP data path.

## Block 01 — IKE and the pre-test crypto state

R1 shows QM_IDLE/ACTIVE. The crypto map is on Gi0/0, and the local/remote identities select protocol 47 between the WAN endpoints. Before the final traffic test, counters were 117 outbound and 115 inbound.

Selected lines from the supplied capture; omitted lines remain in the full text.

```text
R1-VPN#show crypto isakmp sa
198.51.100.2    192.0.2.1       QM_IDLE           1010 ACTIVE
R1-VPN#show crypto ipsec sa
interface: GigabitEthernet0/0
    Crypto map tag: GRE-IPSEC-MAP, local addr 192.0.2.1
   local  ident (addr/mask/prot/port): (192.0.2.1/255.255.255.255/47/0)
   remote ident (addr/mask/prot/port): (198.51.100.2/255.255.255.255/47/0)
    #pkts encaps: 117, #pkts encrypt: 117, #pkts digest: 117
    #pkts decaps: 115, #pkts decrypt: 115, #pkts verify: 115
    #send errors 0, #recv errors 0
     current outbound spi: 0xDA3E187A(3661502586)
```

[Full supplied capture](block-01.txt)

## Block 04 — Active transport-mode ESP after the test

The complete supplied SA output confirms ESP AES-256/SHA-256 HMAC, Transport settings, active inbound/outbound SAs, and replay detection. R1 inbound SPI is 0xCD2CA569; outbound is 0xDA3E187A. Send and receive errors are zero.

Selected lines from the supplied capture; omitted lines remain in the full text.

```text
    #send errors 0, #recv errors 0
     plaintext mtu 1458, path mtu 1500, ip mtu 1500, ip mtu idb GigabitEthernet0/0
     current outbound spi: 0xDA3E187A(3661502586)
     PFS (Y/N): N, DH group: none
     inbound esp sas:
      spi: 0xCD2CA569(3442255209)
        transform: esp-256-aes esp-sha256-hmac ,
        in use settings ={Transport, }
        replay detection support: Y
        Status: ACTIVE(ACTIVE)
     outbound esp sas:
      spi: 0xDA3E187A(3661502586)
        transform: esp-256-aes esp-sha256-hmac ,
        in use settings ={Transport, }
        replay detection support: Y
        Status: ACTIVE(ACTIVE)
```

[Full supplied capture](block-04.txt)

## Correlate the two directions

| Direction | Retained matching SPI | Where it appears |
|---|---|---|
| R3 to R1 | 0xCD2CA569 | R3's [recovered outbound SPI](06-selector.md#block-28--the-correct-identity-restores-esp) and R1's inbound ESP SA above |
| R1 to R3 | 0xDA3E187A | R1's outbound ESP SA above; R3's matching inbound detail is not included in this compilation |

The first pairing directly demonstrates that one peer's outbound SPI matches the other peer's inbound SPI. The handoff records checking both directions; only the retained matching pair is shown as direct CLI evidence here.

## Keep negotiation and MTU fields separate

The ESP output reports **PFS N, DH group none**. That describes IPsec PFS and does not contradict the handoff's IKE Phase 1 DH group 14.

The reported **plaintext MTU 1458 / path MTU 1500** is retained as an SA field, not an inner-ping size test. [Packet behavior](../operation.md#what-the-reported-mtu-establishes) explains the distinction.

[Final traffic and counter comparison](03-final-validation.md)

[Verification index](README.md) · [Troubleshooting](../troubleshooting/README.md) · [GRE/IPsec overview](../README.md)
