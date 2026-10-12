# RSPAN — source CLI inspected without transport validation

**Outcome:** the CSR1000v recognized RSPAN source-session CLI and remote-VLAN help. VLAN transport and successful mirroring were not demonstrated.

## Inspect the source CLI

**Recorded configuration command:**

```cisco
monitor session 3 type rspan-source
```

**Recorded command help — remote VLAN:**

```cisco
destination remote vlan ?
  <2-1001>  RSPAN VLAN number
```

## Inspect VLAN configuration availability

**Reported observation:** `vlan ?` in global configuration mode exposed only `accounting`, rather than the conventional VLAN configuration mode needed for a traditional `remote-span` VLAN.

This finding is bounded to the inspected CLI in this CSR1000v exercise. Recognized session syntax and a displayed VLAN-number range do not establish a working RSPAN transport path.

## Retain the validation boundary

No source-to-destination forwarding test was completed. The record supports CLI-capability findings, without packet evidence of VLAN transport or successful RSPAN replication.

[Investigation index](README.md) · [Configurations](../configs/README.md) · [Verification](../verification/README.md) · [Topology](../topology.md) · [Evidence scope](../scope.md) · [Overview](../README.md)
