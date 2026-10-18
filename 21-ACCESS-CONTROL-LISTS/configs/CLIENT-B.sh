hostname CLIENT-B
ip link set eth0 up
ip addr replace 10.20.20.25/24 dev eth0
ip route replace default via 10.20.20.1 dev eth0