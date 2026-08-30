# STP Troubleshooting Cases

These cases record failures injected into the CML topology. Each diagnosis started with the observed state and IOS evidence; the corrective action removed the trigger instead of disabling the protection feature.

## Case 1 — Unexpected switch on a protected edge port

**Failure injected:** A BPDU-speaking switch was connected to a PortFast edge port protected by BPDU Guard.

**Observed:**

```text
%SPANTREE-2-BLOCK_BPDUGUARD: Received BPDU on port ... with BPDU Guard enabled. Disabling port.
%PM-4-ERR_DISABLE: bpduguard error detected ... putting ... in err-disable state
```

```cisco
show interfaces status err-disabled
show errdisable recovery
show logging | include BPDUGUARD|ERR_DISABLE
```

**Diagnosis:** This was a physical interface shutdown caused by any received BPDU on an edge port—not a per-VLAN `root-inconsistent` condition.

**Recovery:** The switch attachment was removed, the intended host-facing configuration was verified, and the interface was shut/no-shut. The edge port returned to forwarding without weakening BPDU Guard.

## Case 2 — Rogue superior root blocked by Root Guard

**Failure injected:** The downstream/rogue switch advertised a superior Bridge ID toward a Root Guard-protected interface.

**Observed:**

```text
%SPANTREE-2-ROOTGUARD_BLOCK: Root guard blocking port ... on VLAN0010.
```

```text
VLAN0010   Gi0/1   Root Inconsistent
```

```cisco
show spanning-tree inconsistentports
show spanning-tree vlan 10
show logging | include ROOTGUARD
```

**Diagnosis:** The link remained up and normal BPDUs were permitted, but VLAN 10 was blocked because the protected direction attempted to become the root path.

**Recovery:** The superior priority was removed from the rogue/downstream switch. Root Guard cleared automatically when superior BPDUs stopped, and the intended root remained in place.

## Case 3 — Missing expected BPDUs with Loop Guard

**Failure injected:** BPDU reception was suppressed on a redundant non-edge path while the physical interface stayed up.

**Observed:**

```text
%SPANTREE-2-LOOPGUARD_BLOCK: Loop guard blocking port ... on VLAN0010.
```

```text
VLAN0010   Gi0/2   Loop Inconsistent
```

**Diagnosis:** An alternate/root-capable port stopped receiving the BPDUs it was expected to hear. Without Loop Guard, loss of information could eventually make the port forward and create a loop.

**Recovery:** BPDU exchange was restored. The instance automatically left `loop-inconsistent`; no interface reset was needed.

## Case 4 — Native VLAN/PVID mismatch

**Failure injected:** The native VLAN on one end of the `SW2-ACCESS-A`–`SW3-ACCESS-B` trunk was changed without matching the other end.

**Observed:**

```text
%SPANTREE-2-RECV_PVID_ERR: Received BPDU with inconsistent peer vlan id ...
%SPANTREE-2-BLOCK_PVID_LOCAL: Blocking ... on ... Inconsistent local vlan.
%SPANTREE-2-BLOCK_PVID_PEER: Blocking ... on ... Inconsistent peer vlan.
```

```cisco
show interfaces trunk
show spanning-tree inconsistentports
show logging | include PVID|SPANTREE
```

**Diagnosis:** The two switches disagreed about which untagged/native VLAN the control traffic represented. This was a trunk consistency problem, not a path-cost problem.

**Recovery:** Both ends were restored to the same native VLAN and allowed-VLAN policy. IOS automatically cleared the PVID inconsistency after compatible BPDUs resumed.

## Case 5 — Port Type Inconsistency / Bridge Assurance

**Failure injected:** A link configured as an RSTP network port encountered an incompatible peer/port type or stopped receiving the expected BPDUs.

**Observed:**

```text
%SPANTREE-2-BRIDGE_ASSURANCE_BLOCK: Blocking port ... Network port type inconsistent
```

The spanning-tree output exposed an inconsistent/dispute condition instead of allowing the link to forward silently.

```cisco
show spanning-tree inconsistentports
show spanning-tree vlan 10 detail
show running-config interface GigabitEthernet0/1
```

