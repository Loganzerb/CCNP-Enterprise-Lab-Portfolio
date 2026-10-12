# RX-only capture and original payload

The RX-only stage monitored traffic entering R1 GigabitEthernet1 from R2. Alpine inspected the separate GRE copies sent from `10.30.30.1` to `10.30.30.2`.

**Quick navigation:** [RX capture](#rx-capture) · [Original payload](#original-payload) · [Interpretation boundary](#interpretation-boundary)

## RX capture

### Block 01

**Recorded command — Alpine collector.**

```bash
sudo tcpdump -ni eth0 -vv 'ip proto 47'
```

**Reported capture observations from the lab record.**

| Observation | Reported value |
|---|---|
| GRE packets captured | 101 |
| Capture-kernel drops | 0 |
| Outer IPv4 source / destination | `10.30.30.1` / `10.30.30.2` |
| Outer IP protocol | GRE, 47 |
| GRE protocol value | `0x88BE` |
| GRE sequence observations during the 100-ping burst | Included 3–102 |

The count includes a separate packet, so the 101 captured GRE packets must not all be described as ICMP copies. Zero reported capture-kernel drops concerns that capture; it does not establish complete mirroring of every packet on the source interface.

## Original payload

### Block 02

**Recorded command — hexadecimal payload inspection.** The five-packet limit belongs to this inspection command.

```bash
sudo tcpdump -ni eth0 -s 0 -XX -c 5 'ip proto 47'
```

**Decoded observations from the lab record.** These values are supplied interpretation, not a reconstructed hexadecimal dump.

| Decoded field | Reported value |
|---|---|
| ERSPAN session ID | 100, represented as `0x0064` |
| Original IPv4 source | `10.10.10.10` |
| Original IPv4 destination | `10.20.20.20` |
| Inner IP protocol | ICMP |
| ICMP type / code | 8 / 0, Echo Request |
| Representative outer IPv4 total length | 150 bytes for the encapsulated 100-byte IPv4 ICMP packet |
| Another mirrored payload | Cisco Discovery Protocol advertisement originating from R2-SOURCE |

The outer addresses identify the ERSPAN source and collector. The inner addresses identify the original endpoint traffic. The CDP observation also shows why mirrored interface traffic should not be equated with the test's ICMP packets alone. The 150-byte observation applies to the representative packet described in the record.

## Interpretation boundary

ERSPAN Type II is the lab record's decoding. The `0x88BE` value alone does not uniquely establish that format; full raw hexadecimal output and a PCAP file were not supplied for independent decoding. The RX capture counts and the five-packet payload inspection are separate observations.

[Bidirectional verification](bidirectional.md) · [Verification index](README.md) · [Packet flow](../operation.md) · [ERSPAN overview](../README.md) · [Evidence scope](../scope.md)
