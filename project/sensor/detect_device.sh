#!/bin/bash

if [ -z $1 ]; then
	echo "Format for script: ./detect_device.sh <busID> [1,3,4,5]"
	exit
else
	sudo i2cget -y $1 0x68 && exit 0 || exit 1
fi
