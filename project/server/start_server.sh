#!/bin/bash

echo "Starting Motorbike Alarm System..."
echo

echo "Initiating server..."
cd /home/pi/project/server

bash stop_server.sh # execute stop to ensure no instances are running

java -jar motor-system-server.jar &> /home/pi/project/.logs/server.log &

echo $! > /home/pi/project/.pids/server.pid # save process id for closing server

echo "Server started!"
echo

echo "Motorbike System successfully started!"
