# Auto-RP configuration and migration guide

Apply this phase after verifying the [static-RP baseline](README.md). The addresses, OSPF costs, PIM sparse-mode interfaces and receiver join remain the same. These are reconstructed configuration steps from the completed lab, separate from the captured output.

## Phase 1 — Enable discovery transport

On **each of R1, R2, R3 and R4**:

```cisco
configure terminal
ip pim autorp listener
end
show running-config | include ip pim autorp
show ip pim autorp
```

Look for `AutoRP groups over sparse mode interface is enabled`. This supports forwarding of the Auto-RP control groups across the sparse-mode interfaces. It does not enable a Candidate RP or Mapping Agent role by itself.

## Phase 2 — Assign the roles

On **R2-RP**:

```cisco
configure terminal
ip pim send-rp-announce Loopback0 scope 16
end
show running-config | include send-rp-announce
show ip pim autorp
```

On this IOSv lab, a later running-config displayed `ip pim send-rp-announce 2.2.2.2 scope 16`. Both forms identify the same RP address here; the captured command help accepted an interface or an IP address.

On **R3-TRANSIT**:

```cisco
configure terminal
ip pim send-rp-discovery scope 16
end
show running-config | include send-rp-discovery
show ip pim autorp
```

Leave the static RP in place while checking the discovery chain. Compare counters after advertisements have had time to arrive, then inspect `show ip pim rp mapping` on all four routers.

[Candidate counters](../verification/05-autorp-migration.md#block-02), [Mapping Agent counters](../verification/05-autorp-migration.md#block-04), [downstream reception](../verification/05-autorp-migration.md#block-05) and [coexisting mappings](../verification/05-autorp-migration.md#block-06).

## Phase 3 — Remove static fallback

After the dynamic mapping is verified, run on **each router**, checking it before moving to the next:

```cisco
configure terminal
no ip pim rp-address 2.2.2.2
end
show running-config | include ip pim rp-address
show ip pim rp mapping
```

The configuration filter should return no static RP command. The mapping should identify `2.2.2.2` as elected via Auto-RP. Preserve both checks; the historical evidence includes the mapping displays, while the handoff records removal across all four routers.

The final Auto-RP settings relative to the static baseline are:

| Router | Add | Remove |
|---|---|---|
| R1 | `ip pim autorp listener` | `ip pim rp-address 2.2.2.2` |
| R2 | Listener and `ip pim send-rp-announce Loopback0 scope 16` | Static RP |
| R3 | Listener and `ip pim send-rp-discovery scope 16` | Static RP |
| R4 | `ip pim autorp listener` | Static RP |

These settings are sufficient to describe the phase change without duplicating the six existing device templates. Use the staged sequence above rather than removing static RP before dynamic discovery is checked.

## Phase 4 — Validate delivery and tree state

On MCAST-SOURCE:

```cisco
ping 239.1.1.1 repeat 20
```

On R4:

```cisco
show ip pim rp mapping
show ip igmp groups
show ip pim neighbor
show ip rpf 2.2.2.2
show ip rpf 10.1.1.10
show ip mroute 239.1.1.1
```

Keep source traffic active long enough to inspect `show ip mroute 239.1.1.1` on R1, R2 and R3 as well. Record complete traffic results independently of the routing-table snapshots.

[Recorded 19/20 migration test](../verification/05-autorp-migration.md#block-11) · [Final forwarding excerpts](../verification/07-autorp-forwarding.md)

## Restore the listener during troubleshooting

Check the actual running configuration on every router, not just the role configuration on R2/R3. Reapply `ip pim autorp listener` wherever missing, and confirm the status line on all four.

If the Mapping Agent was deliberately withdrawn during testing, also restore `ip pim send-rp-discovery scope 16` on R3. Confirm R2 retains its candidate command. Validate recovery in sequence: R3 Announce received → R3 Discovery sent → R4 Discovery received/dynamic mapping → multicast state → source traffic.

The completed handoff reports restoration across the domain, with [R3 counters and R4 mapping](../verification/06-autorp-recovery.md#block-10) retained as excerpts. Why the configuration changed between sessions was not proven. Save the verified running configurations and a new CML export when preserving the next checkpoint.

## Roll back to the original static phase

Restore `ip pim rp-address 2.2.2.2` on all four routers first. Stop Auto-RP advertisements by removing R2's candidate command and R3's Mapping Agent command using the forms present in the running configurations. Allow learned mappings to expire and verify Static selection before removing the Auto-RP listener.

Retest the [original baseline](../verification/01-baseline.md). This rollback procedure is provided for reproduction; it is not claimed as another completed lab exercise.

[Back to configuration guide](README.md) · [Back to Auto-RP](../auto-rp.md)

