# EIGRP topology and addressing

![Five-router EIGRP AS 100 topology](topology.png)

The diagram shows six router-to-router EIGRP links in one routing domain, AS 100. R1 reaches R4 through R2 or R3; the distribution routers also connect directly. R5 has one upstream neighbor, R4.

## Devices and prefixes

| Device | Router ID | Role and locally originated networks |
|---|---|---|
| R1-CORE | `10.1.1.1` | Core; Loopback0 `10.1.1.1/32` |
| R2-DIST-A | `10.2.2.2` | Distribution A; Loopback0 `10.2.2.2/32` |
| R3-DIST-B | `10.3.3.3` | Distribution B; Loopback0 `10.3.3.3/32` |
| R4-BRANCH | `172.16.40.1` | Loopbacks `172.16.40.1/24` through `172.16.43.1/24`; summarized to `172.16.40.0/22` on both distribution uplinks |
| R5-REMOTE | `172.16.48.1` | Loopbacks `172.16.48.1/24` through `172.16.51.1/24`; summary `172.16.48.0/22` toward R4 |

The branch and remote networks are represented by router loopbacks. They are not separate client LANs with retained endpoint test results.

## Router-to-router addressing

| Network | First endpoint | Second endpoint |
|---|---|---|
| `10.12.0.0/30` | R1 Gi0/0: `10.12.0.1` | R2 Gi0/0: `10.12.0.2` |
| `10.13.0.0/30` | R1 Gi0/1: `10.13.0.1` | R3 Gi0/0: `10.13.0.2` |
| `10.23.0.0/30` | R2 Gi0/1: `10.23.0.2` | R3 Gi0/1: `10.23.0.1` |
| `10.24.0.0/30` | R2 Gi0/2: `10.24.0.2` | R4 Gi0/0: `10.24.0.1` |
| `10.34.0.0/30` | R3 Gi0/2: `10.34.0.1` | R4 Gi0/1: `10.34.0.2` |
| `10.45.0.0/30` | R4 Gi0/2: `10.45.0.1` | R5 Gi0/0: `10.45.0.2` |

The [neighbor captures](verification/neighbors/README.md) show all six relationships. The diagram represents the baseline; the failure cases temporarily change interface state, delay, or summary configuration.

## Policy and observation points

- **R1:** compare two paths to `172.16.40.0/22`, then inspect backup eligibility and replacement routes.
- **R2 and R3:** compare the branch summary with any leaked component routes.
- **R4:** verify that both uplinks carry the same summary and that only the default is advertised toward R5.
- **R5:** verify named EIGRP, stub configuration, the remote summary, and its learned default.

R1–R4 use classic EIGRP metrics. R5's protocol output reports 64-bit metrics and RIB scaling; raw metric values across these representations should not be compared without that context.

## Connections to the wider lab

| Retained configuration | Scope |
|---|---|
| R1 Gi0/3: `10.200.1.1/30`, OSPF Area 0, description toward O1-CORE | R1's static default points to `10.200.1.2`; redistribution is configured |
| R3 Gi0/3: `10.200.2.1/30`, OSPF Area 10 NSSA, description toward O4-EDGE | Redistribution is configured |

These interfaces are outside the six EIGRP links shown. The EIGRP captures include external routes for the transit networks but do not establish complete end-to-end OSPF service or Internet access.

## Capture discrepancy retained

Case 03's R3 recovery excerpt names Gi0/1 for next hop `10.34.0.2`; this addressing table, the configuration, and the general neighbor/routing captures identify Gi0/2. The original excerpt has not been altered. The [case study](troubleshooting/scenario-3-inconsistent-eigrp-summarization.md) explains the limit on its interpretation.

[Configuration guide](configs/README.md) · [Module overview](README.md)
