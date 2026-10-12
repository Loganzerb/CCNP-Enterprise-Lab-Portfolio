# Case 01 — A registered detector misses the shutdown message

The temporary applet registered successfully but reportedly did not respond when GigabitEthernet1 was shut down. Comparing its detector with the emitted syslog exposed a message-identifier mismatch.

**Quick navigation:** [Investigate the symptom](#investigate-the-symptom) · [Repair and result](#repair-and-result) · [Evidence scope](#evidence-scope)

## Investigate the symptom

The configured pattern expected `%LINK-3-UPDOWN.*GigabitEthernet1.*down`. The recorded device message used `%LINK-5-CHANGED` and the state text `administratively down`.

[Original detector — Block 02](../verification/syslog-triggered-diagnostics.md#block-02) · [Actual message — Block 03](../verification/syslog-triggered-diagnostics.md#block-03)

Successful registration established that a policy had registered; it did not establish that this message would match. Inspecting the emitted identifier and text located the discrepancy.

## Repair and result

The detector was changed to `%LINK-5-CHANGED.*GigabitEthernet1.*administratively down`. [Corrected detector — Block 04](../verification/syslog-triggered-diagnostics.md#block-04)

The selected repair excerpt records the administrative-down event at **23:21:17.157** and the LINK-FAULT-TEST alert at **23:21:17.160** on October 9, 2026. [Repair result — Block 05](../verification/syslog-triggered-diagnostics.md#block-05)

The **3 ms** difference is one recorded syslog interval. It provides no guaranteed response time or broader performance result.

## Evidence scope

Initial registration and failure are reported observations without output. The incorrect pattern, emitted message, corrected pattern, and repair result are selected lab-record excerpts.

LINK-FAULT-TEST was subsequently removed. Final GI1-DOWN-ALERT instead detects `%LINEPROTO-5-UPDOWN` and records a CLI diagnostic result; [its separate validation](../verification/syslog-triggered-diagnostics.md#block-01) preserves that distinction.

**Takeaway:** match the actual device message, then verify the action; registration alone cannot establish detector behavior.

[Case index](README.md) · [Verification index](../verification/README.md) · [EEM overview](../README.md)
