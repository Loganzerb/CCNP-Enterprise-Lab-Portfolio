# Case 01 — A VLAN-Mask Mismatch Suspends One LACP Member

## Problem and impact

Po20 between SW1 and SW3 lost one usable member after the allowed VLAN list was changed on SW3 Gi0/0. IOS suspended that interface while keeping Gi0/1 bundled and the logical port-channel in use.

The demonstrated impact is **degraded bundle membership**. This experiment's retained files do not include a client ping run, so they do not establish either a complete service outage or uninterrupted service.

## Expected behavior

The [final SW3 configuration](../configs/EC-SW3-ACCESS-A-running-config.txt) assigns Gi0/0 and Gi0/1 to LACP group 20 in passive mode. Both members and Port-channel20 carry VLANs `1,10,20,30,99`, with native VLAN 99. SW1's corresponding members run LACP active.

The intended healthy summary is Po20(SU) with both Gi0/0(P) and Gi0/1(P). This state is retained in the recovery output; the final export is a reference for the intended configuration, not a timestamped pre-fault capture.

## Evidence chain

| Stage | Artifact | Decisive observation |
|---|---|---|
| Change and reaction | [Configuration change, syslog, and summary](vlan-mask-mismatch-syslog-summary.txt) | Gi0/0's list becomes 1,10,20,30; IOS reports incompatibility with Gi0/1 and suspends Gi0/0 |
| Failure inspection | [Gi0/0 switchport detail](vlan-mask-mismatch-switchport.txt) | Operational mode is down/suspended; enabled trunk VLANs omit 99 |
| Repaired setting | [Recovered switchport excerpt](vlan-mask-mismatch-recovery-switchport.txt) | Operational trunk membership returns, with VLAN 99 included |
| Repaired membership | [Recovery summary](vlan-mask-mismatch-recovery-summary.txt) | Po20(SU), Gi0/0(P), Gi0/1(P) |

## What changed

The captured change was on **SW3 Gi0/0 only**:

```cisco
interface GigabitEthernet0/0
 switchport trunk allowed vlan 1,10,20,30
```

The list replaced the prior allowed set and omitted VLAN 99. The failure capture still shows native VLAN 99. The missing allowed VLAN and the configured native VLAN are different fields; this case does not show the two trunk ends configured with different native VLAN IDs.

## How the evidence isolates the fault

The retained log gives a specific reason, rather than a generic link-down message:

```text
%EC-5-CANNOT_BUNDLE2: Gi0/0 is not compatible with Gi0/1 and will be suspended (vlan mask is different)
```

The accompanying summary is:

```text
20     Po20(SU)        LACP      Gi0/0(s)    Gi0/1(P)
```

The selected excerpts normalize chat escaping only. Full source text remains linked above.

| Possible explanation | What the retained evidence establishes |
|---|---|
| Entire port-channel failed | Po20 remains SU and Gi0/1 remains P; the observed fault affects one member |
| Physical cable failure | IOS explicitly attributes suspension to a VLAN-mask incompatibility following the captured setting change |
| LACP passive/passive mismatch | The recorded change affects the VLAN list, and the peer member remains bundled; the log identifies the local member inconsistency |
| Normal spanning-tree blocking | The affected physical member is suspended by EtherChannel, rather than simply showing an STP alternate/blocked role |
| Native VLAN IDs differ across peers | This is not established. The retained member detail still reports native VLAN 99; its allowed list is the changed field |

This is an evidence-based reconstruction of the diagnosis, not a claim that a transcript of every alternative check survived.

## Root cause

SW3 Gi0/0 no longer had the same allowed VLAN mask as its peer member. IOS refused to bundle that inconsistent interface. A configured LACP relationship did not override the member consistency check.

The decisive combination is the captured change, the explicit VLAN-mask error, the suspended member state, and the changed enabled-VLAN list.

## Repair

Restore the intended list on the affected member. The following is a **repair reference**, not a retained transcript of the repair command:

```cisco
configure terminal
interface GigabitEthernet0/0
 switchport trunk allowed vlan 1,10,20,30,99
end
```

The original lab documentation reports restoration of the list; the post-repair switchport and membership captures substantiate the resulting state. Rebuilding the whole port-channel is not needed to explain this recovery.

## Verification and closure

| Check | Failure | Recovery |
|---|---|---|
| Gi0/0 operational mode | down (suspended member of bundle Po20) | trunk (member of bundle Po20) |
| Gi0/0 enabled trunk VLANs | 1,10,20,30 | 1,10,20,30,99 |
| Gi0/0 membership | s | P |
| Gi0/1 membership | P | P |
| Logical port-channel | SU | SU |

These observations establish repaired member compatibility and restored two-member operation. They do not measure recovered bandwidth. The separate [final 10/10 ping](../verification/PC-A-final-ping.txt) is a module-level steady-state check, not a dedicated before/after service test for this fault.

A replay should capture the member state, relevant VLAN forwarding, and client probes while the intended test path is in use. No such additional measurements or save confirmation are invented here.

## Engineering takeaway

When a bundle remains up, inspect every intended member. An operational logical interface can conceal reduced membership. The explicit incompatibility message and member-level switchport view identify the configuration boundary that needs repair.

[Case index](README.md) · [Final verification](../verification/README.md) · [Module overview](../README.md)
