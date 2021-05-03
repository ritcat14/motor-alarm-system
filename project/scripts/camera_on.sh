#!/bin/bash

echo "Starting Motorbike Alarm System..."
echo

echo "Initiating camera..."
# execute camera stream as background process
cd /home/pi/project/camera/mjpg-streamer/mjpg-streamer-experimental/
./mjpg_streamer -o "output_http.so -w ./www" -i "input_raspicam.so" &>/dev/null &
echo $! > /home/pi/.pids/camera.pid

echo "Camera stream started!"
echo

echo "Motorbike System successfully started!"
