# Case 10 — Path-cost and port-priority engineering

## Experiment

Redundant equal-speed links were manipulated without changing cabling. Path cost was changed first to alter the preferred Root Port. In equal-cost conditions, port priority was used to influence the final sender-port-ID comparison.

## Decision chain

For Root Port selection, the lab applied the relevant sequence:

1. Lowest received Root Path Cost
2. Lowest sender Bridge ID
3. Lowest sender Port ID (port priority plus port number)
4. Lowest local receiving Port ID if still tied

## Verification

```text
show spanning-tree vlan <id>
show spanning-tree interface <interface> detail
show running-config interface <interface>
```

The retained VLAN 10 capture shows SW3 selecting `Gi0/0` at long cost `20000` and keeping `Gi0/2` as `Altn BLK`.

## Recovery

Remove temporary interface cost/priority overrides or document them as intentional design. Re-verify all affected VLANs because Rapid PVST+ makes an independent decision per VLAN.

## Lesson

Cost is the primary path-engineering tool. Port priority is a lower-order tie-break and should not be expected to override a worse root-path cost.
