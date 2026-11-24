# Lab 20A verification

The selected terminal excerpts come from the original CML session. The private checkpoint supports the saved [configuration and topology](../configs/README.md). Reported observations from the lab completion record are identified separately. [Evidence scope](../scope.md)

## Historical evidence

| Phase | Captured CLI | Reported context |
|---|---|---|
| Return-path repair | The two ISP lookups show missing and corrected routes to the selected source addresses. R1 then received **5/5** ICMP replies from each provider loopback. [Return-path excerpts](return-path.md) | Initial loopback pings failed. |
| Baseline | R1's running config shows a tracked primary and a floating backup. Track 10 was **Up** with return code **OK**. The default used `10.20.12.2`, AD **1**. [Baseline excerpt](tracked-default.md#normal-tracked-default) | — |
| Outage | R2 lost the eBGP adjacency with R4 and the IP route to `4.4.4.4`. R1 reported SLA **Timeout** and Track 10 **Down**. The default next hop moved to R3 at `10.20.13.2`, AD **10**. CEF selected **Gi0/2**. [Outage excerpts](tracked-default.md#upstream-failure) | R2 Gi0/1 was shut while Gi0/0 remained in service. |
| Recovery | R1's SLA returned **OK** and Track 10 went **Up**. The default returned to `10.20.12.2`, AD **1**. CEF selected **Gi0/1**. [Recovery excerpt](tracked-default.md#primary-recovery) | R2 Gi0/1, the eBGP session, and the route to `4.4.4.4` recovered. |

The sourced pings exercised the pinned host routes. The CEF lookups used source `10.20.13.1` during the outage and `10.20.12.1` during recovery. Both lookups used destination `8.8.8.8` and show R1's next-hop selection only. End-to-end delivery through the selected default, Internet connectivity, and convergence duration remain unverified. [Cisco IOS CEF verification](https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/ipswitch_cef/configuration/15-mt/isw-cef-15-mt-book/isw-cef-basic-config.html)

## Replay and capture

These are future checks for an isolated CML run. Fresh import, boot, and runtime replay remain pending.

1. Use your licensed CML images to recreate the [topology](../topology.md) and [implementation settings](../configs/README.md), or import the private checkpoint if you are authorized to access it.
2. After boot, check administrative state on each intended active port with `show ip interface brief` or `show interfaces`. Extracted IOSv configurations can omit explicit `no shutdown`. Enable only the intended active ports that are administratively down, and check VLANs 10 and 20 on SW1 if including the desktops. [Cisco CML extraction guidance](https://developer.cisco.com/docs/modeling-labs/extracting-configurations/)
3. Capture the baseline. On R2, enter interface configuration for `GigabitEthernet0/1` and issue `shutdown`. Leave `GigabitEthernet0/0` toward R1 in service. Repeat the checks as the probe changes state.
4. Issue `no shutdown` on R2 Gi0/1. Repeat the checks after the eBGP session, SLA status, and tracked default recover. Leave the restored link in service.

| Device | Example command or observation to capture | Question |
|---|---|---|
| R2 and R3 | `show ip bgp summary` and `show ip ospf neighbor` | Are the provider sessions and loopback-based edge iBGP present, and does the enterprise underlay remain in service? |
| R2 | `show interfaces GigabitEthernet0/0` and `show interfaces GigabitEthernet0/1` | Did the simulated failure leave the core-facing link up? |
| R2 | `show ip bgp 4.4.4.4` and `show ip route 4.4.4.4` | Is a BGP path present and is its next hop usable for route installation? |
| R3 | `show ip bgp 5.5.5.5` and `show ip route 5.5.5.5` | Is the backup provider loopback reachable through the intended handoff? |
| R4 and R5 | `show ip route 10.20.12.1` on R4 and `show ip route 10.20.13.1` on R5 | Do the ISPs have the return routes for the chosen R1 source IPs? |
| R1 | `ping 4.4.4.4 source 10.20.12.1` and `ping 5.5.5.5 source 10.20.13.1` | Can R1 reach each provider loopback from its corresponding transit IP? |
| R1 | `show ip sla configuration 10`, `show ip sla statistics 10`, and `show track 10` | What are the probe settings, latest result, and tracking state? |
| R1 | `show ip route 0.0.0.0` and `show ip cef exact-route` with a fixed lab source and lab destination that uses the default | Do the active default and CEF egress match the expected phase? |

To extend the evidence, capture time-stamped readings across all three phases and a bidirectional traffic test to a lab-only target that uses the default in each state. Verify forward and return routing to that target before using the result to assess packet delivery or outage duration.

[Overview](../README.md) · [Configuration](../configs/README.md) · [Troubleshooting](../troubleshooting/README.md) · [Evidence scope](../scope.md)
