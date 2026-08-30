# Case 07 — EtherChannel misconfiguration guard err-disable

## Failure injection

Links that the local switch treated as one static logical bundle were connected/configured so the remote side did not represent the same logical neighbor relationship.

## Observed behavior

EtherChannel misconfiguration guard detected inconsistent control traffic and err-disabled the unsafe member links. The retained `show spanning-tree summary` confirms the guard was enabled in this image.

## Diagnosis

```text
show interfaces status err-disabled
show etherchannel summary
show logging
show running-config interface <member>
```

## Recovery

Correct the physical partner mapping and channel configuration first. Then recover the interfaces administratively and confirm both members bind to the intended aggregator.

## Lesson

This is a topology-safety failure, not merely an LACP passive/passive negotiation failure. Passive/passive suspends members; misconfiguration guard can err-disable them.
