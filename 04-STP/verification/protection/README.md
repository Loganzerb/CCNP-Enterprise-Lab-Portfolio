# Protection Features — What Was Configured and What Was Captured

The lab uses protection mechanisms to respond to unsafe switching conditions. Their names are similar, but they react to different signals.

| Feature | Purpose in the documented exercise | Evidence retained here |
|---|---|---|
| BPDU Guard | Respond when a supposed endpoint connection receives switch control messages | [SW2/SW3 edge policy](../../configs/README.md); [exercise account](../../troubleshooting/01-bpdu-guard-rogue-switch.md) |
| Root Guard | Prevent an attached switch from taking over the intended root direction | [Exercise account](../../troubleshooting/02-root-guard-root-inconsistent.md); no dedicated failure/recovery capture |
| Loop Guard | Keep a port from becoming unsafe when expected control messages disappear | [Exercise account](../../troubleshooting/03-loop-guard-bpdu-suppression.md); no dedicated failure/recovery capture |
| EtherChannel misconfiguration guard | Respond to an inconsistent logical-bundle relationship | [Enabled status on SW3](../convergence/SW3-show-spanning-tree-summary.txt); [exercise account](../../troubleshooting/07-etherchannel-misconfig-guard.md) |

This folder contains an explanation, not an additional raw protection transcript. The final Root Guard and Loop Guard interface policies are not retained in the saved configurations.

A global default is also different from a per-interface setting: SW3's summary reports default edge BPDU Guard disabled, while its Gi0/3 configuration explicitly enables it. Read the interface policy before deciding whether a specific port is protected.

During a replay, capture the relevant logs, affected port/VLAN state, configuration, and post-repair behavior. Those would establish activation and recovery beyond the settings and accounts retained here.

[Verification index](../README.md) · [Case index](../../troubleshooting/README.md)
