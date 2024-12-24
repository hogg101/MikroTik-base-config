# Find and replace for production:
# 192.168.1. (port forwarding subnet)

	#V4 Input chain
/ip firewall filter
add action=accept chain=input comment="accept established,related,untracked" \
    connection-state=established,related,untracked
add action=drop chain=input comment="drop invalid" connection-state=invalid
add action=accept chain=input comment="accept ICMP" protocol=icmp
add action=drop chain=input comment="drop all not coming from a VLAN" \
    in-interface-list=!VLAN
    
    #V4 Forward chain
add action=fasttrack-connection chain=forward comment="fasttrack" \
    connection-state=established,related hw-offload=yes
add action=accept chain=forward comment=\
    "accept established,related, untracked" connection-state=\
    established,related,untracked
add action=drop chain=forward comment="drop invalid" \
    connection-state=invalid
add action=drop chain=forward comment=\
    "drop all from WAN not DSTNATed" connection-nat-state=!dstnat \
    connection-state=new in-interface-list=WAN
	
	#NAT
/ip firewall nat
add action=masquerade chain=srcnat comment="Hairpin NAT" dst-address=\
    192.168.1.0/24 src-address=192.168.1.0/24
add action=masquerade chain=srcnat comment="NAT masquerade" \
    out-interface-list=WAN
add action=dst-nat chain=dstnat comment="Example port forward, needs dst add list WANIP" \
    dst-address=!254.255.255.255 dst-port=8001 log=\
    yes protocol=tcp to-addresses=192.168.1.5 to-ports=8001 disabled=yes

/ipv6 firewall address-list
add address=::/128 comment="unspecified address" list=bad_ipv6
add address=::1/128 comment="lo" list=bad_ipv6
add address=fec0::/10 comment="site-local" list=bad_ipv6
add address=::ffff:0.0.0.0/96 comment="ipv4-mapped" list=bad_ipv6
add address=::/96 comment="ipv4 compat" list=bad_ipv6
add address=100::/64 comment="discard only " list=bad_ipv6
add address=2001:db8::/32 comment="documentation" list=bad_ipv6
add address=2001:10::/28 comment="ORCHID" list=bad_ipv6
add address=3ffe::/16 comment="6bone" list=bad_ipv6

/ipv6 firewall filter
add action=accept chain=input comment=\
    "accept established,related,untracked" connection-state=\
    established,related,untracked
add action=drop chain=input comment="drop invalid" connection-state=\
    invalid
add action=accept chain=input comment="accept ICMPv6" protocol=\
    icmpv6
add action=accept chain=input comment="accept UDP traceroute" port=\
    33434-33534 protocol=udp
add action=accept chain=input comment=\
    "accept DHCPv6-Client prefix delegation." dst-port=546 protocol=\
    udp src-address=fe80::/10
add action=drop chain=input comment=\
    "drop everything else not coming from a VLAN" in-interface-list=\
    !VLAN
add action=accept chain=forward comment=\
    "accept established,related,untracked" connection-state=\
    established,related,untracked
add action=drop chain=forward comment="drop invalid" \
    connection-state=invalid
add action=drop chain=forward comment=\
    "drop packets with bad src ipv6" src-address-list=bad_ipv6
add action=drop chain=forward comment=\
    "drop packets with bad dst ipv6" dst-address-list=bad_ipv6
add action=drop chain=forward comment="rfc4890 drop hop-limit=1" \
    hop-limit=equal:1 protocol=icmpv6
add action=accept chain=forward comment="accept ICMPv6" protocol=\
    icmpv6
add action=drop chain=forward comment=\
    "drop everything else not coming from a VLAN" in-interface-list=\
    !VLAN