# Case 02 — Forwarding Fails After Enabling LACP Max-Bundle

## Problem and impact

During an advanced LACP experiment, SW3 accepted `lacp max-bundle 1` on Po20 and eventually displayed one bundled member and one hot-standby member. Despite the operational-looking summary, the retained PC-A test received **0 of 5 replies** from SW4's VLAN 10 address.

The recovery set shows two bundled members and **5 of 5 replies**. The earlier module narrative attributes recovery to removing the max-bundle setting. The package preserves the enable command and recovery state, but not a complete transcript of the intervening changes.

This is an **observed forwarding anomaly associated with the max-bundle experiment**. Its internal software or forwarding cause is not independently established by these files.

## Intended experiment

Po20 joins SW1 and SW3 through two physical links. The experiment limited active membership to one, with the other member shown as hot standby. The important acceptance test was that endpoint traffic should continue over the intended test path, rather than merely accepting a plausible LACP summary.

The final exported lab uses two bundled members without the max-bundle override. Its configurations describe the restored baseline, not the exact state at every point in the experiment.

## Retained sources

| Artifact | What it establishes |
|---|---|
| [Enable transition](max-bundle-enable-transition.txt) | SW3 accepts max-bundle 1; Po20 transitions from SN with waiting/hot-standby members to SU with bundled/hot-standby members |
| [Failed endpoint test](max-bundle-broken-ping.txt) | PC-A sends five probes to 10.10.10.20 and receives none |
| [Failure-state STP detail](max-bundle-broken-stp-bpdu.txt) | SW1's Po20 detail shows designated forwarding and zero received BPDUs in the retained VLAN views |
| [Recovery membership](max-bundle-recovery-summary.txt) | SW3 shows Po20(SU) with both members P |
| [Recovery endpoint test](max-bundle-recovery-ping.txt) | Five probes receive five replies |
| [Recovery STP detail](max-bundle-recovery-stp-bpdu.txt) | SW3's Po20 detail shows nonzero received BPDU counters |

These are separate captures organized by the supplied experiment labels. They are not a synchronized recording from both peers.

## The summary initially looks plausible

The captured command is:

```cisco
interface Port-channel20
 lacp max-bundle 1
```

The first summary after the change shows:

```text
20     Po20(SN)        LACP      Gi0/0(w)    Gi0/1(H)
```

Later in the same file, after down/up messages, it shows:

```text
20     Po20(SU)        LACP      Gi0/0(P)    Gi0/1(H)
```

The later observation establishes that the CLI accepted the setting and LACP displayed one bundled member plus one hot-standby member. The transition state should not be presented as the settled failure state.

## Endpoint and spanning-tree evidence change the diagnosis

PC-A's retained test records:

```text
5 packets transmitted, 0 packets received, 100% packet loss
```

SW1's failure-state Po20 detail includes designated-forwarding entries with path cost 4 and `BPDU: sent 276, received 0`.

The failed endpoint test prevents an SU summary from closing the investigation. The STP detail adds a control-traffic observation worth investigating alongside LACP. A zero cumulative receive counter alone does not prove the exact failure mechanism or establish a unidirectional physical link.

| Diagnostic question | Evidence and remaining boundary |
|---|---|
| Was the command unsupported? | No: the enable capture shows acceptance and changed member state |
| Did Po20 remain down throughout? | No: the later summary shows SU |
| Did endpoint forwarding succeed in the retained failure run? | No: all five probes failed |
| Did the selected failure capture show received BPDUs? | No: SW1 reports zero in the shown views |
| Was symmetric peer configuration ruled out as the cause? | The earlier narrative says a symmetric trial did not repair forwarding, but a matching two-peer configuration transcript is absent |
| Is a particular vendor defect proven? | No: no vendor defect record, packet-level diagnosis, or controlled image comparison is included |

## Recovery reference and its limits

The earlier documentation reports removing max-bundle to return to normal two-member operation. For SW3, the corresponding **reference command sequence** is:

```cisco
configure terminal
interface Port-channel20
 no lacp max-bundle
end
```

This block is explanatory and was not captured as a complete repair transcript. In a replay, inspect both peers for settings applied during the experiment and restore the intended baseline on each affected device.

The [final SW1](../configs/EC-SW1-DIST-A-running-config.txt) and [SW3](../configs/EC-SW3-ACCESS-A-running-config.txt) configurations retain the active/passive LACP design without a max-bundle override. They corroborate the delivered state without proving that no other intermediate actions occurred.

## Recovery verification

| Observation | Captured result | What it establishes |
|---|---|---|
| SW3 Po20 | SU, Gi0/0(P), Gi0/1(P) | Two-member operation returned |
| PC-A → 10.10.10.20 | 5 sent, 5 received, 0% loss | Endpoint reachability returned for the retained run |
| Recovery RTT | 4.890 / 6.334 / 11.410 ms min/average/max | Actual latency values for those probes |
| SW3 Po20 STP detail | Path cost 3; received BPDU count 3 in the retained VLAN views | Recovery-side control-traffic observations accompany restored membership |

**The failure BPDU capture is from SW1; the recovery capture is from SW3.** Their bridge/root identifiers also differ. These are not measurements of one counter increasing from zero to three on one unchanged device, and they cannot be used to calculate a convergence interval.

The evidence supports restored service and membership, with a reported rollback of the max-bundle setting. It does not establish the internal cause, continuous loss duration, maximum throughput, long-term stability, or a saved-configuration confirmation.

## Engineering takeaway

CLI acceptance and healthy-looking bundle flags are intermediate checks. Verify the intended traffic path and endpoint result as well. When an experiment produces contradictory indicators, retain the contradiction, document the effective rollback, and separate the observed recovery from an unproven explanation of the platform behavior.

[Case index](README.md) · [Guided exercises](../verification/guided-labs.md) · [Module overview](../README.md)
