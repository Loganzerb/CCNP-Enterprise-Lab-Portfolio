# GLBP: One Gateway, Multiple Forwarders

![GLBP logical topology](../topology-glbp.png)

## Design objective

Demonstrate how a single virtual gateway distributes clients across three routers while retaining forwarding service during AVG, AVF, upstream, and authentication failures.

## Expected state

The AVG should manage virtual-gateway assignments. AVFs should forward traffic addressed to their virtual MACs, and surviving routers should take over failed forwarders.

Client assignment, AVG election, and AVF eligibility should respond to their respective settings.

## Observed behavior

The captures demonstrated three participating AVFs, virtual-MAC takeover, independent AVG and AVF recovery, tracking-based withdrawal, authentication isolation, and operational timer learning.

The weighted sample did **not** establish the configured 60/30/10 proportions.

## Questions investigated

- ARP mappings should explain each host’s selected forwarder.
- A surviving router should be able to service an existing virtual MAC.
- Losing forwarding eligibility should not necessarily remove the AVG role.
- Authentication rejection should explain conflicting group views.
- Shorter hold timers should reduce the observed peer-failure interruption.

## Verification workflow

1. Verify each router’s independent upstream path.
2. Establish the AVG, Standby, and AVF baseline.
3. Compare router state with client ARP entries.
4. Test each load-balancing mode.
5. Introduce one controlled failure and inspect the actual takeover.
6. Restore the device or configuration and verify ownership.
7. Compare timer runs using captured packet counts and loss patterns.

## Captured results

### 1. Underlay and configuration showcase

Each GLBP router learned `10.255.255.1/32` through OSPF process 30 and completed a 5/5 source-addressed ping.

| Router | Observed upstream next hop |
|---|---|
| R1 | 10.255.10.1 |
| R2 | 10.255.10.5 |
| R3 | 10.255.10.9 |

Source: [Independent upstream routing and source-addressed pings](glbp-baseline/GLBP-R1-R2-R3-show-ip-route-and-source-ping.txt).

The following summarizes operational settings from the completed exercises, rather than presenting a reconstructed configuration export:

| Setting | R1 | R2 | R3 |
|---|---|---|---|
| Client-facing interface | Gi0/1 | Gi0/1 | Gi0/1 |
| Group / VIP | 30 / 10.30.30.1 | Same | Same |
| AVG priority | 130 | 110 | 100 |
| AVG preemption in later captures | Enabled | Disabled | Disabled |
| Later configured weighting | 60 | 30 | 10 |
| Later lower / upper thresholds | 30 / 40 | 1 / 30 | 1 / 10 |
| R1 upstream tracking | Object 10, decrement 35 | — | — |
| Authentication after authentication exercise | MD5, key-string | MD5, key-string | MD5, key-string |
| AVF preemption shown | Enabled, minimum 30 seconds | Same | Same |

The lab progressed from round-robin to weighted and then host-dependent mode. Timer testing temporarily changed 3/10 to 1/4.

Sources: [Custom 1/4 timer capture and user observation of peer learning](glbp-timers/GLBP-R1-show-glbp-custom-timers-and-peer-learning-note.txt), [Operational 3/10 timers with local configured 1/4 timers](glbp-timers/GLBP-R2-show-glbp-configured-versus-operational-timers.txt), [R3 claims AVG and all forwarders during authentication isolation](glbp-authentication/GLBP-R3-show-glbp-authentication-isolation.txt).

### 2. Healthy AVG and AVF placement

R1’s captured healthy state:

```text
GLBP-R1#show glbp brief
Interface   Grp  Fwd Pri State    Address         Active router   Standby router
Gi0/1       30   -   130 Active   10.30.30.1      local           10.30.30.3
Gi0/1       30   1   -   Active   0007.b400.1e01  local           -
Gi0/1       30   2   -   Listen   0007.b400.1e02  10.30.30.3      -
Gi0/1       30   3   -   Listen   0007.b400.1e03  10.30.30.4      -
```

