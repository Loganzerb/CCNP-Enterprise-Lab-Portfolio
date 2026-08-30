# Path engineering

The lab used three separate control points:

1. Bridge priority selected the per-VLAN root.
2. Interface path cost changed the preferred upstream path before lower-order tie-breakers were considered.
3. Port priority influenced the final sender-port-ID tie-break when competing paths were otherwise equal.

The final topology uses the long cost method. A 1-Gb link therefore appears as cost `20000`; the election logic remains lowest accumulated Root Path Cost.
