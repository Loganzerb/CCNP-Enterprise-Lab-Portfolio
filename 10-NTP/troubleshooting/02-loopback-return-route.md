# Case 02 — A stable source address needs a return route

## Summary

NTP stopped exchanging time information after R3 began sourcing requests from Loopback0. The server address had not changed; the reply destination had. R2 lacked a route back to the new source, 3.3.3.3.

Adding one host route restored both the source-specific ping and NTP exchanges.

## Symptom and investigation

R3's new Loopback0 was up/up at **3.3.3.3/32**, but R2 returned `% Network not in table` for that address. [Blocks 01–02](../verification/03-loopback-route.md#block-01)

After the NTP source change, R3 showed `.INIT.`, stratum 16 and reach 0. A ping to the same server, explicitly sourced from **3.3.3.3**, failed **0/5**. [Blocks 03–04](../verification/03-loopback-route.md#block-03)

Testing with that source mattered. A probe using R3's directly connected 10.20.0.3 address would not test R2's ability to reply to the loopback.

## Correction

I added a route on R2 pointing to R3's connected interface. The repair command below is reconstructed from the exercise and verified route entry:

```cisco
ip route 3.3.3.3 255.255.255.255 10.20.0.3
```

The captured route table then showed **3.3.3.3/32 via 10.20.0.3**, learned statically. [Block 05](../verification/03-loopback-route.md#block-05)

## Verification

| Check | Before | After |
|---|---|---|
| Ping to 10.20.0.1 sourced from 3.3.3.3 | 0/5 replies | 5/5 replies |
| R3's NTP association | .INIT., stratum 16, reach 0 | Reference 10.12.0.1, server stratum 2, reach 17 |

[Recovered ping — Block 06](../verification/03-loopback-route.md#block-06) · [Recovered exchange — Block 07](../verification/03-loopback-route.md#block-07)

The server still pointed to 10.20.0.1 and retained the loopback source. Restoring the return route allowed communication to resume without another NTP configuration change.

Reach **17** is an octal history of successful exchanges. The final capture has no selected-peer marker and no accompanying synchronized status, so the demonstrated outcome is **communication recovery**, not completed clock convergence.

**Takeaway:** when a service changes its source address, verify the return path to that address as part of the change.

[Back to cases](README.md) · [Back to NTP](../README.md)
