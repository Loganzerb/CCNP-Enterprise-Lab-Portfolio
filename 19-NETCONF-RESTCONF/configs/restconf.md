# RESTCONF — GET, PATCH, and read back one description

The demonstrated RESTCONF exchanges used manually assembled HTTP/1.1 requests through **OpenSSL on HTTPS port 443**. They read the Cisco native hostname and Gi1 description, PATCHed that description, and read it again. Independent router CLI confirmed the final running state.

## Identify the resource and representation

| Resource or field | Role |
|---|---|
| `/restconf/data/Cisco-IOS-XE-native:native/hostname` | Native hostname leaf |
| `/restconf/data/Cisco-IOS-XE-native:native/interface/GigabitEthernet=1/description` | Description leaf in GigabitEthernet list entry keyed by `1` |
| `application/yang-data+json` | JSON representation requested and supplied for the modeled data |
| `Cisco-IOS-XE-native:description` | Qualified JSON member for the selected leaf |
| `RESTCONF-EDIT-VERIFIED` | Final description in the saved export and captured readback |

The keyed URI and qualified JSON member identify the modeled leaf being changed. This was a description edit, not a replacement of the whole interface or a test of another RESTCONF resource.

## Repeat the demonstrated requests

**Reproduction procedure — not a new captured exchange.** Complete [private authentication and certificate setup](client-setup.md) first. Use the [manual HTTPS transport reference](../verification/restconf.md#manual-https-transport) and substitute locally prepared authentication; redacted source Authorization fields are editorial placeholders.

1. Assemble the hostname GET with the resource path, Host header, JSON Accept header, local Authorization value, and Connection close. Separate HTTP headers and body with the required blank line. The [captured hostname exchange](../verification/restconf.md#block-10) records its successful response.
2. GET the keyed description resource before writing it. In the original sequence, this returned the description previously written through NETCONF. Reusing the final saved export instead begins with `RESTCONF-EDIT-VERIFIED`. [Pre-PATCH GET](../verification/restconf.md#block-11)
3. Use the prescribed JSON body in [Block 12](../verification/restconf.md#block-12) to set the description to `RESTCONF-EDIT-VERIFIED`. Assemble a PATCH to the description resource with JSON Content-Type/Accept and a Content-Length matching the body actually sent. The source command's `%s` is a formatting placeholder; it is not a numeric on-wire length to copy into a request.
4. Inspect the PATCH response, then GET the same leaf and compare its JSON value. Finish with the router's interface configuration and status. [Readback GET](../verification/restconf.md#block-13) · [Independent CLI](../verification/restconf.md#block-16)

## Preserve the request-body distinction

The source supplies the PATCH body assignment as **prescribed** content. Its captured command references the body variable and its length but does not echo the assignment or expanded transmitted body. The captured HTTP **204**, subsequent HTTP **200** readback, and CLI establish the resulting description. No numeric historical Content-Length or missing request bytes are reconstructed here.

The hostname GET, pre-PATCH description GET, PATCH response, and readback retain their captured results in [verification](../verification/restconf.md). HTTP chunk-size lines in the GET responses are transfer framing, not JSON members.

## Transport and persistence limits

The source negotiated TLS 1.2 while certificate verification reported a self-signed error. The saved router also enables plain HTTP on port 80; these RESTCONF requests used HTTPS. Sanitization preserves both service settings and removes the old account and PKI identity.

The earlier authentication error is retained under [setup observations](../verification/setup-observations.md#block-17). It is not an additional fault lab or evidence of a newly diagnosed cause. The demonstrated PATCH and readback establish running configuration; an executed save and reboot validation remain absent.

[Configuration index](README.md) · [Client setup](client-setup.md) · [NETCONF](netconf.md) · [RESTCONF verification](../verification/restconf.md) · [Operation](../operation.md) · [Evidence scope](../scope.md)
