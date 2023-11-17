#!/bin/bash

echo "Starting Staging Env."
cd 3_staging_env

# Run `vagrant up` command
vagrant halt && vagrant up


# Check if the backend is running
# Use a while loop to repeatedly check if the backend is running
while true; do
	http_status=$(curl -s -o /dev/null -w "%{http_code}" $backend_url)
	if [ "$http_status" -ge 100 ] && [ "$http_status" -lt 400 ]; then
		echo "Backend is running. HTTP Status: $http_status"
		break
	else
		clear
		echo "Waiting for the backend to start..."
		sleep $WAIT_SECONDS
	fi
done


clear
echo "Backend is running on port $backend_port."
echo "Starting front-end..."

vagrant ssh -c 'cd front-end && npm i && yarn start'
