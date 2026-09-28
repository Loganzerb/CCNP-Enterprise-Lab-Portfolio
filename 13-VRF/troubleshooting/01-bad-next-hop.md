# Case 01 — An installed route with an unresolved next hop

**Outcome:** changing RED’s static next hop back to 10.10.10.2 restored 5/5 replies to 172.16.100.1.

## Symptom and investigation

The controlled fault replaced RED’s next hop with 10.10.10.99. The static route still installed, and CEF resolved it through RED’s connected 10.10.10.0/24 toward Gi0/1. That made the route look plausible until the adjacency and traffic checks were compared.

| Check | Captured result | Meaning |
|---|---|---|
| RED route and CEF for 172.16.100.1 | Installed through 10.10.10.99 and Gi0/1 | Recursion reaches a connected subnet |
| Ping the real CE at 10.10.10.2 | 5/5 | The CE link is working |
| Ping 172.16.100.1 | 0/5 | The selected remote path fails |
| RED ARP for 10.10.10.99 | Incomplete | The selected next hop has no resolved MAC address |

[Blocks 12–13 — route, CEF, ARP and failure evidence](../verification/03-faults.md#block-12--a-nonexistent-next-hop-still-installs)

## Root cause and remediation

The next hop was inside RED’s connected subnet but was not the CE address. An installed route established recursive reachability to the subnet, not a usable Layer 2 adjacency to the chosen host.

The repair commands below are reconstructed from the lab sequence; the resulting route and ping are captured in Block 14.

```ios
no ip route vrf RED 172.16.100.1 255.255.255.255 10.10.10.99
ip route vrf RED 172.16.100.1 255.255.255.255 10.10.10.2
```

## Post-fix validation and lesson

RED’s route again points to the real CE and the loopback responds to all five probes. **Route installation and next-hop adjacency resolution are separate checks.** CEF recursion toward an interface must be correlated with ARP and an actual traffic test.

[Block 14 — recovery](../verification/03-faults.md#block-14--repair-the-next-hop-and-retest) · [Next: wrong table](02-wrong-table.md) · [Case index](README.md)