R1 was AVG and AVF1. R2 was Standby AVG and AVF2. R3 serviced AVF3.

Source: [R1 AVG and primary AVF placement after enabling AVG preemption](glbp-baseline/GLBP-R1-and-R2-show-glbp-brief-preferred-avg-restored.txt).

### 3. Round-robin client assignments

The three hosts initially lacked a gateway ARP entry. After generating upstream traffic, their captured mappings were:

| Host | Gateway | Observed virtual MAC |
|---|---|---|
| HOST-A | 10.30.30.1 | 0007.b400.1e01 |
| HOST-B | 10.30.30.1 | 0007.b400.1e02 |
| HOST-C | 10.30.30.1 | 0007.b400.1e03 |

All three completed 5/5 upstream probes.

This demonstrates different virtual-MAC assignments under the captured round-robin baseline. It does not measure equal bandwidth utilization.

Sources: [Round-robin AVG and three-forwarder baseline](glbp-baseline/GLBP-R1-show-glbp-round-robin-baseline.txt), [HOST-A initial AVF1 assignment and upstream ping](glbp-baseline/HOST-A-ping-and-arp-round-robin.txt), [HOST-B initial AVF2 assignment and upstream ping](glbp-baseline/HOST-B-ping-and-arp-round-robin.txt), [HOST-C initial AVF3 assignment and upstream ping](glbp-baseline/HOST-C-ping-and-arp-round-robin.txt).

### 4. Weighted load balancing

R1 showed:

```text
Weighting 60 (configured 60), thresholds: lower 30, upper 40
  Track object 10 state Up decrement 35
Load balancing: weighted
```

The forwarder details showed weights 60, 30, and 10.

Ten recorded HOST-A ARP observations produced:

| Trial | AVF |
|---|---|
| 1 | 2 |
| 2 | 2 |
| 3 | 1 |
| 4 | 3 |
| 5 | 1 |
| 6 | 2 |
| 7 | 1 |
| 8 | 3 |
| 9 | 3 |
| 10 | 1 |

Totals were **4 / 3 / 3**, or **40% / 30% / 30%**.

A later AVG snapshot showed client-selection counters of **3 / 1 / 1**. Those counters did not match the manual sample, and their reset history was not independently established.

**Supported conclusion:** Weighted mode and unequal weights were operational, and all three AVFs appeared in client mappings.

**Unproven conclusion:** The exercise did not validate a long-run 60/30/10 assignment ratio. Repeated observations from one host, possible additional ARP activity, and unmatched counter windows limit that claim.

Sources: [Weighted mode and 60/30/10 forwarder weights](glbp-load-balancing/GLBP-R1-show-glbp-weighted-settings.txt), [Weighted client assignment observation 1](glbp-load-balancing/HOST-A-show-arp-weighted-trial-01.txt), [Weighted client assignment observation 2](glbp-load-balancing/HOST-A-ping-and-arp-weighted-trial-02.txt), [Weighted client assignment observation 3](glbp-load-balancing/HOST-A-ping-and-arp-weighted-trial-03.txt), [Weighted client assignment observation 4](glbp-load-balancing/HOST-A-ping-and-arp-weighted-trial-04.txt), [Weighted client assignment observation 5](glbp-load-balancing/HOST-A-ping-and-arp-weighted-trial-05.txt), [Weighted client assignment observation 6](glbp-load-balancing/HOST-A-ping-and-arp-weighted-trial-06.txt), [Weighted client assignment observation 7](glbp-load-balancing/HOST-A-show-arp-weighted-trial-07.txt), [Weighted client assignment observation 8](glbp-load-balancing/HOST-A-ping-and-arp-weighted-trial-08.txt), [Weighted client assignment observation 9](glbp-load-balancing/HOST-A-ping-and-arp-weighted-trial-09.txt), [Weighted client assignment observation 10](glbp-load-balancing/HOST-A-ping-and-arp-weighted-trial-10.txt), [Weighted client-selection counter snapshot](glbp-load-balancing/GLBP-R1-show-glbp-weighted-selection-counters.txt).

