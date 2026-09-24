# Case 02 — The next-hop route remains, but the policy path changes

## Summary

After the direct R2–R3 link was disabled, OSPF still installed an indirect route to the policy next-hop subnet through R4. Nevertheless, the source-A trace changed to the normal R2 → R4 → R5 path. Restoring the direct link restored the path through R3.

The result shows why the presence of an address in the routing table is not enough to predict ordinary PBR behavior.

## Failure and investigation

The baseline policy used `set ip next-hop 10.23.1.3` for source A. I followed the exercise step to shut R2 Gi0/1, its direct link to R3.

The next capture did **not** show a missing prefix. Instead, R2 learned **10.23.1.0/24 through OSPF via 10.24.1.4**, metric 3, on Gi0/2. [Block 01](../verification/03-next-hop-failure.md#block-01)

I then tested the traffic path rather than inferring it from that route:

```text
Source 10.1.1.1 → destination 10.5.5.5
R1 → R2 → R4 → R5
```

The captured traceroute omitted R3. [Block 02](../verification/03-next-hop-failure.md#block-02)

## Interpretation

This is consistent with ordinary PBR falling back to destination-based routing when its directly connected next hop is no longer usable. Cisco documents recursive next-hop support as a separate feature for resolving a nonadjacent policy next hop.

The installed indirect route is a control-plane observation, not a successful probe to 10.23.1.3. Also, a trace through R4 alone cannot expose the internal decision: an indirect lookup toward R3 would initially use R4 too. The ordinary policy configuration and Cisco's documented behavior support the fallback interpretation; no packet-level PBR debug was captured during the fault.

## Restoration

I restored R2 Gi0/1. R2 again showed the next-hop subnet as **connected**, and the same source-A traceroute returned to **R1 → R2 → R3 → R4 → R5**.

[Connected route — Block 03](../verification/03-next-hop-failure.md#block-03) · [Restored trace — Block 04](../verification/03-next-hop-failure.md#block-04)

The shutdown commands were provided as exercise steps; the retained CLI captures show the route and path changes, without a separate interface-down capture. The exercise did not measure convergence time or test failure beyond a still-up next-hop link.

**Takeaway:** inspect next-hop usability and the actual flow path together. Do not treat an indirect route as proof that the original policy action remains effective.

[Back to cases](README.md) · [Back to PBR](../README.md)
