# STP, RSTP, PVST+, and Rapid PVST+ Lab

## Objective

Build a redundant Layer 2 topology, select roots deliberately, predict every port role, and compare classic 802.1D convergence with the rapid proposal/agreement process used by 802.1w.

## Protocol model

| Mode | Tree model | Operational behavior |
|---|---|---|
| STP (802.1D) | One common tree | Listening and learning depend on timers |
| RSTP (802.1w) | One common rapid tree | Alternate ports and handshakes accelerate convergence |
| PVST+ | One 802.1D tree per VLAN | Per-VLAN root placement and load sharing |
| Rapid PVST+ | One rapid tree per VLAN | Per-VLAN design with rapid convergence |

Cisco access-layer labs commonly use Rapid PVST+ because each VLAN can have a different root while retaining RSTP behavior. That scale tradeoff is one reason MST is documented separately in `05-MSTP`.

## Baseline configuration

```cisco
! DSW1
spanning-tree mode rapid-pvst
spanning-tree vlan 10,20 root primary
spanning-tree vlan 30,40 root secondary

! DSW2
spanning-tree mode rapid-pvst
spanning-tree vlan 30,40 root primary
spanning-tree vlan 10,20 root secondary
```

The `root primary` and `root secondary` macros produce a usable priority at configuration time. Explicit priorities are preferable when the intended values must be visible and identical across deployments.

```cisco
spanning-tree vlan 10,20 priority 24576
spanning-tree vlan 30,40 priority 28672
```

## Root election and tie-breakers

The lowest Bridge ID wins. Its comparison order is:

1. Lowest bridge priority, including the extended system ID (VLAN).
2. Lowest bridge MAC address when priorities tie.

A non-root switch selects its Root Port by comparing received BPDU information in this order:

1. Lowest Root Bridge ID.
2. Lowest total root path cost.
3. Lowest sender Bridge ID.
4. Lowest sender Port ID (port priority, then port number).
5. Lowest local receiving Port ID if all received information still ties.

Designated-port selection uses the superior BPDU on each segment: root ID, advertised root path cost, sender bridge ID, then sender port ID. Roles describe topology function; states describe forwarding behavior.

```text
RSTP roles:  Root, Designated, Alternate, Backup
RSTP states: Discarding, Learning, Forwarding
802.1D states: Blocking, Listening, Learning, Forwarding, Disabled
```

## Verification evidence

```cisco
DSW1# show spanning-tree vlan 10
VLAN0010
  Spanning tree enabled protocol rstp
  Root ID    Priority    24586
             Address     0011.2233.4400
             This bridge is the root

Interface        Role Sts Cost      Prio.Nbr Type
Po11             Desg FWD 20000     128.65   P2p
Po12             Desg FWD 20000     128.66   P2p
```

`24586` is priority `24576` plus VLAN 10's extended system ID. The value is expected; it is not an unexplained priority change.

```cisco
ASW1# show spanning-tree vlan 10
Root ID    Priority    24586
           Cost        20000
           Port        65 (Port-channel11)

Po11             Root FWD 20000     128.65   P2p
Po20             Altn BLK 20000     128.74   P2p
```

## Convergence and timers

Classic 802.1D relies on Hello Time, Max Age, and Forward Delay. With common defaults, a port can spend 15 seconds listening and 15 seconds learning before forwarding; indirect failures may also depend on Max Age. The root bridge originates the operative timer values.

RSTP converges differently:

- An edge port can move directly to forwarding.
- A point-to-point link can use proposal/agreement synchronization.
- A precomputed alternate port can rapidly replace a failed Root Port.
- Topology-change signaling is propagated rapidly rather than waiting for a root-generated TCN acknowledgment cycle.

```cisco
show spanning-tree vlan 10 detail
show spanning-tree interface port-channel11 detail
```

```text
Number of topology changes 4 last change occurred 00:00:08 ago
from Port-channel11
Link type is point-to-point by default
```

Timer tuning was treated as an exception, not a substitute for Rapid STP and sound topology design.

## Skills demonstrated

- Compared four spanning-tree operating models and their scaling implications.
- Derived elections and port roles from BPDU tie-break fields.
- Explained extended system ID values in real verification output.
- Correlated topology-change evidence with failure and recovery events.
