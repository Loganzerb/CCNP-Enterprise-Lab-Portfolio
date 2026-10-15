# NETCONF: read, merge, and verify running configuration

The client used SSH's NETCONF subsystem to read the Cisco native model and change one interface description. RPC message IDs connect the requests to replies; protocol readback and router CLI then verify the resulting running state.

**Quick navigation:** [Session and hostname](#session-and-hostname) · [Read and edit Gi1](#read-and-edit-gi1) · [Readback and CLI](#readback-and-cli)

## Session and hostname

<a id="block-04"></a>

### Block 04 — NETCONF SSH connection and server hello capabilities

**Captured SSH command and selected server hello excerpts.** The server advertises base 1.0 and 1.1, writable-running, and other capabilities. Candidate-disabled status is explicit in [Block 03](connectivity-and-services.md#block-03). Advertised rollback, validate, XPath, notifications, and base 1.1 were not separately exercised.

```text
inserthostname_here:~$ ssh -s -p 830 [REDACTED]@192.0.2.10 netconf
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<hello xmlns="urn:ietf:params:xml:ns:netconf:base:1.0">
<capabilities>
<capability>urn:ietf:params:netconf:base:1.0</capability>
<capability>urn:ietf:params:netconf:base:1.1</capability>
<capability>urn:ietf:params:netconf:capability:writable-running:1.0</capability>
<capability>urn:ietf:params:netconf:capability:rollback-on-error:1.0</capability>
<capability>urn:ietf:params:netconf:capability:validate:1.0</capability>
<capability>urn:ietf:params:netconf:capability:validate:1.1</capability>
<capability>urn:ietf:params:netconf:capability:xpath:1.0</capability>
<capability>urn:ietf:params:netconf:capability:notification:1.0</capability>
<capability>urn:ietf:params:netconf:capability:interleave:1.0</capability>
<capability>urn:ietf:params:netconf:capability:with-defaults:1.0?basic-mode=explicit&amp;also-supported=report-all-tagged,report-all</capability>
<capability>urn:ietf:params:netconf:capability:yang-library:1.0?revision=2016-06-21&amp;module-set-id=2813650ac1095ad1d44042ecba7333c5</capability>
<!-- Editorial omission: additional advertised capabilities/modules. -->
<capability>
        urn:ietf:params:netconf:capability:notification:1.1
      </capability>
</capabilities>
<session-id>[REDACTED]</session-id></hello>]]>]]>
```

```xml
<capability>http://cisco.com/ns/yang/Cisco-IOS-XE-native?module=Cisco-IOS-XE-native&amp;revision=2020-07-02&amp;deviations=Cisco-IOS-XE-cdp-deviation,Cisco-IOS-XE-dialer-deviation,Cisco-IOS-XE-nd-deviation,Cisco-IOS-XE-policy-deviation,Cisco-IOS-XE-sanet-deviation</capability>
<capability>urn:ietf:params:xml:ns:netconf:base:1.0?module=ietf-netconf&amp;revision=2011-06-01&amp;features=writable-running,rollback-on-error,validate,xpath</capability>
```

<a id="block-05"></a>

### Block 05 — Client hello and hostname GET-CONFIG, message ID 101

**Captured client hello, request, and matching reply.** The client advertises base 1.0 and uses `]]>]]>` framing. Running GET-CONFIG 101 returns hostname `R1-AUTOMATION`; these exchanges do not demonstrate a NETCONF 1.1 chunked session.

```xml
<hello xmlns="urn:ietf:params:xml:ns:netconf:base:1.0">
  <capabilities>
    <capability>urn:ietf:params:netconf:base:1.0</capability>
  </capabilities>
</hello>]]>]]>
<rpc message-id="101"
 xmlns="urn:ietf:params:xml:ns:netconf:base:1.0">
  <get-config>
    <source>
      <running/>
    </source>
    <filter type="subtree">
      <native
       xmlns="http://cisco.com/ns/yang/Cisco-IOS-XE-native">
        <hostname/>
      </native>
    </filter>
  </get-config>
</rpc>]]>]]>
<?xml version="1.0" encoding="UTF-8"?>
<rpc-reply xmlns="urn:ietf:params:xml:ns:netconf:base:1.0" message-id="101"><data><native xmlns="http://cisco.com/ns/yang/Cisco-IOS-XE-native"><hostname>R1-AUTOMATION</hostname></native></data></rpc-reply>]]>]]>
```

## Read and edit Gi1

<a id="block-06"></a>

### Block 06 — Interface GET-CONFIG, message ID 102

**Captured request and reply, message 102.** The keyed interface read returns `NETCONF-RESTCONF-LAB` and IPv4 address `192.0.2.10` with mask `255.255.255.0`.

```xml
<rpc message-id="102"
 xmlns="urn:ietf:params:xml:ns:netconf:base:1.0">
  <get-config>
    <source>
      <running/>
    </source>
    <filter type="subtree">
      <native
       xmlns="http://cisco.com/ns/yang/Cisco-IOS-XE-native">
        <interface>
          <GigabitEthernet>
            <name>1</name>
          </GigabitEthernet>
        </interface>
      </native>
    </filter>
  </get-config>
</rpc>]]>]]>
<?xml version="1.0" encoding="UTF-8"?>
<rpc-reply xmlns="urn:ietf:params:xml:ns:netconf:base:1.0" message-id="102"><data><native xmlns="http://cisco.com/ns/yang/Cisco-IOS-XE-native"><interface><GigabitEthernet><name>1</name><description>NETCONF-RESTCONF-LAB</description><ip><address><primary><address>192.0.2.10</address><mask>255.255.255.0</mask></primary></address></ip><logging><event><link-status/></event></logging><mop><enabled>false</enabled><sysid>false</sysid></mop><negotiation xmlns="http://cisco.com/ns/yang/Cisco-IOS-XE-ethernet"><auto>true</auto></negotiation></GigabitEthernet></interface></native></data></rpc-reply>]]>]]>
```

<a id="block-07"></a>

### Block 07 — Running edit-config with merge and ok, message ID 103

**Captured edit RPC and matching reply, message 103.** The target is running and the default operation is merge. The supplied edit changes the description to `NETCONF-EDIT-VERIFIED`, followed by `<ok/>`. No candidate/commit workflow is represented.

```xml
<rpc message-id="103"
 xmlns="urn:ietf:params:xml:ns:netconf:base:1.0">
  <edit-config>
    <target>
      <running/>
    </target>
    <default-operation>merge</default-operation>
    <config>
      <native
       xmlns="http://cisco.com/ns/yang/Cisco-IOS-XE-native">
        <interface>
          <GigabitEthernet>
            <name>1</name>
            <description>NETCONF-EDIT-VERIFIED</description>
          </GigabitEthernet>
        </interface>
      </native>
    </config>
  </edit-config>
</rpc>]]>]]>
<?xml version="1.0" encoding="UTF-8"?>
<rpc-reply xmlns="urn:ietf:params:xml:ns:netconf:base:1.0" message-id="103"><ok/></rpc-reply>]]>]]>
```

## Readback and CLI

<a id="block-08"></a>

### Block 08 — NETCONF interface readback, message ID 104

**Prescribed request; captured reply, message 104.** The request came from the lab instruction and was not echoed in this capture. The reply retains the updated description and original IPv4 address/mask.

Prescribed request:

```xml
<rpc message-id="104" xmlns="urn:ietf:params:xml:ns:netconf:base:1.0">
  <get-config>
    <source><running/></source>
    <filter type="subtree">
      <native xmlns="http://cisco.com/ns/yang/Cisco-IOS-XE-native">
        <interface><GigabitEthernet><name>1</name></GigabitEthernet></interface>
      </native>
    </filter>
  </get-config>
</rpc>]]>]]>
```

Captured reply:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<rpc-reply xmlns="urn:ietf:params:xml:ns:netconf:base:1.0" message-id="104"><data><native xmlns="http://cisco.com/ns/yang/Cisco-IOS-XE-native"><interface><GigabitEthernet><name>1</name><description>NETCONF-EDIT-VERIFIED</description><ip><address><primary><address>192.0.2.10</address><mask>255.255.255.0</mask></primary></address></ip><logging><event><link-status/></event></logging><mop><enabled>false</enabled><sysid>false</sysid></mop><negotiation xmlns="http://cisco.com/ns/yang/Cisco-IOS-XE-ethernet"><auto>true</auto></negotiation></GigabitEthernet></interface></native></data></rpc-reply>]]>]]>
```

<a id="block-09"></a>

### Block 09 — Independent CLI after the NETCONF change

**Captured router CLI excerpts.** The independent interface configuration agrees with the NETCONF readback, and Gi1 remains up/up. These checks establish running state at this stage, without an executed save or reboot result.

```text
R1-AUTOMATION#show running-config interface GigabitEthernet1
Building configuration...

Current configuration : 154 bytes
!
interface GigabitEthernet1
 description NETCONF-EDIT-VERIFIED
 ip address 192.0.2.10 255.255.255.0
 negotiation auto
 no mop enabled
 no mop sysid
end

R1-AUTOMATION#show ip interface brief
Interface              IP-Address      OK? Method Status                Protocol
GigabitEthernet1       192.0.2.10      YES manual up                    up
```

[RESTCONF read and change](restconf.md) · [Management services](connectivity-and-services.md) · [Verification index](README.md) · [Overview](../README.md) · [Configurations](../configs/README.md) · [Operation](../operation.md) · [Topology](../topology.md) · [Evidence scope](../scope.md)
