#!/bin/bash

echo "Shutting down Motorbike Alarm System..."
echo
echo "========================================="

echo "Shutting down camera stream..."
echo
# kill camera process
kill -9 $(cat /home/pi/.pids/camera.pid)
echo
echo "Camera stream shut down!"
echo
echo "========================================"
echo
echo "Script finished successfully!"
