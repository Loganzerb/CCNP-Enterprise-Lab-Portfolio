# NETCONF and RESTCONF configuration

The [sanitized CML export](../CML-LAB.yaml) preserves the two-node topology and the final saved router description, **RESTCONF-EDIT-VERIFIED**. [R1-AUTOMATION.cfg](R1-AUTOMATION.cfg) is an exact extract of the public YAML's router configuration field. Both files omit the original local account and generated PKI material.

**Before import or node startup, prepare a private local copy with your own privilege 15 account.** The retained AAA and HTTP settings use local authentication. The public export contains no replacement account or usable dummy password. After boot, use the console to establish fresh SSH keys and HTTPS certificate material as needed for your image before attempting remote API access.

| Guide or artifact | Purpose |
|---|---|
| [Public CML export](../CML-LAB.yaml) | Original node/image/interface/link definitions with sanitized startup configuration |
| [Router extract](R1-AUTOMATION.cfg) | Retained AAA, API services, and interface settings |
| [Client setup](client-setup.md) | Saved client addressing, local authentication preparation, and available tools |
| [NETCONF procedure](netconf.md) | SSH session, running reads, merge edit, and readback |
| [RESTCONF procedure](restconf.md) | Manual HTTPS GET, description PATCH, and readback |

## Retained router settings

**Selected saved configuration — not captured CLI output.**

```cisco
aaa new-model
aaa authentication login default local
aaa authorization exec default local
ip domain name encor.lab
ip ssh version 2
ip http server
ip http authentication local
ip http secure-server
netconf-yang
restconf
```

The saved configuration retains plain HTTP as well as HTTPS. The demonstrated RESTCONF requests used HTTPS on port 443; NETCONF used the SSH `netconf` subsystem on port 830. HTTP authentication remains local. Sanitization has not changed these service settings.

**Selected saved interface configuration.**

```cisco
interface GigabitEthernet1
 description RESTCONF-EDIT-VERIFIED
 ip address 192.0.2.10 255.255.255.0
 negotiation auto
 no mop enabled
 no mop sysid
```

Gi2–Gi4 remain unaddressed and shutdown. The client and Gi1 share `192.0.2.0/24` directly. See the [exact wiring](../topology.md#physical-wiring).

## Local preparation and import checks

These are **reproduction instructions**, not additional captured results.

1. Make a private working copy of the YAML. Add your own local privilege 15 account to R1's configuration before importing or starting it. Keep that credential-bearing copy outside the public portfolio.
2. Import using compatible `desktop-3-13-2-xfce` and `csr1000v-170302` images. Confirm client eth0 connects to router Gi1.
3. Use the router console to generate fresh SSH keys and a local HTTPS certificate appropriate to the image. The source trustpoints, certificate chains, and account were removed; their old identity and secrets are not reusable setup artifacts in this export.
4. Inspect the client address and Linux-to-router reachability. On R1, inspect SSH version, NETCONF status, HTTP/HTTPS status, and Gi1. Expected settings and the original observations are separated in [verification](../verification/README.md).
5. Follow the protocol guides, compare each write with its readback, and inspect the router's interface configuration independently. Reusing the final export begins with `RESTCONF-EDIT-VERIFIED`; earlier descriptions belong to the historical test sequence.

Fresh import, API execution from the sanitized files, an executed configuration save, and reboot persistence have not been validated during portfolio preparation. The supplied exchanges establish observed running configuration; they do not establish the outcome of these new setup steps.

## Public export preparation

Sanitization removed the local account command, complete PKI trustpoint/certificate blocks, a license/device identifier, call-home configuration, and generated display headers/comments. All node, image, interface, and link metadata remain unchanged. The retained router commands and client address initialization are preserved, and the router extract matches the public YAML. No replacement secret or saved API client script was added.

[Overview](../README.md) · [Topology](../topology.md) · [Operation](../operation.md) · [Verification](../verification/README.md) · [Evidence scope](../scope.md)
