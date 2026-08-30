# Region verification

The main region is `CCNP_MST`, revision 1, with VLANs 10/20 in MSTI 1 and VLANs 30/40 in MSTI 2. The observed matching digest was `0xCA136A235706B316C8DB8F921067A68F`.

`show spanning-tree mst configuration` exposes the human-readable mapping. `show spanning-tree mst configuration digest` adds the digest; note that a revision or name mismatch can split a region even when this mapping digest remains unchanged.
