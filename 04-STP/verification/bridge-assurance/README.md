# Bridge Assurance

SW3 Gi0/1 and SW4 Gi0/1 are saved as Rapid PVST+ point-to-point network ports (`spanning-tree portfast network`). Bridge Assurance requires this network-port relationship on both ends; global availability alone is not proof that a given link is protected.

During the test, BPDU participation was deliberately broken while the link remained operational. The protected side entered Bridge Assurance inconsistency (`*BA_Inc`) instead of forwarding unsafely. The exact failure table was not retained, so only the exact pre-change interface-detail capture is included.
