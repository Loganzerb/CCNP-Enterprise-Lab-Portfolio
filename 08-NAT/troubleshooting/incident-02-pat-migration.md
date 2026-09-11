# Incident 02 — External access after PAT migration

## Incident summary and impact

A change intended to let both clients share NAT-EDGE's outside-interface address disrupted access to OUTSIDE-SRV (`203.0.113.10`). The incident handover reported that a connectivity test originated on NAT-EDGE had succeeded, while CLIENT-A and CLIENT-B reported failures.

The target was interface PAT through `198.51.100.2`, with both clients able to generate traffic and hold translations concurrently. The incident required preserved topology and addressing, repeated connectivity tests, and stable operation without repeatedly clearing state or reloading devices.

Two configuration faults prevented the intended behavior: the overload statement selected the inside interface address, and a global one-entry limit constrained concurrent translation state.

## Why the router's successful check was misleading

A successful router-originated check can establish some upstream reachability without exercising the same inside-to-outside NAT path as client transit traffic. Its source and processing path matter. The handover statement therefore could not close an outage reported by the clients.

The successful NAT-EDGE check is part of the original incident brief. No original CLI capture of that check is retained here, so its precise source address, count, or translation behavior is not asserted.

## Evidence sources

- [Original Incident 02 YAML](../configs/incident-02-original.yaml): direct evidence of the faulty overload statement, global limit, existing interface roles, ACL, and routing.
- [Final user-pasted verification](../verification/incident-02-final.txt): corrected NAT configuration, interface definitions, ACL, four ping runs, simultaneous ICMP and TCP tables, and final statistics.
- [Exact configuration changes](../configs/incident-02-NAT-EDGE-changes.diff): reconstructed repairs plus removal of the unused pool for the clean deliverable.

The user reported the repair complete before posting final outputs. No intermediate Incident 02 failure table or exact edit sequence was pasted. The analysis below explains the original faults and final proof without fabricating intermediate symptoms or commands.

## Diagnosis 1 — PAT selected the wrong interface address

The original rule was:

```cisco
ip nat inside source list NAT-SOURCES interface GigabitEthernet0/1 overload
```

Gi0/1 was the inside interface at `10.10.10.1`. The intended shared inside-global address was `198.51.100.2` on Gi0/0. Selecting the interface in an overload rule identifies the address to use for translation; it does not simply name where the clients connect.

**Inspection:** compare the rule with both interface configurations and `show ip nat statistics`. The original interfaces already had the correct `ip nat inside` and `ip nat outside` roles. The fault was the reference in the source rule, not a need to swap those interface roles or change addresses.

**Repair:** replace the overload rule with:

```cisco
ip nat inside source list NAT-SOURCES interface GigabitEthernet0/0 overload
```

**Verification:** the final configuration references Gi0/0, and both captured protocols show `198.51.100.2` as the global address. There is no retained pre-repair translation capture, so the case does not present hypothetical `10.10.10.1` translations as observed output.

## Diagnosis 2 — Global translation ceiling of one

The original configuration also contained:

```cisco
ip nat translation max-entries 1
```

PAT allows address sharing but still requires translation state for flows. A one-entry limit conflicts with the requirement to sustain multiple concurrent translations. Correcting only the interface reference would leave this separate capacity constraint in place.

