# Case 03 — Original excerpts and commands

[Read the case study](../../troubleshooting/scenario-3-inconsistent-eigrp-summarization.md) · [Evidence index](README.md)

All fenced blocks from the original case are retained verbatim and in order. They include selected device-output excerpts, documented configuration changes, and command lists. A command list alone does not establish that its result was captured. Section labels are added for navigation.

## Block 1

Baseline

```text
172.16.40.0/22 for Gi0/0, Gi0/1
  Summarizing 4 components
```

## Block 2

Failure Injection

```cisco
configure terminal
interface GigabitEthernet0/1
 no ip summary-address eigrp 100 172.16.40.0 255.255.252.0
end
```

## Block 3

Failure Injection

```text
R4 → R2: 172.16.40.0/22 summary
R4 → R3: 172.16.40.0/24 through 172.16.43.0/24 specifics
```

## Block 4

R3-DIST-B: mixed summary and component routes

```text
Routing entry for 172.16.40.0/24
Known via "eigrp 100", distance 90, type internal
Last update from 10.34.0.2
```

## Block 5

R3-DIST-B: mixed summary and component routes

```text
172.16.40.0/22 via 10.23.0.2
```

## Block 6

R2-DIST-A: mixed summary and component routes

```text
Routing entry for 172.16.40.0/22
Known via "eigrp 100", distance 90, metric 130816, type internal
Last update from 10.24.0.1 on GigabitEthernet0/2

Routing Descriptor Blocks:
  10.24.0.1, from 10.24.0.1, via GigabitEthernet0/2
    Route metric is 130816
    Total delay is 5010 microseconds
    Minimum bandwidth is 1000000 Kbit
    Hops 1
```

## Block 7

R2-DIST-A: mixed summary and component routes

```text
Routing entry for 172.16.40.0/24
Known via "eigrp 100", distance 90, metric 131072, type internal
Last update from 10.23.0.1 on GigabitEthernet0/1

Routing Descriptor Blocks:
  10.23.0.1, from 10.23.0.1, via GigabitEthernet0/1
    Route metric is 131072
    Total delay is 5020 microseconds
    Minimum bandwidth is 1000000 Kbit
    Hops 2
```

## Block 8

Resolution

```cisco
configure terminal
interface GigabitEthernet0/1
 ip summary-address eigrp 100 172.16.40.0 255.255.252.0
end
```

## Block 9

R4-BRANCH

```text
Routing Protocol is "eigrp 100"
EIGRP-IPv4 Protocol for AS(100)

Automatic Summarization: disabled
Address Summarization:
  172.16.40.0/22 for Gi0/0, Gi0/1
    Summarizing 4 components with metric 128256
```

## Block 10

R3-DIST-B

```text
R3-DIST-B#show ip route eigrp | include 172.16.4
D        172.16.40.0 [90/130816] via 10.34.0.2, GigabitEthernet0/1
```

## Block 11

R2-DIST-A

```text
R2-DIST-A#show ip route eigrp | include 172.16.4
D        172.16.40.0/22 [90/130816] via 10.24.0.1, GigabitEthernet0/2
```

