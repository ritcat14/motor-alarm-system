#!/bin/bash

java -jar /home/pi/project/server/motor-system-server.jar &> /home/pi/project/.logs/server.log &
echo $! > /home/pi/project/.pids/server.pid
