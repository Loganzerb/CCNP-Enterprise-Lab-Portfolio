# DHCP configuration guide

The switch connects three networks, the server supplies two address pools, and the clients request their settings automatically. These files make the setup reviewable and provide a starting point for rebuilding it in CML.

## Files and status

| File | Purpose | Status |
|---|---|---|
| [DIST-SW-working.cfg](DIST-SW-working.cfg) | VLANs, access ports, gateways, routing and both helpers | Reconstructed working configuration |
| [DHCP-SRV-working.cfg](DHCP-SRV-working.cfg) | Server address, return route, exclusions and pools | Reconstructed; pool settings corroborated by captured output |
| [CLIENT-A-working.cfg](CLIENT-A-working.cfg) | IOSv host behavior and DHCP on Gi0/0 | Reconstructed |
| [CLIENT-B-working.cfg](CLIENT-B-working.cfg) | Same client behavior for VLAN 20 | Reconstructed |
| [captured-dhcp-pools.txt](captured-dhcp-pools.txt) | Actual server output after removal of the temporary renewal policy | Captured configuration excerpt |

The reconstructions are minimal lab commands, not full saved device configurations. They follow Part 3's setup message `578bbeb5-6803-48b6-a00b-662f83720426`, the later helper changes, DHCP-enabled client output and Part 4's captured pool settings. There is no attached DHCP YAML or full final running-config export.

## Settings worth reviewing

| Setting | Purpose in this lab |
|---|---|
| DIST-SW `ip routing` and three VLAN interfaces | Provide routing between client networks and the server network |
| Helper on Vlan10 and Vlan20 | Forward initial client requests to `10.99.99.50` |
| Server default route via `10.99.99.1` | Provide a return path toward the client networks |
| Exclusions `.1–.20` | Keep gateway and reserved infrastructure addresses out of dynamic allocation |
| Correct `default-router` in each pool | Tell clients which local gateway to use |
| Client `no ip routing` | Make the IOSv routers operate as endpoints for the exercises |

The observed one-day lease uses the default; the captured pools do not contain an explicit `lease` command. `8.8.8.8` is retained as the configured DNS option, without a claim that name resolution or Internet access was tested.

## Rebuild and compare

Create one IOSvL2 switch and three IOSv routers, then use the [wiring table](../topology.md). Apply each file only to its named device from privileged EXEC mode. The working files enable both relays and both clients; the original guided lab enabled them in stages.

Use the following as **replay checks**, not as new results collected for this package:

- On each client: `show ip interface brief`, `show dhcp lease`, `show ip route`.
- On DHCP-SRV: `show ip dhcp binding`, `show ip dhcp pool`, `show running-config | section ip dhcp`.
- From CLIENT-B: ping its gateway, then `10.99.99.50`.

Compare subnet, gateway, binding identity and reachability. Exact host addresses and lease timestamps can differ.

For controlled fault changes and recovery reasoning, follow the [case studies](../troubleshooting/README.md). The delivered working configurations omit the intentionally incorrect gateway and temporary `renew deny unknown` setting.

[Section overview](../README.md)

