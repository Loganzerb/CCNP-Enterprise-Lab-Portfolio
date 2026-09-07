# HSRP: Gateway Redundancy and Verification

![Campus topology](../assets/fhrp-campus-topology.png)

## Problem

Provide redundant gateways for two client VLANs while distributing their preferred forwarding paths across DIST-A and DIST-B.

## Expected behavior

VLAN 10 should prefer DIST-A; VLAN 20 should prefer DIST-B. A surviving peer should assume gateway responsibility after failure, and configured preemption should restore the preferred placement after recovery.

## Observed symptoms

The healthy lab formed complementary Active/Standby pairs. Controlled faults demonstrated three distinct problems: upstream loss without gateway withdrawal, version mismatch with dual-active state, and STP placement that introduced an additional Layer 2 traversal.

Separate authentication and timer exercises extended the protocol showcase.

## Hypotheses

Gateway ownership alone would not establish upstream reachability. Peer communication, routing state, and Layer 2 forwarding needed independent verification.

## Troubleshooting methodology

1. Verify physical-address reachability before enabling the virtual gateway.
2. Inspect HSRP state, priority, preemption, and virtual MAC.
3. Test host reachability and gateway ARP resolution.
4. Introduce one controlled fault.
5. Correlate both peers’ state with routing and host evidence.
6. Repair the fault and verify the restored forwarding path.

## Evidence

### Dual-VLAN placement

Selected rows from DIST-A after version-mismatch repair:

```text
Interface   Grp  Pri P State   Active          Standby         Virtual IP
Vl10        10   120 P Active  local           10.10.10.3      10.10.10.1
Vl20        20   100 P Standby 10.20.20.3      local           10.20.20.1
```

DIST-B:

```text
Interface   Grp  Pri P State   Active          Standby         Virtual IP
Vl10        10   100 P Standby 10.10.10.2      local           10.10.10.1
Vl20        20   120 P Active  local           10.20.20.2      10.20.20.1
```

Source: [7172befc](../evidence/7172befc.txt).

Both clients also reached `10.255.255.1` with 5/5 successful probes in the upstream baseline. Traceroute showed DIST-A as PC-A’s first routed hop and DIST-B as PC-B’s first routed hop.

Source: [786121c5](../evidence/786121c5.txt).

### Captured configuration: DIST-A VLAN 10

Actual running-config excerpt after adding tracking and recovery delay:

```cisco
interface Vlan10
 description USERS-A-GATEWAY
 ip address 10.10.10.2 255.255.255.0
 standby version 2
 standby 10 ip 10.10.10.1
 standby 10 priority 120
 standby 10 preempt delay minimum 10
 standby 10 track 1 decrement 21
end
```

Source: [9e9f8ed6](../evidence/9e9f8ed6.txt).

### Authentication mismatch

DIST-B logged:

```text
*Sep  6 19:31:32.878: %HSRP-4-BADAUTH2: Bad authentication from 10.20.20.2
```

Its HSRP output included:

```text
State is Active
Active router is local
Standby router is unknown
```

The peer capture also showed DIST-A becoming Active. After the mismatch was removed, DIST-A returned to Standby and DIST-B remained Active.

Sources: [698e800b](../evidence/698e800b.txt), [c35de682](../evidence/c35de682.txt), [1297015d](../evidence/1297015d.txt).

### Custom timers

Both peers displayed:

```text
Hello time 1 sec, hold time 4 sec
```

They retained a healthy Active/Standby relationship. After DIST-B’s VLAN 20 shutdown, DIST-A displayed:

```text
State is Active
Active router is local
Standby router is unknown
```

These captures establish timer operation and takeover. They do not provide a precise elapsed failover measurement.

Sources: [9d95d762](../evidence/9d95d762.txt), [d5802fba](../evidence/d5802fba.txt).

## Root cause

The detailed cases isolate different causes: missing upstream tracking, incompatible HSRP versions, and independent STP/HSRP placement decisions. The authentication exercise separately demonstrated rejection of peer messages.

## Resolution

Use consistent peer configuration, connect gateway preference to upstream health, allow routing to recover before reclaiming the gateway, and align STP placement with the intended Active device.

## Verification

Both peers’ roles, client ARP entries, upstream routes, and host forwarding paths were checked after repair. Detailed evidence appears in the [three troubleshooting cases](../troubleshooting/README.md).

## Lessons / ENCOR concept

HSRP priority selects gateway preference; preemption controls reclamation; tracking changes effective priority. None of these checks alone proves that the complete host-to-destination path is healthy.

[Evidence index](../evidence/README.md) · [FHRP overview](../README.md)
