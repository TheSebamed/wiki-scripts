#!/bin/bash
set -x

kass=$(cat /home/user/git/scripts/.karl)
koer=$(cat /home/user/git/scripts/.kana)


#Uploading the newly generated alltogether.xml file to the wikipedia site. user must have access to edit the wiki site page.
curl -v -H "Content-Type: application/xml" -X PUT --data-binary "@alltogether.xml" -u $kass:$koer http://192.168.1.219/redmine/projects/test/wiki/PCs.xml

#Renames the old .xml file into the curdate name. So next time the script will use the new Alltogether.xml file.
#mv /opt/wiki_scripts/alltogether.xml /opt/wiki_scripts/"$(date +"%m-%d-%Y")".xml

#Optional: Delete older than X amount of time files inside /opt/wiki_scripts/ folder. 
#find /opt/wiki_scripts -type f -ctime 30 | xargs rm 
