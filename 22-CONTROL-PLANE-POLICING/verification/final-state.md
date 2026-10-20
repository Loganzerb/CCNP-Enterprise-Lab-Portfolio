# Final configuration and regression

The final design restores both classes to **conform transmit / exceed drop** and attaches CP-PROTECT inbound under R1's control plane. Saved configuration evidence and reported runtime observations support different parts of that conclusion.

**Quick navigation:** [Saved final configuration](#saved-final-configuration) · [Reported final checks](#reported-final-checks) · [Remaining limits](#remaining-limits)

## Saved final configuration

| Component | State retained in the CML export |
|---|---|
| R1 SSH classifier | COPP-SSH permits TCP to host 10.10.10.1, destination port 22; CP-SSH matches that ACL |
| R1 OSPF classifier | COPP-OSPF permits OSPF from host 10.1.12.2; CP-OSPF matches that ACL |
| SSH policer | 80,000-bps CIR; conform transmit; exceed drop |
| OSPF policer | 1,000,000-bps CIR; conform transmit; exceed drop |
| Policy attachment | `service-policy input CP-PROTECT` under `control-plane` on R1 |
| Routing | OSPF 10, Area 0 on both routers; endpoint-facing interfaces passive and inter-router interfaces active |
| Addressing | CLIENT-A 10.10.10.25/24; router transit 10.1.12.0/30; APP-TEST 172.16.40.10/24 |

The [configuration guide](../configs/README.md) explains the sanitized extracts and SSH setup required after import. The published copy removes credentials and generated cryptographic material; the historical working SSH session does not establish that the sanitized copy offers SSH without that setup.

## Reported final checks

| Check | Reported result |
|---|---|
| SSH recovery | Authentication successful with privilege level 15 after restoring 80 kbps |
| SSH counter comparison | Matched 119 to 185; conformed 109 to 175; exceeded remained 10 |
| OSPF recovery | R1 reported LOADING to FULL after conform transmit was restored |
| Remote route | 172.16.40.0/24 reinstalled through 10.1.12.2 |
| Endpoint regression | CLIENT-A to APP-TEST: 10/10 ICMP replies, zero packet loss |
| Saved state | Both router startup configurations inspected |

The SSH comparison adds **66 matched and conforming packets with no additional exceeded packets**. The endpoint result establishes the reported final test, not a long-duration reliability or throughput measurement.

## Remaining limits

No raw runtime or startup-configuration transcripts were supplied. Startup inspection was reported, but **no router reload verification was performed**. A fresh import, boot, and traffic test of the sanitized export has not been performed as part of this documentation work.

[Verification index](README.md) · [SSH results](ssh-policing.md) · [OSPF results](ospf-protection.md) · [Troubleshooting](../troubleshooting/README.md) · [Overview](../README.md) · [Configurations](../configs/README.md) · [Lessons learned](../lessons-learned.md) · [Evidence scope](../scope.md)
