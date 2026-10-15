# 19 — NETCONF and RESTCONF: Change configuration and verify the result

I enabled NETCONF and RESTCONF on a router, retrieved its configuration, and used each protocol to change the same interface-description field. NETCONF changed the description to `NETCONF-EDIT-VERIFIED`; RESTCONF then read that value and changed it to `RESTCONF-EDIT-VERIFIED`. Protocol readback and independent CLI checks confirmed both changes while the management address remained **192.0.2.10/24** and GigabitEthernet1 stayed **up/up**.

This Cisco Modeling Labs exercise aligns with **CCNP ENCOR 350-401 v1.2, objective 4.6 — Configure and verify NETCONF and RESTCONF**. The objective was to connect management-service configuration, model-based requests, and verification of the resulting running configuration.

**Quick navigation:** [Results](#recorded-results) · [Topology](#lab-design) · [Process diagrams](operation.md) · [Configurations](configs/README.md) · [Verification matrix](verification/README.md) · [NETCONF evidence](verification/netconf.md) · [RESTCONF evidence](verification/restconf.md) · [Evidence scope](scope.md)

## Recorded results

| Verification question | Recorded outcome |
|---|---|
| Could Linux reach the router? | **5/5 replies**, **0% loss** in the retained Linux-to-router test |
| Was NETCONF available? | SSH version **2**, NETCONF enabled on **TCP 830**, server/client hello exchange, candidate datastore explicitly **disabled** |
| Did NETCONF retrieve and change configuration? | Hostname and interface reads succeeded; running/merge edit **103** returned `<ok/>`; readback **104** and CLI confirmed the new description |
| Could RESTCONF read the NETCONF change? | Hostname and description GETs returned **HTTP 200**; the description was `NETCONF-EDIT-VERIFIED` |
| Did RESTCONF change the existing leaf? | PATCH returned **HTTP 204**; subsequent GET returned **HTTP 200** with `RESTCONF-EDIT-VERIFIED`; CLI independently confirmed it |
| What transport was negotiated? | **TLS 1.2** over HTTPS/443; OpenSSL also reported a **self-signed certificate verification error** |
| Did the management interface retain its configuration and state? | Both CLI stages show the retained address and **up/up** status |

The [verification matrix](verification/README.md) links each task to the original numbered evidence Blocks. The excerpts are supplied, redacted records of the October 14, 2026 session; no fresh lab execution is represented. TLS negotiation succeeded, but trusted certificate validation was not established.

## Lab design

![Direct management link between the automation client and CSR1000v router](topology.svg)

[PNG copy](topology.png) · [Addresses and wiring](topology.md) · [Sanitized CML export](CML-LAB.yaml)

R1-AUTOMATION runs CSR1000v / IOS XE 17.3.2. Its Gi1 address, `192.0.2.10/24`, connects directly to LINUX-AUTOMATION eth0 at `192.0.2.20/24`. The saved client image is CML's `desktop-3-13-2-xfce`; the lab terminal identifies Alpine tooling.

The client used SSH for NETCONF and manually constructed HTTP requests carried by OpenSSL for RESTCONF. The recorded `command -v` checks returned no path for curl or Python 3, so the exercise used tools already available in that session.

## Implementation approach

| Stage | Engineering purpose |
|---|---|
| Establish management access | Configure addressing, local AAA, a privilege-15 account, and SSH version 2 |
| Enable NETCONF | Use `netconf-yang`, inspect service/capability state, then retrieve and merge a change into running |
| Enable RESTCONF | Use `restconf`, HTTPS, and local HTTP authentication; retrieve and PATCH the same modeled description leaf |
| Verify each change | Read the configuration back through the protocol and independently inspect the router CLI |

Both protocols used **Cisco-IOS-XE-native** to identify hostname and GigabitEthernet list entry `1`. NETCONF expressed the hierarchy in XML; RESTCONF used a keyed resource path and YANG-JSON. They managed the same router configuration. [NETCONF procedure](configs/netconf.md) · [RESTCONF procedure](configs/restconf.md)

## Engineering interpretation

An acknowledgement is one checkpoint: `<ok/>` or HTTP 204 confirms a successful response, while readback and CLI establish the observed configuration. The address and interface state checks show that this description change preserved the management connection at both verification stages.

The server advertised NETCONF base 1.0 and 1.1 plus additional capabilities. This session used **base 1.0 framing** and a running/merge edit; advertised rollback, validate, XPath, and notification capabilities were not separately exercised. [NETCONF evidence](verification/netconf.md)

The record also retains an earlier HTTP 401 and an initial ping with one lost packet. These are [setup observations](verification/setup-observations.md), with their evidence limits preserved. No cause is inferred for the initial ping loss.

## Reuse and remaining validation

The public export removes saved credentials, certificate material, and device-specific identifiers. [Local setup requirements](configs/README.md) explain the replacement account and fresh key/certificate requirements. The saved router enabled HTTP/80 as well as HTTPS/443; the demonstrated RESTCONF requests used HTTPS.

**Still unverified:** a separate router-to-Linux ping summary, executed save/reboot persistence, and a fresh import/boot/run of the sanitized CML file. The NETCONF readback request and PATCH body assignment have prescribed portions that remain explicitly labeled alongside their captured replies. [Evidence scope](scope.md)

[Lessons learned](lessons-learned.md) · [Back to portfolio](../README.md) · [Portfolio reading guide](../READING-GUIDE.md)
