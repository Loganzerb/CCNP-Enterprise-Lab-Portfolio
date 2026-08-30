# Protection verification

The lab exercised edge protection and topology-protection features individually so their outcomes could be distinguished:

- BPDU Guard: err-disables a protected edge port after receiving a BPDU.
- Root Guard: places a port in root-inconsistent after a superior BPDU.
- Loop Guard: places an affected STP instance in loop-inconsistent when expected BPDUs disappear.
- EtherChannel misconfiguration guard: enabled in the retained switch summary.

Use `show spanning-tree inconsistentports`, `show interfaces status err-disabled`, interface detail, and logging together. No full retained output for the first three failure tables was available, so their exact evidence is not fabricated here.
