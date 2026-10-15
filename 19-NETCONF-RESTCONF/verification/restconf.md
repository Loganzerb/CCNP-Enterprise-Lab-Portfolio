# RESTCONF: read, patch, and verify the description

The client constructed HTTP/1.1 requests manually and carried them over TLS using OpenSSL. RESTCONF first read the description written through NETCONF, then changed it to `RESTCONF-EDIT-VERIFIED`; GET readback and router CLI confirm the resulting state.

**Quick navigation:** [Manual HTTPS transport](#manual-https-transport) · [Read the resources](#read-the-resources) · [Patch and read back](#patch-and-read-back) · [Independent CLI](#independent-cli)

## Manual HTTPS transport

**Captured transport reference from the supplied excerpts.** The separate [TLS evidence](connectivity-and-services.md#block-15) retains the self-signed verification error. This command is not a curl or Python test.

```text
openssl s_client -connect 192.0.2.10:443 -tls1_2 -quiet 2>/dev/null
```

## Read the resources

<a id="block-10"></a>

### Block 10 — RESTCONF hostname GET, HTTP 200

**Captured request fragment and response.** Shell line-ending escapes were decoded editorially. The hostname GET returns HTTP 200 and `R1-AUTOMATION`; authentication is redacted.

```text
GET /restconf/data/Cisco-IOS-XE-native:native/hostname HTTP/1.1
Host: 192.0.2.10
Accept: application/yang-data+json
Authorization: Basic [REDACTED]
Connection: close
```

```text
HTTP/1.1 200 OK
Server: openresty
Date: Wed, 14 Oct 2026 23:53:12 GMT
Content-Type: application/yang-data+json
Transfer-Encoding: chunked
Connection: close

36
{
  "Cisco-IOS-XE-native:hostname": "R1-AUTOMATION"
}

0
```

<a id="block-11"></a>

### Block 11 — RESTCONF interface-description GET before PATCH, HTTP 200

**Captured request fragment and response.** The keyed Gi1 description resource returns HTTP 200 with `NETCONF-EDIT-VERIFIED`, connecting this read to the earlier NETCONF change.

```text
GET /restconf/data/Cisco-IOS-XE-native:native/interface/GigabitEthernet=1/description HTTP/1.1
Host: 192.0.2.10
Accept: application/yang-data+json
Authorization: Basic [REDACTED]
Connection: close
```

```text
HTTP/1.1 200 OK
Server: openresty
Date: Wed, 14 Oct 2026 23:54:13 GMT
Content-Type: application/yang-data+json
Transfer-Encoding: chunked
Connection: close

41
{
  "Cisco-IOS-XE-native:description": "NETCONF-EDIT-VERIFIED"
}

0
```

## Patch and read back

<a id="block-12"></a>

### Block 12 — RESTCONF description PATCH and HTTP 204

**Prescribed payload; captured request-template fragments and response.** The body assignment was supplied by the lab instruction. The captured shell command references the variable and its length without expanding the transmitted body. The `%s` Content-Length placeholder is preserved; no numeric transmitted length is reconstructed.

Prescribed body assignment:

```sh
BODY='{"Cisco-IOS-XE-native:description":"RESTCONF-EDIT-VERIFIED"}'
```

Captured request-template fragment:

```text
PATCH /restconf/data/Cisco-IOS-XE-native:native/interface/GigabitEthernet=1/description HTTP/1.1
Host: 192.0.2.10
Authorization: Basic [REDACTED]
Content-Type: application/yang-data+json
Accept: application/yang-data+json
Content-Length: %s
Connection: close
```

Captured shell argument references and transport:

```text
"${#BODY}" "$BODY" | openssl s_client -connect 192.0.2.10:443 -tls1_2 -quiet 2>/dev/null
```

Captured response:

```text
HTTP/1.1 204 No Content
Server: openresty
Date: Wed, 14 Oct 2026 23:56:20 GMT
Content-Type: text/html
Content-Length: 0
Connection: close
Last-Modified: Wed, 14 Oct 2026 23:56:19 GMT
Cache-Control: private, no-cache, must-revalidate, proxy-revalidate
Etag: "1792-22179-835331"
Pragma: no-cache
```

<a id="block-13"></a>

### Block 13 — RESTCONF description readback GET, HTTP 200

**Captured request fragment and response.** The same resource now returns `RESTCONF-EDIT-VERIFIED`. The description sequence is HTTP 200 before PATCH, HTTP 204 for PATCH, then HTTP 200 for readback. The captured `36`, `41`, `42`, and terminal `0` response lines are chunked-transfer framing, not JSON fields.

```text
GET /restconf/data/Cisco-IOS-XE-native:native/interface/GigabitEthernet=1/description HTTP/1.1
Host: 192.0.2.10
Accept: application/yang-data+json
Authorization: Basic [REDACTED]
Connection: close
```

```text
HTTP/1.1 200 OK
Server: openresty
Date: Wed, 14 Oct 2026 23:57:24 GMT
Content-Type: application/yang-data+json
Transfer-Encoding: chunked
Connection: close

42
{
  "Cisco-IOS-XE-native:description": "RESTCONF-EDIT-VERIFIED"
}

0
```

## Independent CLI

<a id="block-16"></a>

### Block 16 — Independent CLI after the RESTCONF change

**Captured router CLI.** The final running description agrees with RESTCONF readback. Gi1 retains `192.0.2.10/24` and up/up state; the excerpt does not establish a saved startup configuration or reboot persistence.

```text
R1-AUTOMATION#show running-config interface GigabitEthernet1
Building configuration...

Current configuration : 155 bytes
!
interface GigabitEthernet1
 description RESTCONF-EDIT-VERIFIED
 ip address 192.0.2.10 255.255.255.0
 negotiation auto
 no mop enabled
 no mop sysid
end

R1-AUTOMATION#show ip interface brief
Interface              IP-Address      OK? Method Status                Protocol
GigabitEthernet1       192.0.2.10      YES manual up                    up
GigabitEthernet2       unassigned      YES unset  administratively down down
GigabitEthernet3       unassigned      YES unset  administratively down down
GigabitEthernet4       unassigned      YES unset  administratively down down
R1-AUTOMATION#
```

[NETCONF evidence](netconf.md) · [Earlier setup observations](setup-observations.md) · [Verification index](README.md) · [Overview](../README.md) · [Configurations](../configs/README.md) · [Operation](../operation.md) · [Topology](../topology.md) · [Evidence scope](../scope.md)
