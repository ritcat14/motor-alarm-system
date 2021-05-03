#!/bin/bash

echo "Starting Motorbike Alarm System..."
echo

echo "Initiating server..."
bash ~/stop_server.sh # execute stop to ensure no instances are running

cd /home/pi/project/server

java -jar motor-system-server.jar &> server.log &

echo $! > /home/pi/.pids/camera.pid # save process id for closing server

echo "Server started!"
echo

echo "Motorbike System successfully started!"
