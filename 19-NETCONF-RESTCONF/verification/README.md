# NETCONF and RESTCONF verification guide

The October 14, 2026 CML record connects structured configuration reads, two description edits, protocol readback, and independent router CLI checks. GigabitEthernet1 progressed from `NETCONF-RESTCONF-LAB` to `NETCONF-EDIT-VERIFIED`, then `RESTCONF-EDIT-VERIFIED`, while retaining `192.0.2.10/24` and up/up state.

**Quick navigation:** [Task-to-evidence matrix](#task-to-evidence-matrix) · [Read the evidence](#read-the-evidence) · [Setup observations](setup-observations.md)

## Task-to-evidence matrix

Original Block IDs are retained across the linked pages. A Block may contain more than one supplied fence.

| Verification task | Evidence | What the record establishes |
|---|---|---|
| Check client prerequisites and connectivity | [01](connectivity-and-services.md#block-01), [02](connectivity-and-services.md#block-02) | Linux address/route and available tools; Linux-to-router ping 5/5, 0% loss |
| Check NETCONF service and datastore | [03](connectivity-and-services.md#block-03) | SSH 2.0, NETCONF enabled on 830, candidate explicitly disabled |
| Establish the NETCONF session and read hostname | [04](netconf.md#block-04), [05](netconf.md#block-05) | Server capabilities; base 1.0 client framing; running hostname `R1-AUTOMATION` |
| Read the original interface configuration | [06](netconf.md#block-06) | Gi1 description and management address from running |
| Change the running description | [07](netconf.md#block-07) | Captured merge edit, message 103, and matching `<ok/>` |
| Verify the NETCONF change | [08](netconf.md#block-08), [09](netconf.md#block-09) | Captured readback and CLI agree; message 104 request is prescribed |
| Check HTTPS and negotiated TLS | [14](connectivity-and-services.md#block-14), [15](connectivity-and-services.md#block-15) | HTTPS 443 and TLS 1.2; self-signed verification error retained |
| Read configuration through RESTCONF | [10](restconf.md#block-10), [11](restconf.md#block-11) | HTTP 200 hostname and the description previously written through NETCONF |
| Patch and verify the description | [12](restconf.md#block-12), [13](restconf.md#block-13), [16](restconf.md#block-16) | HTTP 204, then HTTP 200 and CLI with the final description; BODY assignment is prescribed |
| Retain earlier setup results | [17](setup-observations.md#block-17) | Initial 25% ping loss and HTTP 401, separate from the later successful checks |

## Read the evidence

The supplied excerpts are redacted and editorially formatted: wrapped tokens were rejoined, selected XML may be indented, and HTTP fragments decode shell line-ending escapes. They are readable terminal excerpts, not packet captures or a fresh lab run. `[REDACTED]` and marked omissions are editorial replacements.

Captured output and prescribed requests are labeled locally. Block 08's request and Block 12's BODY assignment were not echoed in their user captures; their replies and later readbacks were captured. The [scope guide](../scope.md) records capability, connectivity, certificate, and persistence limits.

[Overview](../README.md) · [Configurations](../configs/README.md) · [Operation](../operation.md) · [Topology](../topology.md) · [Lessons learned](../lessons-learned.md) · [Evidence scope](../scope.md)
