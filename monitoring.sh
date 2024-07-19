#!/bin/bash

function cpu_usage {
	echo "CPU Usage is:"
	top -bn1 | grep "Cpu(s)" | awk '{print $2}'
}

function memory_usage {
	 free -h | awk 'NR==2{printf "Memory Usage: %s, Free: %s\n", $3, $4}'
 }

function disk_usage {
	
	df -h | awk '$NF=="/"{printf "Used: %d/%d %s%\n", $3, $2, $5}'	
}

function monitor_service(){
	local service_name=$1
	
	if sudo systemctl is-active --quiet $service_name;then
		echo "Service: $service_name is running"
	else
		echo "Service: $service_name is not running"
		echo "Do you want to start the service $service_name (y/n): "
		read option

		if [[ $option == 'y' || $option == 'Y' ]]; then
			sudo systemtl start $service_name
			if sudo systemctl is-active --quiet $service_name;then
			       echo "Service: $service_name has been started sucessfully"
		       else
				echo "Error: Failed to start service"
		 	fi		

		fi

	fi
}

function display_menu(){
		
	echo "1. Show CPU Usage"
	echo "2. Show Memory Usage"
	echo "3. Show Disk Usage"
	echo "4. Monitor Service"
	echo "5. Exit"
	echo -n "Please Enter the option from 1 to 5:"

}

function monitor_metrics(){
	
	while true; do
		
		clear
		echo "Monitoring Metrics"
		echo "------------------"
		display_menu
		read user_selection

		case $user_selection in

			1)
				cpu_usage
				;;
			2)
				memory_usage
				;;
			3)
				disk_usage
				;;
			4)
				echo "Please enter the service name"
				read service_name
				monitor_service $service_name
				;;
			5)
				echo "Exiting ..."
				break
				;;
			*)
				echo "Incorrect Input: Please enter valid choice"
				;;
		esac


		echo "Enter the sleep interval before the next update (or q for quit):"
		read sleep_interval
		if [[ $sleep_interval == 'q' || $sleep_interval == 'Q' ]]; then
			echo "Exiting ..."
			break
		elif ! [[ $sleep_interval =~ ^[0-9]+$ ]]; then
			echo "Incorrect value: Please enter only numeric value"
		else
			sleep $sleep_interval
		fi

	done

}


monitor_metrics
