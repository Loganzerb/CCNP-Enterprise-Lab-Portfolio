# Case 09 — Understanding Recovery Without Inventing a Stopwatch Result

## Why this matters

After a path fails, the useful question is how the topology returns to a usable state and what the client experiences during that change. A list of protocol timers alone cannot answer it.

## Documented exercise

The original notes describe comparing classic 802.1D state progression with Rapid PVST+ after a forwarding-path failure. Classic behavior was discussed through Listening and Learning stages; rapid behavior through port roles and coordinated transitions.

## What was captured

The [SW3 VLAN 10 output](../verification/root-election/SW3-show-spanning-tree-vlan-10.txt) includes:

```text
Hello Time 2 sec  Max Age 20 sec  Forward Delay 15 sec
```

That same file identifies its protocol as `rstp`. The [SW3 summary](../verification/convergence/SW3-show-spanning-tree-summary.txt) reports `rapid-pvst`, with no ports currently counted as Listening or Learning.

These observations show reported timers and a later operating state. They do not independently capture a classic-STP transition or demonstrate a measured improvement between modes.

## How to assess the behavior

| Question | Evidence needed |
|---|---|
| Which mode is being tested? | Operational mode and relevant saved settings |
| Which port/path failed? | A recorded change and affected interface |
| What state transitions occurred? | Ordered interface/STP output or logs |
| When did client service return? | A time-correlated endpoint test |

The last three pieces are not retained as a complete timing experiment here. Zero transition-state counts at the end do not reveal how long those states lasted earlier.

## Recovery and verification

The exercise account describes returning the topology to its intended operation. The final saved configurations use Rapid PVST+ and long costs. A future replay should record timestamps and endpoint behavior for each test mode while keeping the failure and topology comparable.

No exact outage duration, loss count, or percentage speed improvement is assigned to this exercise.

## Engineering takeaway

Use timer values to explain protocol behavior and actual observations to report service recovery. Keeping those two kinds of evidence separate makes performance claims reviewable.

[Case index](README.md) · [Convergence guide](../verification/convergence/README.md) · [Module overview](../README.md)
