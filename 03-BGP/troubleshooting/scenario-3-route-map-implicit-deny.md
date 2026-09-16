# Case 03 — Recover routes excluded by an outbound policy

O4's session to B2 stayed established, but its outbound policy advertised only one prefix. A missing catch-all permit excluded the remaining eligible routes. Completing the intended lab policy restored five advertisements and B2's missing path.

## Expected behavior and fault

O4-EDGE peers with B2-ISP-B across the shared `10.250.2.0/29` subnet. For this experiment, the intended policy permitted the enterprise prefix and allowed the other eligible advertisements to continue.

I applied `BROKEN-TO-B2` outbound toward `10.250.2.2`. Its only sequence permitted `172.31.250.0/24`; routes that did not match were implicitly denied. An outbound soft refresh applied the policy.

[Fault configuration](../verification/incidents/scenario-3-route-map-implicit-deny.md#block-1)

## How I isolated the cause

| Captured observation | What it established |
|---|---|
| O4's route map contained only permit sequence 10 | No later permit handled the other routes |
| O4 advertised only `172.31.250.0/24` to B2 | The fault affected the outbound route set |
| B2's session to O4 remained established with one received prefix | An established peer could coexist with unintended filtering |
| B2's entry for `172.31.251.0/24` showed one path, through X1 | The path through O4 was missing from B2's candidate set |

[Policy and advertised routes](../verification/incidents/scenario-3-route-map-implicit-deny.md#block-2) · [B2's session and remaining path](../verification/incidents/scenario-3-route-map-implicit-deny.md#block-4)

The route-map output includes `Policy routing matches: 0 packets, 0 bytes`. Those counters do not count BGP advertisements; the advertised-routes output provides the relevant check. The fault-state B2 path excerpt ends mid-entry, so no missing lines have been reconstructed.

## Repair and verification

I added an unconditional `route-map BROKEN-TO-B2 permit 20` and refreshed O4's outbound advertisements. This restored the experiment's intended policy; a production export policy would need its own explicit permitted-prefix requirements.

| Check after correction | Recorded result |
|---|---|
| O4's route-map sequences | Permit 10 followed by permit 20 |
| O4's advertised routes to B2 | Five prefixes instead of one |
| B2's paths for `172.31.251.0/24` | Two paths, including the restored `65000 65100` path from O4 |
| B2's selected path | Still through X1, AS path `65300 65100` |

The restored path is learned **from O4, `10.250.2.1`**, but lists **B1, `10.250.2.3`**, as its next hop. Both peers share the same subnet; the advertising neighbor and forwarding next hop are distinct fields.

[Repair commands](../verification/incidents/scenario-3-route-map-implicit-deny.md#block-6) · [Recovered advertisements and paths](../verification/incidents/scenario-3-route-map-implicit-deny.md#block-7)

## Engineering takeaway

Successful recovery did not require B2 to choose a different best path. The repair restored the intended advertisements and an available alternative. The case demonstrates route-policy recovery; it does not include an endpoint delivery test.

[All original evidence](../verification/incidents/scenario-3-route-map-implicit-deny.md) · [Case index](README.md) · [Topology](../topology.md)
