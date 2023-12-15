# Find and replace for production:
# changemerouterID (router's name)
# changemewangraph (name of the interface for WAN graphing i.e ether1)
# changemeadminuser (admin username)
# changemeadminpass (Password for admin user: routeradmin)

#### Extras

/ip neighbor discovery-settings
set discover-interface-list=VLAN

/system package update
set channel=stable

/system logging
add action=disk topics=critical

/ip cloud
set ddns-enabled=yes

/system clock
set time-zone-name=Europe/London

/system identity
set name="changemerouterID"

/tool graphing interface
add interface=changemewangraph

/tool graphing resource
add

/tool mac-server
set allowed-interface-list=VLAN

/tool mac-server mac-winbox
set allowed-interface-list=VLAN

/tool mac-server ping
set enabled=no

#### BTH VPN
/ip/cloud/
set back-to-home-vpn=enabled
/interface list member
add interface=back-to-home-vpn list=VLAN 

/user
add name=changemeadminuser password=changemeadminpass group=full
remove admin
