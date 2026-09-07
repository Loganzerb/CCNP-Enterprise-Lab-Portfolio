# Scenario 2 — HSRP Version Mismatch

## Problem

Removing HSRPv2 from DIST-A’s VLAN 20 interface broke the peer relationship while both devices retained the same virtual IP.

## Expected behavior

DIST-B should be Active at priority 120, with DIST-A Standby at priority 100. Both should recognize the same HSRP version and virtual gateway identity.

## Observed symptoms

Both routers reported Active with an unknown Standby. Their virtual MACs differed, and duplicate-address logs appeared.

PC-B nevertheless completed 19 of 20 upstream probes.

## Hypotheses

- HSRP version mismatch.
- Authentication mismatch.
- Layer 2 loss preventing peer communication.

The version-specific MACs and captured configuration change distinguished this fault from the alternatives.

## Troubleshooting methodology

Inspect both peers, compare version and virtual-MAC fields, correlate duplicate-address logs, and check PC-B’s ARP and forwarding path. Restore the version and verify both protocol state and client service.

## Evidence

DIST-A’s captured change:

```text
FHRP-DIST-A(config-if)#no standby version 2
```

Selected DIST-A output:

```text
State is Active
Local virtual MAC address is 0000.0c07.ac14 (v1 default)
Active router is local
Standby router is unknown
```

Selected DIST-B output:

```text
Vlan20 - Group 20 (version 2)
State is Active
Local virtual MAC address is 0000.0c9f.f014 (v2 default)
Active router is local
Standby router is unknown
```

Captured log:

```text
*Sep  6 18:36:37.841: %IP-4-DUPADDR: Duplicate address 10.20.20.1 on Vlan20, sourced by 0000.0c07.ac14
```

PC-B:

```text
20 packets transmitted, 19 packets received, 5% packet loss
```

Source: [Version change, dual-active state, duplicate VIP logs and client test](../verification/hsrp-version-mismatch/FHRP-DIST-A-DIST-B-and-PC-B-version-mismatch.txt).

After explicitly deleting its gateway ARP entry, PC-B relearned:

```text
10.20.20.1 dev eth0 lladdr 00:00:0c:9f:f0:14 ref 1 used 0/0/0 probes 4 DELAY
```

The next gateway test completed 5/5 probes, and traceroute still used DIST-B.

Source: [Client gateway MAC and routed path during version mismatch](../verification/hsrp-version-mismatch/PC-B-ping-arp-and-traceroute-during-version-mismatch.txt).

## Root cause

DIST-A reverted to HSRPv1 while DIST-B remained on HSRPv2. They no longer formed a shared Active/Standby pair and independently claimed the same VIP.

The captures do not establish alternating packet loss or repeated ARP oscillation.

## Resolution

Restore `standby version 2` on DIST-A’s Vlan20 interface.

## Verification

Both peers subsequently displayed HSRPv2. DIST-A returned to Standby, recognized DIST-B as Active, and used the same virtual MAC.

PC-B’s final upstream test reported:

```text
5 packets transmitted, 5 packets received, 0% packet loss
```

Its neighbor entry remained `00:00:0c:9f:f0:14`, and its first routed hop was `10.20.20.3`.

Sources: [Restored HSRPv2 peers and complementary dual-VLAN roles](../verification/hsrp-version-mismatch/FHRP-DIST-A-and-DIST-B-show-standby-version-restored.txt), [Client verification after HSRPv2 repair](../verification/hsrp-version-mismatch/PC-B-ping-arp-and-traceroute-version-restored.txt).

## Engineering takeaway

Successful traffic through one claimant can conceal a broken redundancy group. Verify the peer relationship and virtual identity on both devices; ping alone cannot establish healthy HSRP.

[Evidence index](../verification/README.md) · [Case studies](README.md)
