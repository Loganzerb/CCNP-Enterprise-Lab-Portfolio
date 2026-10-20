# CoPP configuration

The [sanitized CML export](../CML-LAB.yaml) retains the original four nodes, three links, images, interfaces, addresses, OSPF configuration, and final CoPP policy. These files are exact extracts of its decoded configuration strings. They are saved configuration evidence, not new CLI captures or proof that the sanitized copy has been booted.

| File | Content |
|---|---|
| [R1-CoPP.cfg](R1-CoPP.cfg) | Router interfaces, OSPF, classification ACLs, class maps, final policers, and control-plane attachment |
| [R2-PEER.cfg](R2-PEER.cfg) | Peer interfaces and OSPF configuration |
| [CLIENT-A.sh](CLIENT-A.sh) | Original Alpine hostname, eth0 activation, client address, and default route |
| [APP-TEST.sh](APP-TEST.sh) | Original Alpine hostname, eth0 activation, endpoint address, and default route |
| [Private SSH setup](ssh-setup.md) | Local setup required after removal of credentials and device cryptographic material |

The endpoint extracts preserve every startup command and the original absence of a final newline. They contain network setup only; no endpoint service state or historical test transcripts are embedded in the YAML.

## Configuration stages

### 1. Routed underlay

R1 Gi1 serves CLIENT-A; R2 Gi2 serves APP-TEST. The routers communicate over `10.1.12.0/30`. OSPF process 10 advertises both endpoint networks in Area 0, with only the inter-router interfaces active for adjacency formation.

**Selected saved configuration.**

```cisco
! R1-CoPP
router ospf 10
 router-id 1.1.1.1
 passive-interface default
 no passive-interface GigabitEthernet2
 network 10.1.12.0 0.0.0.3 area 0
 network 10.10.10.0 0.0.0.255 area 0
! R2-PEER
router ospf 10
 router-id 2.2.2.2
 passive-interface default
 no passive-interface GigabitEthernet1
 network 10.1.12.0 0.0.0.3 area 0
 network 172.16.40.0 0.0.0.255 area 0
```

### 2. Identify control-plane traffic

**Exact saved ACL and class-map stanzas.**

```cisco
ip access-list extended COPP-OSPF
 10 permit ospf host 10.1.12.2 any
ip access-list extended COPP-SSH
 10 permit tcp any host 10.10.10.1 eq 22
class-map match-any CP-OSPF
 match access-group name COPP-OSPF
class-map match-any CP-SSH
 match access-group name COPP-SSH
```

The ACLs select traffic for their classes; they are not interface access-group filters. `COPP-SSH` matches TCP destination port 22 at the specific R1 address `10.10.10.1`, from any source. It does not classify SSH to every R1 address. `COPP-OSPF` selects OSPF from peer `10.1.12.2`.

### 3. Apply the final policers

**Exact saved policy and attachment.**

```cisco
policy-map CP-PROTECT
 class CP-SSH
  police 80000 conform-action transmit  exceed-action drop
 class CP-OSPF
  police 1000000 conform-action transmit  exceed-action drop
control-plane
 service-policy input CP-PROTECT
```

The CIRs are 80,000 bps for SSH and 1,000,000 bps for OSPF. Both final classes transmit conforming traffic and drop exceeding traffic. The final saved commands do not specify an explicit burst value. The 1,500-byte burst allowance belongs to the temporary SSH exhaustion experiment, described in [troubleshooting](../troubleshooting/README.md).

`service-policy input` applies this policy to traffic entering R1's control plane. CLIENT-A to APP-TEST traffic is a routed transit path; its successful ping verifies service recovery after OSPF repair, rather than proving that the transit packets matched these CoPP classes.

## Publication boundaries

The public copy removes the R1 local account/hash, both routers' complete PKI trustpoint/certificate blocks, license/device identifiers, call-home configuration, and generated display headers/comments. No replacement password, hash, key, or certificate was inserted. Retained management settings are preserved rather than silently changed into a different hardening lab.

The handoff reports inspection of both router startup configurations. That report is recorded separately in [verification](../verification/README.md); the YAML itself contains saved configuration text rather than a historical startup-config transcript. No fresh sanitized-lab import, SSH test, or router reload verification was performed during publication preparation.

[Overview](../README.md) · [Topology](../topology.md) · [Operation](../operation.md) · [Verification](../verification/README.md) · [Troubleshooting](../troubleshooting/README.md) · [Evidence scope](../scope.md)
