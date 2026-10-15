# Earlier setup observations

The successful protocol checks followed two earlier results retained in the source: one lost Linux ping probe and an unauthorized hostname GET. This page records those observations without creating a new fault scenario or assigning an unproven cause.

**Quick navigation:** [Earlier results](#earlier-results) · [What the comparison establishes](#what-the-comparison-establishes)

## Earlier results

<a id="block-17"></a>

### Block 17 — Earlier setup results preserved separately

**Captured earlier results.** The four-probe ping receives three replies, with 25% loss. The earlier HTTPS hostname GET returns HTTP 401, an access-denied response, and a router authentication-failure log.

Earlier Linux ping excerpt:

```text
inserthostname_here:~$ ping -c 4 192.0.2.10
--- 192.0.2.10 ping statistics ---
4 packets transmitted, 3 packets received, 25% packet loss
round-trip min/avg/max = 0.820/0.983/1.304 ms
```

Earlier GET response and authentication log:

```text
GET /restconf/data/Cisco-IOS-XE-native:native/hostname HTTP/1.1
Authorization: Basic [REDACTED]

HTTP/1.1 401 Unauthorized
Server: openresty
Date: Wed, 14 Oct 2026 23:48:34 GMT
Content-Type: application/yang-data+json
Transfer-Encoding: chunked
Connection: close
WWW-Authenticate: Basic realm="restconf"
Vary: Accept-Encoding

82
{
  "errors": {
    "error": [
      {
        "error-tag": "access-denied",
        "error-type": "protocol"
      }
    ]
  }
}

0

*Oct 14 23:48:34.745: %DMI-5-AUTHENTICATION_FAILED: R0/0: dmiauthd: Authentication failure from 192.0.2.20:0 for rest over http.
```

## What the comparison establishes

The later [five-probe Linux test](connectivity-and-services.md#block-02) has zero loss. The initial loss cause is not established; these short tests do not measure long-term reliability.

The lab instruction prescribed rebuilding the Basic authentication value, and the later [hostname GET](restconf.md#block-10) returns 200. Credentials and encoding steps were excluded. The retained evidence does not isolate an incorrect password, encoding error, or other precise cause. The router's `rest over http` log wording is preserved; the printed client transport used TLS on port 443.

[Verification index](README.md) · [Overview](../README.md) · [Configurations](../configs/README.md) · [Operation](../operation.md) · [Topology](../topology.md) · [Evidence scope](../scope.md)
