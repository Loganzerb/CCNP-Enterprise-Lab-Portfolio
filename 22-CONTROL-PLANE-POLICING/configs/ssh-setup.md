# Private SSH setup after import

The public export intentionally omits R1's local account/hash and generated cryptographic identity. Its retained `login local` setting therefore needs private account setup before the original SSH exercise can be attempted. The instructions below are setup guidance, not an execution record.

1. Keep the CML console open. On R1, create your own local privilege-15 account with a strong private secret. Do not commit the credential or a newly exported hash to the public portfolio.
2. Generate fresh RSA host keys on R1, using the retained hostname `R1-CoPP` and domain `copp.lab`. For this IOS XE image, the command `crypto key generate rsa modulus 2048` requests a new 2,048-bit key pair. Existing private-lab key state may require handling locally before generation.
3. Confirm the retained SSH settings: `ip ssh version 2`, VTY 0–4 `login local`, and `transport input ssh`. Verify the SSH service and client reachability before repeating the policer experiment.
4. From CLIENT-A, use the private account to connect to `10.10.10.1`. Check privilege level and compare CoPP counters before and after the connection. Keep credentials, host key material, and authentication output containing secrets out of public evidence.

The [final R1 configuration](R1-CoPP.cfg) retains the 80,000-bps SSH policer and the `CP-PROTECT` input attachment. The lab's reported original recovery results do not prove that this sanitized import has been boot-tested.

R2's saved VTY stanza uses `login`, with SSH transport, but no usable VTY password or private SSH setup is supplied. Remote SSH access to R2 was not established by the handoff and is not required for the documented CoPP tests; use its CML console for inspection.

[Configuration guide](README.md) · [Verification](../verification/README.md) · [Evidence scope](../scope.md) · [Overview](../README.md)
