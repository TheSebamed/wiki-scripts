#!/bin/bash
# Andmed masina kohta
set -x

# Machine name
host=$(hostname -A|cut -d" " -f1)

# Private IP address
hostname=$(hostname -I| cut -d" " -f1)

# Public IP address
Pub_IP=$(dig +short myip.opendns.com @resolver1.opendns.com 2>/dev/null || curl ipinfo.io/ip 2>/dev/null )

#Debian Version
Deb_Version=$(cat /etc/debian_version)

# Tuumasid systeemis
core=$(cat /proc/cpuinfo | grep -c "processor")

# Memory
memory=$(lshw -C memory | awk -f /tmp/memmaht.sh)

var=$(cat /sys/block/vda/queue/rotational 2>/dev/null || cat /sys/block/sda/queue/rotational 2>/dev/null)
dtype='nil'
if [ $var = 0 ]; then
        dtype=' SSD '
elif [ $var = 1 ]; then
        dtype=' HDD '
fi

#virtulization
var1=$(lsmod | grep kvm | awk 'NR==1{print $3}'  2>/dev/null)
vtype='nil'
if [ $var1 -gt 0 ]; then
        vtype='yes' 
else
    vtype='no'
fi


# Hard disk space
space=$(df -hT /home | awk 'FNR == 2 {print $3 "B"}')

#Full Space

fullspace=$(lshw -class disk -class storage | awk -f /tmp/maht.sh)

#Open Ports from External network
openports=$(nmap localhost | grep "open " | cut -d "/" -f1 | tr '\n' ' ' | nmap "$host" | grep "open " | cut -d "/" -f1 | tr '\n' ' ' )

printf '| %s | %s | %s | %s | %s | %s | %s | %s | %s | %s | %s |\n' "$host" "$hostname" "$Pub_IP" "$vtype" "$Deb_Version" " $core" "$memory" "$dtype" "$space" "$fullspace" "$openports"  > /tmp/phy_machines.txt

rm /tmp/maht.sh
# exit


