# Failover and source acceptance

Read the [verification guide](README.md) for field meanings and capture conventions. Blocks retain selected device outputs in test order; each introduction states what that capture establishes.

## Block 01

**Two configured sources.** R1 is selected at reach 377. R4 responds at reach 3 but has no candidate marker.

```text
R2-NTP-CORE#show ntp associations

address         ref clock       st   when   poll reach  delay  offset   disp
*~10.12.0.1       .LOCL.           1     37    128   377  1.993 -192.42  2.665
~10.20.0.4       127.127.1.1      3     39    128     3  3.030 308.886  0.842

* sys.peer, # selected, + candidate, - outlyer, x falseticker, ~ configured
  R2-NTP-CORE#
```

## Block 02

**Reachable backup rejected.** Before the outage, R4 is receiving replies but is marked insane and invalid. Its availability alone does not establish readiness.

```text
R2-NTP-CORE#show ntp associations detail
10.12.0.1 configured, ipv4, our_master, sane, valid, stratum 1
ref ID .LOCL., time EE5855A6.8DF680AB (00:28:22.554 UTC Sat Sep 19 2026)
our mode client, peer mode server, our poll intvl 64, peer poll intvl 64
root delay 0.00 msec, root disp 0.44, reach 37, sync dist 27.34
delay 2.01 msec, offset 20.1036 msec, dispersion 4.74, jitter 19.84 msec
precision 2**16, version 4
assoc id 40278, assoc name 10.12.0.1
assoc in packets 93, assoc out packets 93, assoc error packets 13
org time 00000000.00000000 (00:00:00.000 UTC Mon Jan 1 1900)
rec time EE5855B4.8E07CDF7 (00:28:36.554 UTC Sat Sep 19 2026)
xmt time EE5855B4.8E07CDF7 (00:28:36.554 UTC Sat Sep 19 2026)
filtdelay =     2.18    2.47    2.26    2.44    2.21    2.16    2.01    2.03
filtoffset =   -7.82  -18.75   -0.31   16.10   16.37   16.46   20.10   22.69
filterror =     0.03    1.47    2.91    4.35    4.36    4.38    5.07    5.76
minpoll = 6, maxpoll = 10

10.20.0.4 configured, ipv4, insane, invalid, stratum 3
ref ID 127.127.1.1    , time EE5855B4.464BFFB4 (00:28:36.274 UTC Sat Sep 19 2026)
our mode client, peer mode server, our poll intvl 64, peer poll intvl 64
root delay 0.00 msec, root disp 0.27, reach 37, sync dist 21.53
delay 3.11 msec, offset 464.9754 msec, dispersion 3.76, jitter 14.64 msec
precision 2**16, version 4
assoc id 40279, assoc name 10.20.0.4
assoc in packets 22, assoc out packets 22, assoc error packets 0
org time 00000000.00000000 (00:00:00.000 UTC Mon Jan 1 1900)
rec time EE5855B6.016ED5E6 (00:28:38.005 UTC Sat Sep 19 2026)
xmt time EE5855B6.016ED5E6 (00:28:38.005 UTC Sat Sep 19 2026)
filtdelay =     3.32    3.81    4.66    3.27    3.44    3.45    3.11    3.88
filtoffset =  442.46  438.24  448.45  464.59  465.63  464.65  464.97  467.44
filterror =     0.03    1.47    2.91    4.35    4.36    4.38    4.39    4.68
minpoll = 6, maxpoll = 10

R2-NTP-CORE#
```

## Block 03

**Primary reach starts falling.** After the reported link shutdown, R1 remains selected while reach changes to 376. R4 is still marked x.

```text
R2-NTP-CORE#show ntp associations

address         ref clock       st   when   poll reach  delay  offset   disp
*~10.12.0.1       .LOCL.           1     73    128   376  2.086  -7.249  2.245
x~10.20.0.4       127.127.1.1      3     16     64   377  3.067 405.942  1.813

* sys.peer, # selected, + candidate, - outlyer, x falseticker, ~ configured
  R2-NTP-CORE#
```

## Block 04

**Core uses backup.** R2 reports synchronized at stratum 4, reference 10.20.0.4. The SPIK loop state and 379.0482 ms offset remain part of the result.

```text
R2-NTP-CORE#sh ntp status 
Clock is synchronized, stratum 4, reference is 10.20.0.4      
nominal freq is 1000.0003 Hz, actual freq is 999.8791 Hz, precision is 2**16
ntp uptime is 612500 (1/100 of seconds), resolution is 1001
reference time is EE58585F.A5711557 (00:39:59.646 UTC Sat Sep 19 2026)
clock offset is 379.0482 msec, root delay is 2.27 msec
root dispersion is 400.91 msec, peer dispersion is 2.92 msec
loopfilter state is 'SPIK' (Spike), drift is 0.000121141 s/s
system poll interval is 128, last update was 222 sec ago.
R2-NTP-CORE#
```

## Block 05

**Client follows backup hierarchy.** R3 reports synchronized at stratum 5 through R2, with CTRL.

