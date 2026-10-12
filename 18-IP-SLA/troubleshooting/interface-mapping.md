# Interface mapping — verify the actual connection

**Reported outcome:** a directly connected ping failed during setup. CDP was used to identify the actual R4 interface connections, and R4's interface addressing was corrected to match them.

**Quick navigation:** [Diagnosis](#reported-diagnosis) · [Correct mapping](#correct-interface-mapping) · [Evidence boundary](#evidence-boundary)

## Reported diagnosis

The initial assumption placed R2's connection on R4 Gi0/0. When the directly connected ping failed, the engineer used `show cdp neighbors` to inspect the physical neighbor/interface relationship. The supplied lab record identifies the opposite R4 port assignment from that assumption.

## Correct interface mapping

| Provider link | Actual target interface | Provider address | Target address |
|---|---|---|---|
| R2-ISP-A Gi0/1 | R4-TARGET Gi0/1 | `10.24.24.1/30` | `10.24.24.2/30` |
| R3-ISP-B Gi0/1 | R4-TARGET Gi0/0 | `10.34.34.1/30` | `10.34.34.2/30` |

These relationships are preserved in the [topology](../topology.md) and [device configurations](../configs/README.md). The addressing follows the verified cabling rather than an assumed interface-number order.

## Evidence boundary

The failed ping, CDP diagnosis, and addressing correction are reported in the supplied lab record. No raw ping or CDP output was supplied, so this page contains no reconstructed CLI transcript or numbered evidence block. The corrected mapping is retained for reproduction; documentation checks do not establish a fresh CML import or boot.

[Case index](README.md) · [Threshold and timeout](threshold-timeout.md) · [Lessons learned](../lessons-learned.md) · [Verification](../verification/README.md) · [Configurations](../configs/README.md) · [Topology](../topology.md) · [Operation](../operation.md) · [Evidence scope](../scope.md) · [Overview](../README.md)
