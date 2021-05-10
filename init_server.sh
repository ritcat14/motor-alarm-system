#!/bin/bash

echo "Script for fulling latest project from git, setting up the files and starting the media server."
echo
echo
echo "Attempting to close and running processe..."
kill -9 $(cat /home/pi/.pids/server.pid)

kill -9 $(cat /home/pi/.pids/camera.pid)
echo
echo "Installing required packages (PASSWORD AND SUDO REQUIRED!)"
echo
sudo apt-get install -y openjdk-8-jre-headless openjdk-8-jre minicom python3 git cmake python-pil libjpeg-dev openvpn
echo "Done"
echo
echo "Clonging Server repository"
cd ~/
rm -rf project
rm -rf SIM800X
rm -rf motor-alarm-system
git clone https://github.com/ritcat14/motor-alarm-system.git
echo "Done"
echo
echo "Moving files to appropriate location"
mkdir ~/.pids
cp -r ~/motor-alarm-system/project ~/
cp -r ~/motor-alarm-system/SIM ~/
sudo cp ~/project/vpn/motor-system-server.ovpn /etc/openvpn/motor-system-server.conf
echo "Done"
echo
echo "Setting up start-up scripts.."
sudo awk '/fi/ { print; print "sh /home/pi/SIM/SIM800X/pi_gpio_init.sh"; next }1' /etc/rc.local
echo "Done"
echo
echo "Cloning camera streamer"
cd ~/project/camera
git clone https://github.com/jacksonliam/mjpg-streamer.git
echo "Done"
echo
echo "Building camera module"
cd mjpg-streamer/mjpg-streamer-experimental/
make CMAKE_BUILD_TYPE=Debug
sudo make install

export LD_LIBRARY_PATH=.
echo "Done"
echo
# ensure no instances are running from previously
cd ~/project/server

echo "Changing user permissions and unzipping fiels"
# change permissions, then unzip server
sudo chown pi motor-system-server.zip
unzip -o motor-system-server.zip
echo "Done"
echo
echo "Executing server"
# execute server
bash ~/project/server/start_server.sh
echo "Done, log file at: /home/pi/project/server/server.log"
echo
echo "SERVER STARTED! ACCESS FROM: http://10.0.0.3:8500/web/index.html"
