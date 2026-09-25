# BSR configuration — checkpoints, completion and experiments

These commands reconstruct the changes supported by the Part 5 lab. Device names stay outside copyable command blocks. Captured outputs are in the [verification pages](../verification/README.md); these instructions are not execution transcripts.

## Saved checkpoint

[PIM-SM_BSR_September_24th.yaml](PIM-SM_BSR_September_24th.yaml) is the supplied seven-node CML export, preserved unchanged. It uses the `iosv-159-3-m3` image definition and includes the R3–R5 link, loopback reachability and both Candidate BSR commands at priority 20.

**This is an intermediate checkpoint.** R3 Gi0/0 and Gi0/1 lack `ip pim sparse-mode`, and R2 does not yet have `ip pim rp-candidate Loopback0`. The export therefore preserves the conditions behind the later investigation. Importing it alone does not reproduce the completed BSR state.

The original six `.cfg` files in this directory still describe the static-RP baseline. Use the export for the seven-node topology, then apply the completion steps below. Neither the export nor these completion steps were rerun in CML during portfolio preparation.

## Complete the saved checkpoint

On **R3-TRANSIT**, restore PIM to both original transit links. The R5-facing Gi0/2 and Loopback0 are already PIM-enabled in the export.

```text
configure terminal
interface GigabitEthernet0/0
 ip pim sparse-mode
interface GigabitEthernet0/1
 ip pim sparse-mode
end
```

First verify that R2 learns the elected BSR. Then configure **R2-RP** as the Candidate RP:

```text
configure terminal
ip pim rp-candidate Loopback0
end
```

R2's captured RP priority is 0. With no group-list restriction, the retained mapping covers `224.0.0.0/4`. The completion commands are reconstructed from the operator's repair report and subsequent verified state; the exact repair keystrokes were not pasted.

## Transition from the earlier Auto-RP phase

If starting from an earlier running lab rather than the supplied BSR export, inspect the current settings first. The lab found static RP settings present again on R1–R3, despite earlier Auto-RP-only checks. Why they reappeared was not established.

On **R1–R4**:

```text
show running-config | section pim
show ip pim rp mapping
```

Remove each prior mechanism where present, keeping interface-level sparse mode. In this checkpoint, R1 and R3 had both the static RP and listener; R4 had only the listener; R2 had the static RP and announcement command.

**R1-FHR and R3-TRANSIT**:

```text
configure terminal
no ip pim rp-address 2.2.2.2
no ip pim autorp listener
end
```

**R3-TRANSIT**, remove its former Mapping Agent role:

```text
configure terminal
no ip pim send-rp-discovery scope 16
end
```

**R2-RP**, remove its former static and Auto-RP roles:

```text
configure terminal
no ip pim rp-address 2.2.2.2
no ip pim send-rp-announce 2.2.2.2 scope 16
end
```

**R4-LHR**:

```text
configure terminal
no ip pim autorp listener
end
```

The [transition captures](../verification/08-bsr-transition.md) retain the before/after checks and R4's empty mapping table. Do not remove PIM from the transit interfaces during discovery cleanup.

## Add the R5 connection to an earlier lab

Follow the [wiring table](../topology-bsr.md#wiring). These additions are already present in the saved export.

**R3-TRANSIT**:

```text
configure terminal
interface Loopback0
 ip address 3.3.3.3 255.255.255.255
 ip pim sparse-mode
interface GigabitEthernet0/2
 description LINK-TO-R5-BSR2
 ip address 10.35.0.1 255.255.255.252
 ip pim sparse-mode
 no shutdown
router ospf 1
 network 3.3.3.3 0.0.0.0 area 0
 network 10.35.0.0 0.0.0.3 area 0
end
```

**R5-BSR2**, using a fresh IOSv router:

```text
configure terminal
hostname R5-BSR2
ip multicast-routing
interface Loopback0
 ip address 5.5.5.5 255.255.255.255
 ip pim sparse-mode
interface GigabitEthernet0/0
 description LINK-TO-R3-TRANSIT
 ip address 10.35.0.2 255.255.255.252
 ip pim sparse-mode
 no shutdown
router ospf 1
 router-id 5.5.5.5
 network 5.5.5.5 0.0.0.0 area 0
 network 10.35.0.0 0.0.0.3 area 0
end
```

## Candidate BSR election

The initial **R3-TRANSIT** election used priority 10:

```text
configure terminal
ip pim bsr-candidate Loopback0 0 10
end
```

Add **R5-BSR2** at priority 20:

```text
configure terminal
ip pim bsr-candidate Loopback0 0 20
end
```

The first numeric argument is **hash-mask length 0**; the second is **BSR priority**. The R5 command was initially omitted, which explains the [first election case](../troubleshooting/05-bsr-candidate-omission.md).

For the equal-priority test, update **R3-TRANSIT**:

```text
configure terminal
no ip pim bsr-candidate Loopback0 0 10
ip pim bsr-candidate Loopback0 0 20
end
```

The final connected state uses priority 20 on both candidates; R5 wins on BSR address. Verify both routers rather than trusting only the winner's local state.

## Isolate and restore the preferred BSR

On **R5-BSR2**, temporarily shut its only transit interface:

```text
configure terminal
interface GigabitEthernet0/0
 shutdown
end
```

Observe R3's BSR and neighbor state. Restore **R5-BSR2** afterward:

```text
configure terminal
interface GigabitEthernet0/0
 no shutdown
end
```

This isolates R5; it does not stop R5's local process. The [case](../troubleshooting/06-bsr-failover.md) retains the observed election sequence and its measurement limits.

## Temporary second Candidate RP

With R2 already the Candidate RP at priority 0, add **R3-TRANSIT** at RP priority 10:

```text
configure terminal
ip pim rp-candidate Loopback0 priority 10
end
```

Then make the RP priorities equal on **R3-TRANSIT**:

```text
configure terminal
no ip pim rp-candidate Loopback0 priority 10
ip pim rp-candidate Loopback0 priority 0
end
```

On **R4-LHR**, compare the advertised set with the chosen group RP:

```text
show ip pim rp mapping
show ip pim rp-hash 239.1.1.1
show ip mroute 239.1.1.1
```

After the experiment, remove only R3's temporary **Candidate RP** role:

```text
configure terminal
no ip pim rp-candidate Loopback0 priority 0
end
```

R3 remains a Candidate BSR. [Final verification](../verification/12-bsr-rp-selection.md#block-04) shows R2 as the only advertised RP again.

## Verification sequence

| Check | Device | Expected checkpoint |
|---|---|---|
| `show ip pim interface` and `show ip pim neighbor` | R1–R5 | Required interfaces participate in PIM; transit adjacencies exist |
| `show ip route 5.5.5.5` and `show ip rpf 5.5.5.5` | Downstream routers | A usable path toward the elected BSR; RPF command is a recommended additional check |
| `show ip pim bsr-router` | R1–R5 | Final connected BSR is 5.5.5.5 at priority 20 |
| `show ip pim rp mapping` | R1–R5 | RP 2.2.2.2 learned via bootstrap |
| `show ip igmp groups` | R4 | Receiver 10.4.4.10 interested in 239.1.1.1 |
| `show ip mroute 239.1.1.1` | R4 and R2 | Shared tree, then source tree and RP-side prune after source startup |

The source uses the same group as earlier phases. A fresh multicast ping and a final running-config export would extend the evidence, but no result is implied for checks without a retained capture.

[BSR overview](../bsr.md) · [Configuration index](README.md) · [Evidence guide](../verification/README.md)
