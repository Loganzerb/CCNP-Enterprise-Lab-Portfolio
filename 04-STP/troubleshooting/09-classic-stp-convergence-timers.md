# Case 09 — Classic STP convergence and timer observations

## Experiment

The lab compared classic 802.1D state progression with Rapid PVST+ behavior after a forwarding-path failure.

## Observed behavior

Classic STP depended on timer-driven transitions through Listening and Learning before Forwarding. The bridge output retained the standard timer values:

```text
Hello Time 2 sec
Max Age 20 sec
Forward Delay 15 sec
```

Rapid PVST+ used explicit port roles and proposal/agreement on point-to-point links, allowing an eligible alternate path to converge without replaying the full classic timer sequence.

## Diagnosis and verification

```text
show spanning-tree vlan <id>
show spanning-tree detail
show spanning-tree interface <interface> detail
show logging
```

## Lesson

Timers describe classic behavior but do not by themselves explain Rapid STP convergence. Link type, edge status, current role, and synchronization/proposal-agreement eligibility matter.
