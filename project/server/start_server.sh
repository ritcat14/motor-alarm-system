#!/bin/bash

cd /home/pi/project/server
java -jar motor-system-server.jar &> /home/pi/project/.logs/server.log &
echo $! > /home/pi/project/.pids/server.pid