### 5. Host-dependent load balancing

After changing the mode, R1 showed:

```text
Load balancing: host-dependent
```

Three repeated HOST-A clear/ping/ARP trials all returned:

```text
Internet  10.30.30.1              0   0007.b400.1e02  ARPA   GigabitEthernet0/0
```

HOST-B also mapped to AVF2; HOST-C mapped to AVF3.

| Host | Observed assignment |
|---|---|
| HOST-A | AVF2 in all three trials |
| HOST-B | AVF2 |
| HOST-C | AVF3 |

The stable HOST-A mapping supported host-dependent assignment. Different hosts sharing AVF2 did not establish a fault.

Sources: [Host-dependent mode and forwarder settings](glbp-load-balancing/GLBP-R1-show-glbp-host-dependent-settings.txt), [HOST-A host-dependent assignment observation 1](glbp-load-balancing/HOST-A-ping-and-arp-host-dependent-trial-01.txt), [HOST-A host-dependent assignment observation 2](glbp-load-balancing/HOST-A-ping-and-arp-host-dependent-trial-02.txt), [HOST-A host-dependent assignment observation 3](glbp-load-balancing/HOST-A-ping-and-arp-host-dependent-trial-03.txt), [HOST-B maps to AVF2 in host-dependent mode](glbp-load-balancing/HOST-B-ping-and-arp-host-dependent.txt), [HOST-C maps to AVF3 in host-dependent mode](glbp-load-balancing/HOST-C-ping-and-arp-host-dependent.txt).

### 6. AVF failure and recovery

With HOST-C using AVF3, R3’s client-facing interface was shut down.

R1 then reported AVF3 on R2:

```text
Gi0/1       30   3   -   Listen   0007.b400.1e03  10.30.30.3      -
```

HOST-C retained:

```text
Internet  10.30.30.1              7   0007.b400.1e03  ARPA   GigabitEthernet0/0
```

R2’s detailed state confirmed it was servicing the inherited forwarder. Following recovery, AVF3 returned to R3.

Sources: [R1 view of R2 taking AVF3](glbp-failover/GLBP-R1-show-glbp-brief-avf3-takeover.txt), [HOST-C retains the AVF3 virtual MAC](glbp-failover/HOST-C-show-arp-during-avf3-takeover.txt), [R2 services inherited AVF3](glbp-failover/GLBP-R2-show-glbp-avf3-takeover.txt), [R2 view after AVF3 returned to R3](glbp-failover/GLBP-R2-show-glbp-brief-avf3-restored.txt).

A separate host-dependent test shut R2’s Gi0/1. R3 then serviced AVF2 while HOST-A retained `0007.b400.1e02`. R2 subsequently reclaimed AVF2.

Sources: [HOST-A ping and ARP with R1 view of AVF2 takeover](glbp-failover/HOST-A-and-GLBP-R1-ping-arp-and-avf2-takeover.txt), [R3 services inherited AVF2](glbp-failover/GLBP-R3-show-glbp-avf2-takeover.txt), [AVF2 returned to R2](glbp-failover/GLBP-R1-show-glbp-brief-avf2-restored.txt), [HOST-A gateway MAC after AVF2 recovery](glbp-failover/HOST-A-show-arp-after-avf2-recovery.txt).

### 7. AVG failure and independent AVF takeover

After R1 failed, R2 showed:

```text
GLBP-R2#show glbp brief
Interface   Grp  Fwd Pri State    Address         Active router   Standby router
Gi0/1       30   -   110 Active   10.30.30.1      local           10.30.30.4
Gi0/1       30   1   -   Listen   0007.b400.1e01  10.30.30.4      -
Gi0/1       30   2   -   Active   0007.b400.1e02  local           -
Gi0/1       30   3   -   Listen   0007.b400.1e03  10.30.30.4      -
```

