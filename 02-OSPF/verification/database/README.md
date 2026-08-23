# OSPF Database Verification

## Command Collected

```cisco
show ip ospf database
```

This command validates the converged OSPF Link-State Database (LSDB), including Router, Network, Summary, NSSA External, and AS External Link-State Advertisements (LSAs).

## Healthy-State Observations

- `O1-CORE` contains the expected Area 0 Router and Network LSAs, plus Summary LSAs originated by `O2-ABR` for Area 10 destinations.
- The Area 0 Network LSA is advertised by `10.100.2.2`, consistent with `O2-ABR` being the Designated Router on the `O1`–`O2` segment.
- `O2-ABR` holds databases for both Area 0 and Area 10, directly validating its Area Border Router (ABR) role.
- Area 10 routers share the same Router-LSA set for router IDs `10.100.2.2` through `10.100.5.5`.
- `O2-ABR` originates the `0.0.0.0` Summary LSA into the totally Not-So-Stubby Area (NSSA).
- `O4-EDGE` originates Type 7 LSAs for `192.0.2.0/24` and `198.51.100.0/24` inside Area 10.
- `O2-ABR` advertises those same prefixes as Type 5 LSAs into Area 0, proving Type 7-to-Type 5 translation.
- Area 0 receives the summarized branch prefix `172.20.32.0` through a Summary LSA from `O2-ABR`.

These captures demonstrate consistent LSDB convergence across the two-area design and the intended NSSA external-route behavior.
