# PC-USERS - VLAN 10
# Static IPv4 configuration

ip addr add 10.20.10.10/24 dev eth0
ip link set dev eth0 up
ip route replace default via 10.20.10.1 dev eth0