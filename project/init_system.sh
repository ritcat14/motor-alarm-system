#!/bin/bash

# Script for setting up system on fresh device

# Install required software and ensure system is up to date
sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install openjdk-8-jre-healess openjdk-8-jre python3 minicom git openvpn apache2 ufw ppp vlc

# Start by ensureing in right directory
cd ~/

# Then copy project to home and extract server
cp -r ~/motor-alarm-system/project .
# Delete file
rm -rf motor-alarm-system
cd ~/project/server
unzip -o *.zip
cd ~/

# Begin process by setting up internet
sudo cp ~/project/SIM/fona /etc/ppp/peers/fona
sudo ufw enable
sudo ufw allow 12221						# SSH
sudo ufw allow 8500						# Web Server
sudo ufw allow 8080						# Camera Stream
sudo ufw allow 443						# VPN
sudo ufw allow proto gre from 193.113.200.195			# PPP Gateway access
sudo iptables -t nat -A POSTROUTING -o ppp0 -j MASQUERADE	# NAT Rules for PPP Communication
sudo systemctl restart ufw					# Restart firewall to apply changes
sudo cp ~/project/vpn/client.ovpn /etc/openvpn/client.conf	# Copy VPN client file

# Finally, copy boot script to ensure system starts on boot
sudo cp ~/project/boot/config.txt /boot/config.txt
sudo cp ~/project/boot/rc.local /etc/rc.local
