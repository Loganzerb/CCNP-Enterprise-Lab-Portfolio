# Baseline: successful probe and primary route

Operation 10 probes `10.40.40.40` from R1's Loopback0 address, `10.100.1.1`. The baseline excerpts show a successful operation, an Up tracking object, and the preferred default route through ISP-A.

**Quick navigation:** [Probe result](#probe-result) · [Tracking state](#tracking-state) · [Primary default](#primary-default) · [Interpretation](#what-the-baseline-establishes)

## Probe result

### Block 01

**Supplied transcribed CLI excerpt — original CML session.** The latest probe started at 22:29:30 UTC on October 12, 2026 and returned OK, with RTT 3 ms and cumulative counts of 4 successes / 0 failures.

```text
R1-BRANCH#show ip sla statistics 10
IPSLAs Latest Operation Statistics

IPSLA operation id: 10
        Latest RTT: 3 milliseconds
Latest operation start time: 22:29:30 UTC Mon Oct 12 2026
Latest operation return code: OK
Number of successes: 4
Number of failures: 0
Operation time to live: Forever
```

## Tracking state

### Block 02

**Supplied transcribed CLI excerpt.** Track 10 uses IP SLA 10 reachability and reports Up. Its relative last-change field belongs to this snapshot.

```text
R1-BRANCH#show track 10
Track 10
  IP SLA 10 reachability
  Reachability is Up
    1 change, last change 00:00:07
  Latest operation return code: OK
  Latest RTT (millisecs) 3
```

## Primary default

### Block 03

**Supplied transcribed CLI excerpt.** The installed default uses primary next hop `10.12.12.2` with administrative distance 1.

```text
R1-BRANCH#show ip route 0.0.0.0
Routing entry for 0.0.0.0/0, supernet
  Known via "static", distance 1, metric 0, candidate default path
  Routing Descriptor Blocks:
  * 10.12.12.2
      Route metric is 0, traffic share count is 1
```

## What the baseline establishes

The successful probe and Up state agree with the installed primary default. The separate host route pins the probe target to ISP-A, while application target `10.40.40.41` follows the active default. Read the [configuration guide](../configs/README.md) for those saved route settings.

This baseline does not include an application-target ping transcript. The [backup forwarding test](failover.md#backup-forwarding) supplies the retained application ping and path evidence.

[Failover evidence](failover.md) · [Verification index](README.md) · [Overview](../README.md) · [Configurations](../configs/README.md) · [Evidence scope](../scope.md)
