# GLBP: One Gateway, Multiple Forwarders

![GLBP logical topology](../assets/glbp-topology.png)

## Problem

Demonstrate how a single virtual gateway distributes clients across three routers while retaining forwarding service during AVG, AVF, upstream, and authentication failures.

## Expected behavior

The AVG should manage virtual-gateway assignments. AVFs should forward traffic addressed to their virtual MACs, and surviving routers should take over failed forwarders.

Client assignment, AVG election, and AVF eligibility should respond to their respective settings.

## Observed symptoms

The captures demonstrated three participating AVFs, virtual-MAC takeover, independent AVG and AVF recovery, tracking-based withdrawal, authentication isolation, and operational timer learning.

The weighted sample did **not** establish the configured 60/30/10 proportions.

## Hypotheses

- ARP mappings should explain each host’s selected forwarder.
- A surviving router should be able to service an existing virtual MAC.
- Losing forwarding eligibility should not necessarily remove the AVG role.
- Authentication rejection should explain conflicting group views.
- Shorter hold timers should reduce the observed peer-failure interruption.

## Troubleshooting methodology

1. Verify each router’s independent upstream path.
2. Establish the AVG, Standby, and AVF baseline.
3. Compare router state with client ARP entries.
4. Test each load-balancing mode.
5. Introduce one controlled failure and inspect the actual takeover.
6. Restore the device or configuration and verify ownership.
7. Compare timer runs using captured packet counts and loss patterns.

## Evidence

### 1. Underlay and configuration showcase

Each GLBP router learned `10.255.255.1/32` through OSPF process 30 and completed a 5/5 source-addressed ping.

| Router | Observed upstream next hop |
|---|---|
| R1 | 10.255.10.1 |
| R2 | 10.255.10.5 |
| R3 | 10.255.10.9 |

Source: [21768922](../evidence/21768922.txt).

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

Sources: [f36ba59b](../evidence/f36ba59b.txt), [50fd2f3e](../evidence/50fd2f3e.txt), [b7cf0bd5](../evidence/b7cf0bd5.txt).

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

Source: [e8cb3d11](../evidence/e8cb3d11.txt).

### 3. Round-robin client assignments

The three hosts initially lacked a gateway ARP entry. After generating upstream traffic, their captured mappings were:

| Host | Gateway | Observed virtual MAC |
|---|---|---|
| HOST-A | 10.30.30.1 | 0007.b400.1e01 |
| HOST-B | 10.30.30.1 | 0007.b400.1e02 |
| HOST-C | 10.30.30.1 | 0007.b400.1e03 |

All three completed 5/5 upstream probes.

This demonstrates different virtual-MAC assignments under the captured round-robin baseline. It does not measure equal bandwidth utilization.

Sources: [d69cac8d](../evidence/d69cac8d.txt), [0af39afc](../evidence/0af39afc.txt), [49c1acb0](../evidence/49c1acb0.txt), [567d4a5d](../evidence/567d4a5d.txt).

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

Sources: [11b47db2](../evidence/11b47db2.txt), [ad5ad4ad](../evidence/ad5ad4ad.txt), [b0085c26](../evidence/b0085c26.txt), [9321370a](../evidence/9321370a.txt), [d0c5cec0](../evidence/d0c5cec0.txt), [256bd6a5](../evidence/256bd6a5.txt), [51a74ea7](../evidence/51a74ea7.txt), [de14b5d5](../evidence/de14b5d5.txt), [8da4502b](../evidence/8da4502b.txt), [0a7261c4](../evidence/0a7261c4.txt), [283f75e2](../evidence/283f75e2.txt), [3a01da72](../evidence/3a01da72.txt).

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

Sources: [7986bb62](../evidence/7986bb62.txt), [f41bbd01](../evidence/f41bbd01.txt), [cbc8da41](../evidence/cbc8da41.txt), [34c9048e](../evidence/34c9048e.txt), [82df3c24](../evidence/82df3c24.txt), [7d8761f0](../evidence/7d8761f0.txt).

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

