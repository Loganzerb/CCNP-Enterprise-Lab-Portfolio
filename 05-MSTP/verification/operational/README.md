# Operational behavior

IOS reported `Configured Pathcost method used is short (Operational value is long)` in MST mode. One-gigabit links therefore appeared with operational cost `20000`. MST BPDUs used configured Max Hops 20; adjacent and two-hop observations showed `rem hops 19` and `18`.

The lab also caught `P2p Dispute` during active reconvergence on MST3. Repeating the command showed normal forwarding afterward. This is retained as a **transient observation**, not diagnosed as a persistent fault.
