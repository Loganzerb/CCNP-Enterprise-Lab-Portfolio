# Scenario 3 — STP/HSRP Path Misalignment

## Problem

VLAN 20’s STP root was moved to DIST-A while its HSRP Active gateway remained DIST-B.

## Expected behavior

The intended design placed both VLAN 20’s STP root and HSRP Active gateway on DIST-B, providing a direct access-to-gateway forwarding path.

## Observed symptoms

Connectivity continued to work, but the access switch forwarded gateway-bound frames toward DIST-A. DIST-A then forwarded those frames across Po10 to DIST-B.

Traceroute still showed DIST-B as the first routed hop.

## Hypotheses

- HSRP gateway ownership changed.
- STP changed the Layer 2 path while HSRP ownership remained unchanged.
- Traceroute would omit the additional device because it only switched frames.

## Troubleshooting methodology

Compare STP before and after the change. Verify HSRP on both distribution devices, then trace the HSRP virtual MAC through their MAC tables. Use ping and traceroute to distinguish connectivity from path efficiency.

## Evidence

Healthy access-switch port roles:

```text
Gi0/0               Altn BLK 4         128.1    P2p
Gi0/1               Root FWD 4         128.2    P2p
```

After changing the root placement:

```text
Gi0/0               Root FWD 4         128.1    P2p
Gi0/1               Altn BLK 4         128.2    P2p
```

Sources: [VLAN 20 access path before root misalignment](../verification/stp-alignment/FHRP-ACCESS-1-show-spanning-tree-vlan20-aligned.txt), [Access root port moves toward DIST-A](../verification/stp-alignment/FHRP-ACCESS-1-show-spanning-tree-vlan20-misaligned.txt).

HSRP still showed DIST-A Standby and DIST-B Active.

Source: [HSRP gateway stays on DIST-B during STP misalignment](../verification/stp-alignment/FHRP-DIST-A-and-DIST-B-show-standby-misaligned-path.txt).

ACCESS-1’s virtual-MAC lookup:

```text
20    0000.0c9f.f014    DYNAMIC     Gi0/0
```

DIST-A’s lookup:

```text
20    0000.0c9f.f014    DYNAMIC     Po10
```

These observations establish the path:

**PC-B → ACCESS-1 → DIST-A → Po10 → DIST-B → CORE-R1**

Source: [Gateway MAC learned toward DIST-A and across Po10](../verification/stp-alignment/FHRP-ACCESS-1-and-DIST-A-show-mac-address-table-misaligned.txt).

PC-B still completed:

```text
5 packets transmitted, 5 packets received, 0% packet loss
```

Traceroute:

```text
1  10.20.20.3 (10.20.20.3)  3.977 ms  3.722 ms  4.385 ms
2  10.255.0.5 (10.255.0.5)  4.881 ms  4.428 ms  *
```

Source: [Client forwarding while Layer 2 and gateway placement differ](../verification/stp-alignment/PC-B-ping-and-traceroute-misaligned-path.txt).

## Root cause

STP and HSRP made independent decisions. The deliberate STP priority change moved the forwarding tree without moving the gateway, introducing an additional Layer 2 traversal.

## Resolution

The saved configuration identified DIST-A’s original setting:

```text
FHRP-DIST-A#show startup-config | include spanning-tree vlan 20
spanning-tree vlan 20 priority 28672
```

Restore that priority to return DIST-B to the intended root position.

Source: [Saved VLAN 20 STP priority](../verification/stp-alignment/FHRP-DIST-A-show-startup-config-vlan20-priority.txt).

## Verification

The access switch returned to Gi0/1 Root/FWD and Gi0/0 Alternate/Blocked. Its final virtual-MAC lookup showed:

```text
20    0000.0c9f.f014    DYNAMIC     Gi0/1
```

Sources: [Original access root-port placement restored](../verification/stp-alignment/FHRP-ACCESS-1-show-spanning-tree-vlan20-alignment-restored.txt), [Gateway MAC returned to the direct Gi0/1 path](../verification/stp-alignment/FHRP-ACCESS-1-show-mac-address-table-alignment-restored.txt).

## Engineering takeaway

Traceroute reveals routed hops, so it did not expose DIST-A’s Layer 2 transit role. STP state and MAC-table evidence were required to prove the additional traversal.

The small ping samples are not used to quantify the latency cost of misalignment.

[Evidence index](../verification/README.md) · [Case studies](README.md)
