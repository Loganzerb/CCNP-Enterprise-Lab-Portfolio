# MST to Rapid PVST+ interoperability

MST5 was converted to Rapid PVST+ and the MST4-facing link changed to `Bound(PVST)`. Two consistency directions were tested:

- With the CIST root inside MST, a superior Rapid-PVST+ VLAN 10 root caused a designated boundary to enter `PVST_Inc`.
- With the CIST root in the Rapid-PVST+ domain, an inferior VLAN 10 BPDU caused the MST root port to enter `PVST_Inc` and emitted `%SPANTREE-2-PVSTSIM_FAIL`.

Both recovered automatically after root information was made consistent, with `%SPANTREE-2-PVSTSIM_OK` and zero inconsistent ports.