```text
R3-NTP-CLIENT#sh ntp status 
Clock is synchronized, stratum 5, reference is 10.20.0.1      
nominal freq is 1000.0003 Hz, actual freq is 999.8609 Hz, precision is 2**16
ntp uptime is 481400 (1/100 of seconds), resolution is 1001
reference time is EE585955.62D931B7 (00:44:05.386 UTC Sat Sep 19 2026)
clock offset is -53.1889 msec, root delay is 5.31 msec
root dispersion is 461.96 msec, peer dispersion is 2.98 msec
loopfilter state is 'CTRL' (Normal Controlled Loop), drift is 0.000139330 s/s
system poll interval is 128, last update was 263 sec ago.
R3-NTP-CLIENT#
```

## Block 06

**Link restored but source not selected.** After the reported link restoration, R1 is .STEP. at reach 0 while R4 remains selected.

```text
R2-NTP-CORE#show ntp associations

address         ref clock       st   when   poll reach  delay  offset   disp
~10.12.0.1       .STEP.          16   1025     64     0  0.000   0.000 15937.
*~10.20.0.4       127.127.1.1      3     63     64     1  3.204 -32.517 7937.5

* sys.peer, # selected, + candidate, - outlyer, x falseticker, ~ configured
  R2-NTP-CORE#
```

## Block 07

**Replies resume but R1 is invalid.** R1 has reach 7 and real samples, but remains insane and invalid. R4 is our_master, sane, valid.

```text
R2-NTP-CORE#show ntp associations detail
10.12.0.1 configured, ipv4, insane, invalid, stratum 1
ref ID .LOCL., time EE585B56.8DC09ADB (00:52:38.553 UTC Sat Sep 19 2026)
our mode client, peer mode server, our poll intvl 64, peer poll intvl 64
root delay 0.00 msec, root disp 0.42, reach 7, sync dist 23.00
delay 2.02 msec, offset -370.0033 msec, dispersion 2.14, jitter 18.59 msec
precision 2**16, version 4
assoc id 40278, assoc name 10.12.0.1
assoc in packets 104, assoc out packets 116, assoc error packets 13
org time 00000000.00000000 (00:00:00.000 UTC Mon Jan 1 1900)
rec time EE585B62.BDEF07B6 (00:52:50.741 UTC Sat Sep 19 2026)
xmt time EE585B62.BDEF07B6 (00:52:50.741 UTC Sat Sep 19 2026)
filtdelay =     2.08    2.07    2.15    2.11    2.09    2.45    2.20    2.02
filtoffset = -329.03 -349.93 -352.10 -366.29 -371.53 -371.30 -370.19 -370.00
filterror =     0.03    1.47    1.77    2.70    2.82    2.85    2.88    2.91
minpoll = 6, maxpoll = 10

10.20.0.4 configured, ipv4, our_master, sane, valid, stratum 3
ref ID 127.127.1.1    , time EE585B74.460EEB03 (00:53:08.273 UTC Sat Sep 19 2026)
our mode client, peer mode server, our poll intvl 64, peer poll intvl 64
root delay 0.00 msec, root disp 0.47, reach 17, sync dist 11.53
delay 3.03 msec, offset -27.3087 msec, dispersion 2.83, jitter 6.38 msec
precision 2**16, version 4
assoc id 40279, assoc name 10.20.0.4
assoc in packets 48, assoc out packets 48, assoc error packets 0
org time 00000000.00000000 (00:00:00.000 UTC Mon Jan 1 1900)
rec time EE585B84.0C06C105 (00:53:24.046 UTC Sat Sep 19 2026)
xmt time EE585B84.0C06C105 (00:53:24.046 UTC Sat Sep 19 2026)
filtdelay =     3.33    3.52    3.18    5.99    3.25    3.03    3.25    3.46
filtoffset =  -27.72  -10.69  -29.63  -29.26  -27.40  -27.30  -27.15  -27.12
filterror =     0.03    1.47    2.91    2.92    2.94    2.95    2.97    2.98
minpoll = 6, maxpoll = 10

R2-NTP-CORE#
```

## Block 08

**Preference test outcome.** After the recorded confirmation of applying prefer, R1 remains x and R4 remains selected. The command itself was confirmed in the lab notes, not captured in running-config.

```text
R2-NTP-CORE#show ntp associations

address         ref clock       st   when   poll reach  delay  offset   disp
x~10.12.0.1       .LOCL.           1     15     64     1  1.966 -320.72 187.59
*~10.20.0.4       127.127.1.1      3     91     64    37  3.033 -27.308  4.219

* sys.peer, # selected, + candidate, - outlyer, x falseticker, ~ configured
  R2-NTP-CORE#
```

## Block 09

**Later core recovery.** In the following session, R2 again reports synchronized at stratum 2 using R1. This is a later checkpoint, not a measured immediate failback.

```text
R2-NTP-CORE#sh ntp status 
Clock is synchronized, stratum 2, reference is 10.12.0.1      
nominal freq is 1000.0003 Hz, actual freq is 1000.4833 Hz, precision is 2**16
ntp uptime is 152000 (1/100 of seconds), resolution is 1000
reference time is EE59371E.6E8D327E (16:30:22.431 UTC Sat Sep 19 2026)
clock offset is 17.1036 msec, root delay is 2.06 msec
root dispersion is 130.59 msec, peer dispersion is 4.94 msec
loopfilter state is 'CTRL' (Normal Controlled Loop), drift is -0.000483072 s/s
system poll interval is 64, last update was 115 sec ago.
R2-NTP-CORE#
```

[Back to verification](README.md) · [Back to NTP](../README.md)
