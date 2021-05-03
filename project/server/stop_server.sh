#!/bin/bash

echo "Shutting down Motorbike Alarm System Server"
echo
echo "========================================="

# kill camera process
kill -9 $(cat /home/pi/.pids/server.pid)

bash ~/project/scripts/camera_off.sh

echo
echo "Server shut down!"
echo
echo "========================================"
echo
echo "Script finished successfully!"
