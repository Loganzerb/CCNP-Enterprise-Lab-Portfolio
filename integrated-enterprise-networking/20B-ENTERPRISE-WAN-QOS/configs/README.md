# Lab 20B configuration guide

The topology and implementation excerpts use values checked against the privately retained CML checkpoint. The complete CML checkpoint and IOS configurations remain private pending redistribution clearance. [Topology and addressing](../topology.md) · [Evidence scope](../scope.md)

## Endpoint startup scripts

| Device | Purpose |
|---|---|
| [PC-CLIENT.sh](PC-CLIENT.sh) | Configure the client hostname, IPv4 address, and default gateway. |
| [PC-SERVER.sh](PC-SERVER.sh) | Configure the server hostname, IPv4 address, and default gateway. |

The scripts retain the Alpine setup commands. Local credential assignments from the original CML nodes were omitted.

## Static routing

| Router | Remote prefix | Saved next hop |
|---|---|---|
| R1-CORE | `10.20.40.0/24` | `10.20.12.2` preferred at static AD 1, `10.20.13.2` floating at AD 10 |
| R2-EDGE-A | `10.20.10.0/24` · `10.20.40.0/24` | `10.20.12.1` · `198.51.100.2` |
| R3-EDGE-B | `10.20.10.0/24` · `10.20.40.0/24` | `10.20.13.1` · `203.0.113.2` |
| R4-ISP-A | `10.20.10.0/24` | `198.51.100.1` preferred at static AD 1, `192.0.2.2` floating at AD 10 |
| R5-ISP-B | `10.20.10.0/24` · `10.20.40.0/24` | `203.0.113.1` · `192.0.2.1` |

The floating routes rely on route eligibility. A downstream fault can leave the directly connected primary next hop resolvable, keeping the preferred route installed. The saved design has no remote reachability tracking. [Lab 20A tracked-default design](../../20A-DUAL-ISP-WAN/README.md)

## Saved R2 policy

| Policy object | Setting |
|---|---|
| `VOICE-TRAFFIC` | Match UDP from `10.20.10.10` to `10.20.40.10` destination port `5001`. |
| `BUSINESS-TRAFFIC` | Match TCP from `10.20.10.10` to `10.20.40.10` destination port `5002`. |
| `MARK-IN` | Set EF for `VOICE`, AF21 for `BUSINESS`, and CS0 for the default class. |
| `WAN-OUT` | Use `priority 1200` for EF and `bandwidth 300` for AF21. |
| `WAN-SHAPE` | Target `shape average 2000000` and invoke `WAN-OUT` under the parent default class. |
| `Gi0/0` · `Gi0/1` | Attach `MARK-IN` on ingress and `WAN-SHAPE` on egress, respectively. |

The selected implementation commands below show the dependency from the business ACL through ingress marking to the egress class definition. Build the complete working policy in the context of the address and policy tables, with the voice and default treatment shown in the [captured final policy](../troubleshooting/README.md#captured-correction-and-recovery).

```cisco
ip access-list extended BUSINESS-TRAFFIC
 permit tcp host 10.20.10.10 host 10.20.40.10 eq 5002
exit
class-map match-all BUSINESS
 match access-group name BUSINESS-TRAFFIC
exit
policy-map MARK-IN
 class BUSINESS
  set dscp af21
exit
exit
class-map match-all BUSINESS-AF21
 match dscp af21
```

## Local reproduction

1. Build the [topology](../topology.md) in an isolated CML lab using compatible IOSv and Alpine Desktop images, or import an authorized private checkpoint. Confirm the node and interface mapping.
2. Verify the administrative state of each intended link with `show ip interface brief`. Extracted IOSv configurations can omit explicit `no shutdown` lines. Activate only the required interfaces that are administratively down and confirm the expected line protocol.
3. Set up console access privately if required. Verify each endpoint's address, default route, and iPerf version. Apply the addressing and the intended static routes and QoS policies where needed.
4. Verify the selected forwarding path and both R2 policy directions. Record fresh baselines before generating traffic. [Verification commands](../verification/README.md#checks-for-a-fresh-run)

A fresh import, boot, and runtime replay remain pending.

[Overview](../README.md) · [Topology](../topology.md) · [Policy architecture](../operation.md)
