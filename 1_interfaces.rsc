/interface bridge
add name=bridge vlan-filtering=no

/interface ethernet
set [ find default-name=ether1 ] comment="nameofinternetconnection"
set [ find default-name=ether2 ] disabled=yes
set [ find default-name=ether3 ] disabled=yes
set [ find default-name=ether4 ] disabled=yes
set [ find default-name=ether5 ] disabled=yes
set [ find default-name=ether11 ] disabled=yes
set [ find default-name=ether12 ] disabled=yes

# Uncomment for PPPoE connection on WAN port.
# /interface pppoe-client
# add add-default-route=yes comment="Zen Internet" disabled=no interface=ether1 name=pppoe1 password=something \
# 	use-peer-dns=yes user="zensomething@zen"
# Note: also uncomment the /interface/list/member entry

/interface vlan
add interface=bridge name=Private_VLAN vlan-id=10
add interface=bridge name=Guest_VLAN vlan-id=20
add interface=bridge name=MGMT_VLAN vlan-id=99

/interface bridge port
add bridge=bridge interface=ether6 pvid=10
add bridge=bridge interface=ether7 pvid=10
add bridge=bridge interface=ether8 pvid=10
add bridge=bridge interface=ether9 pvid=10
add bridge=bridge interface=ether10 pvid=10
add bridge=bridge interface=ether13 pvid=10

/interface bridge vlan
add bridge=bridge untagged=ether6,ether7,ether8,ether9,ether10,ether13 tagged=bridge vlan-ids=10
add bridge=bridge tagged=bridge,ether6,ether7,ether8,ether9,ether10,ether13 vlan-ids=20
add bridge=bridge tagged=bridge,ether6,ether7,ether8,ether9,ether10,ether13 vlan-ids=99

/interface list
add name=WAN
add name=MGMT
add name=VLAN

/interface list member
add interface=ether1 list=WAN
add interface=MGMT_VLAN list=MGMT
add interface=MGMT_VLAN list=VLAN
add interface=Private_VLAN list=VLAN
add interface=Guest_VLAN list=VLAN
# add interface=pppoe1 list=WAN
