# Auto-RP forwarding — from shared tree to native source path

Selected command/output excerpts supplied in the completed September 23 lab handoff. They retain the supplied fields and ordering within each checkpoint; prompts, omitted timers and full tables have not been invented. Neighbor pairs in Block 04 are supplied field summaries.

The earlier [Auto-RP-only ping](05-autorp-migration.md#block-11) captures 19 replies from 20 probes. The post-repair excerpts below establish the recovered tree and final forwarding state; a new complete post-repair ping transcript was not supplied.

## Block 01

**Receiver tree before source traffic.** R4 — show ip mroute 239.1.1.1. Selected lines show (*,G) via Gi0/1 toward the dynamically learned RP and the receiver branch on Gi0/0.

```text
(*, 239.1.1.1), RP 2.2.2.2, flags: SJC
Incoming interface: GigabitEthernet0/1, RPF nbr 10.24.0.1
GigabitEthernet0/0, Forward/Sparse
```

## Block 02

**Initial source-specific state.** R4 — selected entry and flag from the startup snapshot. J is present before the subsequent JT capture. Other fields were not supplied for this particular snapshot.

```text
(10.1.1.10, 239.1.1.1)
flags: J
```

## Block 03

**SPT bit set on R4.** R4 — selected lines from the later source entry. JT includes the SPT bit; Gi0/2 points toward R3 and Gi0/0 toward the receiver. The shared-tree entry remains alongside it.

```text
(10.1.1.10, 239.1.1.1)
flags: JT
Incoming interface: GigabitEthernet0/2, RPF nbr 10.34.0.1
GigabitEthernet0/0, Forward/Sparse
```

## Block 04

**Neighbor-to-interface correlation.** R4 — selected neighbor/interface pairs supplied from show ip pim neighbor, rather than a reconstructed full table. They identify the RP-facing and source-facing directions.

```text
10.24.0.1 via GigabitEthernet0/1
10.34.0.1 via GigabitEthernet0/2
```

## Block 05

**The group is absent from the unicast RIB.** R4 — supplied command and response. The absence of this group from the unicast table is not evidence that its multicast tree is absent; use show ip mroute for group state.

```text
show ip route 239.1.1.1
% Network not in table
```

## Block 06

**Shared state retained while one source is pruned.** R2 — selected shared-tree and source-tree lines. Null IIF is normal for the RP's shared-tree root. PT and Null OIL describe the individual source branch, not loss of all group membership.

```text
(*, 239.1.1.1), RP 2.2.2.2
Incoming interface: Null, RPF nbr 0.0.0.0
GigabitEthernet0/1, Forward/Sparse

(10.1.1.10, 239.1.1.1), flags: PT
Incoming interface: GigabitEthernet0/0, RPF nbr 10.12.0.1
Outgoing interface list: Null
```

## Block 07

**Registration state at source startup.** R1 — selected startup fields and outgoing interfaces supplied in the handoff. Registering is observed CLI state. The physical Gi0/1 entry does not by itself capture or identify an encapsulated PIM Register packet.

```text
(10.1.1.10, 239.1.1.1)
Incoming interface: GigabitEthernet0/0
RPF nbr 0.0.0.0
flags: FT
Registering
GigabitEthernet0/2
GigabitEthernet0/1
```

## Block 08

**Final native source-tree branch.** R1 — selected final lines. Gi0/1 and Registering are no longer in the reported source entry; Gi0/2 remains. FT is retained exactly as supplied. This is consistent with registration suppression and native forwarding, not direct capture of a Register-Stop message.

```text
(10.1.1.10, 239.1.1.1), flags: FT
Incoming interface: GigabitEthernet0/0, RPF nbr 0.0.0.0
GigabitEthernet0/2, Forward/Sparse
```

[Back to Auto-RP](../auto-rp.md) · [Back to verification](README.md)

