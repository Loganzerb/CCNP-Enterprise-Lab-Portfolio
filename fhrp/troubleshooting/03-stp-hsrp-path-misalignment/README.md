# 03 — STP/HSRP Path Misalignment

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

Sources: [05024df7](../../evidence/05024df7.txt), [6a7ab702](../../evidence/6a7ab702.txt).

HSRP still showed DIST-A Standby and DIST-B Active.

Source: [a1d1683a](../../evidence/a1d1683a.txt).

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

Source: [40e84cde](../../evidence/40e84cde.txt).

PC-B still completed:

```text
5 packets transmitted, 5 packets received, 0% packet loss
```

Traceroute:

```text
1  10.20.20.3 (10.20.20.3)  3.977 ms  3.722 ms  4.385 ms
2  10.255.0.5 (10.255.0.5)  4.881 ms  4.428 ms  *
```

Source: [39f04980](../../evidence/39f04980.txt).

## Root cause

STP and HSRP made independent decisions. The deliberate STP priority change moved the forwarding tree without moving the gateway, introducing an additional Layer 2 traversal.

## Resolution

The saved configuration identified DIST-A’s original setting:

```text
FHRP-DIST-A#show startup-config | include spanning-tree vlan 20
spanning-tree vlan 20 priority 28672
```

Restore that priority to return DIST-B to the intended root position.

Source: [09ceb874](../../evidence/09ceb874.txt).

## Verification

The access switch returned to Gi0/1 Root/FWD and Gi0/0 Alternate/Blocked. Its final virtual-MAC lookup showed:

```text
20    0000.0c9f.f014    DYNAMIC     Gi0/1
```

Sources: [b721081e](../../evidence/b721081e.txt), [61352390](../../evidence/61352390.txt).

## Lessons / ENCOR concept

Traceroute reveals routed hops, so it did not expose DIST-A’s Layer 2 transit role. STP state and MAC-table evidence were required to prove the additional traversal.

The small ping samples are not used to quantify the latency cost of misalignment.

[Evidence index](../../evidence/README.md) · [Case studies](../README.md)
