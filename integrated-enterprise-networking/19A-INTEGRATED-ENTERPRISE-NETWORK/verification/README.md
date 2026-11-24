# Lab 19A verification guide

The original Lab 19A handoff supplies the outcomes below as reported observations. Inspection of the private CML export supports the saved configuration details. Raw terminal transcripts, screenshots, and packet captures were unavailable for this lab. The commands are for a future run. [Evidence scope](../scope.md)

## Task-to-evidence matrix

| Check | Device and commands for capture | Reported outcome and saved support |
|---|---|---|
| VLAN segmentation and trunking | Both switches, `show vlan brief` and `show interfaces trunk` | Saved trunk settings allow VLANs 10 and 20, and the router subinterfaces use the corresponding tags. The export lacks the runtime VLAN database. |
| LACP bundle | Both switches, `show etherchannel summary` and `show lacp neighbor` | Port-channel1 was reported operational on both switches. Both Gi0/2 and Gi0/3 use `channel-group 1 mode active` in the saved configurations. |
| Rapid PVST+ root | Both switches, `show spanning-tree vlan 10` and `show spanning-tree vlan 20` | SW2 was reported as root. Both VLANs use configured priorities of 4096 on SW2 and 8192 on SW1. |
| Normal HSRP state | R2 and R3, `show standby brief` | Active/Standby states were verified for both groups. The saved priorities prefer R2 in both VLANs. |
| HSRP VLAN 10 failover and failback | R2 and R3, `show standby brief` during each phase | The group 10 active role moved from R2 to R3, and R2 reclaimed it through preemption. Transition timing and packet loss remain unverified. |
| Upstream OSPF adjacencies | R2, R3, and R4, `show ip ospf neighbor` | R2 and R3 each reached FULL with R4. The Area 0 interface settings and router IDs are saved. |
| Advertised external loopback | R2 and R3, `show ip route 203.0.113.100` | Both gateways learned `203.0.113.100/32` through OSPF. R4’s saved Loopback0 has Area 0 enabled. |
| Normal and alternate PAT paths | R1 source-directed ping; active gateway, `show ip nat translations` and `show ip nat statistics` | R1 was reported to reach the loopback through R2 and through R3 after failover. R2’s observed inside global was `172.16.24.1`; R3’s was `172.16.34.1`. Each saved overload command uses local Gi0/1. |
| VLAN 10 ACL on R2 and R3 | R1 source-directed ping; receiving gateway, `show ip access-lists USERS-FILTER` and `show ip interface GigabitEthernet0/0.10` | Five deny matches were reported on each gateway in separate tests, including after failover. Both saved configurations apply the same ACL inbound on VLAN 10. |
| Separate VLAN 20 PAT test | R1, `show ip route 203.0.113.100` and a ping with a VLAN 20 source address. Receiving gateway, `show ip nat translations` | The handoff reports permitted VLAN 20 traffic and a PAT translation during a separate test. The saved checkpoint retained the subinterfaces and NAT selection ACL after the temporary `/32` was removed. |

## Failover and policy sequence

Use a disposable CML lab and complete the administrative-state and VLAN checks before capturing results. Record normal HSRP ownership for both groups, the matching LACP and STP status, and both gateways’ adjacency and route state. Capture translation tables promptly after generating traffic because dynamic entries expire. [Build and replay checks](../configs/README.md#build-and-replay-checks)

1. **Permitted VLAN 10 PAT test.** The handoff reports a successful test through each gateway in a separate permitted state. For a future replay from the restrictive configuration, temporarily detach the inbound `USERS-FILTER` from Gi0/0.10 on both gateways in the disposable lab. From R1, use `ping 203.0.113.100 source 10.10.10.10 repeat 5`. Confirm R2 owns group 10 and capture its inside global address. To induce a role change in the replay, temporarily shut R2’s VLAN 10 subinterface. Verify R3 owns group 10, issue a new probe, and capture R3’s inside global address. Restore the R2 subinterface and confirm preemption. The original failure injection command is unavailable.
2. **Policy stage.** Attach `ip access-group USERS-FILTER in` on both VLAN 10 subinterfaces. With R2 active, record its deny counter before and after the same five-echo probe. Repeat with R3 active after the controlled role change. The deny-counter delta ties the failed ping to the specific ACL entry. Verify HSRP, upstream OSPF reachability, and subsequent R2 restoration separately.
3. **VLAN 20 exception stage.** R1 has one routing table, so verify the next hop as well as the ping source. A future reproduction can use a temporary `ip route 203.0.113.100 255.255.255.255 10.10.20.1` on R1 to send the `/32` test through the VLAN 20 VIP. The exact historical next hop is unavailable. Use `ping 203.0.113.100 source 10.10.20.20 repeat 5`, check the selected next hop and active gateway, and look for R1’s `10.10.20.20` inside local in that gateway’s translations. Remove the temporary host route and verify R1’s VLAN 10 default remains.

Capture each baseline, role change, and restoration as distinct states. This sequence can verify new traffic after a failover. A continuous transport session and timestamped captures are required to measure session continuity or convergence time.

[Overview](../README.md) · [Configurations](../configs/README.md) · [Topology](../topology.md) · [Operation](../operation.md) · [Troubleshooting](../troubleshooting/README.md)
