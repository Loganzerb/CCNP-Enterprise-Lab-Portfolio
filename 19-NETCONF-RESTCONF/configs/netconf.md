# NETCONF — read and merge the running configuration

The lab used manual SSH to port **830**, selected the `netconf` subsystem, and exchanged XML RPCs against the **running** datastore. The router explicitly reported candidate disabled. The demonstrated change was the description of GigabitEthernet1.

## Locate the native model, list entry, and leaf

| Element | Meaning in this exercise |
|---|---|
| NETCONF namespace | `urn:ietf:params:xml:ns:netconf:base:1.0` identifies protocol operations |
| Cisco native namespace | `http://cisco.com/ns/yang/Cisco-IOS-XE-native` identifies the configuration model |
| Model path | `native/interface/GigabitEthernet` selects the interface list |
| List key | `<name>1</name>` identifies GigabitEthernet1 |
| Changed leaf | `<description>NETCONF-EDIT-VERIFIED</description>` |
| Read operation | `get-config` with running source and a subtree filter |
| Write operation | `edit-config` with running target and explicit `default-operation` merge |

The merge supplies the selected description leaf for list key `1`. The captured readback and independent CLI retain the management address; they establish what this edit changed in the original session.

## Repeat the demonstrated exchange

**Reproduction procedure — not a new captured session.** Complete [private account/key setup](client-setup.md) first.

1. Open SSH to the NETCONF subsystem with your replacement local account. The following account placeholder is a template; the actual source account remains omitted.

```sh
ssh -s -p 830 <LOCAL_ADMIN>@192.0.2.10 netconf
```

2. Inspect the server hello, then send the [client hello](../verification/netconf.md#block-05) advertising base 1.0. The demonstrated exchange uses `]]>]]>` end-of-message framing. Although the server advertised base 1.1, no base 1.1 chunked session was exercised.
3. Submit the [hostname request with message ID 101](../verification/netconf.md#block-05) and the [interface request with message ID 102](../verification/netconf.md#block-06). Use the interface filter's native namespace and key `1`. Read the returned description before editing; the final saved export starts with `RESTCONF-EDIT-VERIFIED`.
4. Submit the [running/merge edit RPC](../verification/netconf.md#block-07) with message ID 103. It selects Gi1 and sets `NETCONF-EDIT-VERIFIED`. Match the reply message ID and inspect its result.
5. Read the interface again and inspect it through the router console. The [message 104 guide](../verification/netconf.md#block-08) labels its request as prescribed and its reply as captured. The [independent CLI excerpt](../verification/netconf.md#block-09) records the original post-edit description, address, and up/up state.

## Interpret the result

The original session supplied the edit RPC, its matching `<ok/>`, interface readback, and independent CLI confirmation. A success reply acknowledges the operation; readback and CLI establish the resulting running configuration shown by the source.

Candidate, commit, rollback, validation operations, XPath queries, notifications, and NETCONF 1.1 framing were not separate hands-on exercises. Advertised capabilities remain service information. No executed save or reboot check establishes persistence of the change.

The [RESTCONF procedure](restconf.md) then changes the same leaf to `RESTCONF-EDIT-VERIFIED`, the final description retained in the export.

[Configuration index](README.md) · [Client setup](client-setup.md) · [NETCONF verification](../verification/netconf.md) · [Operation](../operation.md) · [Evidence scope](../scope.md)
