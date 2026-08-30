# Case 02 — Root Guard and `root-inconsistent`

## Failure injection

SW5-ROGUE advertised a superior bridge ID toward an interface where the existing design required the local distribution layer to remain designated/root-facing authority.

## Observed behavior

The guarded interface entered `root-inconsistent`. The interface was not err-disabled; Root Guard blocked the superior-root condition for the affected STP instance.

## Diagnosis

```text
show spanning-tree inconsistentports
show spanning-tree vlan <id>
show spanning-tree interface <interface> detail
show logging
```

## Recovery

The condition cleared automatically after the superior BPDUs stopped—either because the rogue priority was restored or the rogue connection was removed.

## Lesson

Root Guard is a topology-policy control: superior BPDU in, `root-inconsistent` until the superior condition disappears.
