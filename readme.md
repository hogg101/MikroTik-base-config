# MikroTik base config

This is a collection of MikroTik scripts which can be modified for production.

The goal is to set up a solid foundation for a home router with the following features:

- VLANs in place to separate broadcast domains into “Private, Guest and Management” subnets. By default, inter-VLAN-routing is allowed through the firewall. Additional configuration will be needed to block VLANs from accessing each other.
- Decent basic IPv4 and IPv6 stateful firewalls.
- Single WAN but with the ability to easily add multiple internet connections and apply policy based routing or failover.
- Unnecessary services turned off. Useful ones kept on but secured.
- L2TP VPN set up for remote access.
- Graphing for WAN and resources.
- Fasttrack enabled but can simply be disabled if queues/QoS are to be added.

## Interfaces

1. **/interface/bridge** 
Most routers will only need a single “bridge”. Make sure vlan-filtering=**no** until all your interfaces and IP settings are ready. If **=yes** before you’re ready you will lose connectivity.
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

## Services & Addresses

1. Use the find and replace prompts to set the IP ranges of your subnets and VPN pool. Also find and replace the VPN PSK, username and password for the L2TP road warrior VPN server.
2. **/ip/pool**
Add ranges of IP addresses for your subnets and one for your VPN users.
3. **/ip/dhcp-server**
Add DHCPv4 servers to the interfaces that need one.
4. **/ip/dhcp-server/network**
Give IP settings to the DHCP servers themselves.
5. /**ip/dhcp-client**
Add a DHCPv4 client to the interface your internet connection will be on if required.
6. **/ip/address**
Give IP addresses and subnet info to your VLAN interfaces.
7. **/ip/dns**
Set your own DNS servers that you would like the router to use and allow requests from devices on the LAN to use the DNS cache on the router.
8. **/ip/dns/static**
Here you can add manual DNS entries.
9. **/ppp/profile**
Set up a profile for all your VPN users to share settings.
10. **/ppp/secret**
Add a VPN user and set their password for remote access.
11. **/interface/l2tp-server/server**
Set up the L2TP server and give it a pre-shared-key.
12. **/ip/service**
Disable the services that won’t be required and specify the addresses that are allowed access to the services that will remain enabled.
13. **/interface/bridge**
At this point you’re ready to enable VLAN filtering on the bridge. You should be able to regain access via the IP address of the router’s “native” or “untagged” VLAN once you get an address from the DHCP server.

## Firewall

1. Use the find & replace prompts to ensure the correct addresses are included for the subnet that may need port forwarding and/or haripin NAT. Also to set the VPN pool address range to allow it through the firewall.
2. **/ip/firewall/filter**
Setup the firewall filters on the input (to router) and forward (through router) chains.
3. **/ip/firewall/nat**
Setup source NAT rules like masquerade and hairpinning and destination NAT rules like port forwarding. If using port forwarding you will need to add your external IP as a destination address OR in case of dynamic IP allocation you can use a nifty trick by adding a DDNS address to a /firewall/address-list called “WANIP”. This will dynamically update the IP address and add it to the same list automatically. In this case, instead of adding your external IP as a destination address, just add WANIP as a destination address list and the router will keep it updated dynamically.
4. **/ipv6/firewall/address-list**
This is a list of “bad” IPv6 addresses that we want to block using the firewall.
5. **/ipv6/firewall/filter**
Configure filters for IPv6 traffic.

## Extras

1. **/ip neighbor discovery-settings**
Set the interface list you want to enable neighbour discovery on. Useful if using Winbox so that it discovers the IP, MAC and other info about your router automatically.
2. **/system package update**
Set the channel you would like updates to follow. My recommendation is Stable or Long Term.
3. **/system logging**
Add an option to the default logging behaviour to write critical logs to non volatile memory. This is useful because normally the logs are lost upon reboot.
4. **/ip cloud**
Set the router to use MikroTik’s DDNS service. Useful for the port forwarding trick mentioned above or if you need DDNS updates because you don’t have a static external IP.
5. **/system clock**
Set the time zone. The system should update it’s time using ip/cloud so there’s no need to set up NTP.
6. **/system identity**
This is just a friendly name for your router that appears in various places in UI and CLI.
7. **/tool graphing interface**
This setting will let you add interfaces to a list that the router will create traffic graphs for. The graphs can be viewed either in Winbox or using the web interface. They are sometimes quite insightful.
8. **/tool graphing resource**
This command adds the system resources like CPU and memory usage to the graphing tool.
9. **/tool mac-server**
This tool allows you to connect to the router using MAC telnet even if you don’t have IP connectivity to it. It’s best to limit this to internal interfaces only. When MAC Telnet Server is on, you can connect to the server with another RouterOS device using the mac-telnet client.
10. **/tool mac-server mac-winbox**
Same as MAC telnet but this will allow you to connect using Winbox even if there is no IP connectivity.
11. **/tool mac-server ping**
Same principle again, this setting will allow another MikroTik device to ping the router using its MAC address.
12. **/user**
Add a new user with full rights and remove the default “admin” one.

## Scripts

Currently this script just contains a script that will automatically update the WAN IP using NoIP’s DDNS service. It also contains a scheduler that will run it every hour.
