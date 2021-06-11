#!/bin/bash

# Enable VLC RTSP Camera Stream

raspivid -o - -t 0 -n | cvlc -vvv stream:///dev/stdin --sout '#rtp{sdp=rtsp://:8080/}' :demux=h264 &> /home/pi/project/.logs/camera.log &
echo $! > /home/pi/project/.pids/camera.pid
