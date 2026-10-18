hostname APP-SERVER
ip link set eth0 up
ip addr replace 172.16.40.10/24 dev eth0
ip route replace default via 172.16.40.1 dev eth0