# Hostname
hostname PC-CLIENT

# Interface configuration
ip addr flush dev eth0
ip addr add 10.20.10.10/24 dev eth0
ip link set eth0 up

# Default gateway
ip route replace default via 10.20.10.1