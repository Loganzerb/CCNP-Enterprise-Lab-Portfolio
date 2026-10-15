# Automation client and local setup

LINUX-AUTOMATION uses the saved CML desktop image `desktop-3-13-2-xfce`. Its eth0 connects directly to R1 Gi1. The captured terminal shows `192.0.2.20/24`, a connected route to `192.0.2.0/24`, and available SSH and OpenSSL clients. [Client addressing and tools](../verification/connectivity-and-services.md#block-01)

## Saved client startup configuration

**Saved YAML configuration — not a boot or reboot transcript.**

```sh
# NETCONF/RESTCONF Automation Client
# Interface: eth0
# Address: 192.0.2.20/24

ip link set dev eth0 up
ip addr show dev eth0 | grep -q 'inet 192.0.2.20/24' || ip addr add 192.0.2.20/24 dev eth0

# Set Linux hostname
hostname linux-automation
```

The export contains this address initialization. A fresh import or reboot executing it has not been tested. Inspect eth0 and the connected route after starting the client; the historical terminal check does not substitute for that new startup check.

## Prepare private access before starting the lab

Add your own privilege 15 account to a **private local copy** of R1's startup configuration before import or startup. The public YAML keeps AAA local and HTTP local authentication but removes the original account entirely.

**Reproduction template — replace both placeholders locally. This is not captured source configuration and is not included in the public YAML.**

```cisco
username <LOCAL_ADMIN> privilege 15 secret <YOUR_LOCAL_SECRET>
```

Use the console after boot to generate fresh SSH keys and HTTPS certificate material appropriate to the image, then inspect the service state. The sanitized export does not carry the source PKI identity or secrets. These local setup actions are pending runtime validation.

## Use the demonstrated clients

NETCONF used manual SSH to the `netconf` subsystem. RESTCONF used manually constructed HTTP/1.1 requests carried by OpenSSL over TLS. The recorded checks found SSH and OpenSSL; `curl` and `python3` returned no PATH entry at that time. No Python or curl automation script is included in the saved client configuration.

| Check or method | Reference |
|---|---|
| Inspect addressing and tools | [Captured client checks](../verification/connectivity-and-services.md#block-01) |
| Check Linux-to-router reachability | [Captured 5/5 ping](../verification/connectivity-and-services.md#block-02) |
| Connect to NETCONF on 830 | [NETCONF procedure](netconf.md) |
| Carry manual HTTP over TLS on 443 | [Recorded transport command](../verification/restconf.md#manual-https-transport) and [RESTCONF procedure](restconf.md) |
| Inspect TLS status | [Captured handshake selection](../verification/connectivity-and-services.md#block-15) |

The historical TLS connection negotiated TLS 1.2 and reported a self-signed certificate verification error. It establishes the negotiated transport, not trusted certificate validation. No router-to-client ping summary is supplied.

[Configuration index](README.md) · [NETCONF](netconf.md) · [RESTCONF](restconf.md) · [Topology](../topology.md) · [Evidence scope](../scope.md)
