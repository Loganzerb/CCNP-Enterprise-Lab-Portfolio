# Troubleshooting evidence index

## Direct trunk failure

`direct-trunk-*` captures show the SW3–SW4 Gi0/2 failure, the convergence outage, MAC learning across Po20 → Po10 → Po30, and movement back to Gi0/2 after restoration.

## LACP member failure

`lacp-member-*` captures show Po20 surviving a single failed member, 0% ping loss, and PVST cost changing from 3 to 4 and back to 3.

## Member consistency

`vlan-mask-mismatch-*` captures show the `%EC-5-CANNOT_BUNDLE2` diagnostic, the suspended member, the mismatched VLAN list, and recovery.

## IOSv `max-bundle` anomaly

`max-bundle-*` captures show correct-looking active/hot-standby control-plane state alongside failed traffic and zero received BPDUs, followed by recovery after removing the feature.

## Capability and cleanup checks

The remaining files preserve the CLI capability checks and cleanup evidence for LACP options, hashing options, standalone-disable behavior, LACP system-priority renegotiation, and temporary routed Port-channel40.

No failure output was recreated for tests whose raw console capture was not available in the retrieved evidence set.
