# Technical references

The lab captures establish the observed results. These primary sources explain the mechanisms and command behavior behind them.

| Source | Use in this section |
|---|---|
| Cisco — Configuring the IOS DHCP Relay Agent | Placement of `ip helper-address` and use of the relay address in `giaddr` |
| Cisco — IP Addressing Services Command Reference | `renew deny unknown`, `renew dhcp`, `release dhcp` and the default one-day lease |
| RFC 2131 — Dynamic Host Configuration Protocol | DHCP message flow and the distinction between address acquisition, renewal and release |
| RFC 2131, section 4.4.5 | T1/T2 behavior and lease expiration |

Documentation was checked when preparing this section on September 14, 2026. The lab uses IOSv/IOSvL2; behavior captured here should not be generalized to every platform or software release.

In particular, the client-side handling of the server-generated NAK was not resolved by these excerpts. [Case 03](troubleshooting/03-lease-state-mismatch.md) states what was observed and what a further capture would need to establish.

[Section overview](README.md)

