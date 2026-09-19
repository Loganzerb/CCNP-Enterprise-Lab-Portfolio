# Case 03 — Ping works, but time updates stop

## Summary

R3 could reach its time server, but an access-control rule blocked NTP requests from its new loopback address. The policy still permitted NTP from the old interface address and allowed other IP traffic.

I traced the failure to the matching deny entry, changed that entry to permit the actual source, and verified both renewed NTP communication and the policy counter.

## Starting condition

The previous case had restored routing to **3.3.3.3/32**. R3 continued using that loopback to contact R2 at **10.20.0.1**.

I introduced a narrow test ACL on R2:

| Entry | Effect |
|---|---|
| 10 | Permit UDP/123 from the old source, 10.20.0.3 |
| 20 | Deny UDP/123 from the current source, 3.3.3.3 |
| 30 | Permit other IP traffic |

The ACL was applied inbound on **R2 Gi0/1**. [Policy — Block 01](../verification/04-acl-udp123.md#block-01) · [Attachment — Block 02](../verification/04-acl-udp123.md#block-02)

## Evidence that isolated the fault

A ping from **3.3.3.3** to the server still received **5/5 replies**. The same source address then appeared in the NTP deny entry with **five matches**. R3's association eventually showed **.INIT., stratum 16 and reach 0**.

[Ping — Block 03](../verification/04-acl-udp123.md#block-03) · [Deny counter — Block 04](../verification/04-acl-udp123.md#block-04) · [Failed association — Block 05](../verification/04-acl-udp123.md#block-05)

Together, these checks narrowed the problem to policy for the service. The successful ICMP test did not establish that UDP/123 was permitted.

## Targeted repair

I replaced sequence 20 with a permit for the same source, destination and port:

```cisco
ip access-list extended NTP-SOURCE-TEST
 no 20
 20 permit udp host 3.3.3.3 host 10.20.0.1 eq ntp
```

This is the readable repair sequence; the captured entry command is horizontally truncated. The subsequent ACL output confirms the complete corrected rule. [Block 06](../verification/04-acl-udp123.md#block-06)

R3's NTP configuration and the return route stayed in place.

## Result and cleanup

R3's reach rose from **0 to 1**, and upstream timing information replaced `.INIT.`. The corrected permit entry subsequently accumulated **37 matches**. [Blocks 07–08](../verification/04-acl-udp123.md#block-07)

Those results establish restored NTP exchanges and the policy accepting the intended source. They do not establish final clock synchronization; no final synchronized status was captured for this exercise.

I detached and deleted the temporary ACL. Captures show no inbound or outbound access list on the interface, followed by an empty lookup for the deleted ACL. [Blocks 09–10](../verification/04-acl-udp123.md#block-09)

**Takeaway:** test the service with its actual source identity and use policy counters to connect a rule to the observed failure.

[Back to cases](README.md) · [Back to NTP](../README.md)
