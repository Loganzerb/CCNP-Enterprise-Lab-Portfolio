# ERSPAN configuration and reproduction

The [sanitized CML export](../CML-LAB.yaml) preserves the final ERSPAN lab. These router files are extracts of its configuration fields, not newly reconstructed running configurations.

| Artifact | Role |
|---|---|
| [R1-ERSPAN.cfg](R1-ERSPAN.cfg) | Transit addressing, endpoint host routes, and ERSPAN source session 1 |
| [R2-SOURCE.cfg](R2-SOURCE.cfg) | Source loopback and default route toward R1 |
| [R3-DEST.cfg](R3-DEST.cfg) | Destination loopback and default route toward R1 |
| [Collector setup](collector.md) | Interactive IPv4 address and packet-inspection commands |

## Routing foundation

R1 has host routes for `10.10.10.10/32` through `10.12.12.2` and `10.20.20.20/32` through `10.13.13.2`. R2 and R3 use default routes toward R1. R1's collector-facing Gi3 is directly connected to `10.30.30.0/30`.

This separates endpoint reachability from mirror delivery. A successful R2-to-R3 ping tests the original traffic path; it does not establish that Alpine received a mirrored copy.

## Source-session settings

**Saved configuration excerpt — R1 YAML.**

```cisco
monitor session 1 type erspan-source
 description ENCOR-ERSPAN-LAB
 source interface Gi1
 destination
  erspan-id 100
  ip address 10.30.30.2
  origin ip address 10.30.30.1
```

| Setting | Purpose |
|---|---|
| Session 1 / `erspan-source` | Copies traffic at the source router for remote inspection |
| Gi1 | R2-facing interface; the final operational state confirmed both directions |
| Destination `10.30.30.2` | Alpine collector receiving the outer GRE packets |
| Origin `10.30.30.1` | Source address in the outer IPv4 header |
| ERSPAN ID 100 | Identifies the mirrored ERSPAN session; distinct from the local session number 1 |

**Working session commands — lab record.** These are commands used during configuration, rather than output or the exact serialization of the export.

```cisco
monitor session 1 type erspan-source
 description ENCOR-ERSPAN-LAB
 source interface GigabitEthernet1 both
 destination
  erspan-id 100
  ip address 10.30.30.2
  origin ip address 10.30.30.1
 exit
 no shutdown
```

The saved source line omits `both`; the selected operational output records `Both : Gi1`. The export also omits an explicit session `no shutdown`, while the recorded output shows Admin Enabled. Preserve the saved configuration and inspect operational state after import. [Bidirectional verification](../verification/bidirectional.md)

## Reproduce the exercise

These are reproduction instructions for the saved lab. They have not been executed as a fresh import during documentation preparation.

1. Import `CML-LAB.yaml` into CML with compatible CSR1000v, IOSv, and Alpine images. Start the four nodes using local access settings; check the [wiring and addresses](../topology.md).
2. Confirm tcpdump is available on Alpine. Follow [collector setup](collector.md) to inspect eth0 and restore `10.30.30.2/30` if missing. The export does not persist that address or provide login variables.
3. On R1, inspect interfaces, static routes, and `show monitor session 1`. Confirm Gi1, destination/origin addresses, ID 100, and an enabled source session. Apply the working commands above if operational state needs restoring.
4. Verify R1-to-collector reachability, then generate R2 loopback traffic toward R3's loopback. The command examples below reproduce the recorded test targets; they are not supplied console transcripts.

```cisco
! R1-ERSPAN
ping 10.30.30.2 repeat 10
! R2-SOURCE
ping 10.20.20.20 source 10.10.10.10 repeat 100
```

5. For the RX-only stage, set session 1's source to `GigabitEthernet1 rx` in monitor-session configuration mode. Start the recorded GRE capture on Alpine before generating traffic. Inspect a separate five-packet hexadecimal selection using the command in [RX payload verification](../verification/rx-payload.md).
6. Restore `GigabitEthernet1 both`, confirm `Both : Gi1`, and repeat the R2 test with ten probes. Inspect inner source/destination addresses and ICMP types to distinguish requests from replies. [Bidirectional evidence](../verification/bidirectional.md)

Capture counts and sequence numbers depend on capture timing and other mirrored traffic; the recorded 101 and 12 are observations from the completed runs, not required values for every rebuild. Alpine receives GRE directly. No Cisco ERSPAN destination session is required for the packet inspection performed here.

## Saved scope and portability

Local SPAN and RSPAN tests are documented under [capability investigations](../investigations/README.md). Their temporary configurations and Gi4 test wiring were not added to this export.

[Public export checks](../scope.md#public-export-and-portability) document sanitization and import limits. The three router configuration files match the public YAML.

[Verification guide](../verification/README.md) · [Collector setup](collector.md) · [Topology](../topology.md) · [Overview](../README.md)
