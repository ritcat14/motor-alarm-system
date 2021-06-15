#!/bin/bash

case "$1" in
    start)
        echo "Starting listen-for-shutdown.py"
	sudo python /usr/local/bin/listen-for-shutdown.py &
	;;
    stop)
	echo "Stopping listen-for-shutdown.py"
	sudo pkill -f /usr/local/bin/listen-for-shutdown.py
	;;
    *)
	echo "Usage: /etc/init.d/listen-for-shutdown.sh {start|stop}"
	exit 1
	;;
esac

exit 0