**Inspection:** include global NAT settings in the review; the overload line alone does not describe the entire policy. [Cisco's command reference](https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/ipaddr/command/ipaddr-cr-book/ipaddr-i4.html) defines `ip nat translation max-entries` as a maximum NAT table size.

**Repair:** remove the one-entry limit using the corresponding `no ip nat translation max-entries` command.

**Verification:** the final `show running-config | include ^ip nat` no longer lists the limit, and the final table/statistics demonstrate two active dynamic extended translations. The snapshot proves capacity above one; it is not a scale or maximum-throughput benchmark.

## Healthy supporting configuration

The final `NAT-SOURCES` ACL permits `10.10.10.0/24`, with 14 matches shown in the capture. Gi0/1 is inside and Gi0/0 outside. NAT-EDGE's original default route points to ISP `198.51.100.1`.

ISP's route to `192.0.2.0/24` was inherited from the pooled NAT exercises. It was not the cause of this interface PAT incident. The shared address `198.51.100.2` lies on the existing ISP/NAT-EDGE link. The delivered ISP configuration is preserved unchanged.

## Repair reference and cleanup

This is a reference sequence, not a transcript of the user's edits. During a lab mode change, stop existing test traffic and clear affected dynamic translations if IOS requires it before replacing an in-use rule. Resume tests after the rule change; do not treat repeated clearing as the solution.

```cisco
configure terminal
no ip nat inside source list NAT-SOURCES interface GigabitEthernet0/1 overload
ip nat inside source list NAT-SOURCES interface GigabitEthernet0/0 overload
no ip nat translation max-entries
end
```

The final captured running configuration still listed the `DYNAMIC-NAT` pool. Its active source statement used interface PAT and no rule referenced that pool. The clean portfolio configuration removes only that obsolete pool definition in addition to the two repairs:

```cisco
! Editorial cleanup represented in the final delivered configuration
no ip nat pool DYNAMIC-NAT 192.0.2.10 192.0.2.11 netmask 255.255.255.0
```

This cleanup was not necessary to explain the successful tests and is not claimed as a captured device action. The [final NAT-EDGE configuration](../configs/incident-02-NAT-EDGE-final.cfg) preserves all unrelated exported lines; the [diff](../configs/incident-02-NAT-EDGE-changes.diff) shows the full change boundary.

## Verification 1 — End-to-end reachability

| Client | Test | Captured result | Min/avg/max |
|---|---|---|---|
| CLIENT-A | 20 echoes | 20/20, 100% | 3/3/5 ms |
| CLIENT-A | 50 echoes | 50/50, 100% | 3/4/5 ms |
| CLIENT-B | 20 echoes | 20/20, 100% | 4/4/5 ms |
| CLIENT-B | 50 echoes | 50/50, 100% | 4/4/6 ms |

All tests targeted `203.0.113.10`. These outputs prove reliable reachability during the retained runs. They are not a timing record of which client started first.

## Verification 2 — Simultaneous ICMP PAT state

The first final translation snapshot contains four ICMP entries:

| Inside local | Inside global | ICMP identifiers in this capture |
|---|---|---|
| `10.10.10.10` | `198.51.100.2` | 4 and 5 |
| `10.10.10.20` | `198.51.100.2` | 6 and 7 |

Both clients appear in the same table with the same global IP. ICMP uses identifiers, not TCP/UDP ports. The mappings demonstrate coexisting state; that is stronger concurrency evidence than separate successful pings. The table does not prove the exact scheduling of the two ping commands.

## Verification 3 — Persistent TCP/Telnet as stable evidence

ICMP entries were short-lived and difficult to capture consistently after fast ping bursts. Persistent Telnet sessions were intentionally used to hold stable simultaneous PAT state long enough to inspect it.

Selected original rows from the later TCP snapshot:

```text
tcp 198.51.100.2:15271 10.10.10.10:15271  203.0.113.10:23    203.0.113.10:23
tcp 198.51.100.2:43627 10.10.10.20:43627  203.0.113.10:23    203.0.113.10:23
```

The same global address serves two inside clients reaching the same server and TCP port 23, distinguished by their source-port mappings. The original source ports were preserved in these rows; PAT does not have to change every source port to provide address sharing. Telnet was the lab traffic source for this proof, not a new management design proposal.

The ICMP and TCP tables are separate snapshots. They must not be combined into a fictional six-entry table. Likewise, the final statistics below follow the TCP table, rather than the earlier four-entry ICMP table.

## Verification 4 — NAT statistics

| Field | Captured value | Interpretation |
|---|---|---|
| Active translations | 2: 0 static, 2 dynamic, 2 extended | Two protocol-specific dynamic entries were active. |
| Hits / Misses | 642 / 0 | Recorded cumulative NAT counters at capture time. |
| CEF translated / punted | 642 / 0 | Reported forwarding counters for this capture. |
| Active source mapping | `NAT-SOURCES interface GigabitEthernet0/0 refcount 2` | The live mapping uses the corrected interface. |
| Queued packets | 0 | No packets were queued in the reported NAT snapshot. |

These counters support the successful endpoint and state evidence. They do not mean 642 successful pings, nor do zero misses prove every possible flow works.

## Closure scope and evidence limits

The retained evidence verifies the corrected interface rule, subnet eligibility, both client identities sharing the intended global address, successful 20/20 and 50/50 runs, and two active translations after removal of the one-entry ceiling.

The original ticket also requested overlapping ping runs in both start orders and continued stability without repeated clearing/reloads. Exact start order, absence of intervening clears/reloads, and a saved-configuration confirmation are not independently documented in the retained output. They remain evidence gaps, not fabricated passes or evidence of a known ongoing fault. For a strict ticket audit, a fresh time-ordered capture of both start orders and save confirmation would complete those points.

## Lessons carried forward

Validate the actual client path, identify which address an interface PAT rule selects, and inspect limits as well as mappings. Separate reachability proof from concurrency proof: pings establish replies, while persistent TCP sessions provide a stable window to inspect shared-address state. Capture commands in order and interpret each snapshot on its own terms.
