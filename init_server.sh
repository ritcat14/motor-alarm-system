#!/bin/bash

echo "Script for fulling latest project from git, setting up the files and starting the media server."
echo

# git clone
# ensure no instances are running from previously
cd ~/project/server

echo "Removing old server"
rm -rf * # DO NOT MOVE THIS LINE! Removes all files in current directory, specified as '~/project/server' above ^
echo "Done"
echo
echo "Pulling latest server file from dev server (PASSWORD REQUIRED!)"
# pull new server from dev server
sudo rsync -rvz -e "ssh -p 12221" --progress root@192.168.1.245:/mnt/disks/dev/Java/projects/motor-alarm-system/motor-system-server.zip .
echo "Done"
echo
echo "Changing user permissions and unzipping fiels"
# change permissions, then unzip server
sudo chown pi motor-system-server.zip
unzip motor-system-server.zip
echo "Done"
echo
echo "Executing server"
# execute server
bash ~/start_server.sh
echo "Done, log file at: /home/pi/project/server/server.log"
echo
echo "SERVER STARTED! ACCESS FROM: http://10.0.0.3:8500/web/index.html"



