# motor-alarm-system

Clone repo and run init_system.sh (root not required for execution, but is requried in script)

Script will clone, build and run server.

In ~/project/server is scripts start_server.sh and stop_server.sh for manual control
In ~/project/camera is scripts start_camera.sh and stop_camera.sh for manual control
In ~/project/vpn is start_vpn.sh and stop_vpn.sh for manual control
In ~/project/SIM is several modem related scripts for manual modem control
In ~/project/boot is several scripts and configurations required by the init script for setting up boot processes. DO NOT TOUCH THESE!

All executed processes are stored in ~/project/.pids, and can be killed using the command:
    'kill $(cat ~/project/.pids/{service name}.pid)'

All executed processes have log files stored in ~/project/.logs, and can be accessed with either:
    'cat ~/project/.logs/{service name}.log' 
or for a live feed: 
    'tail -f ~/project/.logs/{service name}.log'

NOTE: Ensure to replace {service name} with the service you wish to control. For a list of services that are active/have been active, do: 'ls ~/project/.pids'
