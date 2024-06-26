# Find and replace for production:
# 192.168.1. (LAN pool)
# 192.168.20. (Guest pool)
# 192.168.99. (Management pool)
# 192.168.40. (Systems pool)
# 192.168.8. (NVX pool)

#### DHCP Server

/ip pool
add name=Private-pool ranges=192.168.1.81-192.168.1.254
add name=Guest-pool ranges=192.168.20.2-192.168.20.254
add name=MGMT-pool ranges=192.168.99.81-192.168.99.254
add name=Systems-pool ranges=192.168.40.81-192.168.40.254
add name=NVX-pool ranges=192.168.8.2-192.168.8.254

/ip dhcp-server
add address-pool=Private-pool disabled=no interface=Private_VLAN lease-time=1d name=Private-DHCP
add address-pool=Guest-pool disabled=no interface=Guest_VLAN lease-time=1d name=Guest-DHCP
add address-pool=MGMT-pool disabled=no interface=MGMT_VLAN lease-time=1d name=MGMT-DHCP
add address-pool=Systems-pool disabled=no interface=Systems_VLAN lease-time=1d name=Systems_VLAN
add address-pool=NVX-pool disabled=no interface=NVX_VLAN lease-time=1d name=NVX-DHCP

/ip dhcp-server network
add address=192.168.1.0/24 dns-server=192.168.1.1 gateway=192.168.1.1 \
    netmask=24
add address=192.168.20.0/24 dns-server=208.67.222.123,208.67.220.123 gateway=192.168.20.1 \
    netmask=24
add address=192.168.99.0/24 dns-server=192.168.99.1 gateway=192.168.99.1 \
    netmask=24
add address=192.168.40.0/24 dns-server=192.168.40.1 gateway=192.168.40.1 \
    netmask=24
add address=192.168.8.0/24 dns-server=192.168.8.1 gateway=192.168.8.1 \
    netmask=24


#### DHCP Client

/ip dhcp-client
add comment="nameofinternetconnection" interface=ether1


#### Router IP Address

/ip address
add address=192.168.1.1/24 interface=Private_VLAN network=192.168.1.0
add address=192.168.20.1/24 interface=Guest_VLAN network=192.168.20.0
add address=192.168.99.1/24 interface=MGMT_VLAN network=192.168.99.0
add address=192.168.40.1/24 interface=Systems_VLAN network=192.168.40.0
add address=192.168.8.1/24 interface=NVX_VLAN network=192.168.8.0


#### DNS

/ip dns
set allow-remote-requests=yes servers=1.1.1.1,1.0.0.1,8.8.8.8,8.8.4.4

/ip dns static
add address=192.168.99.1 name=router.lan

#### Services

/ip service
set telnet disabled=yes
set ftp disabled=yes
set www address=192.168.1.0/24,192.168.99.0/24,192.168.216.0/24
set ssh address=192.168.1.0/24,192.168.99.0/24,192.168.216.0/24
set api disabled=yes
set winbox address=192.168.1.0/24,192.168.99.0/24,192.168.216.0/24
set api-ssl disabled=yes


#### Turn on VLAN filtering:

/interface bridge
set bridge vlan-filtering=yes
