# STP Protection Features

## Objective

Apply each protection mechanism only where its failure assumption is valid, then distinguish its expected failure state from ordinary STP blocking.

## Feature placement matrix

| Feature | Protects against | Correct placement | Failure result |
|---|---|---|---|
| PortFast | Edge-host startup delay | End-station ports only | Immediate forwarding; not itself a security control |
| BPDU Guard | A switch appearing on an edge port | PortFast/edge ports | Err-disables the port after a BPDU |
| Root Guard | An unexpected downstream superior root | Designated ports where the root must never appear | Root-inconsistent; auto-recovers |
| Loop Guard | Loss of expected BPDUs on a non-designated path | Redundant switch-to-switch links | Loop-inconsistent; auto-recovers |
| UDLD | Unidirectional physical links | Fiber and other supported switch links | Aggressive mode can err-disable |
| BPDU Filter | Intentional BPDU suppression | Rare, tightly controlled edge cases | Can remove STP protection and create a loop |

## PortFast and BPDU Guard

```cisco
spanning-tree portfast default
spanning-tree portfast bpduguard default

interface range gigabitEthernet1/0/10-24
 switchport mode access
 spanning-tree portfast
 spanning-tree bpduguard enable
```

```cisco
show spanning-tree interface gigabitEthernet1/0/10 detail
show interfaces status err-disabled
show errdisable recovery
```

```text
Port 10 (GigabitEthernet1/0/10) of VLAN0010 is designated forwarding
  The port is in the portfast mode
%SPANTREE-2-BLOCK_BPDUGUARD: Received BPDU on port Gi1/0/10
%PM-4-ERR_DISABLE: bpduguard error detected on Gi1/0/10
```

PortFast does not stop BPDUs. BPDU Guard provides the fail-closed behavior when an unexpected bridge appears.

## Root Guard

```cisco
interface gigabitEthernet1/0/5
 description Downstream switch - must not become root
 spanning-tree guard root
```

```cisco
show spanning-tree inconsistentports
```

```text
Name                 Interface              Inconsistency
VLAN0010             GigabitEthernet1/0/5   Root Inconsistent
```

Root Guard blocks the VLAN on receipt of superior BPDUs and recovers when they stop. It belongs on a port expected to remain designated, not on a Root Port.

## Loop Guard

```cisco
spanning-tree loopguard default

interface port-channel20
 spanning-tree guard loop
```

Loop Guard prevents a non-designated port from moving to forwarding merely because BPDUs disappeared. It addresses a control-plane symptom; UDLD addresses unidirectional link detection at Layer 2.

```text
Po20 Altn BLK -> BPDU loss -> Loop_Inc BLK
```

Root Guard and Loop Guard are mutually exclusive on the same interface because they protect different expected roles.

## UDLD

```cisco
udld aggressive

interface range tenGigabitEthernet1/1/1-2
 udld port aggressive
```

```cisco
show udld neighbors
show udld interface tenGigabitEthernet1/1/1
```

```text
Port              Neighbor State
Te1/1/1           Bidirectional
```

In aggressive mode, echo failure after neighbor establishment can place the port in an err-disabled condition. STP protection should remain in place; UDLD is complementary, not a replacement.

## BPDU Filter

```cisco
spanning-tree portfast bpdufilter default

! Interface-level filtering is stronger and riskier:
interface gigabitEthernet1/0/24
 spanning-tree bpdufilter enable
```

The global PortFast form stops filtering if a BPDU is received and the port loses edge status. The interface command suppresses BPDU transmission and reception continuously. That can make a cabled loop invisible to STP, so the lab records it as an exception feature rather than a routine hardening control.

## Bridge Assurance preview

Bridge Assurance protects bidirectional network links by requiring BPDUs in both directions. It is covered with link-type requirements and failure evidence in [EtherChannel and Bridge Assurance](04-STP-EtherChannel-Bridge-Assurance.md).

## Skills demonstrated

- Mapped safeguards to topology roles instead of applying them indiscriminately.
- Distinguished err-disabled, root-inconsistent, and loop-inconsistent outcomes.
- Explained global versus interface BPDU Filter behavior and its operational risk.
- Combined STP and physical-link protections without treating them as interchangeable.

