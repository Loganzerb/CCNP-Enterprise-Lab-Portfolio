# Recovery Behavior — Settings Are Different from Timing Results

**Main finding:** the retained summary confirms Rapid PVST+ and the state of SW3's VLANs. It does not measure how quickly traffic recovers.

In [SW3's summary](SW3-show-spanning-tree-summary.txt):

| Observation | Meaning |
|---|---|
| Switch is in rapid-pvst mode | The captured operational mode is Rapid PVST+ |
| Root bridge for: none | SW3 is not the elected root for the listed VLANs |
| One blocking port per VLAN | Each listed VLAN retains a blocked path in this snapshot |
| Zero Listening and Learning counts | No listed port is in those transition states at capture time |
| Configured path-cost method is long | The summary identifies the numerical cost scale |
| Bridge Assurance and EtherChannel misconfig guard enabled | These feature/status fields are enabled; they do not demonstrate that a fault occurred |

The separate [VLAN 10 capture](../root-election/SW3-show-spanning-tree-vlan-10.txt) displays Hello 2, Max Age 20, and Forward Delay 15 seconds. These are timer fields, not a measured outage of that duration.

The original lab notes describe comparing classic STP and Rapid PVST+ recovery. No timestamped transition sequence or endpoint ping run is retained for that comparison. [Case 09](../../troubleshooting/09-classic-stp-convergence-timers.md) explains the exercise and what a future replay would need to capture.

[Verification index](../README.md) · [Module overview](../../README.md)
