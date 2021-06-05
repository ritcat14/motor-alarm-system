#!/bin/bash

echo "Initiating ppp dialup..."
# execute camera stream as background process
bash /home/pi/project/SIM/poff.sh
sudo pon fona &> /home/pi/project/.logs/ppp.log &
echo $! > /home/pi/project/.pids/ppp.pid

echo "PPP started!"
echo