Sources: [49665b3a](../evidence/49665b3a.txt), [6ca39b1b](../evidence/6ca39b1b.txt), [12b0af4b](../evidence/12b0af4b.txt), [00744ef0](../evidence/00744ef0.txt).

A separate host-dependent test shut R2’s Gi0/1. R3 then serviced AVF2 while HOST-A retained `0007.b400.1e02`. R2 subsequently reclaimed AVF2.

Sources: [94fc3316](../evidence/94fc3316.txt), [463f2171](../evidence/463f2171.txt), [9a13521e](../evidence/9a13521e.txt), [096d6236](../evidence/096d6236.txt).

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

Sources: [317897af](../evidence/317897af.txt), [cfe54089](../evidence/cfe54089.txt), [70fab72b](../evidence/70fab72b.txt), [96d23dcf](../evidence/96d23dcf.txt), [0479cc7d](../evidence/0479cc7d.txt), [e8cb3d11](../evidence/e8cb3d11.txt).

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

Sources: [4650971c](../evidence/4650971c.txt), [9456b8d5](../evidence/9456b8d5.txt).

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

Sources: [00ab9f2a](../evidence/00ab9f2a.txt), [e9a3c2a2](../evidence/e9a3c2a2.txt), [b7cf0bd5](../evidence/b7cf0bd5.txt), [23e5cf41](../evidence/23e5cf41.txt).

### 10. Timer learning from the AVG

After R1 was restored to default timers while R2 retained local custom values, R2 showed:

```text
Hello time 3 sec (cfgd 1 sec), hold time 10 sec (cfgd 4 sec)
```

This directly distinguishes R2’s **operational 3/10 timers** from its **locally configured 1/4 timers**.

The user also reported that R2 and R3 adopted the custom timers after changing R1, before explicitly configuring the peers.

Sources: [50fd2f3e](../evidence/50fd2f3e.txt), [f36ba59b](../evidence/f36ba59b.txt).

### 11. Custom timer failover comparison

Both runs failed R3’s client-facing interface while HOST-C used AVF3.

| Capture | Hello / hold | Consecutive loss cluster | Total result |
|---|---|---:|---|
| Default timers | 3 / 10 sec | 6 | 10734/10741 successful |
| Custom timers | 1 / 4 sec | 3 | 8057/8060 successful |

The default run contained seven total losses: the six-loss cluster and one additional terminal loss. Its cause was not established.

The custom run retained HOST-C’s `0007.b400.1e03` mapping while R2 serviced AVF3. Recovery returned AVF3 to R3.

**Conclusion:** The custom-timer run showed a shorter loss cluster. These separate IOSv runs do not prove an exact percentage improvement or a loss-count-to-seconds conversion.

Sources: [eaa06ac6](../evidence/eaa06ac6.txt), [f36ba59b](../evidence/f36ba59b.txt), [cf273278](../evidence/cf273278.txt), [4c201d10](../evidence/4c201d10.txt).

### 12. Redirect and forwarder timers

The captures displayed:

```text
Redirect time 600 sec, forwarder timeout 14400 sec
```

Virtual-MAC takeover was demonstrated. The lab did not run either timer to expiration, so expiration behavior is not claimed as observed evidence.

## Root cause

Each controlled event exercised a different mechanism: peer disappearance, upstream loss crossing a weighting threshold, authentication rejection, or a change in operational timer values.

The weighted-distribution discrepancy remains a measurement limitation rather than an established protocol defect.

## Resolution

Restore failed interfaces, repair authentication consistency, recover tracked upstream connectivity, and use the intended AVG preemption and timer settings.

## Verification

Captures verified restored AVG/Standby placement and primary AVF ownership. The user confirmed that the lab was returned to its original state after timer testing.

The final all-router default-timer cleanup was user-confirmed; a complete post-cleanup configuration export was not supplied.

Source for cleanup confirmation: [e1c57946](../evidence/e1c57946.txt).

## Lessons / ENCOR concept

GLBP separates gateway control from forwarding responsibility. Existing virtual MACs can move between physical routers, weighting can withdraw an AVF while its router remains AVG, and client-assignment behavior must be evaluated with appropriate evidence.

[Evidence index](../evidence/README.md) · [FHRP overview](../README.md)
