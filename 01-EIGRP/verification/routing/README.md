# Routing tables — what was installed?

These five `show ip route eigrp` captures record installed EIGRP routes. They are not full routing tables or packet-forwarding tests.

| Capture | What to inspect |
|---|---|
| [R1-CORE](R1-show-ip-route-eigrp.txt) | Two next hops for branch `172.16.40.0/22` and remote `172.16.48.0/22` |
| [R2-DIST-A](R2-show-ip-route-eigrp.txt) | Both summaries through R4; external default through R1 |
| [R3-DIST-B](R3-show-ip-route-eigrp.txt) | Both summaries through R4; external default through R1 |
| [R4-BRANCH](R4-show-ip-route-eigrp.txt) | Local branch summary to Null0; remote summary through R5; equal-cost default next hops through R2 and R3 |
| [R5-REMOTE](R5-show-ip-route-eigrp.txt) | Learned external default through R4 and a local remote-summary entry |

## Route codes and metrics

`D` identifies internal EIGRP routes; `D EX` identifies external EIGRP routes. The asterisk in `D*EX 0.0.0.0/0` marks a candidate default.

In `[90/131072]`, 90 is administrative distance and 131072 is the route metric. A second indented next-hop line belongs to the preceding prefix and records another installed path.

R5 uses wide metrics and RIB scaling. Its displayed route metric should not be compared directly with the raw topology-table value; see the [metric example](../topology/README.md).

## Summary and default behavior

R4 and R5 each install a local summary to Null0 while retaining their more-specific connected loopbacks. The EIGRP-only listing omits those connected routes.

R5's limited learned route set matches R4's default-only outbound filter. The existence of a default does not establish Internet access or a working return path.

R1's gateway-of-last-resort line names `10.200.1.2`. Its default is static in the saved configuration, so the default does not appear as a learned EIGRP entry in this filtered command output.

[Case 03](../../troubleshooting/scenario-3-inconsistent-eigrp-summarization.md) explains why an installed `/24` takes precedence over a covering `/22` for matching destinations. Its traffic-path implication is derived from the route entries; no traceroute was retained.

[Verification guide](../README.md)
