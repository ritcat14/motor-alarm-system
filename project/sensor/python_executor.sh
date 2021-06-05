#!/bin/bash

if [ -z $1 ]; then
	echo "Format for script: ./python_executor.sh <\"python script path\">"
	exit
else
	python $1
	exit $?
fi
