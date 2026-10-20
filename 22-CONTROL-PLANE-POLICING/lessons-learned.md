# CoPP lessons learned

| Engineering distinction | What the lab record supports |
|---|---|
| Classification versus policing | COPP-SSH and COPP-OSPF select traffic for their classes; the policer rate and actions decide its treatment |
| Management traffic versus transit traffic | R1 SSH and peer OSPF reach the control plane; the endpoint ICMP path depends on routing rather than matching those two classes |
| Working authentication versus a restrictive rate | SSH worked at 80 kbps, exceeded packets appeared at 8 kbps, and authenticated access recovered after restoration |
| Historical totals versus new drops | The recovery test added 66 conforming packets while the exceeded count remained 10 |
| Conforming versus transmitted | A conform-drop action discarded OSPF traffic despite leaving the 1-Mbps CIR unchanged |
| Policy repair versus service recovery | OSPF adjacency, route reinstallation, and endpoint ICMP checked successive recovery dependencies |
| Cumulative counters versus fault-specific counts | OSPF conform totals cannot establish exactly how many packets the temporary conform-drop action discarded |
| Saved configuration versus runtime history | The export retains final policy and routing settings; counters and failure/recovery observations remain reported results |
| Startup inspection versus reload validation | Both startup configurations were reportedly inspected; no router reload was performed |
| Publication security versus a ready SSH service | Sanitization removes authentication and cryptographic material, so SSH requires local setup before retesting |

The [SSH case](troubleshooting/01-ssh-policer-exhaustion.md) and [OSPF case](troubleshooting/02-ospf-conform-action.md) demonstrate two different policy errors: an allowance that is too restrictive for the tested management session, and an incorrect action for traffic within its allowance. The lab's numeric rates describe those experiments rather than a general sizing recommendation.

[Overview](README.md) · [Verification](verification/README.md) · [Final state](verification/final-state.md) · [Troubleshooting](troubleshooting/README.md) · [Configurations](configs/README.md) · [Operation](operation.md) · [Topology](topology.md) · [Evidence scope](scope.md)
