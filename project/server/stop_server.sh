#!/bin/bash

echo "Shutting down Motorbike Alarm System Server"
echo
echo "========================================="

# kill camera process
kill -9 $(cat /home/pi/project/.pids/server.pid)

bash /home/pi/project/camera/camera_off.sh

echo
echo "Server shut down!"
echo
echo "========================================"
echo
echo "Script finished successfully!"