**R2 became AVG, while R3 took over AVF1.** The roles did not have to move to the same router.

The associated ping runs reported:

| Host | Successful / sent | Total losses |
|---|---:|---:|
| HOST-A | 6182 / 6189 | 7 |
| HOST-B | 8655 / 8659 | 4 |
| HOST-C | 10125 / 10125 | 0 |

HOST-B’s losses are retained without assigning an unsupported cause.

When R1 returned with AVG preemption disabled, it reclaimed AVF1 while R2 remained AVG. Enabling AVG preemption on R1 subsequently restored R1 as AVG.

Sources: [R2 becomes AVG while R3 takes AVF1](glbp-failover/GLBP-R2-show-glbp-brief-avg-failure.txt), [HOST-A ping result during AVG failure](glbp-failover/HOST-A-ping-during-avg-failure.txt), [HOST-B ping result during AVG failure](glbp-failover/HOST-B-ping-during-avg-failure.txt), [HOST-C ping result during AVG failure](glbp-failover/HOST-C-ping-during-avg-failure.txt), [R1 reclaimed AVF1 while R2 remained AVG](glbp-failover/GLBP-R2-show-glbp-brief-r1-returned-without-avg-preemption.txt), [R1 AVG and primary AVF placement after enabling AVG preemption](glbp-baseline/GLBP-R1-and-R2-show-glbp-brief-preferred-avg-restored.txt).

### 8. Weighting versus weighted load balancing

The actual threshold-crossing test used **round-robin**, configured weighting 100, lower threshold 80, upper threshold 90, and decrement 30.

After R1’s tracked upstream interface failed:

```text
State is Active
Priority 130 (configured)
Weighting 70, low (configured 100), thresholds: lower 80, upper 90
  Track object 10 state Down decrement 30
Load balancing: round-robin
```

Forwarder 1 showed:

```text
State is Listen
Active is 10.30.30.4 (secondary), weighting 100 (expires in 9.184 sec)
```

R1 remained AVG but relinquished AVF1. Recovery restored weighting 100 and local AVF1 operation.

Sources: [Weighting 70 withdraws AVF1 while R1 remains AVG](glbp-tracking/GLBP-R1-show-track-and-glbp-weighting-below-threshold.txt), [Weighting 100 and local AVF1 restored](glbp-tracking/GLBP-R1-show-track-and-glbp-weighting-restored.txt).

| Mechanism | What the evidence demonstrates |
|---|---|
| AVG priority | Gateway election preference |
| Weighting and thresholds | AVF eligibility can change after tracked failure |
| Weighted load balancing | A separately selected client-assignment mode |
| Host-dependent mode | Can coexist with weighting and tracking |

The later 60/30/40/decrement-35 configuration would calculate to weighting 25 on failure. That arithmetic is a configuration implication; the captured threshold-crossing experiment used **100 → 70**.

### 9. Authentication mismatch

After the controlled R3 key mismatch, R1 logged:

```text
*Sep  7 20:28:13.969: %GLBP-4-BADAUTH: Bad authentication received from 10.30.30.4, group 30
```

R1’s view assigned AVF3 to R2. R3’s view was:

```text
GLBP-R3#show glbp brief
Interface   Grp  Fwd Pri State    Address         Active router   Standby router
Gi0/1       30   -   100 Active   10.30.30.1      local           unknown
Gi0/1       30   1   -   Active   0007.b400.1e01  local           -
Gi0/1       30   2   -   Active   0007.b400.1e02  local           -
Gi0/1       30   3   -   Active   0007.b400.1e03  local           -
```

The authentication failure produced conflicting claims for the gateway and forwarders. Restoring the matching key returned the observed placement to R1 AVG, R2 Standby, and one primary AVF per router.

