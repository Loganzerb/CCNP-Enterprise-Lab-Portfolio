# Topology image generation briefs

Generated with the built-in image-generation tool using the user-supplied EtherChannel topology as a visual style reference. The reference topology was not copied into this portfolio.

These illustrations explain the documented lab layout; they are not captured evidence. Device and role labels were visually reviewed against the lab record.

## Campus topology

Create a precise professional CCNP networking topology infographic as a PNG, landscape 1536x1024 or larger. The attached image is ONLY a STYLE REFERENCE; replace all its content. Match its deep navy background, white sans-serif text, dark slate rounded device cards with gray outline, turquoise network-device icons, crisp colored links, generous spacing, sober technical portfolio look. Not a photograph, no fabricated terminal captures.
Title: "FHRP / CAMPUS TOPOLOGY"
Subtitle: "CCNP Enterprise • HSRP and VRRP lab"
Six device cards, connected correctly in hierarchical arrangement:
Top center CORE-R1 router with "Lo0: 10.255.255.1/32".
Middle left FHRP-DIST-A distribution switch. Card lines "VLAN 10: 10.10.10.2/24", "VLAN 20: 10.20.20.2/24", green "HSRP Active + STP root: VLAN 10".
Middle right FHRP-DIST-B distribution switch. Card lines "VLAN 10: 10.10.10.3/24", "VLAN 20: 10.20.20.3/24", amber "HSRP Active + STP root: VLAN 20".
Below center FHRP-ACCESS-1 switch.
Bottom left PC-A computer: "10.10.10.10/24", "GW: 10.10.10.1 • VLAN 10".
Bottom right PC-B computer: "10.20.20.10/24", "GW: 10.20.20.1 • VLAN 20".
Connections:
CORE-R1 to DIST-A single cyan routed link, label "OSPF 10 • 10.255.0.0/30", at core end "Gi0/0: .1", dist end "Gi0/0: .2".
CORE-R1 to DIST-B single cyan routed link label "OSPF 10 • 10.255.0.4/30", core end "Gi0/1: .5", dist end "Gi0/0: .6".
Between DIST-A and DIST-B two parallel horizontal turquoise lines representing "Po10 • LACP", label "Gi0/2 + Gi0/3 on both switches".
DIST-A Gi0/1 to ACCESS-1 Gi0/0 single green trunk.
DIST-B Gi0/1 to ACCESS-1 Gi0/1 single amber trunk.
ACCESS-1 Gi0/2 to PC-A and ACCESS-1 Gi0/3 to PC-B white single links.
Footer legend "Trunks: VLANs 10, 20, 99 • Native VLAN 99".
Small footer note "Healthy HSRP placement shown. Later VRRP phase: VLAN 20, DIST-B Master / DIST-A Backup."
Do not add links, switches, addresses, claims or section number. Ensure every link meets the right card and no text overlaps links or cards. Use readable large type. A clean technical drawing faithful to these labels is essential.

## GLBP topology

Create a professional, precise CCNP network topology infographic PNG, landscape 1536x1024 or larger. Attached image is STYLE REFERENCE only; match deep navy background, white sans-serif typography, dark slate rounded device cards, gray outlines, turquoise device icons and brightly colored clean links.
Title "FHRP / GLBP TOPOLOGY"
Subtitle "CCNP Enterprise • Three-router gateway redundancy lab"
Top center CORE-R1 router card: "Lo0: 10.255.255.1/32".
Middle row THREE equal router cards spaced widely, each with cyan circular router icon:
GLBP-R1: "Gi0/1: 10.30.30.2/24", "AVG • Priority 130", "AVF1: 0007.b400.1e01".
GLBP-R2: "Gi0/1: 10.30.30.3/24", "Standby AVG • Priority 110", "AVF2: 0007.b400.1e02".
GLBP-R3: "Gi0/1: 10.30.30.4/24", "Listen • Priority 100", "AVF3: 0007.b400.1e03".
Each has its OWN single routed cyan line to CORE-R1. Label left line "OSPF 30" and "Next hop 10.255.10.1"; center line "OSPF 30" and "Next hop 10.255.10.5"; right line "OSPF 30" and "Next hop 10.255.10.9". Label "Gi0/0" at each GLBP router end. These next hops are core addresses. Do not fabricate core interface names.
Below router cards draw one wide rounded horizontal shared LAN bar, NOT a switch device: "Shared Layer 2 access segment • 10.30.30.0/24". Connect EACH GLBP router's bottom separately to the bar with a single straight vertical line.
Below LAN bar THREE IOSv endpoint cards, EACH connected vertically to the shared bar (no direct router-to-host lines). Use small router icons and explicitly label "IOSv endpoint":
HOST-A: "10.30.30.10/24", "Initial ARP → AVF1".
HOST-B: "10.30.30.20/24", "Initial ARP → AVF2".
HOST-C: "10.30.30.30/24", "Initial ARP → AVF3".
Legend footer with turquoise outline: "GLBP group 30 • Virtual gateway 10.30.30.1".
Bottom note: "Healthy round-robin baseline shown • Access-switch wiring abstracted".
Below or tiny secondary footer: "Separate topology from the HSRP / VRRP campus lab".
Everything is a clear explanatory diagram not a screenshot and no fake console evidence. No extra links, no additional switches, no Ethernet channel links, no weights or percent distribution. Distinguish gateway roles from AVF rows. Keep all labels readable without collisions.

