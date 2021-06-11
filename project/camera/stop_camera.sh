#!/bin/bash

# Disable VLC RTSP Camera Stream
sudo kill -9 $(cat /home/pi/project/.pids/camera.pid)
