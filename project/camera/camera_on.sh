#!/bin/bash

echo "Starting Motorbike Alarm System..."
echo

echo "Initiating camera..."
# execute camera stream as background process
bash /home/pi/project/camera/camera_off.sh
cd /home/pi/project/camera/mjpg-streamer/mjpg-streamer-experimental/
./mjpg_streamer -o "output_http.so -w ./www" -i "input_raspicam.so" &> /home/pi/project/.logs/camera.log &
echo $! > /home/pi/project/.pids/camera.pid

echo "Camera stream started!"
echo

echo "Motorbike System successfully started!"
