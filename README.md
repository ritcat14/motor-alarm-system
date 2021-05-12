# motor-alarm-system

Copy init_project.sh into home folder and execute (root not required for execution, but is requried in script)

Script will clone, build and run server.

In ~/project/server is scripts start_server.sh and stop_server.sh for manual control
in ~/project/camera is scripts start_camera.sh and stop_camera.sh for manual control

All executed processes are stored in ~/project/.pids, and can be killed using the command:
    'kill $(cat ~/project/.pids/{service name}.pid)'

All executed processes have log files stored in ~/project/.logs, and can be accessed with either:
    'cat ~/project/.logs/{service name}.log' 
or for a live feed: 
    ' tail -f ~/project/.logs/{service name}.log'

NOTE: Ensure to replace {service name} with the service you wish to control. For a list of services that are active/have been active, do: 'ls ~/project/.pids'
