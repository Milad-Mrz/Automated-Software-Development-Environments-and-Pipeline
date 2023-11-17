#!/bin/bash
echo "Initialising Developer and CI server..."

backend_url="http://192.168.56.9/gitlab/users/sign_in"
http_status=""
WAIT_SECONDS=5

# Use a while loop to repeatedly check if the backend is running
while true; do
	http_status=$(curl -s -o /dev/null -w "%{http_code}" $backend_url)
	if [ "$http_status" == "200" ] ; then
		echo "CI server is running. HTTP Status: $http_status"
		break
	else
		clear
		echo "Waiting for the CI server to start..."
		sleep $WAIT_SECONDS
	fi
done