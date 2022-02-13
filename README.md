# VPNClientIPDynDNS
Simple script to extract public ipv4 from connected VPN clients and update DuckDNS

In case you run an OpenVPN Server with some clients connecting, but you need a clients public IP, just setup this script on your VPN Server.

OpenVPN Server Solution used:
https://github.com/angristan/openvpn-install

DuckDNS:
https://www.duckdns.org/

Ubuntu:
https://ubuntu.com/download/server

## Usage
    git clone https://github.com/ChuckNorrison/VPNClientIPDynDNS
    cd VPNClientIPDynDNS
    sh VPNClientIPDynDNS.sh
    nano config.cfg
    
Update config file with your settings (check your status.log for client names and your duckdns settings) and re-run the script.

    sh VPNClientIPDynDNS.sh

## Cronjob
    chmod +x VPNClientIPDynDNS/VPNClientIPDynDNS.sh
    crontab -e
    
insert at end of file

    */5 * * * * ~/git/VPNClientIPDynDNS/VPNClientIPDynDNS.sh >/dev/null 2>&1