Sources: [R1 authentication rejection logs](glbp-authentication/GLBP-R1-show-logging-authentication-mismatch.txt), [R1 group view during R3 authentication isolation](glbp-authentication/GLBP-R1-show-glbp-brief-peer-authentication-mismatch.txt), [R3 claims AVG and all forwarders during authentication isolation](glbp-authentication/GLBP-R3-show-glbp-authentication-isolation.txt), [Group placement after authentication repair](glbp-authentication/GLBP-R1-show-glbp-brief-authentication-restored.txt).

### 10. Timer learning from the AVG

After R1 was restored to default timers while R2 retained local custom values, R2 showed:

```text
Hello time 3 sec (cfgd 1 sec), hold time 10 sec (cfgd 4 sec)
```

This directly distinguishes R2’s **operational 3/10 timers** from its **locally configured 1/4 timers**.

The user also reported that R2 and R3 adopted the custom timers after changing R1, before explicitly configuring the peers.

Sources: [Operational 3/10 timers with local configured 1/4 timers](glbp-timers/GLBP-R2-show-glbp-configured-versus-operational-timers.txt), [Custom 1/4 timer capture and user observation of peer learning](glbp-timers/GLBP-R1-show-glbp-custom-timers-and-peer-learning-note.txt).

### 11. Custom timer failover comparison

Both runs failed R3’s client-facing interface while HOST-C used AVF3.

| Capture | Hello / hold | Consecutive loss cluster | Total result |
|---|---|---:|---|
| Default timers | 3 / 10 sec | 6 | 10734/10741 successful |
| Custom timers | 1 / 4 sec | 3 | 8057/8060 successful |

The default run contained seven total losses: the six-loss cluster and one additional terminal loss. Its cause was not established.

The custom run retained HOST-C’s `0007.b400.1e03` mapping while R2 serviced AVF3. Recovery returned AVF3 to R3.

**Conclusion:** The custom-timer run showed a shorter loss cluster. These separate IOSv runs do not prove an exact percentage improvement or a loss-count-to-seconds conversion.

Sources: [Default-timer AVF3 failure ping result](glbp-timers/HOST-C-ping-default-timer-failover.txt), [Custom 1/4 timer capture and user observation of peer learning](glbp-timers/GLBP-R1-show-glbp-custom-timers-and-peer-learning-note.txt), [Custom-timer AVF3 takeover, ping result and unchanged gateway MAC](glbp-timers/GLBP-R1-and-HOST-C-custom-timer-failover-ping-and-arp.txt), [AVF3 returned to R3 after custom-timer test](glbp-timers/GLBP-R1-show-glbp-brief-custom-timer-test-recovery.txt).

### 12. Redirect and forwarder timers

The captures displayed:

```text
Redirect time 600 sec, forwarder timeout 14400 sec
```

Virtual-MAC takeover was demonstrated. The lab did not run either timer to expiration, so expiration behavior is not claimed as observed evidence.

## Engineering analysis

Each controlled event exercised a different mechanism: peer disappearance, upstream loss crossing a weighting threshold, authentication rejection, or a change in operational timer values.

The weighted-distribution discrepancy remains a measurement limitation rather than an established protocol defect.

## Recovery approach

Restore failed interfaces, repair authentication consistency, recover tracked upstream connectivity, and use the intended AVG preemption and timer settings.

## Recovery verification

Captures verified restored AVG/Standby placement and primary AVF ownership. The user confirmed that the lab was returned to its original state after timer testing.

The final all-router default-timer cleanup was user-confirmed; a complete post-cleanup configuration export was not supplied.

Source for cleanup confirmation: [User-reported cleanup confirmation; not a device capture](glbp-timers/lab-restoration-note.md).

## Engineering takeaway

GLBP separates gateway control from forwarding responsibility. Existing virtual MACs can move between physical routers, weighting can withdraw an AVF while its router remains AVG, and client-assignment behavior must be evaluated with appropriate evidence.

[Evidence index](README.md) · [FHRP overview](../README.md)
