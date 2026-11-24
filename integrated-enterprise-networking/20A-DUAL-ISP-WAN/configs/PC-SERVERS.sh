# PC-SERVERS - VLAN 20
# Static IPv4 configuration

ip addr add 10.20.20.20/24 dev eth0
ip link set dev eth0 up
ip route replace default via 10.20.20.1 dev eth0