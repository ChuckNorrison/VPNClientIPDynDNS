#!/bin/bash

# Simple script to extract public ipv4 from connected VPN clients
# push public IP with DynDNS service
# https://www.duckdns.org/

# User defined variables
vpnStatusFile="/var/log/openvpn/status.log"
vpnClient="client1"
duckdns_token="12345"
duckdns_host="myduckdns"

# log results
timestamp=$(date "+%d.%m.%Y %H:%M:%S")
logfile=dyndns.log
if [ ! -f $logfile ]; then
    touch $logfile
fi

# check if vpn log file exists
if [ ! -f $vpnStatusFile ]; then
    echo "$timestamp: Error: VPN status file is missing!" >> $logfile
    echo "Please update path to OpenVPN Server status.log file to find Client IPs"
    exit 1
fi

# read vpn log file and extract desired IP for connected client
while read -r line; do 

    if [ $(expr "$line" : "^$vpnClient,.*$") -gt 0 ]; then
        #echo "$timestamp: DEBUG: VPN Client found: $line" >> $logfile
        pubIP=$(echo "$line" | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
        echo "$vpnClient=$pubIP"
        continue
    fi

done < "$vpnStatusFile"

# verify Public IP is set
if [ -z "$pubIP" ]; then
    echo "$timestamp: Error: $vpnClient not found!" >> $logfile
    exit 1
fi

# update duckdns DynDNS
response=$(curl -sSL -w '%{http_code}' "https://nouser:$duckdns_token@www.duckdns.org/nic/update?hostname=$duckdns_host&myip=$pubIP&wildcard=NOCHG&mx=NOCHG&backmx=NOCHG")
echo "$timestamp: $response" >> $logfile

exit 0
