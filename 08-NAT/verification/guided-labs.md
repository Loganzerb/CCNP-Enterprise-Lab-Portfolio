# Guided NAT/PAT labs

These exercises used a predict → configure → observe → explain → break → repair workflow. The compact summaries below link to the retained CLI evidence. The two integrated incidents have separate, more detailed case studies.

## 1. Establish the routed baseline

CLIENT-A reached OUTSIDE-SRV when ISP had a route to `10.10.10.0/24`. Removing that route produced 0/5. This established the return-path dependency before introducing NAT. [Captured baseline](01-baseline-routing.txt).

## 2. Static inside source NAT

Mapped `10.10.10.10` to `198.51.100.10`, with an ISP `/32` route through `198.51.100.2`. The static entry existed before traffic. CLIENT-A and OUTSIDE-SRV each achieved 5/5 in their respective directions. Removing the mapping left the ISP route present but caused 0/5 and a traceroute alternating between ISP and NAT-EDGE. Restoring the mapping restored 5/5. [Static operation](02-static-nat.txt) · [Removal and recovery](03-static-mapping-removal.txt).

## 3. Dynamic one-to-one NAT

The `DYNAMIC-NAT` pool began empty. CLIENT-A acquired `192.0.2.10`; CLIENT-B acquired `192.0.2.11`. Both reached the server. An ICMP extended entry appeared alongside a base address mapping: seeing `:6` in a row did not, by itself, prove overload was configured. [Allocation evidence](04-dynamic-nat.txt).

## 4. Exhaust and reuse the pool

CLIENT-B's secondary source `10.10.10.30` represented a third inside identity, not a third physical client. With both pool addresses allocated, it failed 0/5 and pool allocation misses reached 10, even though the top-level NAT Misses field remained 0. After deliberately clearing CLIENT-A's base mapping, `.30` acquired `192.0.2.10` and succeeded 5/5. This was a controlled capacity experiment; clearing state was not the lasting incident repair. [Exhaustion and reuse](05-pool-exhaustion.txt).

## 5. Interface PAT and TCP confirmation

Interface overload allowed both clients to share `198.51.100.2`. The ICMP capture included identifier remapping for CLIENT-B. A later TCP capture showed two different source ports, and OUTSIDE-SRV independently listed both sessions as `ESTAB`. The ICMP table and the subsequent statistics are different instants: two rows in one and one active entry in the other must not be forced into a single snapshot. [Interface PAT](06-interface-pat.txt).

## 6. Pool PAT

With `PAT-POOL overload`, `.10`, `.20`, and secondary source `.30` shared `192.0.2.10`. The pool contained two addresses but reported only one allocated (50%), while three extended entries were active. Pool PAT can share an address; a configured range does not mean one address must be assigned to each client. [Pool PAT](07-pool-pat.txt).

## 7. Observe translation aging

The captured ICMP verbose entry reported `timeout:60000` and `left 00:00:50`. A later capture showed no translations and no pool allocation. These are observations of this lab entry, not a universal timeout for every NAT protocol or mapping type. [Aging evidence](08-translation-aging.txt).

## 8. Diagnose controlled failures

| Failure | Observed result | Repair and lesson |
|---|---|---|
| ACL permits only CLIENT-A | A 5/5; B 0/5; A has a mapping | Restore subnet eligibility; B returns to 5/5. A NAT selection ACL is not itself an interface packet filter. |
| Missing `ip nat inside` | Blank inside-interface list, no translation, A 0/5 | Restore the role; A returns to 5/5 and creates state. |
| Missing ISP return route | PAT entry exists but A 0/5; ISP reports no route | Restore the route; A returns to 5/5 with PAT still operating. |

[ACL test](09-acl-failure-recovery.txt) · [Inside-role test](10-inside-role-failure-recovery.txt) · [Return-route test](11-return-route-failure-recovery.txt).

The last test is especially useful: a translation establishes that NAT created state, but it does not establish successful delivery or return traffic. The outputs do not provide a packet capture of every hop.
