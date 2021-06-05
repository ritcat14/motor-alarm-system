#!/bin/bash

echo "Shutting down PPP network..."
echo
# kill camera process
sudo kill $(cat /home/pi/project/.pids/ppp.pid)
echo
echo "PPP network shut down!"
echo
