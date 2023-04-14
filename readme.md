# MikroTik base config

This is a collection of MikroTik scripts which can be modified for production.

## Interfaces

1. **/interface/bridge** 
Most routers will only need a single “bridge”.
2. **/interface/ethernet** 
Interfaces are enabled by default so this section is for disabling redundant ports and adding comments. For example on the RB4011 with two switch chips, I would use one switch chip for my LAN bridge and disable all ports on the second switch chip apart from any internet connections.
3. **/interface/pppoe-client**
Leave this commented out unless you need a pppoe client for an internet connection.
4. **/interface/vlan**
Add all your VLANs and their tags here initially. I prefer to have all my subnets on VLANs on the bridge rather than having a “native” subnet directly on the bridge.
5. **/interface/bridge/port**
Add the ports you want to be on the bridge. For example on the 5009 I would add all ports except the WAN(s). Also set the port VLAN ID (pvid) which is the VLAN that will be untagged on the port.
6. **/interface/bridge/vlan**
Use this section to set which VLAN’s you want to be tagged or untagged per port. All VLANs should be tagged on the bridge regardless of whether they are tagged or untagged on individual ports.
7. **/interface/list**
Add lists you can use to group interfaces into. These groups will make firewall rules easier to manage.
8. **/interface/list/member**
Add interfaces to your lists. Because we’re using VLANs we don’t need to add every interface on the bridge, we only need to add the VLANs to lists. If using a PPPoE client don’t forget to add it to the WAN group otherwise it won’t be firewalled.