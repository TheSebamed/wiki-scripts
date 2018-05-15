#!/bin/bash
set -x

# Location where bash scripts are located.
phy_ssh=/opt/wiki_scripts/servers.sh
vm_ssh=/opt/wiki_scripts/virtualservers.sh
insta=/opt/wiki_scripts/proginst.sh
maht=/opt/wiki_scripts/maht.sh
memmaht=/opt/wiki_scripts/memmaht.sh
xml=/opt/wiki_scripts/alltogether.xml
rmine=/opt/wiki_scripts/rmine.sh

# Hosts where we will ssh into. Variable remine is only used for sending the final Alltogether.xml to the redmine host. 
# So it is recommended for you to not add any more hosts there.
Phy_Hosts=( vmfarm1.stacc.ee barclay.stacc.ee p12.stacc.ee maximus.stacc.ee backup.stacc.ee firefly.stacc.ee accountant.stacc.ee 10.6.6.90 )
vmfarm1=( icinga.stacc.ee ldap.stacc.ee mail.stacc.ee openvpn.stacc.ee dns.stacc.ee redmine.stacc.ee owncloud.stacc.ee www.stacc.ee git.stacc.ee )
maximus=( elasticsearch.stacc.ee jenkins.stacc.ee egcut.stacc.ee demo.stacc.ee )
firefly=( client.stacc.ee )
texta=( 10.6.6.91 10.6.6.92 10.6.6.93 )
remine=(redmine.stacc.ee)

SendFiles2 () {
        local host2="$1"
        ssh "root@$host2" 'bash -s' <"$insta"
	scp "$maht" "$memmaht" "root@$host2":/tmp/
}

SendFiles () {
        local host="$1"
        ssh "root@$host" 'bash -s' <"$phy_ssh"
        ssh "root@$host" cat /tmp/phy_machines.txt
}

SendFiles1 () {
        local host1="$1"
        ssh "root@$host1" 'bash -s' <"$vm_ssh"
        ssh "root@$host1" cat /tmp/vm_machines.txt
}

SendFiles3 () {
        local host3="$1"
        scp "$xml" "root@$host3":/opt/wiki_scripts/
        ssh "root@$remine" 'bash -s' <"$rmine"
}


#Sends file to install packages
for host2 in "${Phy_Hosts[@]}"; do
        SendFiles2 "$host2"
done
printf 'h2. Physical machines\n\n|_.Machine  name|_.Private IP |_.Public IP|_.Virtualisation|_.OS|_.Cores|_.Memory|_.HDD/SSD|_.Machine Space|_.Total Disk Space|_.External Ports |\n' > phy_machines.txt

# Save the following data to the phy_machine file.
for host in "${Phy_Hosts[@]}"; do
        SendFiles "$host"
done >>/opt/wiki_scripts/phy_machines.txt

printf '\nh2. Virtual Machines \n\n|_.Machine |_.Hostname |_.Private IP|_.Public IP |_.Debian Version |_.Cores |_.RAM |_.Disk Type|_.Disk Size|_.Internal Firewall|_.External Ports |' >vm_machines.txt

printf ' \n|/%d.vmfarm1 ' "${#vmfarm1[@]}" >>  vm_machines.txt

# Save the following data to the vm_machine file.
for host1 in "${vmfarm1[@]}"; do
        SendFiles1 "$host1"
done >>/opt/wiki_scripts/vm_machines.txt

printf ' |/%d.maximus ' "${#maximus[@]}" >>  vm_machines.txt

# Save the following data to the vm_machine file.
for host1 in "${maximus[@]}"; do
        SendFiles1 "$host1"
done >>/opt/wiki_scripts/vm_machines.txt

printf '|/%d.firefly ' "${#firefly[@]}" >>  vm_machines.txt

# Save the following data to the vm_machine file.
for host1 in "${firefly[@]}"; do
        SendFiles1 "$host1"
done >>/opt/wiki_scripts/vm_machines.txt


printf ' |/%d.texta-host ' "${#texta[@]}" >> vm_machines.txt

# Save the following data to the vm_machine file.
for host1 in "${texta[@]}"; do
        SendFiles1 "$host1"
done >>/opt/wiki_scripts/vm_machines.txt

cat upper.txt phy_machines.txt vm_machines.txt lower.txt > alltogether.xml
rm phy_machines.txt vm_machines.txt
./delete.sh


# Execute the final script that uploads new Alltogether.xml file into the new host.
for host3 in "${remine[@]}"; do
        SendFiles3 "$host3"
done

