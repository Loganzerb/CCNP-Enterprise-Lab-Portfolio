# CCNP Enterprise STP Masterclass

This project documents a hands-on Cisco Modeling Labs investigation of campus Layer 2 resiliency. I built a redundant switched topology, engineered different roots for different VLAN groups, observed classic and rapid convergence, deliberately created unsafe conditions, and recovered the network using IOS evidence rather than guesswork.

The emphasis is operational: build, verify, break, diagnose, restore.

## Topology

```text
                     SW1-DIST-A
                    /          \
                   /            \
          SW2-ACCESS-A -------- SW3-ACCESS-B
             |       \          /       |
            PC1       \        /       PC2
                       SW4-DIST-B
                            |
                        SW5-ROGUE
```

The CML file contains four production-role IOSvL2 switches, two VLAN 10 endpoints, and a fifth switch used to inject rogue BPDUs and trunk failures. Inter-switch links carry VLANs 10, 20, 30, and 40.

| Device | Lab role |
|---|---|
| `SW1-DIST-A` | Preferred root for VLANs 10/20; secondary for 30/40 |
| `SW4-DIST-B` | Preferred root for VLANs 30/40; secondary for 10/20 |
| `SW2-ACCESS-A` | Access switch, PC1 attachment, redundant uplinks |
| `SW3-ACCESS-B` | Access switch, PC2 attachment, redundant uplinks |
| `SW5-ROGUE` | Superior-BPDU and trunk-failure injection |

The saved topology finishes in Rapid PVST+ with long path costs. `SW1-DIST-A` has priority 24576 for VLANs 10/20 and 28672 for VLANs 30/40; `SW4-DIST-B` uses the inverse. This places roots deliberately instead of relying on MAC-address elections.

## Design goals

- Compare 802.1D behavior with RSTP, PVST+, and Rapid PVST+.
- Prove root election and every relevant tie-breaker from IOS output.
- steer per-VLAN forwarding with bridge priority, path cost, and port priority.
- Protect the root and access edge without hiding control-plane failures.
- Diagnose inconsistent and err-disabled states from the trigger, log, and show commands.
- Test how STP treats EtherChannels and network-edge features.

## What I built and demonstrated

- Deterministic per-VLAN root placement and load distribution.
- Classic timer-driven convergence versus RSTP proposal/agreement behavior.
- Rapid alternate-port promotion and edge-port topology-change suppression.
- PortFast with BPDU Guard on host ports.
- Root Guard, Loop Guard, BPDU Filter behavior, and UDLD recognition.
- PVID/native-VLAN and port-type inconsistency troubleshooting.
- Short versus long path-cost methods and per-VLAN path engineering.
- EtherChannel as one logical STP port, plus misconfiguration protection.
- Bridge Assurance and network-port behavior.
- Recognition of legacy UplinkFast and BackboneFast in modern Rapid PVST+ designs.

## Evidence and outcomes

The lab was validated with commands including:

```cisco
show spanning-tree summary
show spanning-tree vlan 10
show spanning-tree vlan 10 detail
show spanning-tree inconsistentports
show interfaces trunk
show etherchannel summary
show interfaces status err-disabled
show logging | include SPANTREE|EC|UDLD
```

One representative capture on `SW2-ACCESS-A` showed VLAN 10 using `Gi0/0` as `Root FWD`, the other trunks as `Desg FWD`, and `Gi0/3` as `P2p Edge`. The detailed output recorded root priority `24586`, root path cost `4` under the short-cost method, and BPDU Guard enabled on the host port. After the lab moved to long costs, the saved CML configuration retained that production-oriented method.

The most important result was not a single stable topology. It was repeatable recovery: identify the protection mechanism from the observed state, remove the actual trigger, and verify automatic or manual restoration without disabling safeguards.

## Repository contents

- [`CCNP_MASTERCLASS_STP.yaml`](CCNP_MASTERCLASS_STP.yaml) — importable CML topology and saved device configurations
- [`LAB-NOTES.md`](LAB-NOTES.md) — experiment sequence, configurations, and verification points
- [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md) — injected failures, observed IOS evidence, diagnosis, and recovery

> MSTP is intentionally excluded. It is developed as a separate portfolio project.
