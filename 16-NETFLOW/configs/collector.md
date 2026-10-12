# Alpine collector setup and capture

The collector was an Alpine Linux 3.13 node attached directly to R1 Gi3. Its `10.30.30.2/30` address was configured interactively during the successful test and is **not present in the saved CML YAML**.

## Address after import or restart

Check whether eth0 already has the address. If it is absent, the command used successfully in the lab was:

```bash
sudo ip addr add 10.30.30.2/30 dev eth0
```

The handoff reports eth0 was **UP/LOWER_UP**, without supplying the interface-output transcript. This note preserves the tested address command; no persistent startup configuration or new Linux setup has been added. A restarted or reimported collector may require the address to be reapplied.

The public YAML removes supplied Alpine login variables during sanitization. Use login/access settings appropriate to the local CML environment. The sanitized topology has not been import-tested during documentation work.

## Capture exported datagrams

The command used to observe UDP/2055 delivery was:

```bash
sudo tcpdump -ni eth0 -vv 'udp port 2055'
```

The hexadecimal inspection command was:

```bash
sudo tcpdump -ni eth0 -s 0 -XX 'udp dst port 2055'
```

The capture verifies that export datagrams reached this interface. The supplied decoded template/data values support interpretation of their contents; no PCAP file or complete hexadecimal dump was supplied. This collector exercise used packet inspection, without a documented flow-analysis service or dashboard.

[Capture excerpts and decoding](../verification/export-and-templates.md) · [Configuration index](README.md) · [Overview](../README.md)
