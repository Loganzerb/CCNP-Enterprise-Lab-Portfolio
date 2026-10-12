# Alpine ERSPAN collector setup

ERSPAN-CAPTURE uses Alpine Linux on the link to R1 GigabitEthernet3. The collector's `10.30.30.2/30` address was added interactively during the lab and is absent from the saved CML startup configuration.

**Quick navigation:** [Address after restart or import](#address-after-restart-or-import) · [Recorded address command](#block-01) · [Inspect mirrored traffic](#inspect-mirrored-traffic)

## Address after restart or import

**Reproduction steps — not an additional recorded test.**

1. Check whether eth0 already has `10.30.30.2/30`.
2. If the address is absent, reapply the recorded command below.

### Block 01

**Recorded command — interactive collector addressing.**

```bash
sudo ip addr add 10.30.30.2/30 dev eth0
```

The saved startup script does not set this IPv4 address. No persistent initialization change or fresh-import test is represented as completed work. Use local access settings for the sanitized collector; [export scope](../scope.md) records the public-file preparation.

## Inspect mirrored traffic

The [RX capture command](../verification/rx-payload.md#block-01) filters GRE with IP protocol 47. The [payload-inspection command](../verification/rx-payload.md#block-02) requests hexadecimal output for five packets. Their reported results and decoded fields remain in the verification guide; no raw capture file was supplied.

Alpine receives the routed GRE packets and inspects them directly. It does not run a configured ERSPAN destination session in this lab.

[Verification index](../verification/README.md) · [Configuration index](README.md) · [Topology](../topology.md) · [ERSPAN overview](../README.md) · [Evidence scope](../scope.md)
