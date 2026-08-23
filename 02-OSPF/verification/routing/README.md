# OSPF Routing Verification

## Command Collected

```cisco
show ip route ospf
```

This command validates the routes OSPF installs after shortest-path calculation, including intra-area (`O`), inter-area (`O IA`), NSSA external type 1 (`O N1`), and external type 1 (`O E1`) entries.

## Healthy-State Observations

- `O1-CORE` learns Area 10 destinations as inter-area routes through `O2-ABR`, including the summarized `172.20.32.0/22` branch prefix.
- `O1-CORE` installs `192.0.2.0/24` and `198.51.100.0/24` as `O E1`, confirming that translated external routes reach Area 0.
- `O2-ABR` sees the four component branch `/24` routes and installs a local `172.20.32.0/22` summary route to `Null0`, supporting controlled summary advertisement.
- `O2-ABR` learns the two redistributed prefixes as `O N1` from Area 10.
- The Area 10 routing tables confirm the expected default-route behavior from the ABR.
- Equal-Cost Multi-Path (ECMP) is visible where the topology offers equal-cost alternatives; `O2-ABR`, for example, has two next hops toward `O5-TRANSIT`.
- Installed routes use the normal OSPF administrative distance of `110` in the captured tables.

The routing-table evidence closes the loop between the converged LSDB and actual forwarding decisions.
