# MTU boundary — one byte changes the result

The final three tests hold the destination constant and vary packet size and the Don’t Fragment bit. IOS ping `size` here is the IP datagram size, not an ICMP payload value requiring another header addition.

These excerpts retain actual CLI from the completed lab. The linked full transcripts preserve all supplied lines; selections are identified where used.

## Block 12 — Compare 1476 and 1477 bytes with and without DF

1476 bytes with DF returns 5/5; 1477 with DF returns 0/5; 1477 without DF returns 5/5. This establishes the tested boundary and successful delivery when fragmentation is permitted. No packet capture or fragment counters were retained to show individual fragments.

```text
R1-GRE#ping 172.16.13.2 size 1476 df-bit repeat 5
Type escape sequence to abort.
Sending 5, 1476-byte ICMP Echos to 172.16.13.2, timeout is 2 seconds:
Packet sent with the DF bit set
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 2/2/3 ms
R1-GRE#ping 172.16.13.2 size 1477 df-bit repeat 5
Type escape sequence to abort.
Sending 5, 1477-byte ICMP Echos to 172.16.13.2, timeout is 2 seconds:
Packet sent with the DF bit set
.....
Success rate is 0 percent (0/5)
R1-GRE#ping 172.16.13.2 size 1477 repeat 5
Type escape sequence to abort.
Sending 5, 1477-byte ICMP Echos to 172.16.13.2, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 3/3/4 ms
R1-GRE#
```

[Full captured text](block-12.txt)

[Evidence index](README.md) · [GRE overview](../README.md)
