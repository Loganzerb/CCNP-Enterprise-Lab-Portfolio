# Verification evidence

This tree organizes observed IOS output by engineering question. Raw-style text is preserved where the console output was captured. Context files explain why each command matters and avoid treating transient experiment states as the final baseline.

- `region/`: region parameters and digest
- `instances/`: MST0, MSTI 1, and MSTI 2 operation
- `root-engineering/`: intended root placement and access path selection
- `boundary-master/`: separate-region behavior, external CIST root, and Master Ports
- `region-mismatch/`: revision, mapping/digest, and name mismatch signatures
- `pvst-simulation/`: Rapid PVST+ boundary, inconsistency, logs, and recovery
- `operational/`: Max Hops, long costs, and transient Dispute