**Diagnosis:** `spanning-tree portfast network` is a switch-to-switch contract. It must not be confused with `portfast edge`, and it requires a compatible RSTP/MST peer that continuously exchanges BPDUs.

**Recovery:** The peer link type and spanning-tree mode were made consistent on both ends. Normal BPDU exchange cleared the protected state.

## Case 6 — Interface-level BPDU Filter removed STP visibility

**Failure injected:** BPDU Filter was applied directly to a switch-facing interface.

```cisco
interface GigabitEthernet0/2
 spanning-tree bpdufilter enable
```

**Observed:** The interface could remain operational while normal BPDU counters stopped changing. Neighboring STP information aged away, creating the risk that a redundant link would forward without loop protection.

**Diagnosis:** BPDU Filter does not mean “drop bad BPDUs.” It suppresses the control-plane exchange STP needs. Interface-level filtering also does not have the safer global PortFast-filter fallback behavior.

**Recovery:** `spanning-tree bpdufilter enable` was removed from the inter-switch link, BPDU counters resumed, and the stable role set was verified before proceeding.

## Case 7 — Stale `Peer is STP` after PVST+ to Rapid PVST+ migration

**Failure injected:** The topology was transitioned between PVST+ and Rapid PVST+.

**Observed:** Both switches reported Rapid PVST+ globally, but one interface detail still showed:

```text
Link type is point-to-point by default, Peer is STP
```

**Diagnosis:** Per-port protocol-migration state retained evidence of a legacy BPDU received during the staggered mode change. Global mode alone did not prove native RSTP operation on every link.

**Recovery:**

```cisco
clear spanning-tree detected-protocols
```

The interface reevaluated its neighbor and returned to native rapid operation.

## Case 8 — Path changed after cost-method conversion

**Failure injected:** The topology was compared under short and long path-cost methods while explicit costs were being tested.

**Observed:** A Gigabit interface displayed cost `4` with the short method and `20000` with the long method. An explicit cost that made sense in one scale could dominate unexpectedly in the other.

```cisco
show spanning-tree summary
show spanning-tree vlan 10
show running-config interface GigabitEthernet0/0
```

**Diagnosis:** STP compares the numeric total, not the engineer’s intent. Cost-method changes and manual per-VLAN overrides must be audited together.

**Recovery:** Explicit test costs were removed or recalculated, all switches were standardized on the long method, and root/alternate roles were reverified per VLAN.

## Case 9 — EtherChannel member mismatch

**Failure injected:** Parallel links were configured with incompatible channel parameters on the two ends or among member interfaces.

**Observed:**

```cisco
show etherchannel summary
show interfaces etherchannel
show spanning-tree vlan 10
show logging | include EC|SPANTREE
```

Member flags failed to show a consistently bundled channel, and EtherChannel misconfiguration protection prevented an unsafe partial bundle. STP did not see the intended single logical path until the bundle was valid.

**Diagnosis:** Trunk mode, allowed VLANs, negotiation protocol/mode, and member characteristics must agree. Configuring STP independently on physical members is not a substitute for a healthy Port-channel.

**Recovery:** The mismatched member configuration was removed and rebuilt consistently. `show etherchannel summary` confirmed bundled members, and `show spanning-tree` then displayed the Port-channel as the logical STP interface.

## Diagnostic decision table

| Evidence | Trigger | Recovery behavior |
|---|---|---|
| `err-disabled`, BPDU Guard log | Any BPDU on protected edge port | Remove cause; reset/recover interface |
| `root-inconsistent` | Superior BPDU on Root Guard port | Automatic after superior BPDU stops |
| `loop-inconsistent` | Expected BPDUs disappear | Automatic after valid BPDUs return |
| PVID inconsistent | Native/PVID mismatch | Automatic after trunk agreement |
| Port type / Bridge Assurance inconsistent | Incompatible network-port peer or missing BPDUs | Automatic after compatible exchange |
| `Peer is STP` | Legacy peer or migration state | Fix peer mode or clear detected protocols |
| Unbundled/suspended EtherChannel member | Channel parameter mismatch | Correct bundle parameters and verify |

The repeated workflow was: inspect role and state, correlate the log, verify the adjacent configuration, remove the actual fault, and confirm the intended root and forwarding topology after recovery.
