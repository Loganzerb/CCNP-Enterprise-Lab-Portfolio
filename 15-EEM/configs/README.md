# EEM configurations — retained applets and temporary tests

The device files below are sanitized configuration extracted from the completed CML YAML. They preserve the saved interface settings and both retained EEM applets. The temporary exercise policies are documented separately from that final state.

| File | What it contains |
|---|---|
| [EEM-R1.cfg](EEM-R1.cfg) | CSR1000v configuration with Gi1 addressing and the two retained applets |
| [R2-PEER.cfg](R2-PEER.cfg) | IOSv peer configuration with the connected Gi0/0 interface |
| [CML-LAB.yaml](../CML-LAB.yaml) | Sanitized two-node export with the original node/interface/link definitions |
| [Exercise applets](exercise-applets.md) | Timer, syslog fault, and CLI interception configurations from the handoff; not retained in the export |

## GI1-DOWN-ALERT — capture the interface state after a matching event

Selected saved configuration:

```cisco
event manager applet GI1-DOWN-ALERT
 event syslog pattern "%LINEPROTO-5-UPDOWN.*GigabitEthernet1.*down"
 action 1.0 syslog msg "EEM ALERT: GigabitEthernet1 line protocol DOWN"
 action 2.0 cli command "enable"
 action 3.0 cli command "show ip interface brief | include GigabitEthernet1"
 action 4.0 syslog msg "EEM DIAG: $_cli_result"
```

The detector selects a line-protocol message for Gi1 containing `down`. The applet logs an alert, enters privileged CLI mode, collects the filtered interface result, and logs the result of that diagnostic command. The retained test used an administrative shutdown; the applet collected evidence rather than changing the interface configuration.

The regex is not an exact whole-message match. Its behavior is validated against the supplied lab event, rather than claimed to cover every possible failure message.

[Automatic diagnostic evidence](../verification/syslog-triggered-diagnostics.md)

## MANUAL-DIAG — run the diagnostic on demand

Selected saved configuration:

```cisco
event manager applet MANUAL-DIAG
 event none
 action 1.0 cli command "enable"
 action 2.0 cli command "show ip interface brief"
 action 3.0 puts "$_cli_result"
 action 4.0 syslog msg "EEM MANUAL-DIAG: Diagnostic completed"
```

`event none` makes this an administrator-invoked policy. The diagnostic output goes to the terminal through `puts`; a separate syslog marks completion. The handoff reports successful execution through `event manager run MANUAL-DIAG`.

[Manual execution record](../verification/manual-execution.md)

## Configuration provenance and sanitization

The original October 9 export is preserved outside the public portfolio. The public YAML and `.cfg` files remove device-specific PKI trustpoints and certificate chains, a licensing/device identifier command, and call-home configuration. Console display headers were removed so the configuration fields contain configuration text.

All EEM detector/action lines, interface settings, node definitions, image-definition references, and link endpoints remain unchanged. The `.cfg` files match the public YAML's configuration fields. Image references identify the CML platforms; no Cisco software images are included.

The export parses successfully and its node/link/configuration relationships have been checked. It has not been imported or executed again during portfolio preparation.

[Temporary exercise configurations](exercise-applets.md) · [Evidence scope](../scope.md) · [Overview](../README.md)
