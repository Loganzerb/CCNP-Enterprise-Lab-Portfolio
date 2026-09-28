# Case 02 — A configured route that never installs

**Outcome:** placing the route back in RED restored the RIB entry and 5/5 replies to 172.16.100.1.

## Symptom and investigation

The exercise removed RED’s static route and configured this global route instead:

```ios
ip route 172.16.100.1 255.255.255.255 10.10.10.2
```

Running-config contained the command, but both the global and RED destination lookups returned `% Network not in table`. The decisive comparison was the next-hop lookup: global had no route to 10.10.10.2, while RED had its connected /24 through Gi0/1.

[Blocks 15–16 — configured route and routing-context comparison](../verification/03-faults.md#block-15--a-global-route-exists-in-configuration-only)

## Root cause and remediation

The route was configured in the wrong table. Recursive next-hop resolution had to succeed in the global context; RED’s connected route did not satisfy that lookup. The route was accepted as configuration but never installed globally, and removing the RED route also left RED without the destination.

These repair commands are reconstructed from the exercise. The restored RED route and successful probes are retained in Block 17.

```ios
no ip route 172.16.100.1 255.255.255.255 10.10.10.2
ip route vrf RED 172.16.100.1 255.255.255.255 10.10.10.2
```

## Post-fix validation and lesson

The destination installs inside RED through 10.10.10.2 and returns 5/5 replies. **Configured does not mean installed.** Check both the destination and next hop in the route’s own routing context before changing the physical network.

[Block 17 — recovery](../verification/03-faults.md#block-17--restore-the-route-in-the-right-context) · [Next: return paths](03-return-path.md) · [Case index](README.md)
