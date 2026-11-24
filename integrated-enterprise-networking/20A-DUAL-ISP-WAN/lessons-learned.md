# Lab 20A lessons learned

- **Match the probe to the failure you need to detect.** The core's connected next hop remains reachable when the primary edge loses its upstream link. A probe beyond that link can inform the route change.
- **Pin the probe and validate its complete path.** While R2 remains reachable from R1, the host route keeps the probe pointed at R2 even when the default next hop moves to R3 toward ISP-B. Downstream alternate routing and the ISP's path back to the source also determine whether the probe succeeds.
- **Use each routing check to answer a specific question.** A BGP session exchanges routes, an installed route needs a usable next hop, and CEF identifies an egress. An end-to-end test adds evidence of packet delivery and a working return path.
- **Keep the default-route test distinct from the health checks.** Pings to the two provider loopbacks match /32 routes. To measure a user's experience across failover, choose a destination that uses the default and record traffic across the transition.

The [historical captures](verification/tracked-default.md) show which default R1 installed and which CEF adjacency it selected. A replay with a measured, default-selected flow would add evidence of packet delivery and switchover timing.

[Overview](README.md) · [Verification](verification/README.md) · [Evidence scope](scope.md)
