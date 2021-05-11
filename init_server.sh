#!/bin/bash

echo "Script for fulling latest project from git, setting up the files and starting the media server."
echo
echo
cd /home/pi
echo "Attempting to close and running processe..."
kill -9 $(cat /home/pi/.pids/server.pid)
kill -9 $(cat /home/pi/.pids/minicom.pid)
kill -9 $(cat /home/pi/.pids/camera.pid)
echo

# Installs required packages
echo "Installing required packages (PASSWORD AND SUDO REQUIRED!)"
echo
sudo apt-get install -y openjdk-8-jre-headless openjdk-8-jre minicom python3 git cmake python-pil libjpeg-dev openvpn
echo "Done"
echo

# Removes old files and clones git repo
echo "Clonging Server repository"
cd /home/pi
rm -rf project
git clone https://github.com/ritcat14/motor-alarm-system.git
echo "Done"
echo

# Clones camera module
echo "Cloning camera streamer"
cd /home/pi/motor-alarm-system/project/camera
git clone https://github.com/jacksonliam/mjpg-streamer.git
cd /home/pi
echo "Done"
echo

# Setup project
echo "Moving files to appropriate location"
cp -r /home/pi/motor-alarm-system/project /home/pi
rm -rf motor-alarm-system
mkdir /home/pi/project/.pids
mkdir /home/pi/project/.logs
echo "Done"
echo

# Init all start scripts
echo "Setting up start-up scripts.."
sudo awk '/fi/ { print; print "sh /home/pi/project/SIM/SIM800X/pi_gpio_init.sh"; next }1' /etc/rc.local # add gpio init to boot
echo "Done"
echo

# Builds camera module
echo "Building camera module"
cd /home/pi/project/camera/mjpg-streamer/mjpg-streamer-experimental/
make CMAKE_BUILD_TYPE=Debug
sudo make install

export LD_LIBRARY_PATH=.
cd /home/pi
echo "Done"
echo

echo "Changing user permissions and unzipping files"
# change permissions, then unzip server
cd /home/pi/project/server
sudo chown pi motor-system-server.zip
unzip -o motor-system-server.zip
cd /home/pi
echo "Done"
echo


echo "Executing server"
# execute server
bash /home/pi/project/server/start_server.sh
echo "Done, log file at: /home/pi/project/server/server.log"
echo
echo "SERVER STARTED! ACCESS FROM: http://10.0.0.3:8500/web/index.html"
