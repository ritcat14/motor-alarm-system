#!/bin/bash

bash /home/pi/project/vpn/stop_vpn.sh

sudo systemctl start openvpn@client.service
