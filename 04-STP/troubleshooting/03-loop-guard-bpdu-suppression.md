# Case 03 — Loop Guard after BPDU suppression

## Failure injection

BPDU reception was suppressed on a link/instance where the local non-designated port was expected to continue receiving BPDUs while the physical link remained up.

## Observed behavior

Loop Guard prevented the port from aging into forwarding and placed the affected instance in `loop-inconsistent`.

## Diagnosis

```text
show spanning-tree inconsistentports
show spanning-tree interface <interface> detail
show logging
```

The critical distinction was “link up, expected BPDUs missing,” rather than a physical link failure.

## Recovery

Restore bidirectional BPDU delivery and remove the suppression condition. Loop Guard automatically returns the instance to normal STP processing once valid BPDUs resume.

## Lesson

Loop Guard protects a port role that depends on received BPDUs. It is not an edge-port feature and does not err-disable the physical interface.
