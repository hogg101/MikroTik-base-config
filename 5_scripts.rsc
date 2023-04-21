# Find and replace for production:
# changemesubdomain (DDNS subdomain)
# changemedomain (DDNS domain)
# changemenoipusername
# changemenoippassword
# changemeddnsinterface

#### NoIP DDNS updater

/system script
add dont-require-permissions=no name=DDNSupdate policy=\
    read,write,policy,test source="# No-IP automatic Dynamic DNS update\r\
    \n# Permissions needed: Write, Test, Read\r\
    \n#--------------- Change Values in this section to match your setup -----\
    -------------\r\
    \n\r\
    \n# No-IP User account info\r\
    \n:local noipuser \"changemenoipusername\"\r\
    \n:local noippass \"changemenoippassword\"\r\
    \n\r\
    \n# Set the hostname or label of network to be updated.\r\
    \n# Hostnames with spaces are unsupported. Replace the value in the quotat\
    ions below with your host names.\r\
    \n# To specify multiple hosts, separate them with commas.\r\
    \n:local noiphost \"changemesubdomain.changemedomain.com\"\r\
    \n\r\
    \n# Change to the name of interface that gets the dynamic IP address\r\
    \n:local inetinterface \"changemeddnsinterface\"\r\
    \n\r\
    \n#-----------------------------------------------------------------------\
    -------------\r\
    \n\r\
    \n:global previousIP\r\
    \n\r\
    \n:if ([/interface get \$inetinterface value-name=running]) do={\r\
    \n# Get the current IP on the interface\r\
    \n   :local currentIP [/ip address get [find interface=\"\$inetinterface\"\
    \_disabled=no] address]\r\
    \n\r\
    \n# Strip the net mask off the IP address\r\
    \n   :for i from=( [:len \$currentIP] - 1) to=0 do={\r\
    \n       :if ( [:pick \$currentIP \$i] = \"/\") do={ \r\
    \n           :set currentIP [:pick \$currentIP 0 \$i]\r\
    \n       } \r\
    \n   }\r\
    \n\r\
    \n   :if (\$currentIP != \$previousIP) do={\r\
    \n       :log info \"No-IP: Current IP \$currentIP is not equal to previou\
    s IP, update needed\"\r\
    \n       :set previousIP \$currentIP\r\
    \n\r\
    \n# The update URL. Note the \"\\3F\" is hex for question mark (\?). Requi\
    red since \? is a special character in commands.\r\
    \n       :local url \"http://dynupdate.no-ip.com/nic/update\\3Fmyip=\$curr\
    entIP\"\r\
    \n       :local noiphostarray\r\
    \n       :set noiphostarray [:toarray \$noiphost]\r\
    \n       :foreach host in=\$noiphostarray do={\r\
    \n           :log info \"No-IP: Sending update for \$host\"\r\
    \n           /tool fetch url=(\$url . \"&hostname=\$host\") user=\$noipuse\
    r password=\$noippass mode=http dst-path=(\"no-ip_ddns_update-\" . \$host \
    . \".txt\")\r\
    \n           :log info \"No-IP: Host \$host updated on No-IP with IP \$cur\
    rentIP\"\r\
    \n       }\r\
    \n   }  else={\r\
    \n       :log info \"No-IP: Previous IP \$previousIP is equal to current I\
    P, no update needed\"\r\
    \n   }\r\
    \n} else={\r\
    \n   :log info \"No-IP: \$inetinterface is not currently running, so there\
    fore will not update.\"\r\
    \n}"

/system scheduler
add interval=1h name=DDNSchedule on-event=DDNSupdate policy=\
    read,write,policy,test start-date=mar/09/2022 start-time=14:00:00
