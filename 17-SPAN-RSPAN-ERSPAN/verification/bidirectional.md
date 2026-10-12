# Bidirectional ERSPAN verification

The final runtime check reported Gi1 as a Both-direction source. The collector observations then identified an original Echo Request and its reply inside separate GRE packets.

**Quick navigation:** [Runtime direction](#runtime-direction) · [Reported request and reply](#reported-request-and-reply) · [Evidence scope](#evidence-scope)

## Runtime direction

### Block 03

**Selected CLI excerpt — R1 `show monitor session 1`.** Line contents follow the supplied handoff.

```text
Type                     : ERSPAN Source Session
Status                   : Admin Enabled
Source Ports             :
    Both                 : Gi1
Destination IP Address   : 10.30.30.2
Destination ERSPAN ID    : 100
Origin IP Address        : 10.30.30.1
```

The saved source line is abbreviated as `source interface Gi1`, without an explicit `both` keyword. This runtime excerpt records `Both : Gi1`. Read the [configuration guide](../configs/README.md) alongside the operational result to distinguish saved serialization from reported direction.

## Reported request and reply

**Decoded observations from the lab record.** No packet-output transcript accompanies this table.

| Mirrored packet | Inner source | Inner destination | ICMP type |
|---|---|---|---|
| Echo Request | `10.10.10.10` | `10.20.20.20` | 8 |
| Echo Reply | `10.20.20.20` | `10.10.10.10` | 0 |

The handoff identifies a matching request/reply pair in consecutive GRE sequence numbers **122 and 123**. It reports **12 GRE packets**, no capture-kernel drops, and **10/10** successful R2 ping probes.

Requests enter R1 Gi1 from R2; replies leave Gi1 toward R2. The selected pair is consistent with mirroring both directions on that interface.

## Evidence scope

The runtime source setting is supported by the selected CLI excerpt. Packet identities, sequences, counts, and ping success are reported observations and decoding. The 12-packet capture does not establish a complete capture across all ten probes. No raw packet dump or PCAP file is attached, and the kernel-drop observation does not quantify source-side mirroring loss.

Alpine received and inspected GRE directly. An ERSPAN destination session was not part of the verified lab.

[RX capture and payload](rx-payload.md) · [Connectivity results](connectivity.md) · [Verification index](README.md) · [ERSPAN overview](../README.md) · [Packet flow](../operation.md) · [Evidence scope](../scope.md)
