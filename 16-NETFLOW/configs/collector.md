# Alpine collector setup and capture

The collector was an Alpine Linux 3.13 node attached directly to R1 Gi3. Its `10.30.30.2/30` address was configured interactively during the successful test and is **not present in the saved CML YAML**.

## Address after import or restart

Check whether eth0 already has the address. If it is absent, the command used successfully in the lab was:

```bash
sudo ip addr add 10.30.30.2/30 dev eth0
```

**Reported observation:** eth0 was **UP/LOWER_UP**, without an interface-output transcript. The address command above was tested; no persistent startup configuration has been added. A restarted or reimported collector may require the address to be reapplied.

Alpine login variables were removed from the public YAML. Use access settings appropriate to the local CML environment; [public export checks](../scope.md#public-export-and-portability) describe sanitization and the import limit.

## Capture exported datagrams

The command used to observe UDP/2055 delivery was:

```bash
sudo tcpdump -ni eth0 -vv 'udp port 2055'
```

The hexadecimal inspection command was:

```bash
sudo tcpdump -ni eth0 -s 0 -XX 'udp dst port 2055'
```

Selected UDP excerpts demonstrate delivery to this interface; decoded template/data summaries interpret their contents. [Evidence sources](../scope.md#sources) define the capture limits. This collector exercise used packet inspection, without a documented flow-analysis service or dashboard.

[Capture excerpts and decoding](../verification/export-and-templates.md) · [Configuration index](README.md) · [Overview](../README.md)
