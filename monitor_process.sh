#!/bin/bash

function is_process {
	
	if pgrep -x "$1" >/dev/null ; then
		return 0
	else
		return 1
	fi

}

function restart_process {
	
	if sudo systemctl restart "$1" ; then
		echo "restarting the process"
	else
		echo "restart failed"
	fi

}

process_name="$1"
attempt=1
max_attempt=3

while [ $attempt -le $max_attempt ]; do
	
	if is_process "$process_name" ;then
		echo "process is running"
		echo "Process $process_name is running" | mail -s "Monitor Process: $process_name" awsvandana18@gmail.com
	else
		restart_process "$process_name" 
	fi
	attempt=$((attempt+1))
	sleep 5

done
