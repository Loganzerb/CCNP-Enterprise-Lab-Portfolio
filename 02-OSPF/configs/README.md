# OSPF Configuration Reference

This directory contains the sanitized Cisco IOS configurations used in the five-router, multi-area OSPF lab. The files preserve the protocol design and policy needed to understand, reproduce, and verify the implementation while removing platform-generated and operationally sensitive content.

## Included Configurations

| Configuration | Lab role |
|---|---|
| [`O1-CORE.cfg`](O1-CORE.cfg) | Core and backbone OSPF router |
| [`O2-ABR.cfg`](O2-ABR.cfg) | Area Border Router connecting Area 0 and Area 10 |
| [`O3-BRANCH.cfg`](O3-BRANCH.cfg) | Branch-side OSPF router |
| [`O4-EDGE.cfg`](O4-EDGE.cfg) | Edge router used for external-route and policy behavior |
| [`O5-TRANSIT.cfg`](O5-TRANSIT.cfg) | Transit-side router at the lab boundary |

Together, these configurations document OSPF process **1**, the **Area 0 / Area 10** hierarchy, and the routing-policy features exercised throughout the lab.

## Preserved Content

The sanitized files retain the configuration required to evaluate the OSPF control plane:

- OSPF-relevant interfaces and IPv4 addressing
- `router ospf 1`, router IDs, and Area 0 / Area 10 assignments
- Passive-interface policy and interface network types
- Authentication structure, key chains, key IDs, and interface bindings where applicable
- OSPF timers where explicitly configured
- Area 10 NSSA and totally NSSA behavior
- Area ranges and inter-area summarization
- Route filtering and external-route policy
- Static-route redistribution into OSPF
- OSPF-related route maps, prefix lists, and route tags

These elements are intentionally preserved so the configurations can be compared with the healthy-state evidence in [`../verification/`](../verification/) and the fault analysis in [`../troubleshooting/`](../troubleshooting/).

## Sanitization and Redaction

Authentication secrets were replaced with clearly marked redacted placeholders. Where applicable, the surrounding key-chain names, key IDs, authentication modes, and interface bindings remain intact so the design can be reviewed without exposing credentials.

The following nonessential content was removed:

- CML and YAML metadata
- IOS boot, image, and licensing boilerplate
- Console and VTY configuration
- Unrelated service and platform defaults
- Unused interfaces and other configuration not relevant to the OSPF lab

## Usage Note

These files are portfolio and lab artifacts, not production-ready templates. Redacted values must be replaced and all addressing, interface mappings, authentication, routing policy, and platform-specific syntax must be validated before reuse in another environment.

---

This configuration set is part of the **CCNP Enterprise Lab Portfolio** and demonstrates practical multi-area OSPF design, security, summarization, route control, and redistribution policy using reproducible Cisco Modeling Labs artifacts.
