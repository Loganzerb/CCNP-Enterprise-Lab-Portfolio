hostname CLIENT-A
ip link set eth0 up
ip addr replace 10.10.10.25/24 dev eth0
ip route replace default via 10.10.10.1 dev eth0