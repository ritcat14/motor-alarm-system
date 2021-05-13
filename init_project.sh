#!/bin/bash

echo "==============================================================="
echo "      Welcome to motor-alarm-system setup script!              "
echo "==============================================================="
echo

if [ -z $1 ]; then
	echo " This script will collect, organise and build the alarm system."
	echo 
	echo "==============================================================="
	echo 
	echo "==============================================================="
	echo "              Installing required packages...                  "
	echo
	sudo apt-get update && sudo apt-get upgrade
	sudo apt-get install -y openjdk-8-jre-headless openjdk-8-jre python3 cmake
	sudo apt-get install -y minicom git python-pil libjpeg-dev openvpn apache2 ufw
	echo
	echo "                          Done                                 "
	echo "==============================================================="
	echo
	echo "==============================================================="
	echo "              Cleaning any old files/processes...              "
	echo
	cd /home/pi
	# Kill and hanging processes from previous installs
	for f in /home/pi/project/.pids/*.pid; do
		kill $(cat $f)
		kill -9 $(cat $f)
	done
	cd /home/pi # Safety check, do not move!
	sudo find /home/pi/ -type d -delete --max-depth=1	# Ensure is preceeded my cd /home/pi!
	echo
	echo "                          Done                                 "
	echo "==============================================================="
	echo "      Cloning motor-alarm-system and camera repository...      "
	echo
	git clone https://github.com/ritcat14/motor-alarm-system.git
	cd /home/pi/motor-alarm-system/project/camera
	git clone https://github.com/jacksonliam/mjpg-streamer.git
	cd /home/pi
	mv /home/pi/motor-alarm-system/project /home/pi/
	rm -rf /home/pi/motor-alarm-system
	echo
	echo "                          Done                                 "
	echo "==============================================================="
	echo "              Setting up project submodules...                 "
	echo
	cd /home/pi/project/
	mkdir .pids
	mkdir .logs
	cd /home/pi
	echo "                  Building camera module...                    "
	echo
	cd /home/pi/project/camera/mjpg-streamer/mjpg-streamer-experimental/
	make CMAKE_BUILD_TYPE=Debug
	sudo make install
	export LD_LIBRARY_PATH=.
	echo 
	echo "                  Camera build successfull                     "
	echo
	echo "                    Setting up network...                      "
	echo
	sudo cp /home/pi/project/SIM/PPP/fona /etc/ppp/peers/
	sudo cp /home/pi/project/SIM/PPP/interfaces /etc/network/interfaces
	sudo cp /home/pi/project/SIM/PPP/resolv.conf /etc/resolv.conf
	sudo ufw enable
	sudo ufw allow 12221 						# SSH
	sudo ufw allow 8500  						# Web server
	sudo ufw allow 8080  						# Camera stream
	sudo ufw allow 443   						# VPN
	sudo ufw allow proto gre from 193.113.200.195   		# PPP Gateway access
	sudo iptables -t nat -A POSTROUTING -o ppp0 -j MASQUERADE	# allow NAT for PPP
	sudo systemctl restart ufw					# Restart firewall
	echo
	echo "                   Network setup complete                      "
	echo
	echo "                      Setting up noip...                       "
	echo
	cd /home/pi/project/noip
	wget https://www.noip.com/client/linus/noip-duc-linux.tar.gz
	tar -zxvf noip-duc-linux.tar.gz
	cd /home/pi/project/noip/noip-*/
	sudo make
	echo
	echo "Please use noip username/password. Interval time is in minutes!"
	echo
	sudo make install
	echo
	echo "                  noip setup complete                          "
	echo
	echo "                  Setting up OpenVPN...                        "
	echo
	cp /home/pi/project/vpn/client.conf /etc/openvpn/
	sudo systemctl enable openvpn@client.service
	sudo systemctl start openvpn@client.service
	echo
	echo "                  OpenVPN setup complete                       "
	echo 
	echo "                  Setting up webserver...                      "
	echo
	cd /home/pi/project/server
	sudo chown pi motor-system-server.zip
	unzip -o motor-system-server.zip
	echo
	echo "                  Webserver setup and ready                    "
	echo
	echo "              Adding scripts to boot sequence...               "
	echo
	# copy first rc.local
	sudo cp /home/pi/project/boot/first_rc.local /etc/rc.local
	echo "==============================================================="
	echo "                        Init complete.                         "
	echo "==============================================================="
	echo "        REMOVE ETHERNET AND PRESS ANY KEY WHEN DONE...         "
	echo
	while [ true ]; do read -t 3 -n 1; if [ $? = 0 ] ; then break; fi
	echo
	sudo reboot now
else
	ARGUMENT=$1
	sudo cp /home/pi/project/boot/second_rc.local /etc/rc.local
	echo "Argument: ${ARGUMENT}"
	echo "              Finishing init. Starting server...               "
	bash /home/pi/project/server/start_server.sh
	echo
	echo "                          Done                                 "
	echo "==============================================================="
	echo "                  Server accessible from:                      "
	echo "      http://motor-system1.ddns.net:8500/web/index.html        "
fi
